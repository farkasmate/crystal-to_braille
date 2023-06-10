FROM crystallang/crystal:1-alpine AS BUILDER

WORKDIR /src/

COPY . .

RUN shards build \
  --cross-compile \
  --target=aarch64-unknown-linux-gnu \
  --release \
  --static \
  | grep '^cc' > link.sh

FROM alpine:latest AS LINKER

WORKDIR /src/

RUN apk add --no-cache \
  alpine-sdk \
  gc-dev \
  libevent-static \
  pcre2-dev

COPY --from=BUILDER /src/bin/to_braille.o bin/
COPY --from=BUILDER /src/link.sh .

RUN source link.sh \
  && strip bin/to_braille

FROM busybox:latest AS DEPLOYER

WORKDIR /export/

COPY --from=LINKER /src/bin/to_braille .
