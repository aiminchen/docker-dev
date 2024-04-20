FROM amd64/ubuntu:20.04

LABEL maintainer="chenaimin"
LABEL version="latest"
MAINTAINER chen "chenaimim@163.com"

# build参数
ARG user=chen

RUN sed -i 's/\/\/.*\/ubuntu/\/\/mirrors.aliyun.com\/ubuntu/g' /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/*

RUN   \
    DEBIAN_FRONTEND=noninteractive apt-get clean && apt-get update  && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https --assume-yes  \
    apt-utils               \
    util-linux              \
    sudo                    \
    htop                    \
    procps                  \
    ssh                     \
    telnet                  \
    wget                    \
    openssl                 \
    openssh-server          \
    net-tools               \
    vim                     \
    curl                    \
    tzdata                  \
    gawk                    \
    gcc                     \
    g++                     \
    build-essential         \
    nano       &&           \
    apt-get clean           \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp*

#Time zone adjusted to East eighth District
RUN DEBIAN_FRONTEND=noninteractive ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# 添加用户：赋予sudo权限，指定密码
RUN useradd --create-home --no-log-init --shell /bin/bash ${user} \
    && adduser ${user} sudo \
    && echo "${user}:123456" | chpasswd \
    && echo "root:123456" | chpasswd

# 开启ssh服务
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]