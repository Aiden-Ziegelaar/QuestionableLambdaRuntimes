let remove_vowels s : string =
  let not_vowel = Fun.negate (String.contains "AaEeIiOoUu") in
  String.to_seq s |> Seq.filter not_vowel |> String.of_seq

let handler event =
  let name = Yojson.Safe.Util.member "name" event in
  let formatted_string = Yojson.Safe.Util.to_string name in
  let no_vowel_string = remove_vowels formatted_string in
  `String no_vowel_string

