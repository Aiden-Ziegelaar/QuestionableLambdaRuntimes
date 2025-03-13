FROM fedora:latest
RUN dnf -y install gnucobol
COPY ./code/target/release/bootstrap /bootstrap
CMD ["/bootstrap"]