<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    // 设置请求编码
    request.setCharacterEncoding("UTF-8");

    // 功能：通过查询数据库，获取对应的用户信息，显示在对应的输入框中
    // 获取要编辑的数据编号
    String id = request.getParameter("id");
    String action = request.getParameter("action");
    boolean updateSuccess = false;
    String errorMsg = "";

    // 如果是提交操作，则处理数据
    if ("insert".equals(action)) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String realname = request.getParameter("realname");
        String email = request.getParameter("email");

        boolean hasError = false;

        if (password == null || password.trim().isEmpty()) {
            hasError = true;
            errorMsg = "密码不能为空";
        } else if (realname == null || realname.trim().isEmpty()) {
            hasError = true;
            errorMsg = "姓名不能为空";
        } else if (email == null || email.trim().isEmpty()) {
            hasError = true;
            errorMsg = "邮箱不能为空";
        } else if (username == null || username.trim().isEmpty()) {
            hasError = true;
            errorMsg = "用户名不能为空";
        }

        if (!hasError) {
            String sqlUpdate = "insert into `admins`(`username`,`password`,`realname`,`email`) values(?,?,?,?)";
            Object[] paramsUpdate = new Object[]{username, password, realname, email};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

%>
<html>
<head>
    <title>添加管理员</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/add.css">
    <style>
        .error {
            color: red;
            margin-left: 10px;
        }
    </style>
</head>
<body>
<header>
    <div class="title">编辑用户</div>
</header>
<div class="main">
    <form id="editForm" action="add.jsp?id=<%=id%>&action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">
        <input name="id" type="hidden" value=">">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>

        <div class="form-item">
            <label for="username">账号：</label>
            <input value="" id="username" name="username" type="text">
        </div>
        <div class="form-item">
            <label for="password">密码：</label>
            <input value="" id="password" name="password" type="password">
            <span class="error" id="passwordError"></span>
        </div>
        <div class="form-item">
            <label for="cmfPsw">确认密码：</label>
            <input value="" id="cmfPsw" name="cmfPsw" type="password">
            <span class="error" id="cmfPswError"></span>
        </div>
        <div class="form-item">
            <label for="realname">姓名：</label>
            <input value="" id="realname" name="realname" type="text">
            <span class="error" id="realnameError"></span>
        </div>
        <div class="form-item">
            <label for="email">邮件：</label>
            <input value="" id="email" name="email" type="text">
            <span class="error" id="emailError"></span>
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
    // 页面加载完成后执行
    $(document).ready(function () {
        // 检查是否更新成功
        var updateSuccess = <%=updateSuccess ? "true" : "false" %>;
        if (updateSuccess) {
            // 显示成功提示并返回列表页
            alert("添加成功！");
            window.location.href = "list.jsp";
        }

        // 返回按钮事件
        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

        // 提交按钮事件
        $("#btnSubmit").click(function () {
            var isValid = true;
            var password = $("#password").val();
            var cmfPsw = $("#cmfPsw").val();
            var realname = $("#realname").val();
            var email = $("#email").val();

            // 清空错误消息
            $(".error").text("");

            // 验证密码
            if (password.trim() === "") {
                $("#passwordError").text("密码不能为空");
                isValid = false;
            }

            // 验证确认密码
            if (cmfPsw.trim() === "") {
                $("#cmfPswError").text("确认密码不能为空");
                isValid = false;
            } else if (password !== cmfPsw) {
                $("#cmfPswError").text("两次输入的密码不一致");
                isValid = false;
            }

            // 验证姓名
            if (realname.trim() === "") {
                $("#realnameError").text("姓名不能为空");
                isValid = false;
            }

            // 验证邮箱
            if (email.trim() === "") {
                $("#emailError").text("邮箱不能为空");
                isValid = false;
            } else if (!validateEmail(email)) {
                $("#emailError").text("邮箱格式不正确");
                isValid = false;
            }

            // 如果验证通过，提交表单
            if (isValid) {
                $("#editForm").submit();
            }
        });

        // 邮箱格式验证函数
        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(email);
        }
    });
</script>
</body>
</html>