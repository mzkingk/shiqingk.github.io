---
title: deepin部分使用笔记  
date: 2019-01-03 19:24:29  
tags:  
---
linux用过挺长的一段时间了，最开始用的是Ubuntu18.04用了半年，后来换成deepin15.8一直用到现在，这里主要记录一些，使用过程中的经验总结吧  
被修复的问题，或者失效的，都及时删掉了
# 干掉dde托盘小图标
dde桌面托盘那里有音量、wifi设置等快捷方式，但我不太喜欢用，查了查发现使用插件实现的  
解决方案如下
```
sudo mv /usr/lib/dde-dock/plugins/libtray.so /usr/lib/dde-dock/plugins/libtray.so.bak
```
# 1. 升级新内核后vmware15无法打开
从4.X更新到新的内核后，vmware都无法打开，根据弹窗提示的日志文件，查看对应的日志
```
sudo cat /tmp/vmware-root/vmware-2290.log
```
能找到下面三处错误：
```
Failed to find /lib/modules/$(uname -r)/build/include/linux/version.h

Failed to build vmmon.  Failed to execute the build command.

Failed to build vmnet.  Failed to execute the build command.
```
问题一不解决好像也没问题，主要是后面两个，不过查到了，就把方法也贴出来了
```
sudo ln -s /usr/include/linux/version.h /lib/modules/$(uname -r)/build/include/linux/version.h
```
第二种第三种就是无法编译 vmmon 与 vmnet 模块  
首先回到旧内核
卸载最新版的内核及其文件
然后重装最新内核
然后重启从新内核进入系统，以root权限执行下面的脚本
```
#!/bin/bash
# VMWARE_VERSION是当前电脑上安装的内核版本，按需修改
VMWARE_VERSION=workstation-15.0.4
TMP_FOLDER=/tmp/patch-vmware
rm -fdr $TMP_FOLDER
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER

git clone https://github.com/mkubecek/vmware-host-modules.git
cd $TMP_FOLDER/vmware-host-modules
git checkout $VMWARE_VERSION
git fetch

tar -cf vmmon.tar vmmon-only
tar -cf vmnet.tar vmnet-only
sudo cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/
sudo vmware-modconfig --console --install-all

sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo ln -s /lib/x86_64-linux-gnu/libz.so.1 /usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo /etc/init.d/vmware restart
```
如果最新的内核上启动过vmware，则必须将回到旧内核卸载重装新内核才能继续执行脚本  
部分参考自 https://blog.csdn.net/wpzsidis/article/details/78222025  和  https://plumz.me/archives/9871/  
# 2. vmware中虚拟机安装vmware-tools失败
错误提示为
```
There was a problem updating a software component. Try again later and if the problem persists, contact VMware Support or your system administrator
```
打印一下错误日志
```
cat /var/log/vmware-installer

发现下面这一行
libncursesw.so.5: cannot open shared object file: No such file or directory
```
我试过安装libncursesw.so.5、libncursesw.so.6结果都一样，最后发现需要手动建立一条软链接
```
sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.6 /usr/lib/libncursesw.so.5
```
再关闭虚拟机打开，应该就可以正常安装vmware-tools了
# 3. 命令行换壁纸
第一种方案：可以先执行这条命令，获取壁纸路径的当前值。这里用到了org.gnome.desktop.background这句，但实际上与是否使用gnome桌面环境是没什么关系的
```
$ gsettings get org.gnome.desktop.background picture-uri

'file:///usr/share/backgrounds/default_backgroud.jpg'
```
上面第二行是命令的输出结果，然后依样画葫芦即可修改壁纸：
```
$ gsettings set org.gnome.desktop.background picture-uri file:///home/mzking/壁纸.bmp
```
学习自https://bbs.deepin.org/forum.php?mod=viewthread&tid=29808  
升级版：自动更换文件夹下壁纸
```
#!/bin/bash

while [ 1 -eq 1 ]; do
for i in $(echo /home/mzking/Wallpapers/*.jpg); do
        echo $i
        gsettings set org.gnome.desktop.background picture-uri file:///${i}
        sleep 600;
done
done
```
[python版](https://bbs.deepin.org/forum.php?mod=viewthread&tid=38940)
```
import os
import os.path
import time
rootdir="/home/kirigayaloveyousei/Wallpaper/"
while True:        
    for parent,dirnames,filenames in os.walk(rootdir):
        for filename in filenames:        
            #print("filename with full path:"+ os.path.join(parent,filename))
            os.system("gsettings set org.gnome.desktop.background picture-uri file://"+os.path.join(parent,filename))
            print("正在设置壁纸,壁纸来自:"+os.path.join(parent,filename))
            time.sleep(60)
```
还有一种是，deb的安装即用版 https://bbs.deepin.org/forum.php?mod=viewthread&tid=156469  
# 4. 修改默认文件管理器
```
sudo vi ~/.config/mimeapps.list
```
修改[Default Applications]字段下内容
```
把这里所有旧的文件管理器快捷方式，换成想要改的那个文件管理器的
```
[学习自deepin社区(@dragondjf)](https://bbs.deepin.org/)
# 5. 把dock栏的工具图标移到topbar上面
1.安装deepin-topbar
```
sudo apt install deepin-topbar.deb
```
2.打开topbar设置，去掉最后一项的对勾
3.修改dde-dock.conf
```
sudo vi /home/mzking/.config/deepin/dde-dock.conf
```
改完后，全部内容如下
```
[datatime]
enable=false

[datetime]
enable=false

[shutdown]
enable=false

[system-tray]
enable=false
pos_fashion-mode-item_0=3

[tray]
enable=false
fashion-tray-expanded=false
```
4.重启电脑
# 6. 无用文件清理
有一部分选自[知乎专栏](https://zhuanlan.zhihu.com/p/26032793)
```
清理不常用的软件
sudo apt-get purge thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku onboard deja-dup libreoffice-common unity-webapps-common yelp

清理旧版本的软件缓存
sudo apt-get autoclean

清理所有软件缓存
sudo apt-get clean

删除系统不再使用的孤立软件
sudo apt-get autoremove
```
一些快捷方式
```
sudo rm /usr/share/applications/hplj1020.desktop
sudo rm /usr/share/applications/evince-previewer.desktop
sudo rm /usr/share/applications/assistant-qt5.desktop
sudo rm /usr/share/applications/vmware-player.desktop
sudo rm /usr/share/applications/fcitx.desktop
sudo rm /usr/share/applications/fcitx-skin-installer.desktop
sudo rm /usr/share/applications/fcitx-config-gtk3.desktop
sudo rm /usr/share/applications/nemo-autostart.desktop
```
# 7. 开机自启管理程序
gnome桌面下有效，可以用来便捷的添加开机自启项，其它桌面的不用尝试了
```
sudo apt install gnome-startup-properties 
```
# 8. 开机自动挂载磁盘
查看磁盘分区的UUID
```
sudo blkid
```
配置开机自动挂载：将分区信息写到/etc/fstab文件中让它永久挂载：
```
sudo vim /etc/fstab
```
例如
```
UUID=42168DE83BC5EDAD   /media/mking/dataD       ntfs    defaults        0       1
```
说明：/media/mking/dataD为当前挂载的位置，不是/dev/sda1。
[原贴](https://www.cnblogs.com/EasonJim/p/7447000.html)
# 9. 对文本按行排序
这里是对我自己在用的ublock规则整理，然后想对已有的进行去重排序，用到了这个  
去除文件中重复行并输出到新文件
```
cat filename |sort|uniq > outfilename.txt
```
删除以!开头的行并输出到新文件
```
sed -r '/^\!/d' b.txt > c.txt
```
整合版，去除a中重复行并输出到b，然后对b排序输出到c，删除b
```
cat a.txt |sort|uniq > b.txt && sed -r '/^!/d' b.txt > c.txt && rm b.txt
```
# 10. sudo gedit 错误：Gtk-WARNING **: cannot open display: :0.0
这个问题是在ubuntu18.04下遇到过很多次，在深度里面还没遇到过。  
当使用su 到另外一个用户运行某个程序，而这个程序又要有图形显示的时候，就有可能有下面提示：
```
No protocol specified
Unable to init server: 无法连接： 拒绝连接
(gedit:22339): Gtk-WARNING **: **:**:**.**: cannot open display: :0
```
解决方法：
这是因为Xserver默认情况下不允许别的用户的图形程序的图形显示在当前屏幕上. 如果需要别的用户的图形显示在当前屏幕上, 则应以当前登陆的用户, 也就是切换身份前的用户执行如下命令。
```
xhost +
```
通过执行这条命令，就授予了其它用户访问当前屏幕的权限，于是就可以以另外的用户运行需要运行的程序了。[学习自linux公社](https://www.linuxidc.com/Linux/2017-10/148145.htm)
# 11. ubuntu18下坚果云使用问题
提示无法连接ssl，则备份并移除老的cacerts
```
sudo mv /etc/ssl/certs/java/cacerts{,.backup}
```
生成新的cacerts
>sudo keytool -importkeystore -destkeystore /etc/ssl/certs/java/cacerts -deststoretype jks -deststorepass changeit -srckeystore /etc/ssl/certs/java/cacerts.backup -srcstoretype pkcs12 -srcstorepass changeit

[吧友@珏缘愛](http://tieba.baidu.com/p/5680448441)询问官方后官方提供的临时解决方案
另一种，清除重装方案(客服给我的回复)
```
rm ~/.config/autostart/nutstore-daemon.desktoprm ~/.local/share/applications/nutstore-menu.desktoprm ~/.local/share/icons/hicolor/64x64/apps/nutstore.pnggtk-update-icon-cache --ignore-theme-index "~/.local/share/icons/hicolor" > /dev/null 2>&1rm -r ~/.nutstore/dist
```
上面这一段，客服回我的，分割都没做好，整理之后如下，输完了重新安装就可解决无法打开的问题
```
rm ~/.config/autostart/nutstore-daemon.desktop
rm ~/.local/share/applications/nutstore-menu.desktop
rm ~/.local/share/icons/hicolor/64x64/apps/nutstore.png
gtk-update-icon-cache --ignore-theme-index "~/.local/share/icons/hicolor" > /dev/null 2>&1
rm -r ~/.nutstore/dist
```
# 12. 在线视频播放的问题
这个是ubuntu遇到的问题，h5跟flash两种情况不能播放都有，分享到csdn上了  
[可以看看我在csdn上的一篇分享](https://blog.csdn.net/qq_37623240/article/details/82288689)
# 13. 使用ssh链接linux主机时，可能出现“Host key verification failed.“的提示，ssh连接不成功。
在.ssh/config（或者/etc/ssh/ssh_config）中配置：
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
原帖地址 http://www.51testing.com/html/38/225738-234384.html

# 14. 缩短grub开机引导界面时长
```
sudo gedit /etc/default/grub
```
GRUB_TIMEOUT这里按需修改，改成0、1、2、3都是2s？自行尝试
完成后命令行必须更新grub配置
```
sudo update-grub
```
# 15. 给apt-get开启多线程加速
```
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update
sudo apt-get -y install apt-fast
```
装完之后，弹出一个页面，选择apt-get或者apt都可以，选择哪个就是给哪个开启多线程
以后也可以用apt-fast代替apt-get来操作
[详细介绍看这里](https://www.tecmint.com/use-apt-fast-command-speed-up-apt-get-downloads-installs-ubuntu/)

# 16. boot空间不足
打开终端，在终端里依次输入一下命令，以解决/boot分区满的问题： 
```
df -h  #（查看Ubuntu的文件系统 使用情况） 

uname -a  #(查看当前使用的内核版本) 

dpkg --get-selections| grep linux   #(查看已经安装的内核，然后删掉不用的旧的)

sudo apt-get remove linux-image- #（删掉旧的，别删错了！！！） 

sudo update-grub
```
再查看下内核和磁盘容量，发现释放了很多空间。   
在之后更新grub引导  
```
sudo /usr/sbin/update-grub 
```
done......

# 17. 更换字体
ubuntu自带的字体不太好看，所以采用文泉译微米黑字体替代，效果会比较好，毕竟是国产字体！
```
sudo apt-get install fonts-wqy-microhei
```
然后通过unity-tweak-tool来替换字体：
# 18. unity-tweak-tool
调整 Unity 桌面环境，还是推荐使用Unity Tweak Tool，这是一个非常好用的 Unity 图形化管理工具，可以修改工作区数量、热区等。
```
sudo apt-get install unity-tweak-tool 
```
安装Unity-Tweak-Tool出错
The following schema is missing
com.canonical.notify.osd 
In order to work properly, Unity Tweak Tool recommends you install the necessary packages.

则
```
sudo apt-get install notify-osd
```
遇到com.canonical.indicator.bluetooth missing，则
```
sudo apt-get install indicator-* hud
```
# 19. ubuntu离线安装网卡驱动(对于博通部分网卡有效)
把iso包解压：按照这个路径找到这样一个文件
``` 
pool -> main -> d -> dkms -> dkms_2.2.0.3-2ubuntu11.1_all.deb
```
在这个文件夹下右键打开终端，运行

```
sudo dpkg -i dkms_2.2.0.3-2ubuntu11.1_all.deb
```
然后打开这个目录，找到驱动文件
```
ubuntu-16.04-desktop-amd64 -> pool -> restricted -> b -> bcmwl -> bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu8_amd64.deb
```
这就是无线网卡的驱动安装包了，在这个文件的目录下右键打开终端
```
运行
sudo dpkg -i [文件名]
示例
sudo dpkg -i bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu8_amd64.deb
```
然后重启Wi-Fi，就可以搜索到 WIFI了。
# 20. 超好用的多线程下载工具-aria2的安装：
```
sudo apt-get update 
sudo apt-get install aria2
```
使用的时候
```
aria2c url
```
# 21. v2ray在linux下的使用指南
ubuntu系统下使用命令
```
sudo su & bash <(curl -L -s https://install.direct/go.sh)
```
安装完成后,参照网上的教程修改/etc/v2ray/config.json改成用户端的配置
```
sudo gedit /etc/v2ray/config.json
```
改成全局代理，目前的模式默认为国内外自动分流，国外走代理，国内直连，但是想国内国外一起走代理，则
> 在config.json配置文件的routing里改，把rules里面删空

然后v2ray里面的本地端口是多少，就把代理设置的sock5端口改成多少
# 22. linux下在终端连接vps
终端输入
```
ssh root@ip
```
或者文件传输模式则，输入
```
sftp root@ip
```
或者用scp传，具体略
# 23. 查看当前ip信息
```
sudo curl ip.gs
```
如果提示未安装curl，则  
```
sudo apt install curl
```
# 24. 彻底删除wine
先依次执行以下操作  
１，卸载之：
```
sudo apt-get remove wine
```
２，清除程序目录及系统菜单项,图标等
```
sudo rm -rf $HOME.wine
sudo rm -f $HOME/.config/menus/applications-merged/wine*
sudo rm -rf $HOME/.local/share/applications/wine
sudo rm -f $HOME/.local/share/desktop-directories/wine*
sudo rm -f $HOME/.local/share/icons/????_*.{xpm,png}
sudo rm -f $HOME/.local/share/icons/*-x-wine-*.{xpm,png}
```
3,删除一些扩展文件
删除所有类似wine-extension-*.desktop这类的东东
```
sudo rm -rf $HOME/.local/share/applications/wine*
```
另外一个目录: ~/.local/share/mime/packages
清除所有 x-wine-extension... 这样的文件
```
sudo rm -rf $HOME/.local/share/mime/packages/x-wine*
```
然后还有一些图标选择性删除
这个目录下：``$HOME/.local/share/icons``把不要的删了
然后 sudo reboot 重启就ＯＫ了，不重启也行
原帖地址[https://blog.csdn.net/ustczwc/article/details/8956371](https://blog.csdn.net/ustczwc/article/details/8956371)
# 25. eclipse中文乱码解决方案：
>1：windows-->preferences-->General-->Workspace--> 选择Text file encoding中的**Other**，选择**GBK**，如果没有直接输入GBK，点击“Apply”

>2：windows-->preferences-->General-->Content Types-->点击右边窗口中的Text，选择Java Source File，在Default encoding【在窗口最下边，如果看不到，拖动滑块下拉即可看到】中输入GBK，点击OK。

# 26. Vnote-大概是最好用的md编辑器
用它最好配合上AppImageLauncher，下载好 Appimage文件后，借助AppImageLauncher可以添加到程序清单中去
> https://github.com/tamlok/vnote/blob/master/README_zh.md
# 27. 使用 AppImageLauncher 轻松运行和集成 AppImage 文件
如果是使用 **Ubuntu 18.04**，请确保下载的 deb 包的名字中有**bionic**，而其它的 deb 是用于旧一些的 Ubuntu 版本的  
>[https://github.com/TheAssassin/AppImageLauncher/releases](https://github.com/TheAssassin/AppImageLauncher/releases)

完了在appimage文件上右键用它打开就行
# 28. 命令行走socks5代理：Proxychains
deepin一直是自带的，没有的话可以自行安装
```
sudo apt-get install proxychains  
```
修改，只需要把 /etc/proxychains.conf 末尾一行改成这样OK：  
```
socks5 127.0.0.1 1080  
```
这样 socks5 连接到 1080 端口之后，就可以在命令前面加上 proxychains 来让程序走 socks5 代理。  
```
sudo proxychains apt-get update  
```
