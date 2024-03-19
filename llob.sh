# 设置环境变量
export DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
apt update && apt install -y \
    openbox \
    curl \
    unzip \
    xvfb \
    supervisor \
    libnotify4 \
    libnss3 \
    libxss1 \
    xdg-utils \
    libsecret-1-0 \
    libasound2 \
    fonts-wqy-zenhei \
    git \
    gnutls-bin && \
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# 安装Linux QQ
curl -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.5_240305_arm64_01.deb
dpkg -i /root/linuxqq.deb && apt-get -f install -y && rm /root/linuxqq.deb

# 安装LiteLoader
curl -L -o /tmp/LiteLoaderQQNT.zip https://mirror.ghproxy.com/https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.0.3/LiteLoaderQQNT.zip
    mkdir -p /opt/QQ/resources/app/LiteLoader
    unzip /tmp/LiteLoaderQQNT.zip -d /opt/QQ/resources/app/LiteLoader
    sed -i '1s/^/require("\/opt\/QQ\/resources\/app\/LiteLoader");\n/' /opt/QQ/resources/app/app_launcher/index.js
    rm /tmp/LiteLoaderQQNT.zip


# 配置supervisor
echo "[supervisord]" > /etc/supervisord.conf
echo "nodaemon=true" >> /etc/supervisord.conf
echo "[program:qq]" >> /etc/supervisord.conf
echo "command=qq --no-sandbox" >> /etc/supervisord.conf
echo 'environment=DISPLAY=":1"' >> /etc/supervisord.conf

# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm -rf /tmp/.X1-lock &
mkdir -p /var/run/dbus &
echo "登录方法: 浏览器访问 http://localhost:6099/api/panel/getQQLoginQRcode"
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address > /dev/null &
Xvfb :1 -screen 0 1080x760x16  > /dev/null &
export DISPLAY=:1
exec supervisord > /dev/null &" > /root/start.sh

# 安装LLOneBot  
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
curl -L -o /tmp/LLOneBot.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLOneBot/releases/download/v3.16.1/LLOneBot.zip
curl -L -o /tmp/LLWebUiApi.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLWebUiApi/releases/download/v0.0.31/LLWebUiApi.zip
unzip /tmp/LLOneBot.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot
unzip /tmp/LLWebUiApi.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
rm /tmp/LLOneBot.zip /tmp/LLWebUiApi.zip
echo -e "LLOneBot 安装完成
现在你可以输入命令 \e[32mbash start.sh\e[0m 来启动服务"