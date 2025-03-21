use lambda_runtime::{Error, LambdaEvent};
use serde::{Deserialize, Serialize};
use std::process::Command;

#[derive(Deserialize)]
pub(crate) struct IncomingMessage {
    source: String,
    target: String,
}

#[derive(Serialize)]
pub(crate) struct OutgoingMessage {
    distance: i32,
}

pub(crate) async fn function_handler(event: LambdaEvent<IncomingMessage>) -> Result<OutgoingMessage, Error> {
    let output = Command::new("/var/task/handler.out")
        .arg(event.payload.source)
        .arg(event.payload.target)
        .output().unwrap();

    let resp = OutgoingMessage {
        distance: String::from_utf8(output.stdout).unwrap().trim().parse().unwrap(),
    };

    Ok(resp)
}

#[cfg(test)]
mod tests {
    use super::*;
    use lambda_runtime::{Context, LambdaEvent};

    #[tokio::test]
    async fn test_generic_handler() {
        let event = LambdaEvent::new(IncomingMessage { command: "test".to_string() }, Context::default());
        let response = function_handler(event).await.unwrap();
        assert_eq!(response.msg, "Command test.");
    }
}
