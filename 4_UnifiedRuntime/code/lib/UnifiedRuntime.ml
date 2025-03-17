
let handler event =
  let name = Yojson.Safe.Util.member "name" event in
  `String ("Hello, " ^ Yojson.Safe.to_string name ^ "!")