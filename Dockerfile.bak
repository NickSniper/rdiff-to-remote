FROM alpine:3
MAINTAINER nicksniper2@gmail.com

VOLUME /config
VOLUME /host

ENV RDIFF_BACKUP_TARGET=
ENV TZ=

COPY ./backup.sh /bin/backup.sh
COPY ./root /var/spool/cron/crontabs/root

RUN apk update && apk upgrade && \
  apk add --no-cache rdiff-backup openssh-client tzdata && \
  rm -rf /tmp/* /var/tmp/* ~/.cache ~/.npm && \
  rm -rf /usr/local/share/doc /usr/local/share/man /var/cache/apk/* && \
  chmod +x /bin/backup.sh

CMD crond -l 2 -f
