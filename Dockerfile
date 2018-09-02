FROM python:3.5.6-alpine3.8

# 修改时区
RUN apk update \
        --repository https://mirrors.aliyun.com/alpine/v3.8/main/ \
        --allow-untrusted && \
    apk --no-cache add tzdata --virtual abcdefg \
        --repository https://mirrors.aliyun.com/alpine/v3.8/main/ \
        --allow-untrusted  && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del -f abcdefg

ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN apk --update add --no-cache nginx
RUN apk --update add --no-cache \
    lapack-dev \
    gcc \
    freetype-dev

RUN apk --update add --no-cache --virtual .build-deps \
        gfortran \
        musl-dev \
        libxslt-dev \
        g++ \
        --repository http://mirrors.ustc.edu.cn/alpine/v3.8/main/ --allow-untrusted \
    && \
    pip3 --default-timeout=60000 install -r requirements.txt  \
    && apk del -f .build-deps


RUN echo "alias date='date +\"%Y-%m-%d %H:%M:%S\"'" >> ~/.bashrc

EXPOSE 8000

CMD [ "python3"]

# $ docker build -t alpine_20180830 -f Dockerfile-alpine .
# $ docker run -it --rm --name my-running-app alpine_20180830
