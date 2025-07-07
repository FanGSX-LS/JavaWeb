<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    // 设置请求编码
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 功能：编辑公告信息
    String id = request.getParameter("id");
    String action = request.getParameter("action");
    boolean updateSuccess = false;
    String errorMsg = "";

    if ("update".equals(action)) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String publisher_id = request.getParameter("publisher_id");
        String is_published = request.getParameter("is_published");
        String publish_time = request.getParameter("publish_time");

        boolean hasError = false;
        if (title == null || title.trim().isEmpty()) {
            hasError = true;
            errorMsg = "公告标题不能为空";
        }
        if (publisher_id == null || publisher_id.trim().isEmpty()) {
            hasError = true;
            errorMsg = "发布人不能为空";
        }

        if (!hasError) {
            String sqlUpdate = "UPDATE `announcements` SET " +
                    "`title` = ?, " +
                    "`content` = ?, " +
                    "`publisher_id` = ?, " +
                    "`is_published` = ?, " +
                    "`publish_time` = ? " +
                    "WHERE `id` = ?";
            Object[] paramsUpdate = {title, content, publisher_id, is_published, publish_time, id};
            int result = DbConnect.update(sqlUpdate, paramsUpdate);

            if (result > 0) {
                updateSuccess = true;
            } else {
                errorMsg = "更新失败，请重试";
            }
        }
    }

    // 查询公告信息
    String sqlSelect = "SELECT * FROM `announcements` WHERE `id`=?";
    ResultSet rs = DbConnect.select(sqlSelect, new Object[]{id});
    if (!rs.next()) {
        response.sendRedirect("list.jsp");
        return;
    }
    // 初始化表单字段值
    String dbtitle = rs.getString("title");
    String dbcontent = rs.getString("content");
    String dbpublisher_id = rs.getString("publisher_id");
    String dbis_published = rs.getString("is_published");
    String dbpublish_time = rs.getString("publish_time");

    // 查询管理员列表
    String sqlAdmins = "SELECT id, username FROM admins";
    ResultSet rsAdmins = DbConnect.select(sqlAdmins, null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑公告</title>
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
    <div class="title">编辑公告</div>
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
            <label for="title">公告标题：</label>
            <input type="text" id="title" name="title" value="<%=dbtitle%>"/>
            <span class="error" id="titleError"></span>
        </div>
        <div class="form-item">
            <label for="content">公告内容：</label>
            <textarea id="content" name="content"><%=dbcontent%></textarea>
            <span class="error" id="contentError"></span>
        </div>
        <div class="form-item">
            <label for="publisher_id">发布人：</label>
            <select id="publisher_id" name="publisher_id">
                <% while (rsAdmins.next()) {
                    String adminId = rsAdmins.getString("id");
                    String adminUsername = rsAdmins.getString("username");
                    String selected = adminId.equals(dbpublisher_id) ? "selected" : "";
                %>
                <option value="<%=adminId%>" <%=selected%>><%=adminUsername%>
                </option>
                <% } %>
            </select>
            <span class="error" id="publisher_idError"></span>
        </div>
        <div class="form-item">
            <label for="is_published">是否发布：</label>
            <select id="is_published" name="is_published">
                <option value="0" <%= "0".equals(dbis_published) ? "selected" : "" %>>未发布</option>
                <option value="1" <%= "1".equals(dbis_published) ? "selected" : "" %>>已发布</option>
            </select>
            <span class="error" id="is_publishedError"></span>
        </div>
        <div class="form-item">
            <label for="publish_time">发布时间：</label>
            <input type="datetime-local" id="publish_time" name="publish_time"
                   value="<%=dbpublish_time != null ? dbpublish_time.replace(" ", "T") : "" %>"/>
            <span class="error" id="publish_timeError"></span>
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
        // 处理更新成功跳转
        if (<%=updateSuccess ? "true" : "false"%>) {
            alert("更新成功！");
            window.location.href = "list.jsp";
        }

        // 返回按钮
        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

        // 表单验证
        $("#editForm").submit(function (event) {
            var isValid = true;
            var title = $("#title").val().trim();
            var content = $("#content").val().trim();
            var publisher_id = $("#publisher_id").val().trim();
            var is_published = $("#is_published").val();
            var publish_time = $("#publish_time").val().trim();

            $(".error").text("");

            if (title === "") {
                $("#titleError").text("公告标题不能为空");
                isValid = false;
            }

            if (content === "") {
                $("#contentError").text("公告内容不能为空");
                isValid = false;
            }

            if (publisher_id === "") {
                $("#publisher_idError").text("发布人不能为空");
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