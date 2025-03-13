FROM fedora:latest
RUN dnf -y install gnucobol
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  -s -- -y
RUN source $HOME/.cargo/env