source $HOME/.cargo/env
cd /code
rm ./dist/linkage.o
rm ./dist/handler.o
cobc -c -static ./src_cobol/handler.cob ./src_c/linkage.c
mv linkage.o ./dist
mv handler.o ./dist
cargo clean
cargo test
cargo build --release