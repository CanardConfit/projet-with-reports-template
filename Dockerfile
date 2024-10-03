FROM pandoc/core:latest

COPY build_reports.sh .

RUN apk add --update git

CMD [ "bash", "build_reports.sh", "true" ]