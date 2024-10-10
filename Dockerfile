FROM omalaspinas/c_pandoc:latest

COPY build_reports.sh .

RUN apk add --update git

RUN chmod +x build_reports.sh

ENV GIT_REPO_PATH="/build"
ENV FORCE_REBUILD=false

ENTRYPOINT [ "sh" ]
