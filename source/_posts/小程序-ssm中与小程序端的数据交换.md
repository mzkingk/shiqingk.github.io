---
title: 小程序-ssm中与小程序端的数据交换
date: 2019-01-03 16:46:38
tags:
---
# 1. controller中
```
@RequestMapping(value = "/upgradeMeetting", method = RequestMethod.POST)
    @ResponseBody
    public boolean upgradeMeetting(@Param("bookRecord") BookRecord bookRecord) {
        System.out.println("输出-->" + bookRecord);
        return true;
    }
```

# 2. 小程序中
	var obj = new Object()
	obj.userId = that.data.userId

	wx.request({
		url: appdata.globalData.localurl + '/upgradeMeetting',
		data: obj,
		header: {
			'content-type': 'application/x-www-form-urlencoded'
		},
		method: 'POST',
		success: res => {
			console.log("返回值", res.data)
		}
    })

# 3. 注意事项
	obj中的变量,必须是bookrecord中也要定义过的,才能正确接收
![image](https://wx3.sinaimg.cn/large/006fjQMUly1fy4gclr282j311t0azjt0.jpg)