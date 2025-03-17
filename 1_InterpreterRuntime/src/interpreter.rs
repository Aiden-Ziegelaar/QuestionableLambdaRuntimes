use std::collections::HashMap;

pub fn brainf(input: String) -> String {
    let mut memory = vec![0; 100];
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
            '.' => output.push(memory[pointer] as u8 as char),
            ']' => {
              if memory[pointer] != 0 {
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
    fn test_brainf() {
        let input = String::from(">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+.");
        let output = brainf(input);
        assert_eq!(output, "Hello, World!");
    }
}