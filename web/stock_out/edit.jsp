<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String action = request.getParameter("action");
    boolean updateSuccess = false;
    String errorMsg = "";

<<<<<<< Updated upstream
=======
    // 查询所有设备（用于设备下拉选择）
    String sqlDevices = "SELECT id, device_no, name FROM devices";
    ResultSet rsDevices = DbConnect.select(sqlDevices, null);

    // 查询所有管理员（用于操作人下拉选择）
    String sqlAdmins = "SELECT id, username FROM admins";
    ResultSet rsAdmins = DbConnect.select(sqlAdmins, null);

>>>>>>> Stashed changes
    if ("update".equals(action)) {
        String device_id = request.getParameter("device_id");
        String quantity = request.getParameter("quantity");
        String recipient = request.getParameter("recipient");
        String purpose = request.getParameter("purpose");
        String operator_id = request.getParameter("operator_id");
        String remark = request.getParameter("remark");

        boolean hasError = false;
        if (device_id == null || device_id.trim().isEmpty()) {
            hasError = true;
<<<<<<< Updated upstream
            errorMsg = "设备ID不能为空";
        }
        if (quantity == null || quantity.trim().isEmpty()) {
            hasError = true;
            errorMsg = "出库数量不能为空";
        }
        if (operator_id == null || operator_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "操作人ID不能为空";
=======
            errorMsg = "请选择设备";
        } else if (quantity == null || quantity.trim().isEmpty()) {
            hasError = true;
            errorMsg = "出库数量不能为空";
        } else if (operator_id == null || operator_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "请选择操作人";
>>>>>>> Stashed changes
        }

        if (!hasError) {
            String sqlUpdate = "UPDATE `stock_outs` SET " +
                    "`device_id` = ?, " +
                    "`quantity` = ?, " +
                    "`recipient` = ?, " +
                    "`purpose` = ?, " +
                    "`operator_id` = ?, " +
                    "`remark` = ? " +
                    "WHERE `id` = ?";
            Object[] paramsUpdate = {device_id, quantity, recipient, purpose, operator_id, remark, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

<<<<<<< Updated upstream
=======
    // 查询当前出库记录信息
>>>>>>> Stashed changes
    String sqlSelect = "SELECT * FROM `stock_outs` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
<<<<<<< Updated upstream
=======
    // 初始化表单字段值
>>>>>>> Stashed changes
    String dbdevice_id = rs.getString("device_id");
    String dbquantity = rs.getString("quantity");
    String dbrecipient = rs.getString("recipient");
    String dbpurpose = rs.getString("purpose");
    String dboperator_id = rs.getString("operator_id");
    String dbremark = rs.getString("remark");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑出库信息</title>
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
    <div class="title">编辑出库信息</div>
</header>
<div class="main">
    <form id="editForm" action="edit.jsp?id=<%=id%>&action=update" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">
        <input type="hidden" name="id" value="<%=rs.getString("id")%>">

        <div class="form-item">
<<<<<<< Updated upstream
            <div class="error"><%=errorMsg %>
            </div>
        </div>

        <div class="form-item">
            <label for="device_id">设备ID：</label>
            <input type="text" id="device_id" name="device_id" value="<%=dbdevice_id%>"/>
            <span class="error" id="device_idError"></span>
        </div>
=======
            <div class="error"><%=errorMsg %></div>
        </div>

        <!-- 设备选择（替换原设备ID输入框） -->
        <div class="form-item">
            <label for="device_id">设备：</label>
            <select id="device_id" name="device_id">
                <option value="">请选择设备</option>
                <% while (rsDevices.next()) {
                    String devId = rsDevices.getString("id");
                    String devNo = rsDevices.getString("device_no");
                    String devName = rsDevices.getString("name");
                %>
                <option value="<%=devId%>" <%= devId.equals(dbdevice_id) ? "selected" : "" %>>
                    <%=devNo%> - <%=devName%>
                </option>
                <% } %>
            </select>
            <span class="error" id="device_idError"></span>
        </div>

>>>>>>> Stashed changes
        <div class="form-item">
            <label for="quantity">出库数量：</label>
            <input type="text" id="quantity" name="quantity" value="<%=dbquantity%>"/>
            <span class="error" id="quantityError"></span>
        </div>
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
        <div class="form-item">
            <label for="recipient">领取人：</label>
            <input type="text" id="recipient" name="recipient" value="<%=dbrecipient%>"/>
            <span class="error" id="recipientError"></span>
        </div>
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
        <div class="form-item">
            <label for="purpose">用途：</label>
            <input type="text" id="purpose" name="purpose" value="<%=dbpurpose%>"/>
            <span class="error" id="purposeError"></span>
        </div>
<<<<<<< Updated upstream
        <div class="form-item">
            <label for="operator_id">操作人ID：</label>
            <input type="text" id="operator_id" name="operator_id" value="<%=dboperator_id%>"/>
            <span class="error" id="operator_idError"></span>
        </div>
=======

        <!-- 操作人选择（替换原操作人ID输入框） -->
        <div class="form-item">
            <label for="operator_id">操作人：</label>
            <select id="operator_id" name="operator_id">
                <option value="">请选择操作人</option>
                <% while (rsAdmins.next()) {
                    String adminId = rsAdmins.getString("id");
                    String adminName = rsAdmins.getString("username");
                %>
                <option value="<%=adminId%>" <%= adminId.equals(dboperator_id) ? "selected" : "" %>>
                    <%=adminName%>
                </option>
                <% } %>
            </select>
            <span class="error" id="operator_idError"></span>
        </div>

>>>>>>> Stashed changes
        <div class="form-item">
            <label for="remark">备注：</label>
            <textarea id="remark" name="remark"><%=dbremark%></textarea>
            <span class="error" id="remarkError"></span>
        </div>
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            var device_id = $("#device_id").val().trim();
            var quantity = $("#quantity").val().trim();
            var recipient = $("#recipient").val().trim();
            var purpose = $("#purpose").val().trim();
            var operator_id = $("#operator_id").val().trim();
=======
            var device_id = $("#device_id").val(); // 设备选择值（ID）
            var quantity = $("#quantity").val().trim();
            var recipient = $("#recipient").val().trim();
            var purpose = $("#purpose").val().trim();
            var operator_id = $("#operator_id").val(); // 操作人选择值（ID）
>>>>>>> Stashed changes
            var remark = $("#remark").val().trim();

            $(".error").text("");

<<<<<<< Updated upstream
            if (device_id === "") {
                $("#device_idError").text("设备ID不能为空");
                isValid = false;
            }

=======
            // 验证设备选择
            if (device_id === "") {
                $("#device_idError").text("请选择设备");
                isValid = false;
            }

            // 验证出库数量
>>>>>>> Stashed changes
            if (quantity === "") {
                $("#quantityError").text("出库数量不能为空");
                isValid = false;
            }

<<<<<<< Updated upstream
            if (operator_id === "") {
                $("#operator_idError").text("操作人ID不能为空");
                isValid = false;
            }

=======
            // 验证操作人选择
            if (operator_id === "") {
                $("#operator_idError").text("请选择操作人");
                isValid = false;
            }

            // 阻止无效提交
>>>>>>> Stashed changes
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>