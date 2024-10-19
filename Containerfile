FROM docker.io/alpine

RUN apk add grub-bios grub curl bash xorriso

COPY build.sh /
RUN chmod +x /build.sh
ENTRYPOINT ["/build.sh"]
