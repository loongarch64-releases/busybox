FROM lcr.loongnix.cn/library/debian:unstable

RUN apt update && apt install -y git \
    golang \
    make \
    libseccomp-dev \
    gcc \
    build-essential \
    libncurses-dev  \
    bzip2 \
    wget

    

ENV BUSYBOX_VERSION=''

CMD ["sh", "-c","/workspace/process_version.sh $BUSYBOX_VERSION"]
