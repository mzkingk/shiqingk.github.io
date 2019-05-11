---
title: '小程序-提交一次,获取多个formid'
date: 2019-01-03 16:08:48
tags:
---
# 1. wxml中
```
    <form bindsubmit="formSubmit" report-submit="{{true}}">
        <button formType="submit" class='btn'>
            <form bindsubmit="formSubmit2" report-submit="{{true}}">
                <button form-type='submit' class='btn-area' bindtap="doFinish">{{finish}}</button>
            </form>
        </button>
    </form>
```

# 2. wxss中
按钮的没写,以下必须写

```
form button {
    padding: 0;
}

form button::after {
    display: none;
}
```

# 3. js中
```
Page({
    /**
     * 页面的初始数据
     */
    data: {
        formId: null
    },
    /**
     * form提交表单
     */
    formSubmit(e) {
        if (e.detail.formId != 'the formId is a mock one') {
            this.setData({
                formId: this.data.formId + "," + e.detail.formId
            })
        }
        console.log('submit事件,必须手机上执行才有效，携带数据为：', this.data.formId);
    },
    formSubmit2(e) {
        if (e.detail.formId != 'the formId is a mock one') {
            this.setData({
                formId: e.detail.formId.split(' ')
            })
        }
    }
})
```
# 4. 然后要发送等操作,调用如下

```
var form = that.data.formId.split(',');
console.log(form[0])
console.log(form[1])
```