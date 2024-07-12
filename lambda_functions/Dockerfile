# ビルド
FROM golang:1.22.0 AS builder

COPY ./go /workspace/go
WORKDIR /workspace/go

ENV ARCH="arm64"

ARG VERSION
RUN go mod download && \
    GOOS=linux GOARCH=${ARCH} CGO_ENABLED=0 go build -trimpath -ldflags="-s -w -X main.version=${VERSION}" -o /functions/send_mail ./functions/send_mail/*

# 本番実行用
# 2023/08/29 の latest
FROM gcr.io/distroless/static@sha256:2368c04cb307fd5244b92de95bd2bde6a7eb0eb4b9a0428cb276beeae127f118 as aws
COPY --from=builder /functions /functions
# entrypointはlambdaの設定で上書きされる
ENTRYPOINT ["/functions/send_mail"]

# ローカル実行用
FROM public.ecr.aws/lambda/provided:al2 as local
COPY --from=builder /functions /functions
ENTRYPOINT ["/functions/send_mail"]