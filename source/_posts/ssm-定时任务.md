---
title: ssm-定时任务  
date: 2019-05-12 11:41:43  
tags:  
---
# 1. 在springmvc.xml添加如下内容 
在xmlns中增加

```
xmlns:task="http://www.springframework.org/schema/task"
```

在xsi中增加
```
http://www.springframework.org/schema/task
http://www.springframework.org/schema/task/spring-task-3.2.xsd
```

在中间添加
base-package是扫描位置
```
<!-- 设置定时任务 -->
<task:annotation-driven/>
<context:component-scan base-package="包名.目录名"></context:component-scan>
```
# 2. service层
TaskService.java
```!
@Component
public class TaskService{
    /**
     * 每隔10秒隔行一次
     */
    @Override
    @Scheduled(cron = "0/10 * * * * ?")
    public void test2() {
        System.out.println("job2 开始执行");
    }
}
```