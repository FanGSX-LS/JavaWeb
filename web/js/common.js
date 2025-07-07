/**
 * POST无刷新提交
 * @param url 目标地址（提交给谁）
 * @param data 传输的数据类型
 * @param callback 请求成功后的回调函数（要实现的功能）
 */
function postAction(url, data, callback) {
    //通用的无刷新提交(POST)
    $.ajax({
        url: url, //目标地址（提交给谁）
        method: 'post', //提交方式(get|post)
        dataType: 'json', //传输的数据类型
        //一次性获取标点中所有的数据
        data: data,
        //请求成功后要实现功能(匿名)
        success: function (res) {
            callback(res);//回调函数
        },
        //请求失败后要实现功能(匿名)
        error: function (err) {
            alert("请求失败，请联系管理员")
        }
    });
}

/**
 * 功能：验证单个输入框的内容是否为空（公共方法|函数）
 * @param id 输入框的id值
 * @param msg 提示信息
 * @returns {boolean}
 */
function checkInputIsNull(id, msg) {
    let obj = $(id); //通过jquery获取元素对象
    let value = obj.val(); //获取输入框对象中内容
    if (value == "") {
        alert(msg);//提示信息
        obj.focus();//设置当前元素获得焦点(使光标在其身上)
        return false;//终止执行
    }
    return true;
}