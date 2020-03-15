ARG zlib_version=latest
FROM zlib:${zlib_version}

MAINTAINER Francis Duffy
LABEL Description="Build openssl."

ARG num_cores

COPY . /openssl

RUN apt-get update \
  && apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y perl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /openssl \
  && find -regex ".*\.\(sh\|in\|ac\|am\)" -exec dos2unix {} ';' \
  && dos2unix config \
  && ./config \
  && make -j ${num_cores} \
  && make install_sw \
  && cd / \
  && rm -rf openssl \
  && ldconfig

CMD bash
