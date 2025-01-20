FROM omalaspinas/c_pandoc:latest

COPY build_reports.sh .
COPY disable_float_image.tex .

RUN apk add --update git

RUN chmod +x build_reports.sh

ENV GIT_REPO_PATH="/build"
ENV FORCE_REBUILD=false

ENTRYPOINT [ "/bin/sh", "-c", "/bin/sh" ]
