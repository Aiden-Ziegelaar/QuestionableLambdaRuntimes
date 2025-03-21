source $HOME/.cargo/env
cd /code/src_fortran
gfortran main.f90 -o handler.out
./handler.out test123 test123
cd ../
cargo build --release
rm -rf /code/dist
mkdir /code/dist
cp target/release/bootstrap /code/dist/bootstrap
cp src_fortran/handler.out /code/dist/handler.out
cp /usr/lib64/libgfortran.so.5 /code/dist/libgfortran.so.5
cp /usr/lib64/libquadmath.so.0 /code/dist/libquadmath.so.0
