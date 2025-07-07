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

    if ("insert".equals(action)) {
        String deviceId = request.getParameter("device_id");
        String quantity = request.getParameter("quantity");
        String supplier = request.getParameter("supplier");
        String price = request.getParameter("price");
        String totalPrice = request.getParameter("total_price");
        String receiptNo = request.getParameter("receipt_no");
        String remark = request.getParameter("remark");

        boolean hasError = false;

        if (deviceId == null || deviceId.trim().isEmpty()) {
            hasError = true;
            errorMsg = "请选择设备";
        } else if (quantity == null || quantity.trim().isEmpty()) {
            hasError = true;
            errorMsg = "入库数量不能为空";
        }

        if (!hasError) {
            try {
                int deviceIdInt = Integer.parseInt(deviceId);
                int quantityInt = Integer.parseInt(quantity);
                double priceDouble = price != null && !price.trim().isEmpty() ? Double.parseDouble(price) : 0;
                double totalPriceDouble = totalPrice != null && !totalPrice.trim().isEmpty() ? Double.parseDouble(totalPrice) : 0;

                String sqlInsert = "INSERT INTO `guanli`.`stock_ins`( `device_id`, `quantity`, `supplier`, `price`, `total_price`, `receipt_no`, `operator_id`, `remark`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                Object[] paramsInsert = new Object[]{deviceIdInt, quantityInt, supplier, priceDouble, totalPriceDouble, receiptNo, operatorId, remark};
                int result = DbConnect.update(sqlInsert, paramsInsert);

                if (result > 0) {
                    insertSuccess = true;
                } else {
                    errorMsg = "添加失败，请重试";
                }
            } catch (NumberFormatException e) {
                hasError = true;
                errorMsg = "设备ID、入库数量、单价或总价必须为有效数字";
            }
        }
    }

    String sqlSelectDevices = "SELECT id, device_no, name FROM devices";
    ResultSet rs = DbConnect.select(sqlSelectDevices, null);
%>
<html>
<head>
    <title>新增入库管理</title>
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
    <div class="title">新增入库管理</div>
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
                <% while (rs.next()) { %>
                <option value="<%=rs.getInt("id") %>"><%=rs.getString("device_no") %> - <%=rs.getString("name") %>
                </option>
                <% } %>
            </select>
            <span class="error" id="deviceIdError"></span>
        </div>
        <div class="form-item">
            <label for="quantity">入库数量：</label>
            <input value="" id="quantity" name="quantity" type="text">
            <span class="error" id="quantityError"></span>
        </div>
        <div class="form-item">
            <label for="supplier">供应商：</label>
            <input value="" id="supplier" name="supplier" type="text">
            <span class="error" id="supplierError"></span>
        </div>
        <div class="form-item">
            <label for="price">单价：</label>
            <input value="" id="price" name="price" type="text">
            <span class="error" id="priceError"></span>
        </div>
        <div class="form-item">
            <label for="total_price">总价：</label>
            <input value="" id="total_price" name="total_price" type="text">
            <span class="error" id="totalPriceError"></span>
        </div>
        <div class="form-item">
            <label for="receipt_no">收据编号：</label>
            <input value="" id="receipt_no" name="receipt_no" type="text">
            <span class="error" id="receiptNoError"></span>
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
            var deviceId = $("#device_id").val();
            var quantity = $("#quantity").val();
            var supplier = $("#supplier").val();
            var price = $("#price").val();
            var totalPrice = $("#total_price").val();
            var receiptNo = $("#receipt_no").val();
            var remark = $("#remark").val();

            $(".error").text("");

            if (deviceId === "") {
                $("#deviceIdError").text("请选择设备");
                isValid = false;
            }

            if (quantity.trim() === "") {
                $("#quantityError").text("入库数量不能为空");
                isValid = false;
            }

            if (price.trim() !== "" && isNaN(price)) {
                $("#priceError").text("单价必须为有效数字");
                isValid = false;
            }
            if (totalPrice.trim() !== "" && isNaN(totalPrice)) {
                $("#totalPriceError").text("总价必须为有效数字");
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