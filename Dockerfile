FROM node:10.16.0-alpine

WORKDIR /usr/src/app
RUN apk add --no-cache --virtual .build-deps curl tar gzip python make g++ \
  && curl -L https://github.com/statsd/statsd/archive/v0.8.2.tar.gz --output statsd-v0.8.2.tar.gz \
  && tar xzf statsd-v0.8.2.tar.gz \
  && rm statsd-v0.8.2.tar.gz \
  && mv statsd-0.8.2/package.json . \
  && npm install && npm cache clean --force \
  && mv statsd-0.8.2/bin statsd-0.8.2/lib statsd-0.8.2/servers statsd-0.8.2/backends statsd-0.8.2/stats.js statsd-0.8.2/proxy.js . \
  && rm -rf statsd-0.8.2 \
  && apk del .build-deps
COPY config.js .

EXPOSE 8125/udp
EXPOSE 8126

ENTRYPOINT [ "node", "stats.js", "config.js" ]
