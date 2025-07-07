package util;

import com.alibaba.fastjson2.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * 格式化返回结果
 */
public class Result {
    /**
     * 通用的返回结果格式
     *
     * @param res  成功(true)或失败(false)的结果
     * @param msg  提示的信息
     * @param url  跳转的地址
     * @param data 返回的数据集
     * @return json格式数据
     */
    public static String result(boolean res, String msg, String url, Map<String, Object> data) {
        Map<String, Object> map = new HashMap<>();
        //Object:泛型，指所有类型
        map.put("result", res);
        map.put("msg", msg);
        map.put("url", url);
        map.put("data", data);
        //使用工具将map数据集转换成标准的json格式数据
        return JSONObject.toJSONString(map);
    }

    /**
     * 返回成功的结果：只携带提示信息
     *
     * @param msg 提示的信息
     * @return
     */
    public static String success(String msg) {
        return result(true, msg, "", null);
    }

    /**
     * 返回成功的结果：携带提示信息及跳转链接
     *
     * @param msg 提示的信息
     * @param url 要跳转的链接
     * @return
     */
    public static String success(String msg, String url) {
        return result(true, msg, url, null);
    }

    /**
     * 返回成功的结果：携带提示信息及数据集
     *
     * @param msg  提示信息
     * @param data 返回的数据集
     * @return
     */
    public static String success(String msg, Map<String, Object> data) {
        return result(true, msg, "", data);
    }

    /**
     * 返回失败的结果：只携带提示信息
     *
     * @param msg 提示信息
     * @return
     */
    public static String error(String msg) {
        return result(false, msg, "", null);
    }

    /**
     * 返回失败的结果：携带提示信息及跳转链接
     *
     * @param msg 提示的信息
     * @param url 要跳转的链接
     * @return
     */
    public static String error(String msg, String url) {
        return result(false, msg, url, null);
    }

    /**
     * 返回失败的结果：携带提示信息及数据集
     *
     * @param msg  提示信息
     * @param data 返回的数据集
     * @return
     */
    public static String error(String msg, Map<String, Object> data) {
        return result(false, msg, "", data);
    }
}

