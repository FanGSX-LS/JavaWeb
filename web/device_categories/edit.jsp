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

    if ("update".equals(action)) {
        String password = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        boolean hasError = false;
        if (name == null || name.trim().isEmpty()) {
            hasError = true;
            errorMsg = "密码不能为空";
        } else if (description == null || description.trim().isEmpty()) {
            hasError = true;
            errorMsg = "姓名不能为空";
        }
        if (!hasError) {
            String sqlUpdate = "UPDATE `device_categories` SET " +
                    "`name`=?, `description`=? " +
                    "WHERE `id`=?";
            Object[] paramsUpdate = {name, description, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

    String sqlSelect = "SELECT * FROM `device_categories` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
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
            <label for="id">设备ID：</label>
            <input disabled type="text" id="username" name="username" value="<%=rs.getString("id")%>"/>
            <span class="error" id="idError"></span>
        </div>

        <div class="form-item">
            <label for="name">设备类别名称：</label>
            <input type="text" id="name" name="name" value="<%=rs.getString("name")%>"/>
            <span class="error" id="nameError"></span>
        </div>

        <div class="form-item">
            <label for="description">设备类别备注：</label>
            <input type="text" id="description" name="description" value="<%=rs.getString("description")%>"/>
            <span class="error" id="descriptionError"></span>
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
            var id = $("#id").val().trim();
            var name = $("#name").val().trim();
            var description = $("#description").val().trim();

            $(".error").text("");

            if (id === "") {
                $("#idError").text("ID不能为空");
                isValid = false;
            }
            if (name === "") {
                $("#nameError").text("设备名称不能为空");
                isValid = false;
            }
            if (department === "") {
                $("#departmentError").text("设备备注不能为空");
                isValid = false;
            }
            // 阻止无效提交
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>