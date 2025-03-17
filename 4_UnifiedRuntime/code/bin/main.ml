open Lwt
open Cohttp_lwt_unix

let aws_runtime_api = Sys.getenv "AWS_LAMBDA_RUNTIME_API"
let runtime_base_url = "http://" ^ aws_runtime_api ^ "/2018-06-01/runtime"

(* Function to fetch the next Lambda invocation *)
let get_next_invocation () =
  let uri = Uri.of_string (runtime_base_url ^ "/invocation/next") in
  Client.get uri >>= fun (resp, body) ->
  Cohttp_lwt.Body.to_string body >>= fun body_str ->
  let headers = Cohttp.Response.headers resp in
  let body_json = Yojson.Safe.from_string body_str in
  let payload = Yojson.Safe.Util.member "payload" body_json in 
  match Cohttp.Header.get headers "Lambda-Runtime-Aws-Request-Id" with
  | Some req_id -> Lwt.return (req_id, payload)
  | None -> Lwt.fail_with "Missing request ID"

(* Function to send response to AWS Lambda *)
let send_response request_id response_json =
  let uri = Uri.of_string (runtime_base_url ^ "/invocation/" ^ request_id ^ "/response") in
  let body = Yojson.Safe.to_string response_json in
  let headers = Cohttp.Header.init_with "Content-Type" "application/json" in
  Client.post ~body:(Cohttp_lwt.Body.of_string body) ~headers uri >>= fun _ ->
  Lwt.return_unit

(* Main loop to continuously fetch and process Lambda events *)
let rec lambda_loop () =
  get_next_invocation () >>= fun (request_id, event_body) ->
  let response = UnifiedRuntime.handler event_body in
  send_response request_id response >>= fun () ->
  lambda_loop ()

(* Start the runtime *)
let () =
  Lwt_main.run (lambda_loop ())