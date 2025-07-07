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


    String sqlCategory = "SELECT id, name FROM device_categories";
    ResultSet rsCategory = DbConnect.select(sqlCategory, null);


    if ("insert".equals(action)) {
        String device_no = request.getParameter("device_no");
        String category_id = request.getParameter("category_id");
        String name = request.getParameter("name");
        String model = request.getParameter("model");
        String specification = request.getParameter("specification");
        String manufacturer = request.getParameter("manufacturer");
        String purchase_date = request.getParameter("purchase_date");
        String warranty_period = request.getParameter("warranty_period");
        String status = request.getParameter("status");
        String location = request.getParameter("location");
        String price = request.getParameter("price");


        boolean hasError = false;

        if (device_no == null || device_no.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备编号不能为空";
        } else if (name == null || name.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备名称不能为空";
        } else if (model == null || model.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备型号不能为空";
        } else if (specification == null || specification.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备规格不能为空";
        } else if (manufacturer == null || manufacturer.trim().isEmpty()) {
            hasError = true;
            errorMsg = "制造商不能为空";
        } else if (purchase_date == null || purchase_date.trim().isEmpty()) {
            hasError = true;
            errorMsg = "购买日期不能为空";
        } else if (warranty_period == null || warranty_period.trim().isEmpty()) {
            hasError = true;
            errorMsg = "保修期限不能为空";
        } else if (status == null || status.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备状态不能为空";
        } else if (location == null || location.trim().isEmpty()) {
            hasError = true;
            errorMsg = "存放位置不能为空";
        } else if (price == null || price.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备价格不能为空";
        }

        if (!hasError) {

            String sqlInsert = "INSERT INTO `guanli`.`devices`( `device_no`, `category_id`, `name`, `model`, `specification`, `manufacturer`, `purchase_date`, `warranty_period`, `status`, `location`, `price`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            Object[] paramsInsert = new Object[]{device_no, category_id, name, model, specification, manufacturer, purchase_date, warranty_period, status, location, price};
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
    <title>新增设备</title>
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
    <div class="title">新增设备</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="device_no">设备编号：</label>
            <input value="" id="device_no" name="device_no" type="text">
            <span class="error" id="device_noError"></span>
        </div>
        <div class="form-item">
            <label for="category_id">设备类型：</label>
            <select id="category_id" name="category_id">
                <option value="">请选择</option>
                <% while (rsCategory.next()) { %>
                <option value="<%=rsCategory.getInt("id")%>"><%=rsCategory.getString("name")%>
                </option>
                <% } %>
            </select>
            <span class="error" id="category_idError"></span>
        </div>
        <div class="form-item">
            <label for="name">设备名称：</label>
            <input value="" id="name" name="name" type="text">
            <span class="error" id="nameError"></span>
        </div>
        <div class="form-item">
            <label for="model">设备型号：</label>
            <input value="" id="model" name="model" type="text">
            <span class="error" id="modelError"></span>
        </div>
        <div class="form-item">
            <label for="specification">设备规格：</label>
            <input value="" id="specification" name="specification" type="text">
            <span class="error" id="specificationError"></span>
        </div>
        <div class="form-item">
            <label for="manufacturer">制造商：</label>
            <input value="" id="manufacturer" name="manufacturer" type="text">
            <span class="error" id="manufacturerError"></span>
        </div>
        <div class="form-item">
            <label for="purchase_date">购买日期：</label>
            <input value="" id="purchase_date" name="purchase_date" type="text">
            <span class="error" id="purchase_dateError"></span>
        </div>
        <div class="form-item">
            <label for="warranty_period">保修期限：</label>
            <input value="" id="warranty_period" name="warranty_period" type="text">
            <span class="error" id="warranty_periodError"></span>
        </div>
        <div class="form-item">
            <label for="status">设备状态：</label>
            <select id="status" name="status">
                <option value="">请选择</option>
                <option value="available">闲置</option>
                <option value="in_use">正在使用</option>
                <option value="maintenance">维修中</option>
                <option value="scrapped">已报废</option>
            </select>
            <span class="error" id="statusError"></span>
        </div>
        <div class="form-item">
            <label for="location">存放位置：</label>
            <input value="" id="location" name="location" type="text">
            <span class="error" id="locationError"></span>
        </div>
        <div class="form-item">
            <label for="price">设备价格：</label>
            <input value="" id="price" name="price" type="text">
            <span class="error" id="priceError"></span>
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
            var device_no = $("#device_no").val();
            var category_id = $("#category_id").val();
            var name = $("#name").val();
            var model = $("#model").val();
            var specification = $("#specification").val();
            var manufacturer = $("#manufacturer").val();
            var purchase_date = $("#purchase_date").val();
            var warranty_period = $("#warranty_period").val();
            var status = $("#status").val();
            var location = $("#location").val();
            var price = $("#price").val();


            $(".error").text("");


            if (device_no.trim() === "") {
                $("#device_noError").text("设备编号不能为空");
                isValid = false;
            }


            if (category_id === "") {
                $("#category_idError").text("请选择设备类型");
                isValid = false;
            }


            if (name.trim() === "") {
                $("#nameError").text("设备名称不能为空");
                isValid = false;
            }


            if (model.trim() === "") {
                $("#modelError").text("设备型号不能为空");
                isValid = false;
            }


            if (specification.trim() === "") {
                $("#specificationError").text("设备规格不能为空");
                isValid = false;
            }


            if (manufacturer.trim() === "") {
                $("#manufacturerError").text("制造商不能为空");
                isValid = false;
            }


            if (purchase_date.trim() === "") {
                $("#purchase_dateError").text("购买日期不能为空");
                isValid = false;
            }


            if (warranty_period.trim() === "") {
                $("#warranty_periodError").text("保修期限不能为空");
                isValid = false;
            }


            if (status === "") {
                $("#statusError").text("请选择设备状态");
                isValid = false;
            }


            if (location.trim() === "") {
                $("#locationError").text("存放位置不能为空");
                isValid = false;
            }


            if (price.trim() === "") {
                $("#priceError").text("设备价格不能为空");
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