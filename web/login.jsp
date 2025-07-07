<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession session1 = request.getSession();
    session1.invalidate();
%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录页面</title>
    <style>
        @font-face {
            font-family: 'CustomFont';
            src: url('css/bluearchive.ttf') format('truetype');
            font-weight: bold;
            font-style: normal;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'CustomFont', sans-serif;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            /*background: linear-gradient(45deg, #b3d1ff, #2b66e7);*/
            background-image: url("./img/bg.png");
            background-repeat: no-repeat;
            background-size: cover;
            font-family: sans-serif;
        }

        .login-box {
            width: 350px;
            height: 400px;
            background-color: rgb(255, 255, 255); /*28*/
            border-radius: 3px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            opacity: 0;
            transform: translateY(-20px);
            animation: fadeInUp 0.5s ease forwards;
            border-top: #1c9afa 3px solid;
            /*backdrop-filter: blur(5px);*/
        }

        input:hover {
            background: rgba(239, 239, 239, 0.18);
        }

        .login-box h2 {
            float: left;
            text-align: center;
            color: #2b66e7;
            font-size: 22px;
            font-family: 'CustomFont', sans-serif;
        }

        .form-group {
            width: 100%;
            margin-bottom: 20px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
            font-size: 16px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-group input:focus {
            border-color: #2b66e7;
            box-shadow: 0 0 0 3px rgba(43, 102, 231, 0.2);
        }

        .form-group.error input {
            border-color: #e74c3c;
        }

        .form-group.error input:focus {
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.2);
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .form-group.error .error-message {
            display: block;
        }

        .remember {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
            font-size: 15px;
        }

        .remember input {
            margin-right: 8px;
        }

        .login-btn {
            width: 296px;
            padding: 13px;
            background-color: #2b66e7;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 16px;
            margin-top: 15px;
        }

        .login-btn:hover {
            background-color: #1a4ebf;
        }

        .login-btn.loading {
            background-color: #6a99f0;
            cursor: not-allowed;
            transform: none;
        }

        .login-btn.loading::after {
            content: "";
            display: inline-block;
            width: 15px;
            height: 15px;
            margin-left: 8px;
            border: 2px solid #fff;
            border-radius: 50%;
            border-right-color: transparent;
            animation: spin 1s linear infinite;
            vertical-align: middle;
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>
</head>
<body>
<div class="login-box">
    <div style="width: 100%;height: 80px;display: flex;align-items: center;justify-content: flex-start; border-bottom: 1px solid #f9f9f9;padding: 25px;margin-bottom: 10px">
        <h2>设备管理后台登录</h2>
    </div>
    <form id="loginForm" novalidate style="margin: 0 auto;width: 350px;height: 400px;padding: 25px">
        <div class="form-group" id="usernameGroup">
            <p>用户名</p>
            <input type="text" id="username" name="username" placeholder="" required
                   style="width: 296px;height: 30px;padding: 20px;margin-top:5px;border-radius: 3px">
            <div class="error-message">请输入账号</div>
        </div>
        <div class="form-group" id="passwordGroup">
            <p>密码</p>
            <input type="password" id="password" name="password" placeholder="" required
                   style="width: 296px;height: 30px;padding: 20px;margin-top:5px;border-radius: 3px">
            <div class="error-message">请输入密码</div>
        </div>
        <button type="button" class="login-btn" id="loginBtn" onclick="submitForm()">登录</button>
    </form>
</div>
<%--引用jquery代码库--%>
<script src="js/jquery-3.5.1.min.js"></script>
<!-- 引用公共的js文件：common.js -->
<script src="js/common.js"></script>
<script>
    /**
     * 验证表单中的内容是否为空，为空则停止提交表单
     * @returns {boolean}
     */
    function submitForm() {
        //1.验证账号是否为空：!false == true
        //let res = checkInputIsNull('username','请输入账号'); //true（有内容）|false（为空）
        if (!checkInputIsNull('#username', '请输入账号')) return false;
        //2.验证密码是否为空
        if (!checkInputIsNull('#password', '请输入密码')) return false;
        //3.进行无刷新提交数据
        postAction('loginCheck.jsp', $('#loginForm').serialize(), function (res) {
            alert(res.msg);
            if (res.result) window.location.href = res.url;
        })
    }

</script>
</body>
</html>