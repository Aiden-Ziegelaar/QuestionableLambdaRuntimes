FROM amazonlinux:latest
RUN dnf install gcc-gfortran -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  -s -- -y
RUN source $HOME/.cargo/env