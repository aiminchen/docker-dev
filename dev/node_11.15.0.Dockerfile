FROM amd64/node:12.22.12-bullseye

LABEL maintainer="chenaimin"
LABEL version="latest"
MAINTAINER chen "chenaimim@163.com"

# build参数
ARG user=chen

RUN sed -i "s@http://\(deb\|security\).debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list

RUN rm -rf /var/lib/apt/lists/*

# 清理缓存并更新软件包列表
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    # 安装 SSH 服务器软件包
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp*

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