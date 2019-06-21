---
title: docker使用笔记
date: 2019-06-20 20:46:45
tags:
---
# deepin-15.10安装docker

教程来自深度社区大佬lanseyujie<https://bbs.deepin.org/forum.php?mod=viewthread&tid=179562&extra=>
```shell
sudo apt-get update
```
**移除旧版本的 Docker**
```shell
sudo apt-get remove docker docker-engine docker.io
```
**安装以下软件包以允许 apt 通过 HTTPS 使用仓库**
```shell
sudo apt-get install apt-transport-https ca-certificates curl
```
**添加 Docker 的官方 GPG 密钥**
```shell
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
**切换 root 用户，添加 Docker 官方仓库**
```shell
sudo su
echo -e "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" >> /etc/apt/sources.list
```
或者用清华源 也行 https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian stretch stable

**安装 Docker-CE**
```shell
sudo apt-get update && sudo apt-get install docker-ce -y
```
免 sudo 使用 docker，注销再登录 即可生效。参考链接：<http://tinylab.org/use-docker-without-sudo/>

```shell
#添加docker group
sudo groupadd docker

#将用户加入该 group 内
sudo gpasswd -a ${USER} docker

#重启 docker 服务
sudo service docker restart

#切换当前会话到新 group 或者重启 X 会话
newgrp - docker
```
# docker常用命令

可能大部分都需要sudo权限运行

| 命令                   | 解释                                 |
| ---------------------- | ------------------------------------ |
| docker pull mysql      | mysql是镜像名，可换成其它程序        |
| docker images          | 查看镜像                             |
| docker ps              | 查看运行的容器                       |
| docker rm docker-mysql | docker-mysql是容器名，可换成其它容器 |

# docker使用mysql

主要参考自简书用户@[吧啦啦小汤圆](https://www.jianshu.com/p/d9b6bbc7fd77) 
```shell
#从docker hub的仓库中拉去mysql镜像
sudo docker pull mysql

#运行一个mysql容器,docker-mysql是容器名，3307是映射到物理机器的端口，123456是密码，5.7是版本
sudo docker run --name docker-mysql -p 3307:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql:5.7
```

连接时，像平常连接mysql一样连接即可
```shell
#-h后的是docker的ip，linux下根据ifconfig查看；3307端口，mzking是密码
mysql -h172.17.0.1 -P3307 -uroot -pmzking
```
