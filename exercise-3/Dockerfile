
FROM alpine:3.19
WORKDIR /app

COPY rest_1.0_linux_amd64 ./rest-app

RUN chmod +x ./rest-app

EXPOSE 8080

CMD ["./rest-app"]