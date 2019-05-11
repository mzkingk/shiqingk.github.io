---
title: deepin部分使用笔记
mathjax: true
date: 2019-01-03 19:24:29
categories:
---
# 1. [命令行换壁纸](https://bbs.deepin.org/forum.php?mod=viewthread&tid=29808)
可以先执行这条命令，获取壁纸路径的当前值：
```
$ gsettings get org.gnome.desktop.background picture-uri
'file:///usr/share/backgrounds/default_backgroud.jpg'
```
上面第二行是命令的输出结果，然后依样画葫芦即可修改壁纸：
```
$ gsettings set org.gnome.desktop.background picture-uri file:///home/mzking/壁纸.bmp
```
shell的自动更换文件夹下壁纸
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
[另一位老哥分享的python自动换的](https://bbs.deepin.org/forum.php?mod=viewthread&tid=38940)
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
deb的安装即用版 https://bbs.deepin.org/forum.php?mod=viewthread&tid=156469

# 2. 开机输入密码无法进入界面的问题
多半是显卡的问题
grub那里，用这句
```
nouveau.modeset=0
```
[具体看这里csdn,不过帖子里wifi那部分不用看，没用](https://blog.csdn.net/qq_31707275/article/details/82709133)
# 3. 联想电脑安装linux后wifi不能用的问题
编辑开机启动脚本
```
sudo vi /etc/rc.local
```
填写内容如下
```
#!/bin/sh -e
# 4. rc.local
#
sudo modprobe -r ideapad_laptop

exit 0
```
[参考这里，但博主脚本写的有些问题](https://blog.csdn.net/llfjcmx/article/details/81156593)
# 4. 修改默认文件管理器
```
sudo vi ~/.config/mimeapps.list
```
修改[Default Applications]字段下内容
```
把这里所有旧的文件管理器快捷方式，换成想要改的那个文件管理器的
```

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
# 6. 无用快捷方式清理
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
无用软件
```
sudo apt purge yelp

```