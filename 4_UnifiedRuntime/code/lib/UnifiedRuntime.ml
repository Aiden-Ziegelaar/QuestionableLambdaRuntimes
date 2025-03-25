let not_vowel = Fun.negate (String.contains "AaEeIiOoUu")

let handler event =
  `String (Yojson.Safe.Util.member "name" event |>
  Yojson.Safe.Util.to_string |>
  String.to_seq |> 
  Seq.filter not_vowel |> 
  String.of_seq)