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
    String status = "pending";
    if ("update".equals(action)) {
        String applicant_id = request.getParameter("applicant_id");
        String device_id = request.getParameter("device_id");
        String reason = request.getParameter("reason");
        String start_date = request.getParameter("start_date");
        String end_date = request.getParameter("end_date");
        String device_status = request.getParameter("status");
        String approver_id = request.getParameter("approver_id");
        String approval_time = request.getParameter("approval_time");
        String rejection_reason = request.getParameter("rejection_reason");
        boolean hasError = false;
        if (applicant_id == null || applicant_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "申请人 ID 不能为空";
        }

        if (!hasError) {
            String sqlUpdate = "UPDATE `device_applications` SET " +
                    "`applicant_id` = ?," +
                    "`device_id` = ?," +
                    " `reason` = ?, " +
                    "`start_date` = ?, " +
                    "`end_date` = ?, " +
                    "`status` = ?, " +
                    "`approver_id` = ?, " +
                    "`approval_time` = ?, " +
                    "`rejection_reason` = ? " +
                    "WHERE `id` = ?";
            Object[] paramsUpdate = {applicant_id, device_id, reason, start_date, end_date, device_status, approver_id, approval_time, rejection_reason, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

    String sqlSelect = "SELECT * FROM `device_applications` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
    String dbapplicant_id = rs.getString("applicant_id");
    String dbdevice_id = rs.getString("device_id");
    String dbreason = rs.getString("reason");
    String dbstart_date = rs.getString("start_date");
    String dbend_date = rs.getString("end_date");
    String dbstatus = rs.getString("status");
    String dbapprover_id = rs.getString("approver_id");
    String dbapproval_time = rs.getString("approval_time");
    String dbrejection_reason = rs.getString("rejection_reason");
    status = rs.getString("status");
    if (status == null) {
        status = "pending";
    }
    String sqlApplicants = "SELECT `id`, `username` FROM `employees`";
    ResultSet rsApplicants = DbConnect.select(sqlApplicants, null);
    String sqlDevices = "SELECT `id`, `name` FROM `devices`";
    ResultSet rsDevices = DbConnect.select(sqlDevices, null);
    String sqlApprovers = "SELECT `id`, `username` FROM `admins`";
    ResultSet rsApprovers = DbConnect.select(sqlApprovers, null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑设备审批</title>
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
    <div class="title">编辑设备审批</div>
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
            <label for="applicant_id">申请人：</label>
            <select id="applicant_id" name="applicant_id">
                <% while (rsApplicants.next()) { %>
                <option value="<%=rsApplicants.getString("id")%>" <%= rsApplicants.getString("id").equals(dbapplicant_id) ? "selected" : "" %>>
                    <%=rsApplicants.getString("username")%>
                </option>
                <% } %>
            </select>
            <span class="error" id="applicant_idError"></span>
        </div>
        <div class="form-item">
            <label for="device_id">设备：</label>
            <select id="device_id" name="device_id">
                <% while (rsDevices.next()) { %>
                <option value="<%=rsDevices.getString("id")%>" <%= rsDevices.getString("id").equals(dbdevice_id) ? "selected" : "" %>>
                    <%=rsDevices.getString("name")%>
                </option>
                <% } %>
            </select>
            <span class="error" id="device_idError"></span>
        </div>
        <div class="form-item">
            <label for="reason">申请原因：</label>
            <textarea id="reason" name="reason"><%=dbreason%></textarea>
            <span class="error" id="reasonError"></span>
        </div>
        <div class="form-item">
            <label for="start_date">开始日期：</label>
            <input type="date" id="start_date" name="start_date" value="<%=dbstart_date%>"/>
            <span class="error" id="start_dateError"></span>
        </div>
        <div class="form-item">
            <label for="end_date">结束日期：</label>
            <input type="date" id="end_date" name="end_date" value="<%=dbend_date%>"/>
            <span class="error" id="end_dateError"></span>
        </div>
        <div class="form-item">
            <label for="status">设备审批状态：</label>
            <select id="status" name="status">
                <option value="pending" <%= "pending".equals(status) ? "selected" : "" %>>待审批</option>
                <option value="approved" <%= "approved".equals(status) ? "selected" : "" %>>已批准</option>
                <option value="rejected" <%= "rejected".equals(status) ? "selected" : "" %>>已拒绝</option>
                <option value="completed" <%= "completed".equals(status) ? "selected" : "" %>>已完成</option>
            </select>
            <span class="error" id="statusSelectError"></span>
        </div>
        <div class="form-item">
            <label for="approver_id">审批人：</label>
            <select id="approver_id" name="approver_id">
                <% while (rsApprovers.next()) { %>
                <option value="<%=rsApprovers.getString("id")%>" <%= rsApprovers.getString("id").equals(dbapprover_id) ? "selected" : "" %>>
                    <%=rsApprovers.getString("username")%>
                </option>
                <% } %>
            </select>
            <span class="error" id="approver_idError"></span>
        </div>
        <div class="form-item">
            <label for="approval_time">审批时间：</label>
            <input type="datetime-local" id="approval_time" name="approval_time"
                   value="<%=dbapproval_time != null ? dbapproval_time.replace(" ", "T") : "" %>"/>
            <span class="error" id="approval_timeError"></span>
        </div>
        <div class="form-item">
            <label for="rejection_reason">拒绝原因：</label>
            <textarea id="rejection_reason" name="rejection_reason"><%=dbrejection_reason%></textarea>
            <span class="error" id="rejection_reasonError"></span>
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
            var applicant_id = $("#applicant_id").val().trim();
            var device_id = $("#device_id").val().trim();
            var reason = $("#reason").val().trim();
            var start_date = $("#start_date").val().trim();
            var end_date = $("#end_date").val().trim();
            var device_status = $("#status").val();
            var approver_id = $("#approver_id").val().trim();
            var approval_time = $("#approval_time").val().trim();
            var rejection_reason = $("#rejection_reason").val().trim();
            $(".error").text("");
            if (applicant_id === "") {
                $("#applicant_idError").text("申请人 ID 不能为空");
                isValid = false;
            }
            if (device_id === "") {
                $("#device_idError").text("设备 ID 不能为空");
                isValid = false;
            }
            if (reason === "") {
                $("#reasonError").text("申请原因不能为空");
                isValid = false;
            }
            if (start_date === "") {
                $("#start_dateError").text("开始日期不能为空");
                isValid = false;
            }
            if (end_date === "") {
                $("#end_dateError").text("结束日期不能为空");
                isValid = false;
            }
            if (device_status === "") {
                $("#statusError").text("设备审批状态不能为空");
                isValid = false;
            }
            if (approver_id === "") {
                $("#approver_idError").text("审批人 ID 不能为空");
                isValid = false;
            }
            if (device_status === "rejected" && rejection_reason === "") {
                $("#rejection_reasonError").text("拒绝原因不能为空");
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