# 在手机上部署 LLOneBot
本项目提供了在安卓手机上安装 [LLOneBot](https://github.com/LLOneBot/LLOneBot) 的方法
使用 [ZeroTermux](https://github.com/hanxinhao000/ZeroTermux) + bookworm + linuxqq 制作

- 基于 Linux QQ
- 运行内存大于 600M
- 支持持久化 QQ 登录状态和数据

# 目录：
- 1. 安装 ZeroTermux 和 VncView
- 2. 安装 LLOneBot
   * 2.1 方法1. 使用恢复包安装（推荐）
   * 2.2 方法2. 使用命令安装
   * 2.3 方法3. 使用一键脚本（推荐）
- 3. 启动 VNC
- 4. 登录 VNC
- 5. 登录 Linux QQ
- 6. 修改 LLOneBot 配置

## 1. 安装 ZeroTermux 和 VncView
前往[hanxinhao000/ZeroTermux](https://github.com/hanxinhao000/ZeroTermux/releases)下载 ZeroTermux 安装包并安装
安装一个vnc客户端，推荐 [RealVNC](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android)

- 注意事项： 
   直接从 GitHub 下载 ZeroTermux 速度可能会很慢，建议使用 [ghproxy.com](https://ghproxy.com) 代理
    
## 2. 安装 LLOneBot

### 2.1 使用恢复包安装（推荐）

<details>
  <summary>点击展开内容！</summary>

#### 2.1.1 下载恢复包
前往 [Github releases](https://github.com/LLOneBot/llonebot-termux/releases) 下载 ZeroTermux 恢复包, 并将恢复包放在 手机的 `内部存储/xinhao/data/` 目录

- 注意事项： 
    - 恢复包要放在 `内部存储/xinhao/data/`目录或者 `/sdcard/xinhao/data`目录，否则在恢复容器的时候无法找到恢复包

#### 2.1.2 恢复容器
- 打开ZeroTermux
- 恢复
    进入ZeroTermux 点击音量上键 呼出菜单栏 点击菜单栏的 `备份/恢复` 选择下载的恢复包
    输入一个容器名字点击恢复 这个过程需要等待几分钟
- 切换容器
    再次点击音量上键， 呼出菜单栏，点击菜单栏的 `容器切换` 选择刚才创建的容器 询问你是否需要重启时， 选择立即重启，接下你将进入启动界面

- 注意事项：
    - 如果音量上键无法呼出菜单，说明你的ZeroTermux版本比较旧，可以使用右滑左侧的屏幕边缘来呼出菜单栏
</details>

### 2.2 使用命令安装（不推荐）

[点我](./step-by-step/readme.sh)

### 2.3 使用一键脚本（推荐）
   ```shell
   bash -c "$(curl -L https://github.com/LLOneBot/llonebot-termux/raw/main/onekey.sh)"
   ```
### 3. 启动 VNC
>如果你使用的是恢复包，VNC将会在进入终端时自启
如果你的 LLOneBot 是用命令安装的，那么你需要手动启动
```shell
bash /root/start.sh
```

### 4. 登录vnc
使用VNC软件登陆服务器IP:5900 默认密码是vncpasswd

### 5. 登录qqnt
在终端中输入qq, 回车
一段时间后桌面会弹出二维码，扫码即可

### 7. 修改LLOneBot配置
登录VNC后在QQ设置页面修改
或直接修改配置文件 /opt/QQ/resources/app/LiteLoader/data/LLOneBot/config_$ACCOUNT.json，修改后重启 QQ 或 termux

## 参考与基础
[LLOneBot/LLOneBot](https://github.com/LLOneBot/LLOneBot)

[yuuki-nya/chronocat-docker](https://github.com/yuuki-nya/chronocat-docker/blob/main/Dockerfile)

[yudezeng/yutools](https://gitee.com/yudezeng/yutools)