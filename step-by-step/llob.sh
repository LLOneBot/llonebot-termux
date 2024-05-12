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

# 安装LLWebUiApi
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
curl -L -o /tmp/LLWebUiApi.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLWebUiApi/releases/download/v0.0.31/LLWebUiApi.zip
unzip /tmp/LLWebUiApi.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLWebUiApi
mkdir -p /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi
echo '{"Server":{"Port":6099},"AutoLogin":true,"BootMode":3,"Debug":false}' > /opt/QQ/resources/app/LiteLoader/data/LLWebUiApi/config.json
rm /tmp/LLWebUiApi.zip

# 安装LLOneBot  
version=$(curl -Ls "https://api.github.com/repos/LLOneBot/LLOneBot/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot
curl -L -o /tmp/LLOneBot.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLOneBot/releases/download/$version}/LLOneBot.zip
unzip /tmp/LLOneBot.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot
rm /tmp/LLOneBot.zip 
echo -e "LLOneBot 安装完成
现在你可以输入命令 \e[32mbash start.sh\e[0m 来启动服务"