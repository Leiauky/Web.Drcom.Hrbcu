# 免责声明
在根据本教程进行实际操作时，如因您操作失误导致出现的一切意外，包括但不限于路由器变砖、故障、数据丢失等情况，概不负责；

该技术仅供学习交流，请勿将此技术应用于任何商业行为，所产生的法律责任由您自行承担；

本教程仅用于交流使用，安装路由器的行为完全是您个人意志所决定的，如您已成功安装，请在 24 小时内重置路由器至原出产状态；

请按照学校推荐的方式连接到互联网，如因个人问题受到相关校规追责，由您自行承担。
# 前言
本教程教您如何在Drcom下使用路由器上校园网

本教程适合使用Drcom进行Web验证的用户，同时，要求您的路由器支持刷入第三方系统，如openwrt、padavan。

考虑到萌新不是很会，会尽量详细叙述。

本教程路由器以Redmi AC2100为例，不同型号的路由器操作过程会有所差异，需您自己上网查找操作教程。

# 所需工具
一款支持刷入第三方系统(openwrt、padavan)的路由器、一台Windows10专业版的电脑。

两根网线。

下载软件WinSCP、Xshell。

# 一、刷openwrt（此处以RedmiAC2100举例）
## Ⅰ：前期准备工作
1.开启Telnet

打开“控制面板”点击“程序”在“程序和功能”中打开“启用或关闭Windows功能”勾选“Telnet客户端”点击确定。

2.关闭防火墙和杀毒软件
打开“控制面板”点击“系统和安全”打开“WindowsDefender防火墙”点击“启用或关WindowsDefender防火墙”在“专用网络设置”和“公用网络设置”选择“关闭WindowsDefender防火墙”点击确定。

3.连接路由器

把一根网线连上路由器的wan口（Internet口）和旁边的一个lan口，另一根网线连上路由器的第二个lan口和电脑网口。

4.禁用其他网卡

打开“控制面板”点击“网络和Internet”打开“网络和共享中心”点击左侧的“更改适配器设置”禁用所有不相关的网卡（包括虚拟机的网卡）只留下连接路由器的网卡。

5.修改网卡ip地址

右键“网卡”点击“属性”双击“Internet协议版本4（TCP/IPv4）”点击“使用下面的IP地址”将ip地址ip，子网掩码，默认网关修改为ip地址：192.168.31.177掩码：255.255.255.0网关：192.168.31.1。

## Ⅱ：解锁路由器刷入Breed

1.解压压缩包，安装npcap-0.9991.exe
        
2.在浏览器中打开192.168.31.1，在上网设置中选择pppoe拨号，填入 用户名：123密码：123
        
3.打开文本“开启telnet命令.txt”，复制里面的内容
        
4.双击打开“一键开启telnet.bat”，根据窗口提示进行操作
        
5.按下win+r，输入cmd,复制下列代码运行
```
telnet 192.168.31.1
wget http://192.168.31.177:8081/breed-mt7621-xiaomi-r3g.bin&&nvram set uart_en=1&&nvram set bootdelay=5&&nvram set flag_try_sys1_failed=1&&nvram commit

mtd -r write breed-mt7621-xiaomi-r3g.bin Bootloader
```
6.将网卡改回自动获取IP地址
7.拔掉电源，拿牙签顶住后面重置按钮后不松手的情况下插上电源，路由灯闪烁，稍等片刻
## Ⅲ：进入Breed刷openwrt

1.浏览器输入192.168.1.1进入Breed，点击“环境变量编辑”，添加参数“xiaomi.r3g.bootfw”，数值为2，点击保存

2.点击“固件更新”，刷入openwrt底包。

3.浏览器输入192.168.1.1进入后台，账号：root，密码：password，点击“系统”“备份/升级”，去除“保留配置”选项，上传openwrt完整固件包，点击刷写固件

4.等待路由器重启，在浏览器中输入192.168.2.1，账号：root，密码：password
# 三、使用Xshell、WinSCP连接路由器并联网
## Xshell

点击“新建”，点击“连接”，“名称”输入openwrt，“协议”选择SSH，在“主机”那里输入192.168.2.1，“端口号”22，在“用户身份验证”的方法中选择“Password”，“用户名”输入root，“密码”输入password,点击确定
## WinSCP

“文件协议”选择SCP，“主机名”输入192.168.2.1，“端口号”输入22，“用户名”输入root，“密码”输入password，点击登录

## 修改Drcom.hrbcu.sh文件并通过WinSCP放入路由器系统中

修改完Drcom.hrbcu.sh文件后放入/etc/init.d文件目录中
## 通过Xshell运行Drcom.hrbcu.sh，输入以下命令
```
cd /etc/init.d/
chmod 777 /etc/init.d/Drcom.hrbcu.sh
./Drcom.hrbcu.sh
```

# 四、防检测
## 修改UA
更新 OpenWRT 路由器的软件源，并安装 Privoxy 软件包
```
opkg update
opkg install privoxy luci-app-privoxy luci-i18n-privoxy-zh-cn
```

配置 Privoxy 设置
点击 Services -> Privoxy WEB proxy
Files and Directories（文件和目录）：Action Files 删除到只剩一个框，填入match-all.action。Filter files 和 Trust files 均留空
Access Control（访问控制）：Listen addresses 填写0.0.0.0:8118，Permit access 填写192.168.0.0/16。Enable action file editor 勾选
Miscellaneous（杂项）：Accept intercepted requests 勾选
Logging（日志）：全部取消勾选
点击 Save & Apply

配置防火墙转发。点击 Network-> Firewall（防火墙），然后点击 Custom Rules 标签，在大框框里另起一行，添加下面的代码：
```
iptables -t nat -N PrivoxyUA
iptables -t nat -I PREROUTING -p tcp --dport 80 -j PrivoxyUA
iptables -t nat -A PrivoxyUA -m mark --mark 1/1 -j RETURN
iptables -t nat -A PrivoxyUA -d 0.0.0.0/8 -j RETURN
iptables -t nat -A PrivoxyUA -d 127.0.0.0/8 -j RETURN
iptables -t nat -A PrivoxyUA -d 192.168.0.0/16 -j RETURN
iptables -t nat -A PrivoxyUA -p tcp -j REDIRECT --to-port 8118
```
点击 Restart Firewall（重启防火墙）按钮

使用 Privoxy 替换 UA。打开http://config.privoxy.org/edit-actions-list?f=0 点击 Edit 按钮。在Action 那一列中，hide-user-agent 改选为 Enable（绿色）,其它全部选择为 No Change （紫色）。最后点击 Submit 按钮，再次重启路由器
验证防检测效果。手机连接到该路由器的WIFI，使用手机在浏览器打开http://www.user-agent.cn/ 查看结果是否为Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.108 Safari/537.36

# 五、自启设置
通过Xshell进入rc.d目录
```
cd  /etc/rc.d
```
在rc.d目录下建立启动软链接
```
ln -s /etc/init.d/Drcom.hrbcu.sh /etc/rc.d/S99Drcom.hrbcu.sh
```
