<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");
    boolean insertSuccess = false;
    String errorMsg = "";

    int operatorId = 1;

    String sqlDevices = "SELECT id, device_no, name FROM devices";
    ResultSet rsDevices = DbConnect.select(sqlDevices, null);

    if ("insert".equals(action)) {
        String deviceId = request.getParameter("device_id");
        String quantity = request.getParameter("quantity");
        String recipient = request.getParameter("recipient");
        String purpose = request.getParameter("purpose");
        String remark = request.getParameter("remark");

        boolean hasError = false;

        if (deviceId == null || deviceId.trim().isEmpty()) {
            hasError = true;
            errorMsg = "请选择设备";
        } else if (quantity == null || quantity.trim().isEmpty()) {
            hasError = true;
            errorMsg = "出库数量不能为空";
        }

        if (!hasError) {
            try {
                int deviceIdInt = Integer.parseInt(deviceId);
                int quantityInt = Integer.parseInt(quantity);

                String sqlInsert = "INSERT INTO `guanli`.`stock_outs`( `device_id`, `quantity`, `recipient`, `purpose`, `operator_id`, `remark`) VALUES (?, ?, ?, ?, ?, ?)";
                Object[] paramsInsert = new Object[]{deviceIdInt, quantityInt, recipient, purpose, operatorId, remark};
                int result = DbConnect.update(sqlInsert, paramsInsert);

                if (result > 0) {
                    insertSuccess = true;
                } else {
                    errorMsg = "添加失败，请重试";
                }
            } catch (NumberFormatException e) {
                hasError = true;
                errorMsg = "设备ID或出库数量必须为有效数字";
            }
        }
    }
%>
<html>
<head>
    <title>新增出库管理</title>
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
    <div class="title">新增出库管理</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="device_id">设备：</label>
            <select id="device_id" name="device_id">
                <option value="">请选择设备</option>
                <% while (rsDevices.next()) {
                    String devId = rsDevices.getString("id");
                    String devNo = rsDevices.getString("device_no");
                    String devName = rsDevices.getString("name");
                %>
                <option value="<%=devId%>"><%=devNo%> - <%=devName%>
                </option>
                <% } %>
            </select>
            <span class="error" id="deviceIdError"></span>
        </div>
        <div class="form-item">
            <label for="quantity">出库数量：</label>
            <input value="" id="quantity" name="quantity" type="text">
            <span class="error" id="quantityError"></span>
        </div>
        <div class="form-item">
            <label for="recipient">领取人：</label>
            <input value="" id="recipient" name="recipient" type="text">
            <span class="error" id="recipientError"></span>
        </div>
        <div class="form-item">
            <label for="purpose">用途：</label>
            <input value="" id="purpose" name="purpose" type="text">
            <span class="error" id="purposeError"></span>
        </div>
        <div class="form-item">
            <label for="remark">备注：</label>
            <textarea id="remark" name="remark"></textarea>
            <span class="error" id="remarkError"></span>
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
            var deviceId = $("#device_id").val(); // 获取选中的设备ID
            var quantity = $("#quantity").val();
            var recipient = $("#recipient").val();
            var purpose = $("#purpose").val();

            $(".error").text("");

            if (deviceId === "") {
                $("#deviceIdError").text("请选择设备");
                isValid = false;
            }

            if (quantity.trim() === "") {
                $("#quantityError").text("出库数量不能为空");
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