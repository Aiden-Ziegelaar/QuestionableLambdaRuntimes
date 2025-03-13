fn main() {
    cc::Build::new()
        .object("./dist/handler.o")
        .object("./dist/linkage.o")
        .compile("libhandler.a");
    println!("cargo:rustc-link-arg=-lcob");
}
