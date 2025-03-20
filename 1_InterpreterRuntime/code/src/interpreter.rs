use std::collections::HashMap;
use std::num::Wrapping;

pub fn brainf(input: String) -> String {
    let mut memory: Vec<Wrapping<u8>> = vec![std::num::Wrapping(0); 100];
    let mut pointer = 0;
    let mut output = String::new();
    let mut bracket_pairs: HashMap<usize, usize> = HashMap::new();
    let mut bracket_stack: Vec<usize> = Vec::new();

    for (i, c) in input.chars().enumerate() {
        if c == '[' {
            bracket_stack.push(i);
        } else if c == ']' {
            let start = bracket_stack.pop().unwrap();
            bracket_pairs.insert(i, start);
        }
    }

    let mut i = 0;
    while i < input.len() {
        let c = input.chars().nth(i).unwrap();
        match c {
            '>' => pointer += 1,
            '<' => pointer -= 1,
            '+' => memory[pointer] += 1,
            '-' => memory[pointer] -= 1,
            '.' => output.push(memory[pointer].0 as u8 as char),
            ']' => {
              if memory[pointer] != std::num::Wrapping(0) {
                i = bracket_pairs[&i];
              } else {
                i += 1;
              }
            },
            _ => (),
        }
        if c != ']' {
            i += 1;
        }
    }
    return output;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_brainf_hello_world() {
        let input = String::from(">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+.");
        let output = brainf(input);
        assert_eq!(output, "Hello, World!");
    }

    #[test]
    fn test_brainf_sentence() {
        let input = String::from("-[--->+<]>-.[---->+++++<]>-.+.++++++++++.+[---->+<]>+++.-[--->++<]>-.++++++++++.+[---->+<]>+++.[-->+++++++<]>.++.-------------.[--->+<]>---..+++++.-[---->+<]>++.+[->+++<]>.++++++++++++..---.[-->+<]>--------.");
        let output = brainf(input);
        assert_eq!(output, "This is pretty cool.");
    }
}