use lambda_runtime::{Error, LambdaEvent};
use serde::{Deserialize, Serialize};
use crate::interpreter;

const PROGRAM: &str = include_str!("handler.bf");

#[derive(Deserialize)]
pub(crate) struct IncomingMessage {
}

#[derive(Serialize)]
pub(crate) struct OutgoingMessage {
    greeting: String,
}

pub(crate) async fn function_handler(_event: LambdaEvent<IncomingMessage>) -> Result<OutgoingMessage, Error> {
    
    let message = interpreter::brainf(PROGRAM.to_string());

    let resp = OutgoingMessage {
        greeting: message,
    };

    Ok(resp)
}