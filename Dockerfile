# ----------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# ----------------------------------------------------------------------
# Name.......: Dockerfile
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2020.09.03
# Revision...: 1.0
# Purpose....: Dockerfile to build a utilities image with static sslscan
# Notes......: --
# Reference..: Based on the idea from https://github.com/treibholz/docker-sslscan
#              but modified to build sslscan 2 (latest)
# License....: Licensed is licensed under the GNU General Public License v3.0
# ----------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# ----------------------------------------------------------------------

# Pull base image
# ----------------------------------------------------------------------
FROM alpine

# Maintainer
# ----------------------------------------------------------------------
LABEL maintainer="stefan.oehrli@trivadis.com"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV CFLAGS "-D__USE_GNU"

# RUN as user root
# ----------------------------------------------------------------------
# get base package and start to build
RUN apk add --no-cache --virtual .build-deps \
            build-base git \
            perl zlib-dev libc6-compat \
            binutils linux-headers && \
    git clone --depth 1 https://github.com/rbsec/sslscan.git && \
    cd sslscan && \
    make static && make install && \
    cd / && rm -rf sslscan && \
    strip /usr/bin/sslscan

# New runtime image from scratch
# add what is really, really needed, to reduce the size of the image 
# ----------------------------------------------------------------------
FROM scratch

# Maintainer
# ----------------------------------------------------------------------
LABEL maintainer="stefan.oehrli@trivadis.com"

# copy required files from base image 
COPY --from=0 /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=0 /lib/libz.so.1 /lib/libz.so.1
COPY --from=0 /etc/passwd /etc/passwd
COPY --from=0 /usr/bin/sslscan /sslscan

# setuser nobody
USER nobody
# set the ENTRYPOINT
ENTRYPOINT ["/sslscan"]
# --- EOF --------------------------------------------------------------