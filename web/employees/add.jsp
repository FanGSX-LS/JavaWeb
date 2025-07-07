<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
<<<<<<< Updated upstream

    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");


=======
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

>>>>>>> Stashed changes
    String action = request.getParameter("action");
    boolean insertSuccess = false;
    String errorMsg = "";

<<<<<<< Updated upstream
=======
    // 查询所有部门（用于下拉选项）
    String sqlDepts = "SELECT id, name FROM departments ORDER BY id ASC";
    ResultSet rsDepts = DbConnect.select(sqlDepts, null);
>>>>>>> Stashed changes

    if ("insert".equals(action)) {
        String password = request.getParameter("password");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String department_id = request.getParameter("department_id");
        String phone = request.getParameter("phone");
        String employee_no = request.getParameter("employee_no");
        String cmfPsw = request.getParameter("cmfPsw");

<<<<<<< Updated upstream

        boolean hasError = false;

        if (password == null || password.trim().isEmpty()) {
=======
        boolean hasError = false;

        if (employee_no == null || employee_no.trim().isEmpty()) {
            hasError = true;
            errorMsg = "员工编号不能为空";
        } else if (password == null || password.trim().isEmpty()) {
>>>>>>> Stashed changes
            hasError = true;
            errorMsg = "密码不能为空";
        } else if (!password.equals(cmfPsw)) {
            hasError = true;
            errorMsg = "两次输入的密码不一致";
        } else if (username == null || username.trim().isEmpty()) {
            hasError = true;
            errorMsg = "姓名不能为空";
        } else if (email == null || email.trim().isEmpty()) {
            hasError = true;
            errorMsg = "邮箱不能为空";
        } else if (phone == null || phone.trim().isEmpty()) {
            hasError = true;
            errorMsg = "联系电话不能为空";
        } else if (department_id == null || department_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "请选择部门";
        }

        if (!hasError) {
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
            String sqlInsert = "INSERT INTO `employees`(`employee_no`, `department_id`, `username`, `password`, `email`, `phone`) VALUES (?, ?, ?, ?, ?, ?)";
            Object[] paramsInsert = new Object[]{employee_no, department_id, username, password, email, phone};
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
    <div class="title">新增用户</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="employee_no">员工编号：</label>
            <input value="" id="employee_no" name="employee_no" type="text">
            <span class="error" id="employee_noError"></span>
        </div>
        <div class="form-item">
            <label for="username">姓名：</label>
            <input value="" id="username" name="username" type="text">
            <span class="error" id="usernameError"></span>
        </div>
        <div class="form-item">
            <label for="password">密码：</label>
            <input value="" id="password" name="password" type="password">
            <span class="error" id="passwordError"></span>
        </div>
        <div class="form-item">
            <label for="cmfPsw">确认密码：</label>
            <input value="" id="cmfPsw" name="cmfPsw" type="password">
            <span class="error" id="cmfPswError"></span>
        </div>
        <div class="form-item">
            <label for="department_id">部门：</label>
            <select id="department_id" name="department_id">
                <option value="">请选择部门</option>
                <% while (rsDepts.next()) {
                    String deptId = rsDepts.getString("id");
                    String deptName = rsDepts.getString("name");
                %>
                <option value="<%=deptId%>"><%=deptName%></option>
                <% } %>
            </select>
            <span class="error" id="departmentError"></span>
        </div>
        <div class="form-item">
            <label for="email">邮件：</label>
            <input value="" id="email" name="email" type="text">
            <span class="error" id="emailError"></span>
        </div>
        <div class="form-item">
            <label for="phone">联系电话：</label>
            <input value="" id="phone" name="phone" type="text">
            <span class="error" id="phoneError"></span>
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
<<<<<<< Updated upstream

    $(document).ready(function () {

        var insertSuccess = <%=insertSuccess ? "true" : "false" %>;
        if (insertSuccess) {

=======
    $(document).ready(function () {
        var insertSuccess = <%=insertSuccess ? "true" : "false" %>;
        if (insertSuccess) {
>>>>>>> Stashed changes
            alert("添加成功！");
            window.location.href = "list.jsp";
        }

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
        $("#addForm").submit(function (event) {
            var isValid = true;
            var password = $("#password").val();
            var cmfPsw = $("#cmfPsw").val();
            var username = $("#username").val();
            var email = $("#email").val();
            var department = $("#department_id").val(); // 下拉选择直接获取值
            var phone = $("#phone").val();
            var employee_no = $("#employee_no").val();

<<<<<<< Updated upstream

            $(".error").text("");


=======
            $(".error").text("");

>>>>>>> Stashed changes
            if (employee_no.trim() === "") {
                $("#employee_noError").text("员工编号不能为空");
                isValid = false;
            }
            if (password.trim() === "") {
                $("#passwordError").text("密码不能为空");
                isValid = false;
            }

            if (cmfPsw.trim() === "") {
                $("#cmfPswError").text("确认密码不能为空");
                isValid = false;
            } else if (password !== cmfPsw) {
                $("#cmfPswError").text("两次输入的密码不一致");
                isValid = false;
            }

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
            if (username.trim() === "") {
                $("#usernameError").text("姓名不能为空");
                isValid = false;
            }

<<<<<<< Updated upstream

            if (department.trim() === "") {
                $("#departmentError").text("部门不能为空");
                isValid = false;
            }


=======
            if (department === "") { // 下拉选择判断值是否为空
                $("#departmentError").text("请选择部门");
                isValid = false;
            }

>>>>>>> Stashed changes
            if (phone.trim() === "") {
                $("#phoneError").text("电话不能为空");
                isValid = false;
            }

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
            if (email.trim() === "") {
                $("#emailError").text("邮箱不能为空");
                isValid = false;
            } else if (!validateEmail(email)) {
                $("#emailError").text("邮箱格式不正确");
                isValid = false;
            }

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
            if (!isValid) {
                event.preventDefault();
            }
        });

<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
        function validateEmail(email) {
            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(email);
        }
    });
</script>
</body>
</html>