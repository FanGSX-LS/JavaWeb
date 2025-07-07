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

    if ("update".equals(action)) {
        String device_id = request.getParameter("device_id");
        String quantity = request.getParameter("quantity");
        String supplier = request.getParameter("supplier");
        String price = request.getParameter("price");
        String total_price = request.getParameter("total_price");
        String receipt_no = request.getParameter("receipt_no");
        String operator_id = request.getParameter("operator_id");
        String remark = request.getParameter("remark");

        boolean hasError = false;
        if (device_id == null || device_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备ID不能为空";
        }
        if (quantity == null || quantity.trim().isEmpty()) {
            hasError = true;
            errorMsg = "入库数量不能为空";
        }
        if (operator_id == null || operator_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "操作人ID不能为空";
        }

        if (!hasError) {
            String sqlUpdate = "UPDATE `stock_ins` SET " +
                    "`device_id` = ?, " +
                    "`quantity` = ?, " +
                    "`supplier` = ?, " +
                    "`price` = ?, " +
                    "`total_price` = ?, " +
                    "`receipt_no` = ?, " +
                    "`operator_id` = ?, " +
                    "`remark` = ? " +
                    "WHERE `id` = ?";
            Object[] paramsUpdate = {device_id, quantity, supplier, price, total_price, receipt_no, operator_id, remark, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

    String sqlSelect = "SELECT * FROM `stock_ins` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
    String dbdevice_id = rs.getString("device_id");
    String dbquantity = rs.getString("quantity");
    String dbsupplier = rs.getString("supplier");
    String dbprice = rs.getString("price");
    String dbtotal_price = rs.getString("total_price");
    String dbreceipt_no = rs.getString("receipt_no");
    String dboperator_id = rs.getString("operator_id");
    String dbremark = rs.getString("remark");

    String sqlDeviceSelect = "SELECT id, device_no, name FROM `devices`";
    ResultSet deviceRs = DbConnect.select(sqlDeviceSelect, new Object[]{});

    String sqlAdminSelect = "SELECT id, username FROM `admins`";
    ResultSet adminRs = DbConnect.select(sqlAdminSelect, new Object[]{});
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑入库信息</title>
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
    <div class="title">编辑入库信息</div>
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
            <label for="device_id">设备：</label>
            <select id="device_id" name="device_id">
                <% while (deviceRs.next()) {
                    String deviceId = deviceRs.getString("id");
                    String deviceNo = deviceRs.getString("device_no");
                    String deviceName = deviceRs.getString("name");
                    String selected = deviceId.equals(dbdevice_id) ? "selected" : "";
                %>
                <option value="<%=deviceId%>" <%=selected%>><%=deviceNo%> - <%=deviceName%>
                </option>
                <% } %>
            </select>
            <span class="error" id="device_idError"></span>
        </div>

        <div class="form-item">
            <label for="quantity">入库数量：</label>
            <input type="text" id="quantity" name="quantity" value="<%=dbquantity%>"/>
            <span class="error" id="quantityError"></span>
        </div>
        <div class="form-item">
            <label for="supplier">供应商：</label>
            <input type="text" id="supplier" name="supplier" value="<%=dbsupplier%>"/>
            <span class="error" id="supplierError"></span>
        </div>
        <div class="form-item">
            <label for="price">单价：</label>
            <input type="text" id="price" name="price" value="<%=dbprice%>"/>
            <span class="error" id="priceError"></span>
        </div>
        <div class="form-item">
            <label for="total_price">总价：</label>
            <input type="text" id="total_price" name="total_price" value="<%=dbtotal_price%>"/>
            <span class="error" id="total_priceError"></span>
        </div>
        <div class="form-item">
            <label for="receipt_no">收据编号：</label>
            <input type="text" id="receipt_no" name="receipt_no" value="<%=dbreceipt_no%>"/>
            <span class="error" id="receipt_noError"></span>
        </div>
        <div class="form-item">
            <label for="operator_id">操作人：</label>
            <select id="operator_id" name="operator_id">
                <% while (adminRs.next()) {
                    String adminId = adminRs.getString("id");
                    String adminUsername = adminRs.getString("username");
                    String selected = adminId.equals(dboperator_id) ? "selected" : "";
                %>
                <option value="<%=adminId%>" <%=selected%>><%=adminUsername%>
                </option>
                <% } %>
            </select>
            <span class="error" id="operator_idError"></span>
        </div>

        <div class="form-item">
            <label for="remark">备注：</label>
            <textarea id="remark" name="remark"><%=dbremark%></textarea>
            <span class="error" id="remarkError"></span>
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
            var device_id = $("#device_id").val().trim();
            var quantity = $("#quantity").val().trim();
            var supplier = $("#supplier").val().trim();
            var price = $("#price").val().trim();
            var total_price = $("#total_price").val().trim();
            var receipt_no = $("#receipt_no").val().trim();
            var operator_id = $("#operator_id").val().trim();
            var remark = $("#remark").val().trim();

            $(".error").text("");

            if (device_id === "") {
                $("#device_idError").text("设备ID不能为空");
                isValid = false;
            }

            if (quantity === "") {
                $("#quantityError").text("入库数量不能为空");
                isValid = false;
            }

            if (operator_id === "") {
                $("#operator_idError").text("操作人ID不能为空");
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