FROM ubuntu:14.04
MAINTAINER Chip Miller <chip@cornerstone-sf.org>

# ================================================================
# = Build Essentials for FFMPEG, GraphicsMagick, & ElasticSearch =
# ================================================================
RUN apt-get update
RUN apt-get install -y -q curl
# RUN curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
# RUN (echo "deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main" >> /etc/apt/sources.list)
# RUN apt-get update
RUN apt-get install -y -q git autoconf automake build-essential
# RUN apt-get install -y -q libass-dev libfreetype6-dev libgpac-dev libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev libmp3lame-dev
RUN apt-get install -y -q graphicsmagick-imagemagick-compat
# RUN apt-get install -y -q openjdk-7-jre-headless
RUN apt-get clean


# # ================================================================
# # =                Compile FFMPEG from Source                    =
# # ================================================================
# # # yasm
# RUN mkdir -p ~/ffmpeg_sources
# RUN cd ~/ffmpeg_sources
# RUN curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
# RUN tar xzvf yasm-1.2.0.tar.gz
# RUN cd yasm-1.2.0                                                       && \
#     ./configure --prefix='$HOME/ffmpeg_build' --bindir='/usr/local/bin' && \
#     make                                                                && \
#     make install                                                        && \
#     make distclean
#
# # # libvpx
# RUN mkdir -p ~/ffmpeg_sources
# RUN cd ~/ffmpeg_sources
# RUN curl -O http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
# RUN tar xjvf libvpx-v1.3.0.tar.bz2
# RUN cd libvpx-v1.3.0                                              && \
#     ./configure --prefix="$HOME/ffmpeg_build" --disable-examples  && \
#     make                                                          && \
#     make install                                                  && \
#     make clean
#
# # # libx264
# RUN mkdir -p ~/ffmpeg_sources
# RUN cd ~/ffmpeg_sources
# RUN curl -O http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
# RUN tar xjvf last_x264.tar.bz2
# RUN cd x264-snapshot*                                                                  && \
#     ./configure --prefix="$HOME/ffmpeg_build" —bindir="/usr/local/bin" --enable-static && \
#     make                                                                               && \
#     make install                                                                       && \
#     make distclean
#
# # # FFMPEG
# RUN mkdir -p ~/ffmpeg_sources
# RUN cd ~/ffmpeg_sources
# RUN curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
# RUN tar xjvf ffmpeg-snapshot.tar.bz2
# RUN cd ffmpeg && \
#     PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
#   --prefix="$HOME/ffmpeg_build" \
#   --extra-cflags="-I$HOME/ffmpeg_build/include" \
#   --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
#   --bindir="/usr/local/bin" \
#   --extra-libs="-ldl" \
#   --enable-gpl \
#   --enable-libass \
#   --enable-libfreetype \
#   --enable-libmp3lame \
#   --enable-libtheora \
#   --enable-libvorbis \
#   --enable-libvpx \
#   --enable-libx264   && \
#
#     make             && \
#     make install     && \
#     make distclean   && \
#     hash -r
#
# # =======================================
# # = Install Elastic Search as a Service =
# # =======================================
# RUN sudo apt-get install elasticsearch
# RUN sudo update-rc.d elasticsearch defaults 95 10
# RUN sudo /etc/init.d/elasticsearch start
#
