use lambda_http::{Body, Error, Request, Response};

use crate::interpreter;

const PROGRAM: &str = include_str!("./handler.bf");

pub(crate) async fn function_handler(_: Request) -> Result<Response<Body>, Error> {
    
    let message = interpreter::brainf(PROGRAM.to_string());

    let resp = Response::builder()
        .status(200)
        .header("content-type", "text/html")
        .body(message.into())
        .map_err(Box::new)?;
    Ok(resp)
}