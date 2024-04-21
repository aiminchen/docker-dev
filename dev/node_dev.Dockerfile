FROM amd64/node:12.22.12-bullseye

LABEL maintainer="chenaimin"
LABEL version="latest"

RUN sed -i "s@http://\(deb\|security\).debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/*

# 清理缓存并更新软件包列表
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    # 安装 SSH 服务器软件包
    apt-get install -y openssh-server gnutls-bin

# 禁用 SSL 验证
RUN git config --global http.sslVerify false
# 增大 http.postBuffer
RUN git config --global http.postBuffer 1048576000

# 设置npm镜像源为淘宝镜像
RUN npm config set registry https://registry.npmmirror.com

# 设置yarn镜像源为淘宝镜像
RUN yarn config set registry https://registry.npm.taobao.org

RUN DEBIAN_FRONTEND=noninteractive ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# 添加用户：赋予sudo权限，指定密码
RUN echo "root:123456" | chpasswd

# 开启ssh服务
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# 创建目录
RUN mkdir -p /tmp/phantomjs

# 复制文件
COPY phantomjs-2.1.1-linux-x86_64.tar.bz2 /tmp/phantomjs

CMD ["/usr/sbin/sshd", "-D"]