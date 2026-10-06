# syntax=docker/dockerfile:1.7
#
# PCOM - DS - Minio (Apache-2.0)
# ------------------------------
# MinIO built from source at RELEASE.2021-04-22T15-44-28Z, the last release
# published under the Apache License 2.0 (later releases are AGPL v3).
# Used as the S3 backend for Milvus in the NNP Data Store.
#
# Build:
#   docker build -t pcom-ds-minio-apache:RELEASE.2021-04-22-v1 .

ARG go_image=docker.io/library/golang
ARG go_version=1.17-bullseye
ARG base_image=docker.io/nubonativesolution/pcom-brc-ubuntu
ARG base_version=22.04-v1

FROM ${go_image}:${go_version} AS build
ARG MINIO_TAG=RELEASE.2021-04-22T15-44-28Z
ENV CGO_ENABLED=0 GOFLAGS=-trimpath
WORKDIR /src
RUN git clone --depth 1 --branch "${MINIO_TAG}" https://github.com/minio/minio.git .
RUN grep -q "Apache License" LICENSE \
 && go build -tags kqueue -ldflags "$(go run buildscripts/gen-ldflags.go)" -o /out/minio . \
 && /out/minio --version

FROM ${base_image}:${base_version}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="RELEASE.2021-04-22-v1"

LABEL org.opencontainers.image.title="pcom-ds-minio-apache" \
      org.opencontainers.image.description="MinIO RELEASE.2021-04-22 (Apache-2.0) built from source on the PCOM Ubuntu base." \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-DS-Minio-Apache" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-DS-Minio-Apache" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /out/minio /usr/bin/minio
COPY --from=build /src/LICENSE /licenses/MINIO-LICENSE
COPY --from=build /src/CREDITS /licenses/MINIO-CREDITS

ENV MINIO_ROOT_USER_FILE=access_key \
    MINIO_ROOT_PASSWORD_FILE=secret_key

EXPOSE 9000
VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/minio"]
CMD ["server", "/data"]
