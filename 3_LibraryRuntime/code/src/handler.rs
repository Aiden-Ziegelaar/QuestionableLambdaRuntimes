use std::os::raw::c_char;
use lambda_runtime::{Error, LambdaEvent};
use serde::{Deserialize, Serialize};

#[link(name = "handler", kind = "static")]
extern "C" {
    fn initialize_cobol();
    fn handler(i: *const c_char, o: *mut c_char);
}

#[derive(Deserialize)]
pub(crate) struct IncomingMessage {
    name: String,
}

#[derive(Serialize)]
pub(crate) struct OutgoingMessage {
    greeting: String,
}

pub(crate) async fn function_handler(event: LambdaEvent<IncomingMessage>) -> Result<OutgoingMessage, Error> {
    let name = event.payload.name;

    let mut string_buf: Vec<i8> = vec![0; 100];
    let mut input_buf: Vec<i8> = vec![0; 40];
    for (i, c) in name.chars().enumerate() {
        input_buf[i] = c as i8;
    }

    unsafe {
        handler(input_buf.as_ptr(), string_buf.as_mut_ptr());
    }
    
    let resp = OutgoingMessage {
        greeting: format!("{}", string_buf.iter().map(|&c| c as u8 as char).collect::<String>().trim_matches(char::from(0))),
    };

    Ok(resp)
}

#[cfg(test)]
mod tests {
    use super::*;
    use lambda_runtime::{Context, LambdaEvent};

    #[tokio::test]
    async fn test_generic_handler() {
        unsafe {
            initialize_cobol();
        }
        let event1 = LambdaEvent::new(IncomingMessage { name: "test".to_string() }, Context::default());
        let response1 = function_handler(event1).await.unwrap();
        let event2 = LambdaEvent::new(IncomingMessage { name: "testbutlonger".to_string() }, Context::default());
        let response2 = function_handler(event2).await.unwrap();
        assert_eq!(response1.greeting, "Hello test!");
        assert_eq!(response2.greeting, "Hello testbutlonger!");
    }
}
