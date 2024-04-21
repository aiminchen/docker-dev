FROM amd64/node:12.22.12-bullseye

LABEL maintainer="chenaimin"
LABEL version="latest"
MAINTAINER chen "chenaimim@163.com"

RUN sed -i "s@http://\(deb\|security\).debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list

# 清理缓存并更新软件包列表
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get update

# 设置npm镜像源为淘宝镜像
RUN npm config set registry https://registry.npmmirror.com

# 设置yarn镜像源为淘宝镜像
RUN yarn config set registry https://registry.npm.taobao.org

