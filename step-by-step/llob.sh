# 创建必要的目录
mkdir -p ~/.vnc

# 配置supervisor
echo "[supervisord]" > /etc/supervisor/supervisord.conf
echo "nodaemon=true" >> /etc/supervisor/supervisord.conf
echo "[program:x11vnc]" >> /etc/supervisor/supervisord.conf
echo "command=/usr/bin/x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd" >> /etc/supervisor/supervisord.conf

# 创建启动脚本
echo "chmod 777 /tmp &
rm -rf /run/dbus/pid &
rm /tmp/.X1-lock &
mkdir -p /var/run/dbus &
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address &
Xvfb :1 -screen 0 1080x760x16 &
export DISPLAY=:1
fluxbox & 
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -rfbauth ~/.vnc/passwd &
nohup /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6081 --file-only &
x11vnc -storepasswd vncpasswd ~/.vnc/passwd
qq --no-sandbox &" > /root/start.sh

# 安装LLOneBot  
mkdir -p /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot && \
curl -L -o /tmp/LLOneBot.zip https://mirror.ghproxy.com/https://github.com/LLOneBot/LLOneBot/releases/download/v3.14.1/LLOneBot.zip && \
unzip /tmp/LLOneBot.zip -d /opt/QQ/resources/app/LiteLoader/plugins/LLOneBot/ && \
rm /tmp/LLOneBot.zip
echo -e "LLOneBot 安装完成
现在你可以输入命令 \e[32mbash start.sh\e[0m 来启动服务"