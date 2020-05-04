FROM ubuntu:20.04 as builder
RUN mkdir /build
WORKDIR /build
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y curl

# RUN curl https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2 -o ffmpeg-4.2.2.tar.bz2 && tar xf ffmpeg-4.2.2.tar.bz2

# RUN apt-get install -y make gcc nasm libass-dev libmfx-dev libstdc++-9-dev libmp3lame-dev \
#     libopus-dev libgnutls28-dev libtheora-dev libvorbis-dev libvpx-dev libx264-dev \
#     libx265-dev libxvidcore-dev libffmpeg-nvenc-dev libbz2-dev libva-dev \
#     nvidia-cuda-toolkit intel-media-va-driver-non-free && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN cd ffmpeg-4.2.2 && ./configure --disable-shared --enable-static --enable-avfilter --enable-gnutls --enable-gpl --enable-libass \
#   --enable-libmp3lame --enable-libvorbis --enable-libvpx --enable-libxvid --enable-libx264 --enable-libx265 --enable-libtheora --enable-postproc \
#   --enable-pic --enable-pthreads --enable-libxcb --disable-stripping --disable-librtmp --enable-vaapi --enable-vdpau --enable-libopus --disable-debug \
#   --enable-nonfree --enable-libfreetype --enable-filters --enable-runtime-cpudetect --enable-bzlib --enable-zlib --enable-libmfx --enable-cuda --enable-cuvid \
#   --enable-nvenc --enable-libnpp --prefix=/opt/ffmpeg && \
#   make && make install
  

RUN cat /etc/apt/sources.list | grep -v "#" > /tmp/sources.list && cat /tmp/sources.list > /etc/apt/sources.list && cat /tmp/sources.list | sed 's/^deb/deb-src/g' >> /etc/apt/sources.list
RUN chown -R _apt:root /var/lib/apt/lists
RUN apt-get update && apt-get build-dep -y ffmpeg && apt-get source -y ffmpeg
RUN apt-get install -y make gcc nasm dpkg-dev libstdc++-9-dev libmfx-dev nvidia-cuda-dev
RUN cd /build/ffmpeg-4* && \
    sed -i "s/--enable-sdl2/--enable-sdl2 --enable-libmfx --enable-cuda --enable-cuvid --enable-libnpp --enable-nonfree/g" debian/rules && \
    sed -i '191i\ nvidia-cuda-toolkit, intel-media-va-driver-non-free, i965-va-driver-shaders,' debian/control && \
    sed -i "s/Build-Depends:/Build-Depends:\n libstdc++-9-dev,\n libmfx-dev,\n nvidia-cuda-dev,/" debian/control

RUN cd /build/ffmpeg-4* && dpkg-buildpackage -B
RUN rm -f /build/*-extra*.deb

FROM ubuntu:20.04
COPY --from=builder /build/*.deb /tmp/
# ARG LIBVA_DRIVER_NAME=iHD
ENV DEBIAN_FRONTEND="noninteractive" 
RUN apt-get update && apt-get install -y /tmp/*.deb && \
    rm /tmp/*.deb && apt-get clean && \
    rm -rf /var/lib/apt/lists/*