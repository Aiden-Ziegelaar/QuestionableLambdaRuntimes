FROM amazonlinux:latest
RUN dnf -y install openssl diffutils patch tar unzip gzip gcc make gmp-devel bzip2
RUN bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh) --download-only"
RUN ls
RUN mv /opam-2.3.0-arm64-linux /bin/opam
RUN chmod +x /bin/opam
RUN opam init --disable-sandboxing -y
RUN eval $(opam env)
RUN opam install cohttp-lwt-unix cohttp-async yojson -y
RUN opam install dune -y