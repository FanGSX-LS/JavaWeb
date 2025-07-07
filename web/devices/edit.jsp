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
    String status = "available";


    if ("update".equals(action)) {
        String device_no = request.getParameter("device_no");
        String category_id = request.getParameter("category_id");
        String name = request.getParameter("name");
        String model = request.getParameter("model");
        String specification = request.getParameter("specification");
        String manufacturer = request.getParameter("manufacturer");
        String warranty_period = request.getParameter("warranty_period");
        String device_status = request.getParameter("status");
        String location = request.getParameter("location");
        String price = request.getParameter("price");


        boolean hasError = false;
        if (device_no == null || device_no.trim().isEmpty()) {
            hasError = true;
            errorMsg = "设备编号不能为空";
        }

        if (!hasError) {

            String sqlUpdate = "UPDATE `devices` SET " +
                    "`device_no` = ?," +
                    "`category_id` = ?," +
                    " `name` = ?, " +
                    "`model` = ?," +
                    "`specification` = ?," +
                    "`manufacturer` = ?," +
                    "`warranty_period` = ?," +
                    "`status` = ?, " +
                    "`location` = ?," +
                    "`price` = ? " +
                    "WHERE `id` = ?";
            Object[] paramsUpdate = {device_no, category_id, name, model, specification, manufacturer, warranty_period, device_status, location, price, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }


    String sqlSelect = "SELECT * FROM `devices` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }

    String dbdevice_no = rs.getString("device_no");
    String dbcategory_id = rs.getString("category_id");
    String dbname = rs.getString("name");
    String dbmodel = rs.getString("model");
    String dbspecification = rs.getString("specification");
    String dbmanufacturer = rs.getString("manufacturer");
    String dbwarranty_period = rs.getString("warranty_period");
    String dbstatus = rs.getString("status");
    String dblocation = rs.getString("location");
    String dbprice = rs.getString("price");
    status = rs.getString("status");
    if (status == null) {
        status = "available";
    }


    String sqlCategory = "SELECT id, name FROM device_categories";
    ResultSet rsCategory = DbConnect.select(sqlCategory, null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑设备</title>
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
    <div class="title">编辑设备</div>
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
            <label for="device_no">设备编号：</label>
            <input type="text" id="device_no" name="device_no" value="<%=dbdevice_no%>"/>
            <span class="error" id="device_noError"></span>
        </div>

        <div class="form-item">
            <label for="category_id">设备类型：</label>
            <select id="category_id" name="category_id">
                <% while (rsCategory.next()) { %>
                <option value="<%=rsCategory.getString("id")%>" <%= rsCategory.getString("id").equals(dbcategory_id) ? "selected" : "" %>>
                    <%=rsCategory.getString("name")%>
                </option>
                <% } %>
            </select>
            <span class="error" id="category_idError"></span>
        </div>

        <div class="form-item">
            <label for="name">设备名称：</label>
            <input type="text" id="name" name="name" value="<%=dbname%>"/>
            <span class="error" id="nameError"></span>
        </div>

        <div class="form-item">
            <label for="manufacturer">制作商名称：</label>
            <input type="text" id="manufacturer" name="manufacturer" value="<%=dbmanufacturer%>"/>
            <span class="error" id="manufacturerError"></span>
        </div>


        <div class="form-item">
            <label for="warranty_period">保修期限：</label>
            <input type="text" id="warranty_period" name="warranty_period" value="<%=dbwarranty_period%>"/>
            <span class="error" id="warranty_periodError"></span>
        </div>


        <div class="form-item">
            <label for="model">型号：</label>
            <input type="text" id="model" name="model" value="<%=dbmodel%>"/>
            <span class="error" id="modelError"></span>
        </div>


        <div class="form-item">
            <label for="specification">设备类别：</label>
            <input type="text" id="specification" name="specification" value="<%=dbspecification%>"/>
            <span class="error" id="specificationError"></span>
        </div>

        <div class="form-item">
            <label for="location">存放位置：</label>
            <input type="text" id="location" name="location" value="<%=dblocation%>"/>
            <span class="error" id="locationError"></span>
        </div>


        <div class="form-item">
            <label for="price">价格：</label>
            <input type="text" id="price" name="price" value="<%=dbprice%>"/>
            <span class="error" id="priceError"></span>
        </div>


        <div class="form-item">
            <label for="status">设备状态：</label>
            <select id="status" name="status">
                <option value="available" <%= "available".equals(status) ? "selected" : "" %>>闲置</option>
                <option value="in_use" <%= "in_use".equals(status) ? "selected" : "" %>>正在使用</option>
                <option value="maintenance" <%= "maintenance".equals(status) ? "selected" : "" %>>维修中</option>
                <option value="scrapped" <%= "scrapped".equals(status) ? "selected" : "" %>>已报废</option>
            </select>
            <span class="error" id="statusSelectError"></span>
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
            var device_no = $("#device_no").val().trim();
            var category_id = $("#category_id").val().trim();
            var name = $("#name").val().trim();
            var manufacturer = $("#manufacturer").val().trim();
            var warranty_period = $("#warranty_period").val().trim();
            var model = $("#model").val().trim();
            var specification = $("#specification").val().trim();
            var device_status = $("#status").val();
            var location = $("#location").val().trim();
            var price = $("#price").val().trim();


            $(".error").text("");


            if (device_no === "") {
                $("#device_noError").text("设备编号不能为空");
                isValid = false;
            }


            if (category_id === "") {
                $("#category_idError").text("设备类型不能为空");
                isValid = false;
            }


            if (name === "") {
                $("#nameError").text("设备名称不能为空");
                isValid = false;
            }


            if (manufacturer === "") {
                $("#manufacturerError").text("制作商名称不能为空");
                isValid = false;
            }


            if (warranty_period === "") {
                $("#warranty_periodError").text("保修期限不能为空");
                isValid = false;
            }


            if (model === "") {
                $("#modelError").text("型号不能为空");
                isValid = false;
            }


            if (specification === "") {
                $("#specificationError").text("设备类别不能为空");
                isValid = false;
            }


            if (device_status === "") {
                $("#statusError").text("设备状态不能为空");
                isValid = false;
            }


            if (location === "") {
                $("#locationError").text("存放位置不能为空");
                isValid = false;
            }


            if (price === "") {
                $("#priceError").text("价格不能为空");
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