FROM node:12.13.1-alpine

RUN apk --no-cache add openssl ca-certificates wget bash && \
    apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python 

ENV VERDACCIO_APPDIR=/opt/verdaccio \
    VERDACCIO_USER_NAME=verdaccio \
    VERDACCIO_USER_UID=1000 \
    VERDACCIO_PORT=4873 \
    VERDACCIO_PROTOCOL=http

RUN mkdir -p /verdaccio/storage /verdaccio/plugins /verdaccio/conf /usr/local/lib



RUN adduser -u $VERDACCIO_USER_UID -S -D -h $VERDACCIO_APPDIR -g "$VERDACCIO_USER_NAME user" -s /sbin/nologin $VERDACCIO_USER_NAME && \
    chown -R $VERDACCIO_USER_UID:root /verdaccio/storage && \
    chown -R $VERDACCIO_USER_UID:root /usr/local && \
    chown -R $VERDACCIO_USER_UID:root /verdaccio && \
    chmod -R g=u /verdaccio/storage /etc/passwd /usr/local/lib

USER $VERDACCIO_USER_UID

RUN npm install -g verdaccio



ADD conf/config.yaml /verdaccio/conf/config.yaml
CMD /usr/local/bin/verdaccio --config /verdaccio/conf/config.yaml --listen $VERDACCIO_PROTOCOL://0.0.0.0:$VERDACCIO_PORT

