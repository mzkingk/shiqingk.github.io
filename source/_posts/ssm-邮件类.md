---
title: ssm-邮件类  
date: 2019-05-12 11:44:31  
tags:
---
大概操作如下,记录一下
## 1. pom.xml中添加以下包
```
<dependency>
    <groupId>javax.mail</groupId>
    <artifactId>mail</artifactId>
    <version>1.5.0-b01</version>
</dependency>
```
## 2. 发件人邮箱开启pop3服务
我用的是qq邮箱,如果用的其它邮箱按需修改服务器主机
qq邮箱设置页，生成一个授权码,并复制下来
## 3. 新建一个邮件类
我是在util目录下的新建了一个EmailUtil.java
```
/**
 * 邮件服务
 */
public class EmailUtil {
    private static String sender = "发件人qq邮箱";
    private static String passwd = "授权码";
    
    public static boolean send(String receiver, String subject, String msg) throws MessagingException {
        Properties props = new Properties();
        // 开启debug调试
        props.setProperty("mail.debug", "true");
        // 发送服务器需要身份验证
        props.setProperty("mail.smtp.auth", "true");
        // 设置邮件服务器主机名
        props.setProperty("mail.host", "smtp.qq.com");
        // 发送邮件协议名称
        props.setProperty("mail.transport.protocol", "smtp");
        // 设置环境信息
        Session session = Session.getInstance(props);
        // 创建邮件对象
        Message message = new MimeMessage(session);
        message.setSubject(subject);
        // 设置邮件内容
        message.setText(msg);
        // 设置发件人
        message.setFrom(new InternetAddress(sender));
        Transport transport = session.getTransport();
        // 连接邮件服务器
        transport.connect(sender, passwd);
        // 发送邮件
        transport.sendMessage(message, new Address[]{new InternetAddress(receiver)});
        // 关闭连接
        transport.close();
        return true;
    }
}
```
## 4. 如何使用
### 4.1.发邮件的位置直接调用就好了
```
try {
    EmailUtil.send(email, title, msg);//收件人,标题,内容
} catch (MessagingException e) {
    e.printStackTrace();
}
```
### 4.2.改进版
由于发邮件比较耗费时间,发一个就得6s左右,如果连续发送多条需要更长时间,建议在需要发邮件的时候,新开辟一个线程,专门用来发送邮件

java中开启多线程的方法有好几种

这里我用的是最方便的一种,匿名内部类

在普通方法中,需要邮件服务的位置,直接加入这句,然后调用邮件服务就可以了
```
Thread sendThread = new Thread(() -> {
    //正则表达式匹配邮箱
    boolean emailTrue = email != null && email.matches("[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?");
    if (emailTrue) {
       try {
           EmailUtil.send(email, title, msg);//收件人,标题,内容
       } catch (MessagingException e) {
            e.printStackTrace();
       }
    }
});
sendThread.start();
```
EmailUtil类,学习自csdn,但原贴已经找不到了,感谢前人的分享