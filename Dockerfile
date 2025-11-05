ARG OSMIUM_VERSION=v1.18.0

FROM ubuntu:24.04 AS build
ARG OSMIUM_VERSION
RUN apt-get update && apt-get install -y \
	cmake \
	g++ \
	git \
	libboost-program-options-dev libbz2-dev zlib1g-dev libexpat1-dev \
	nlohmann-json3-dev liblz4-dev \
	wget

RUN mkdir work && cd work && \
	git clone https://github.com/mapbox/protozero && \
	git clone https://github.com/osmcode/libosmium && \
	git clone https://github.com/osmcode/osmium-tool && \
	cd osmium-tool && git fetch --tags && git checkout ${OSMIUM_VERSION}

RUN	cd work && cd osmium-tool && mkdir build && cd build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release && \
	make && \
	ln -s /work/osmium-tool/build/osmium /usr/bin/osmium

FROM ubuntu:24.04 AS deploy
ARG OSMIUM_VERSION
RUN apt-get update && apt-get install -y \
	libboost-program-options1.83.0 libbz2-1.0 zlib1g libexpat1 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /work/osmium-tool/build/src/osmium /usr/bin/osmium

RUN groupadd -r osmtools && useradd -r -g osmtools osmtools
USER osmtools

LABEL org.opencontainers.image.source="https://github.com/krizleebear/docker-osmium-tool"
LABEL org.opencontainers.image.description="Osmium Command Line Tool"
LABEL org.opencontainers.image.version="${OSMIUM_VERSION}"

ENTRYPOINT ["/usr/bin/osmium"]