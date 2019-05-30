---
title: 自行编译shadowsocks-deepin
date: 2019-05-30 16:44:12
tags: linux
---
# 安装要用到的软件
```
sudo apt update
sudo apt install qt5-default qttools5-dev-tools qt5-qmake g++ qtcreator qttools5-dev -y
sudo apt install libdtkbase-dev libdtkwidget-dev -y
sudo apt install libdframeworkdbus-dev -y
sudo apt install libqrencode-dev libzbar-dev -y
sudo apt install libdtkcore-dev libdtkwidget-dev libdtkwm-dev libdtkcore-bin -y
sudo apt install libdtksettings-dev libdtksettingsview-dev -y
sudo apt install dh-make fakeroot -y
```
# 安装QtShadowsocks
这个必须自己安装，否则直接执行第三步会编译失败
```
FOLDER=$(dirname $(readlink -f "$0"))
rm -rf libQtShadowsocks
git clone https://github.com/shadowsocks/libQtShadowsocks.git
cd libQtShadowsocks
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DUSE_BOTAN2=ON
make -j4
sudo make install
cd ${FOLDER}
```
# 编译shadowsocks-deepin
```
rm -rf shadowsocks-deepin
git clone https://github.com/lolimay/shadowsocks-deepin.git
cd shadowsocks-deepin
mkdir build && cd build
cmake ..
make -j4
```

# 安装程序
在shadowsocks-deepin/build目录下执行
```
sudo make install
```
