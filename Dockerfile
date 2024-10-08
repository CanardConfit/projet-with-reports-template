FROM omalaspinas/c_pandoc:latest

COPY build_reports.sh .

RUN apk add --update git

RUN chmod +x build_reports.sh

ENV FORCE_REBUILD=false

ENTRYPOINT [ "bash", "build_reports.sh" ]