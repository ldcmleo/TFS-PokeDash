FROM ubuntu:18.04 AS build
RUN apt update
RUN apt-get install -y git cmake build-essential libluajit-5.1-dev libmysqlclient-dev libboost-system-dev libboost-iostreams-dev libpugixml-dev libcrypto++-dev libfmt-dev libgmp-dev

COPY cmake /app/forgottenserver/cmake/
COPY src /app/forgottenserver/src/
COPY CMakeLists.txt /app/forgottenserver/
RUN mkdir -p /app/forgottenserver/build
WORKDIR /app/forgottenserver
RUN cd build && cmake -DUSE_LUAJIT=FALSE .. && make

FROM ubuntu:18.04
RUN apt update && \
    apt-get install -y \
    libluajit-5.1-2 \
    libmysqlclient20 \
    libboost-system1.65-dev \
    libboost-iostreams1.65-dev \
    libpugixml1v5 \
    libcrypto++-dev \
    libfmt-dev \
    libgmp-dev

COPY --from=build /app/forgottenserver/build/tfs /app/forgottenserver/tfs
COPY data /app/forgottenserver/data/
COPY config.lua /app/forgottenserver/config.lua

EXPOSE 7171 7172
WORKDIR /app/forgottenserver
VOLUME /app/forgottenserver

ENTRYPOINT [ "/app/forgottenserver/tfs" ]