let not_vowel = Fun.negate (String.contains "AaEeIiOoUu")

let remove_vowels s =
  String.to_seq s |> Seq.filter not_vowel |> String.of_seq

let handler event =
  `String (Yojson.Safe.Util.member "name" event |>
  Yojson.Safe.Util.to_string |>
  remove_vowels)
  