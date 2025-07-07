<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>新增用户</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/add.css">
</head>
<body>
<%--
    1.标题：新增用户
    2.表单：form元素
    3.输入框：账号、密码、确认密码、姓名
    4.按钮：提交、重置、返回
--%>
<header>
    <div class="title">新增用户</div>
</header>
<div class="main">
    <form id="addForm">
        <div class="form-item">
            <label for="username">账号：</label>
            <input id="username" name="username" type="text">
        </div>
        <div class="form-item">
            <label for="password">密码：</label>
            <input id="password" name="password" type="password">
        </div>
        <div class="form-item">
            <label for="cmfPsw">确认密码：</label>
            <input id="cmfPsw" name="cmfPsw" type="password">
        </div>
        <div class="form-item">
            <label for="realname">姓名：</label>
            <input id="realname" name="realname" type="text">
        </div>
        <div class="form-item">
            <button class="primary" id="btnSubmit" type="button">提交</button>
            <button type="reset">重置</button>
            <button id="btnBack" type="button">返回</button>
        </div>
    </form>
</div>
<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    /*
    * 功能：
    * 1.绑定提交按钮的点击事件
    *   (1)验证是否为空：账号、密码、姓名
    *   (2)无刷新提交数据
    *       网址(用于真正处理保存)
    *       获取表单中所有数据
    *       请求成功后的操作：
    *           保存成功：弹出提示信息，返回列表页面
    *           保存失败：弹出提示信息
    * 2.绑定返回按钮的点击事件：返回列表页面
    * */
    //1.绑定提交按钮的点击事件
    $('#btnSubmit').on('click', function () {
        //(1)验证是否为空：账号、密码、姓名
        if (!checkInputIsNull('#username', '请输入账号')) return false;
        if (!checkInputIsNull('#password', '请输入密码')) return false;
        //验证两次输入的密码是否一致
        if ($('#password').val() !== $('#cmfPsw').val()) {
            alert('两次输入的密码不一致');
            $('#cmfPsw').val('').focus();//清空确认密码，并设置其获得焦点
            return false;//停止往下执行
        }
        if (!checkInputIsNull('#realname', '请输入姓名')) return false;
        //(2)无刷新提交数据
        postAction('/user/add', $('#addForm').serialize(), function (res) {
            alert(res.msg);
            if (res.result) window.location.href = res.url;
        });
    });
    //2.绑定返回按钮的点击事件：返回列表页面
    $('#btnBack').on('click', function () {
        if (confirm("确定要返回列表页面吗？")) {
            window.location.href = 'list.jsp';
        }
    });
</script>
</body>
</html>
