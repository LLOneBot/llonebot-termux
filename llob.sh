# 设置环境变量
export DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
apt update && apt install -y \
    openbox \
    curl \
    unzip \
    xvfb \
    libnotify4 \
    libnss3 \
    libxss1 \
    xdg-utils \
    libsecret-1-0 \
    libasound2 \
    fonts-wqy-zenhei \
    jq \
    gnutls-bin && \
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

################################################################################################################################

# 安装Linux QQ
# payload=$(curl https://im.qq.com/rainbow/linuxQQDownload | grep -oP "var params= \K\{.*\}(?=;)")
# amd64_url=$(jq -r .x64DownloadUrl.deb <<< "$payload")
# arm64_url=$(jq -r .armDownloadUrl.deb <<< "$payload")
curl -L -o /root/linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.12_240927_arm64_01.deb
dpkg -i /root/linuxqq.deb 
apt-get -f install -y
rm /root/linuxqq.deb

# 下载LiteLoader 1.1.1
curl -L -o /tmp/LiteLoaderQQNT.zip https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/download/1.2.2/LiteLoaderQQNT.zip
unzip /tmp/LiteLoaderQQNT.zip -d /LiteLoader
echo 'require("/LiteLoader");' > /opt/QQ/resources/app/app_launcher/llqqnt.js
sed -i 's|"main": "[^"]*"|"main": "./app_launcher/llqqnt.js"|' /opt/QQ/resources/app/package.json

# 安装 whale
curl -L -o /tmp/whale.zip https://github.com/initialencounter/whale/releases/download/v0.1.1/whale.zip
mkdir -p /LiteLoader/plugins/whale
unzip /tmp/whale.zip -d /LiteLoader/plugins/whale

################################################################################################################################

# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm -rf /tmp/.X1-lock &
mkdir -p /var/run/dbus &
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address > /dev/null &
Xvfb :1 -screen 0 1080x760x16  > /dev/null &
export DISPLAY=:1
qq --no-sandbox --disable-gpu" > /root/start.sh

# 安装LLOneBot  
version=v3.33.10
curl -L -o /tmp/LLOneBot.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLOneBot/releases/download/$version}/LLOneBot.zip
mkdir -p /LiteLoader/plugins/LLOneBot
unzip /tmp/LLOneBot.zip -d /LiteLoader/plugins/LLOneBot
rm /tmp/LLOneBot.zip 


echo -e "LLOneBot 安装完成
现在你可以输入命令 \e[32mbash start.sh\e[0m 来启动服务"