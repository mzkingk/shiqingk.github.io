---
title: ssm-httprequest的请求封装  
date: 2019-05-12 11:52:00  
tags:  
---
# 1. 新建一个UrlConnect.class类,写入该方法
我这用到了net.sf.json.JSONObject这个包，需要在pom里面导入，也可以用其它方式返回结果
```
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.*;
import net.sf.json.JSONObject;

public class UrlConnect {
    public static JSONObject httpRequest(String requestUrl, String requestMethod, String outputStr){
        JSONObject jsonObject = null;
        StringBuffer buffer = new StringBuffer();
        try {
            URL url = new URL(requestUrl);
            HttpsURLConnection httpUrlConn = (HttpsURLConnection) url.openConnection();
            httpUrlConn.setConnectTimeout(8000);
            httpUrlConn.setReadTimeout(8000);
            httpUrlConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");//这里按需修改,不是一定要改(application/json)
            httpUrlConn.setDoOutput(true);
            httpUrlConn.setDoInput(true);
            httpUrlConn.setUseCaches(false);
            // 设置请求方式（GET/POST）
            httpUrlConn.setRequestMethod(requestMethod);
            if ("GET".equalsIgnoreCase(requestMethod))
                httpUrlConn.connect();
            // 当有数据需要提交时
            if (null != outputStr) {
                OutputStream outputStream = httpUrlConn.getOutputStream();
                // 注意编码格式，防止中文乱码
                outputStream.write(outputStr.getBytes("UTF-8"));
                outputStream.close();
            }
            // 将返回的输入流转换成字符串
            InputStream inputStream = httpUrlConn.getInputStream();
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "utf-8");
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String str = null;
            while ((str = bufferedReader.readLine()) != null) {
                buffer.append(str);
            }
            bufferedReader.close();
            inputStreamReader.close();
            // 释放资源
            inputStream.close();
            httpUrlConn.disconnect();
            jsonObject = JSONObject.fromObject(buffer.toString());
        } catch (ConnectException ce) {
            ce.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jsonObject;
    }
}
```
# 2. 其他位置调用
```
JSONObject token = httpRequest(url, "GET", null);//链接,GET/POST方法,额外参数
```