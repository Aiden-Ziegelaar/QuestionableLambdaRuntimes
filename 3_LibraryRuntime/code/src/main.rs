use lambda_runtime::{run, service_fn, tracing, Error};
mod handler;
use handler::function_handler;


#[link(name = "handler", kind = "static")]
extern "C" {
    fn initialize_cobol();
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();
    unsafe {
        initialize_cobol();
    }
    run(service_fn(function_handler)).await
}
