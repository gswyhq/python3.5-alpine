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

# COPY requirements.txt ./

RUN apk --update add --no-cache nginx
RUN mkdir /run/nginx
RUN apk --update add --no-cache \
    lapack-dev \
    gcc \
    freetype-dev \
    git

RUN apk --update add --no-cache --virtual .build-deps \
        gfortran \
        musl-dev \
        libxslt-dev \
        g++ \
        --repository http://mirrors.ustc.edu.cn/alpine/v3.8/main/ --allow-untrusted \
    && \
    pip install mammoth==1.4.2 && \
    pip install geopy==1.11.0 && \
    pip install pyltp==0.1.9.1 && \
    pip install fuzzywuzzy==0.15.0 && \
    pip install xlutils==2.0.0 && \
    pip install numpy==1.14.2 && \
    pip install jieba3k==0.35.1 && \
    pip install xlwt==1.2.0 && \
    pip install requests==2.12.4 && \
    pip install lxml==3.7.3 && \
    pip install xlrd==1.0.0 && \
    pip install PyMySQL==0.7.10 && \
    pip install chardet==2.3.0 && \
    pip install py2neo==3.1.2 && \
    pip install pypinyin==0.23.0 && \
    pip install elasticsearch==5.3.0 && \
    pip install gensim==2.0.0 && \
    pip install redis==2.10.5 && \
    pip install rdflib==4.2.2 && \
    pip install Flask==0.12.2 && \
    pip install Cython==0.27.3 && \
    pip install pandas==0.19.2 && \
    pip install pyemd==0.4.3 && \
    pip install pymongo==3.6.1 && \
    pip install tornado==4.4.2 && \
    pip install acora==2.1 && \
    pip install python_Levenshtein==0.12.0 && \
    pip install NeuroNER==0.0.3 && \
    pip install jieba==0.39 && \
    pip install JPype1==0.6.3 && \
    pip install scikit_learn==0.19.2 && \
    pip3 install git+https://github.com/Supervisor/supervisor.git \
    # pip3 --default-timeout=60000 install -r requirements.txt  \
    && apk del -f .build-deps

RUN mkdir /var/log/supervisor && \
    mkdir -p /etc/supervisord/conf.d && \
    echo_supervisord_conf > /etc/supervisor/supervisord.conf && \
    echo "[include]" >> /etc/supervisor/supervisord.conf && \
    echo "files = /etc/supervisord/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

RUN echo "alias date='date +\"%Y-%m-%d %H:%M:%S\"'" >> ~/.bashrc

EXPOSE 8000

CMD [ "python3"]

# $ docker build -t alpine_20180830 -f Dockerfile-alpine .
# $ docker run -it --rm --name my-running-app alpine_20180830
