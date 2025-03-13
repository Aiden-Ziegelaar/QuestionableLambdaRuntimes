use std::os::raw::c_char;
use lambda_runtime::{Error, LambdaEvent};
use serde::{Deserialize, Serialize};

#[link(name = "handler", kind = "static")]
extern "C" {
    fn initialize_cobol();
    fn handler(i: *const c_char, o: *mut c_char);
}


/// This is a made-up example. Incoming messages come into the runtime as unicode
/// strings in json format, which can map to any structure that implements `serde::Deserialize`
/// The runtime pays no attention to the contents of the incoming message payload.
#[derive(Deserialize)]
pub(crate) struct IncomingMessage {
    name: String,
}

/// This is a made-up example of what an outgoing message structure may look like.
/// There is no restriction on what it can be. The runtime requires responses
/// to be serialized into json. The runtime pays no attention
/// to the contents of the outgoing message payload.
#[derive(Serialize)]
pub(crate) struct OutgoingMessage {
    greeting: String,
}

/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
/// - https://github.com/aws-samples/serverless-rust-demo/
pub(crate) async fn function_handler(event: LambdaEvent<IncomingMessage>) -> Result<OutgoingMessage, Error> {
    // Extract some useful info from the request
    let name = event.payload.name;

    let mut string_buf: Vec<i8> = vec![0; 100];
    let mut input_buf: Vec<i8> = vec![0; 40];
    for (i, c) in name.chars().enumerate() {
        input_buf[i] = c as i8;
    }

    unsafe {
        handler(input_buf.as_ptr(), string_buf.as_mut_ptr());
    }
    
    // Prepare the outgoing message
    let resp = OutgoingMessage {
        greeting: format!("{}", string_buf.iter().map(|&c| c as u8 as char).collect::<String>().trim_matches(char::from(0))),
    };

    // Return `OutgoingMessage` (it will be serialized to JSON automatically by the runtime)
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
