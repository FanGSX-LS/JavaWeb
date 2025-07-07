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

    String sqlEmployees = "SELECT id, username FROM employees";
    ResultSet rsEmployees = DbConnect.select(sqlEmployees, null);

    String sqlDevices = "SELECT id, name FROM devices";
    ResultSet rsDevices = DbConnect.select(sqlDevices, null);

    String sqlAdmins = "SELECT id, username FROM admins";
    ResultSet rsAdmins = DbConnect.select(sqlAdmins, null);

    if ("insert".equals(action)) {
        String applicant_id = request.getParameter("applicant_id");
        String device_id = request.getParameter("device_id");
        String approver_id = request.getParameter("approver_id");
        String reason = request.getParameter("reason");
        String start_date = request.getParameter("start_date");
        String end_date = request.getParameter("end_date");

        boolean hasError = false;

        if (applicant_id == null || applicant_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "申请人不能为空";
        } else if (device_id == null || device_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "申请设备不能为空";
        } else if (approver_id == null || approver_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "审批人不能为空";
        } else if (reason == null || reason.trim().isEmpty()) {
            hasError = true;
            errorMsg = "申请原因不能为空";
        } else if (start_date == null || start_date.trim().isEmpty()) {
            hasError = true;
            errorMsg = "开始日期不能为空";
        } else if (end_date == null || end_date.trim().isEmpty()) {
            hasError = true;
            errorMsg = "结束日期不能为空";
        }

        if (!hasError) {
            String sqlInsert = "INSERT INTO `guanli`.`device_applications`( `applicant_id`, `device_id`, `reason`, `start_date`, `end_date`, `approver_id`) VALUES (?, ?, ?, ?, ?, ?)";
            Object[] paramsInsert = new Object[]{applicant_id, device_id, reason, start_date, end_date, approver_id};
            int result = DbConnect.insert(sqlInsert, paramsInsert);

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
    <title>新增设备审批</title>
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
    <div class="title">新增设备审批</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="applicant_id">申请人：</label>
            <select id="applicant_id" name="applicant_id">
                <option value="">请选择申请人</option>
                <% while (rsEmployees.next()) { %>
                <option value="<%=rsEmployees.getInt("id") %>"><%=rsEmployees.getString("username") %>
                </option>
                <% } %>
            </select>
            <span class="error" id="applicant_idError"></span>
        </div>
        <div class="form-item">
            <label for="device_id">申请设备：</label>
            <select id="device_id" name="device_id">
                <option value="">请选择申请设备</option>
                <% while (rsDevices.next()) { %>
                <option value="<%=rsDevices.getInt("id") %>"><%=rsDevices.getString("name") %>
                </option>
                <% } %>
            </select>
            <span class="error" id="device_idError"></span>
        </div>
        <div class="form-item">
            <label for="approver_id">审批人：</label>
            <select id="approver_id" name="approver_id">
                <option value="">请选择审批人</option>
                <% while (rsAdmins.next()) { %>
                <option value="<%=rsAdmins.getInt("id") %>"><%=rsAdmins.getString("username") %>
                </option>
                <% } %>
            </select>
            <span class="error" id="approver_idError"></span>
        </div>
        <div class="form-item">
            <label for="reason">申请原因：</label>
            <textarea id="reason" name="reason"></textarea>
            <span class="error" id="reasonError"></span>
        </div>
        <div class="form-item">
            <label for="start_date">开始日期：</label>
            <input value="" id="start_date" name="start_date" type="date">
            <span class="error" id="start_dateError"></span>
        </div>
        <div class="form-item">
            <label for="end_date">结束日期：</label>
            <input value="" id="end_date" name="end_date" type="date">
            <span class="error" id="end_dateError"></span>
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
            var applicant_id = $("#applicant_id").val();
            var device_id = $("#device_id").val();
            var approver_id = $("#approver_id").val();
            var reason = $("#reason").val();
            var start_date = $("#start_date").val();
            var end_date = $("#end_date").val();

            $(".error").text("");

            if (applicant_id === "") {
                $("#applicant_idError").text("申请人不能为空");
                isValid = false;
            }

            if (device_id === "") {
                $("#device_idError").text("申请设备不能为空");
                isValid = false;
            }

            if (approver_id === "") {
                $("#approver_idError").text("审批人不能为空");
                isValid = false;
            }

            if (reason.trim() === "") {
                $("#reasonError").text("申请原因不能为空");
                isValid = false;
            }

            if (start_date.trim() === "") {
                $("#start_dateError").text("开始日期不能为空");
                isValid = false;
            }

            if (end_date.trim() === "") {
                $("#end_dateError").text("结束日期不能为空");
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
