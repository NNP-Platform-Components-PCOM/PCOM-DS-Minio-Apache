# PCOM-DS-Minio-Apache

NNP Data Store (DS) component. MinIO built from source at tag `RELEASE.2021-04-22T15-44-28Z`,
the last release under the **Apache License 2.0** (MinIO switched to AGPL v3 afterwards).
Used as the S3 backend for Milvus.

Published to Docker Hub on every push to `main`:

```
docker.io/nubonativesolution/pcom-ds-minio-apache:RELEASE.2021-04-22-v1
docker.io/nubonativesolution/pcom-ds-minio-apache:latest
```

Architecture: `linux/amd64`. CI/CD via the shared [PCOM-CICD](https://github.com/NNP-Platform-Components-PCOM/PCOM-CICD) reusable pipeline.

Run: `docker run -e MINIO_ROOT_USER=... -e MINIO_ROOT_PASSWORD=... -p 9000:9000 -v data:/data <image>`
(API and the built-in web UI are both on port 9000).

> This release is five years old and has known security issues. Keep it on an internal network only.

## License
Apache-2.0 (see `LICENSE`). The MinIO source it is built from is also Apache-2.0 at this tag; its LICENSE and CREDITS are copied into `/licenses`.
