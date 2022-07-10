FROM debian:11-slim

# set version lables
ARG BUILD_DATE
ARG VERSION
ARG CALIBRE_VERSION=5.44.0
ARG CALIBRE_URL="https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz"
LABEL MAINTAINER bradley leonard <bradley@leonard.pub>

# prep system
RUN \
  echo "---===>>> prep system <<<===---" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libfontconfig \
    libgl1 \
    python3 \
    wget \
    xz-utils && \
  echo "---===>>> install calibre <<<===---" && \
  mkdir -p /opt/calibre && \
  curl -o \
    /tmp/calibre-tarball.txz -L \
    $CALIBRE_URL && \
  tar xvf /tmp/calibre-tarball.txz -C /opt/calibre && \
  echo "---===>>> cleanup <<<===---" && \
  apt autoremove -y && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/

# create directories
RUN mkdir /data && mkdir /scripts

# add startup.sh
ADD startup.sh /scripts/startup.sh
RUN chmod 755 /scripts/startup.sh

# add add-books.sh
ADD add-books.sh /scripts/add-books.sh
RUN chmod 755 /scripts/add-books.sh

# add remove-books.sh
ADD remove-books.sh /scripts/remove-books.sh
RUN chmod 755 /scripts/remove-books.sh

# Expose port
EXPOSE 8080

CMD ["/scripts/startup.sh"]
