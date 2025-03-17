let handler event =
  let name = Yojson.Safe.Util.member "name" event in
  let formatted_string = Yojson.Safe.Util.to_string name in
  `String ("Hello, " ^ formatted_string ^ "!")