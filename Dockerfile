FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
	cmake \
	g++ \
	git \
	libboost-program-options-dev libbz2-dev zlib1g-dev libexpat1-dev \
	wget

RUN mkdir work && cd work && \
	git clone https://github.com/mapbox/protozero && \
	git clone https://github.com/osmcode/libosmium && \
	git clone https://github.com/osmcode/osmium-tool && \
	cd osmium-tool && mkdir build && cd build && \
	cmake .. -DCMAKE_BUILD_TYPE=Release && \
	make && \
	ln -s /work/osmium-tool/build/osmium /usr/bin/osmium
	
