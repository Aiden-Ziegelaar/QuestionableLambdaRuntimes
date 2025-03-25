open Lwt
open Cohttp_lwt_unix

let aws_runtime_api = Sys.getenv "AWS_LAMBDA_RUNTIME_API"
let runtime_base_url = "http://" ^ aws_runtime_api ^ "/2018-06-01/runtime"

let get_next_invocation () =
  Uri.of_string (runtime_base_url ^ "/invocation/next") |>
  Client.get >>= fun (resp, body) ->
  Cohttp_lwt.Body.to_string body >>= fun body_str ->
  let req_id = Cohttp.Header.get (Cohttp.Response.headers resp) "Lambda-Runtime-Aws-Request-Id" in
  let body_json = Yojson.Safe.from_string body_str in
  match req_id with
  | Some req_id -> Lwt.return (req_id, body_json)
  | None -> Lwt.fail_with "Missing request ID"

let send_response request_id response_json =
  let headers = Cohttp.Header.init_with "Content-Type" "application/json" in
  let body = Yojson.Safe.to_string response_json |> Cohttp_lwt.Body.of_string in
  Uri.of_string (runtime_base_url ^ "/invocation/" ^ request_id ^ "/response") |> 
  Client.post ~body ~headers >>= fun _ ->
  Lwt.return_unit

let rec lambda_loop () =
  get_next_invocation () >>= fun (request_id, event_body) ->
  UnifiedRuntime.handler event_body |>
  send_response request_id >>= fun () ->
  lambda_loop ()

let () =
  Lwt_main.run (lambda_loop ())