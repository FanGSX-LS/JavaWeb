<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    boolean insertSuccess = false;
    String errorMsg = "";
    if ("insert".equals(action)) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        boolean hasError = false;

        if (name == null || name.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备类别不能为空";
        } else if (description == null || description.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备备注不能为空";
        }
        if (!hasError) {
            String sqlInsert = "INSERT INTO `device_categories`(`name`, `description`) VALUES (?, ?)";
            Object[] paramsInsert = new Object[]{name, description};
            int result = DbConnect.update(sqlInsert, paramsInsert);

            if (result > 0) {
                insertSuccess = true;
            } else {
                errorMsg = "添加失败，请重试";
            }
        }
    }
%>
<html>
<head>
    <title>新增用户</title>
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
    <div class="title">新增设备类别</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="name">设备类别名称：</label>
            <input value="" id="name" name="name" type="text">
            <span class="error" id="nameError"></span>
        </div>
        <div class="form-item">
            <label for="description">设备类别备注：</label>
            <input value="" id="description" name="description" type="text">
            <span class="error" id="descriptionError"></span>
        </div>
        <div class="form-item">
            <button class="primary" id="btnSubmit" type="submit">提交</button>
            <button type="reset">重置</button>
            <button id="btnBack" type="button">返回</button>
        </div>
    </form>
</div>
<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    $(document).ready(function () {
        var insertSuccess = <%=insertSuccess ? "true" : "false" %>;
        if (insertSuccess) {
            alert("添加成功！");
            window.location.href = "list.jsp";
        }

        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

        $("#addForm").submit(function (event) {
            var isValid = true;
            var name = $("#name").val();
            var description = $("#description").val();

            $(".error").text("");

            if (name.trim() === "") {
                $("#nameError").text("设备类别名称不能为空");
                isValid = false;
            }
            if (description.trim() === "") {
                $("#descriptionError").text("设备类别备注不能为空");
                isValid = false;
            }
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>