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
curl -L -o /tmp/LLOneBot.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLOneBot/releases/download/$version/LLOneBot.zip
mkdir -p /LiteLoader/plugins/LLOneBot
unzip /tmp/LLOneBot.zip -d /LiteLoader/plugins/LLOneBot
rm /tmp/LLOneBot.zip 


echo -e "LLOneBot 安装完成
现在你可以输入命令 \e[32mbash start.sh\e[0m 来启动服务"