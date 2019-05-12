---
title: ssm-jsp中用隐式form表单带参跳转
date: 2019-05-12 11:49:02
tags:ssm
---
# 1. login.jsp中在需要跳转的位置,写入这段
如果传参较多,可以拼接f.innerHTML的字符串
```
    var f = document.createElement('form');
    f.style.display = 'none';
    f.action = 'index.jsp';//跳转的页面
    f.method = 'post';
    f.innerHTML = '<input type="hidden" name="account" value="' + "传的参数" + '"/>';
    document.body.appendChild(f);
    f.submit();
```
# 2. index.jsp中接收,传过来直接是json格式的数据
这里用的是js接收
```
<script type="text/javascript">
var account = "${param.account}";
</script>
```
用java应该也能接收,没试