<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.swing.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String action = request.getParameter("action");
    boolean updateSuccess = false;
    String errorMsg = "";
    String isActiveValue = "在职";

    if ("update".equals(action)) {
        String password = request.getParameter("password");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String department_id = request.getParameter("department_id");
        String phone = request.getParameter("phone");
        isActiveValue = request.getParameter("is_active"); /

        boolean hasError = false;
        if (password == null || password.trim().isEmpty()) {
            hasError = true;
            errorMsg = "密码不能为空";
        } else if (username == null || username.trim().isEmpty()) {
            hasError = true;
            errorMsg = "姓名不能为空";
        } else if (email == null || email.trim().isEmpty()) {
            hasError = true;
            errorMsg = "邮箱不能为空";
        } else if (phone == null || phone.trim().isEmpty()) {
            hasError = true;
            errorMsg = "联系电话不能为空";
        } else if (isActiveValue == null || !"在职".equals(isActiveValue) && !"离职".equals(isActiveValue)) {
            hasError = true;
            errorMsg = "请选择有效的员工状态";
        }

        if (!hasError) {

            String sqlUpdate = "UPDATE `employees` SET " +
                    "`password`=?, `username`=?, `email`=?, " +
                    "`department_id`=?, `phone`=?, `is_active`=? " +
                    "WHERE `id`=?";
            Object[] paramsUpdate = {password, username, email, department_id, phone, isActiveValue, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }


    String sqlSelect = "SELECT * FROM `employees` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }


    String password = rs.getString("password");
    String dbUsername = rs.getString("username");
    String dbDepartmentId = rs.getString("department_id");
    String dbEmail = rs.getString("email");
    String dbPhone = rs.getString("phone");
    isActiveValue = rs.getString("is_active");
    if (isActiveValue == null) {
        isActiveValue = "在职";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑用户</title>
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
    <form id="editForm" action="edit.jsp?id=<%=id%>&action=update" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">
        <input type="hidden" name="id" value="<%=rs.getString("id")%>">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>

        <div class="form-item">
            <label for="username">姓名：</label>
            <input type="text" id="username" name="username" value="<%=dbUsername%>"/>
            <span class="error" id="usernameError"></span>
        </div>

        <div class="form-item">
            <label for="password">密码：</label>
            <input type="password" id="password" name="password" value="<%=password%>"/>
            <span class="error" id="passwordError"></span>
        </div>

        <div class="form-item">
            <label for="cmfPsw">确认密码：</label>
            <input type="password" id="cmfPsw" name="cmfPsw" value="<%=password%>"/>
            <span class="error" id="cmfPswError"></span>
        </div>

        <div class="form-item">
            <label for="department_id">部门：</label>
            <input type="text" id="department_id" name="department_id" value="<%=dbDepartmentId%>"/>
            <span class="error" id="departmentError"></span>
        </div>

        <div class="form-item">
            <label for="email">邮箱：</label>
            <input type="text" id="email" name="email" value="<%=dbEmail%>"/>
            <span class="error" id="emailError"></span>
        </div>

        <div class="form-item">
            <label for="phone">联系电话：</label>
            <input type="text" id="phone" name="phone" value="<%=dbPhone%>"/>
            <span class="error" id="phoneError"></span>
        </div>

        <div class="form-item">
            <label for="is_active">是否在职：</label>
            <select id="is_active" name="is_active">
                <option value="在职" <%= "在职".equals(isActiveValue) ? "selected" : "" %>>在职</option>
                <option value="离职" <%= "离职".equals(isActiveValue) ? "selected" : "" %>>离职</option>
            </select>
            <span class="error" id="is_activeError"></span>
        </div>

        <div class="form-item">
            <button class="primary" type="submit">提交</button>
            <button type="reset">重置</button>
            <button id="btnBack" type="button">返回</button>
        </div>
    </form>
</div>

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    $(document).ready(function () {

        if (<%=updateSuccess ? "true" : "false"%>) {
            alert("更新成功！");
            window.location.href = "list.jsp";
        }

        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

        $("#editForm").submit(function (event) {
            var isValid = true;
            var password = $("#password").val().trim();
            var cmfPsw = $("#cmfPsw").val().trim();
            var username = $("#username").val().trim();
            var email = $("#email").val().trim();
            var department = $("#department_id").val().trim();
            var phone = $("#phone").val().trim();
            var isActive = $("#is_active").val();

            $(".error").text("");

            if (password === "") {
                $("#passwordError").text("密码不能为空");
                isValid = false;
            }

            if (cmfPsw === "") {
                $("#cmfPswError").text("确认密码不能为空");
                isValid = false;
            } else if (password !== cmfPsw) {
                $("#cmfPswError").text("两次密码不一致");
                isValid = false;
            }

            if (username === "") {
                $("#usernameError").text("姓名不能为空");
                isValid = false;
            }

            if (department === "") {
                $("#departmentError").text("部门不能为空");
                isValid = false;
            }

            if (phone === "") {
                $("#phoneError").text("联系电话不能为空");
                isValid = false;
            }

            if (email === "") {
                $("#emailError").text("邮箱不能为空");
                isValid = false;
            } else if (!validateEmail(email)) {
                $("#emailError").text("邮箱格式不正确");
                isValid = false;
            }

            if (isActive !== "在职" && isActive !== "离职") {
                $("#is_activeError").text("请选择有效的员工状态");
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
        });

        function validateEmail(email) {
            return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
        }
    });
</script>
</body>
</html>