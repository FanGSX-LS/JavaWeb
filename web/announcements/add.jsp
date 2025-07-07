<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%
    // 设置请求编码
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 功能：处理新增公告请求
    String action = request.getParameter("action");
    boolean insertSuccess = false;
    String errorMsg = "";

    // 查询所有管理员信息
    String sqlSelectAdmins = "SELECT id, username FROM admins";
    ResultSet rsAdmins = DbConnect.select(sqlSelectAdmins, null);

    if ("insert".equals(action)) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String isPublished = request.getParameter("is_published");
        String publishTimeStr = request.getParameter("publish_time");
        String publisherIdStr = request.getParameter("publisher_id");
        boolean hasError = false;
        if (title == null || title.trim().isEmpty()) {
            hasError = true;
            errorMsg = "公告标题不能为空";
        } else if (content == null || content.trim().isEmpty()) {
            hasError = true;
            errorMsg = "公告内容不能为空";
        } else if (publisherIdStr == null || publisherIdStr.trim().isEmpty()) {
            hasError = true;
            errorMsg = "请选择发布人";
        }

        Timestamp publishTime = null;
        if ("1".equals(isPublished)) {
            if (publishTimeStr == null || publishTimeStr.trim().isEmpty()) {
                hasError = true;
                errorMsg = "发布时间不能为空";
            } else {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    Date date = sdf.parse(publishTimeStr);
                    publishTime = new Timestamp(date.getTime());
                } catch (Exception e) {
                    hasError = true;
                    errorMsg = "发布时间格式不正确，请重新选择";
                }
            }
        }

        if (!hasError) {
            int publisherId = Integer.parseInt(publisherIdStr);
            String sqlInsert = "INSERT INTO `guanli`.`announcements`( `title`, `content`, `publisher_id`, `is_published`, `publish_time`) VALUES (?, ?, ?, ?, ?)";
            Object[] paramsInsert = new Object[]{title, content, publisherId, isPublished, publishTime};
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
    <title>新增公告</title>
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
    <div class="title">新增公告</div>
</header>
<div class="main">
    <form id="addForm" action="add.jsp?action=insert" method="post">
        <input type="hidden" name="_charset_" value="UTF-8">

        <div class="form-item">
            <div class="error"><%=errorMsg %>
            </div>
        </div>
        <div class="form-item">
            <label for="title">公告标题：</label>
            <input value="" id="title" name="title" type="text">
            <span class="error" id="titleError"></span>
        </div>
        <div class="form-item">
            <label for="content">公告内容：</label>
            <textarea id="content" name="content"></textarea>
            <span class="error" id="contentError"></span>
        </div>
        <div class="form-item">
            <label for="publisher_id">发布人：</label>
            <select id="publisher_id" name="publisher_id">
                <option value="">请选择发布人</option>
                <% while (rsAdmins.next()) { %>
                <option value="<%= rsAdmins.getInt("id") %>"><%= rsAdmins.getString("username") %>
                </option>
                <% } %>
            </select>
            <span class="error" id="publisherIdError"></span>
        </div>
        <div class="form-item">
            <label for="is_published">是否发布：</label>
            <input type="radio" id="is_published_yes" name="is_published" value="1"> <label
                for="is_published_yes">是</label>
            <input type="radio" id="is_published_no" name="is_published" value="0" checked> <label
                for="is_published_no">否</label>
            <span class="error" id="is_publishedError"></span>
        </div>
        <div class="form-item">
            <label for="publish_time">发布时间：</label>
            <input type="datetime-local" id="publish_time" name="publish_time">
            <span class="error" id="publishTimeError"></span>
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
    // 页面加载完成后执行
    $(document).ready(function () {
        // 检查是否添加成功
        var insertSuccess = <%=insertSuccess ? "true" : "false" %>;
        if (insertSuccess) {
            // 显示成功提示并返回列表页
            alert("添加成功！");
            window.location.href = "list.jsp";
        }

        // 返回按钮事件
        $("#btnBack").click(function () {
            window.location.href = "list.jsp";
        });

        // 表单提交前验证
        $("#addForm").submit(function (event) {
            var isValid = true;
            var title = $("#title").val();
            var content = $("#content").val();
            var isPublished = $('input[name="is_published"]:checked').val();
            var publishTime = $("#publish_time").val();
            var publisherId = $("#publisher_id").val();

            $(".error").text("");

            if (title.trim() === "") {
                $("#titleError").text("公告标题不能为空");
                isValid = false;
            }

            if (content.trim() === "") {
                $("#contentError").text("公告内容不能为空");
                isValid = false;
            }

            if (publisherId === "") {
                $("#publisherIdError").text("请选择发布人");
                isValid = false;
            }

            if (isPublished === "1") {
                if (publishTime.trim() === "") {
                    $("#publishTimeError").text("发布时间不能为空");
                    isValid = false;
                }
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>