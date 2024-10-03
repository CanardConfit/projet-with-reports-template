FROM pandoc/core:latest

COPY build_reports.sh .

RUN apk add --update git

RUN chmod +x build_reports.sh

CMD [ "./build_reports.sh", "true" ]