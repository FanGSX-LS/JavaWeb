<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String title = request.getParameter("title");
    if (title == null) title = "";
    String publisherName = request.getParameter("publisher_name");
    if (publisherName == null) publisherName = "";
    String isPublished = request.getParameter("is_published");
    if (isPublished == null) isPublished = "";

    // 查询所有管理员信息
    String adminSql = "SELECT id, username FROM admins";
    ResultSet adminRs = DbConnect.select(adminSql, null);

    // 获取发布人ID
    String publisherId = "";
    if (!publisherName.isEmpty()) {
        String getIdSql = "SELECT id FROM admins WHERE username LIKE ?";
        Object[] getIdParams = new Object[]{"%" + publisherName + "%"};
        ResultSet getIdRs = DbConnect.select(getIdSql, getIdParams);
        if (getIdRs.next()) {
            publisherId = getIdRs.getString("id");
        }
    }

    // 获取数据的总行数（修正后的SQL）
    String sql = "SELECT COUNT(*) AS total FROM  `announcements` " +
            "WHERE `id` LIKE ? AND `title` LIKE ? AND `publisher_id` IN (SELECT id FROM admins WHERE username LIKE ?) AND `is_published` LIKE ?;";
    Object[] params = new Object[]{"%" + id + "%", "%" + title + "%", "%" + publisherName + "%", "%" + isPublished + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");// 总行数
    // 每页显示的行数
    int pageSize = 5;
    // 计算总页数（向上取整）
    int pageTotal = (int) Math.ceil((float) total / pageSize);// 向上取整
    // 当前页码
    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);// 将字符串转换成整数类型

    // 通过执行sql查询语句，获得数据库用户表的数据（修正后的SQL）
    int start = (pageNo - 1) * pageSize;// 开始行号
    sql = "SELECT a.*, ad.username AS publisher_name FROM `announcements` a " +
            "JOIN admins ad ON a.publisher_id = ad.id " +
            "WHERE a.`id` LIKE ? AND a.`title` LIKE ? AND ad.`username` LIKE ? AND a.`is_published` LIKE ? " +
            "ORDER BY a.id ASC " +  // 修改为正序排列
            "LIMIT ?,?;";
    params = new Object[]{
            "%" + id + "%", "%" + title + "%", "%" + publisherName + "%", "%" + isPublished + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>公告管理列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!--查询区域 S-->
<div class="search-box">
    <form id="searchForm">
        <label for="id">公告ID：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="title">公告标题：</label>
        <input value="<%=title%>" id="title" name="title" type="text">
        <label for="publisher_name">发布人：</label>
        <select id="publisher_name" name="publisher_name">
            <option value="">全部</option>
            <% while (adminRs.next()) { %>
            <option value="<%=adminRs.getString("username")%>" <%=adminRs.getString("username").equals(publisherName) ? "selected" : ""%>><%=adminRs.getString("username")%>
            </option>
            <% } %>
        </select>
        <label for="is_published">是否发布：</label>
        <input value="<%=isPublished%>" id="is_published" name="is_published" type="text">
        <button id="btnSearch" class="primary" type="button">查询</button>
        <button id="btnReset" type="button">重置</button>

    </form>
    <div class="btn-box">
        <button id="btnAdd" class="add" type="button">新增</button>
    </div>
</div>
<!--查询区域 E-->

<!--按钮区域 S-->

<!--按钮区域 E-->

<!--表格区域 S-->
<div class="table-box">
    <table>
        <tr>
            <th>公告ID</th>
            <th>公告标题</th>
            <th>公告内容</th>
            <th>发布人</th>
            <th>是否发布</th>
            <th>发布时间</th>
            <th>创建时间</th>
            <th class="option">操作</th>
        </tr>
        <%
            java.util.HashMap<String, String> statusMap = new java.util.HashMap<>();
            statusMap.put("0", "未发布");
            statusMap.put("1", "已发布");
            while (rs.next()) {
                // 获取状态ID
                String statusId = rs.getString("is_published");
                String statusName = statusMap.getOrDefault(statusId, statusId);
        %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("title")%>
            </td>
            <td><%=rs.getString("content")%>
            </td>
            <td><%=rs.getString("publisher_name")%>
            </td>
            <td><%=statusName%>
            </td>
            <td><%=rs.getString("publish_time")%>
            </td>
            <td><%=rs.getString("created_at")%>
            </td>
            <td>
                <button data-id="<%=rs.getString("id")%>" name="btnEdit" class="primary" type="button">编辑</button>
                <button data-id="<%=rs.getString("id")%>" name="btnDelete" class="danger" type="button">删除</button>
            </td>
        </tr>
        <% } %>
    </table>
</div>
<!--表格区域 E-->

<!--页码区域 S-->
<div class="pager">
    <%
        String url = "list.jsp?id=" + id + "&title=" + title + "&publisher_name=" + publisherName + "&is_published=" + isPublished;
    %>
    <ul>
        <li>共 <%=total%> 条数据/每页 <%=pageSize%> 行</li>
        <% if (pageNo > 1) { %>
        <li><a href="<%=url%>&pageNo=1">首页</a></li>
        <li><a href="<%=url%>&pageNo=<%=pageNo - 1%>">上一页</a></li>
        <% } %>
        <% for (int i = 1; i <= pageTotal; i++) { %>
        <li class="<%=(pageNo == i ? "active" : "") %>">
            <a href="<%=url%>&pageNo=<%=i%>"><%=i%>
            </a>
        </li>
        <% } %>
        <% if (pageTotal > pageNo) { %>
        <li><a href="<%=url%>&pageNo=<%=pageNo + 1%>">下一页</a></li>
        <li><a href="<%=url%>&pageNo=<%=pageTotal%>">尾页</a></li>
        <% } %>
    </ul>
</div>
<!--页码区域 E-->

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    // 查询按钮的点击事件
    $('#btnSearch').on('click', function () {
        // 获取搜索表单中的数据：账号、姓名
        window.location.href = 'list.jsp?' + $('#searchForm').serialize()
    });

    $('#btnReset').on('click', function () {
        window.location.href = 'list.jsp';
    });

    $('#btnAdd').on('click', function () {
        window.location.href = 'add.jsp';
    });

    $('button[name=btnEdit]').on('click', function () {
        // 获取当前点击的编辑按钮data-id值
        let id = $(this).attr("data-id");
        window.location.href = 'edit.jsp?id=' + id;
    });

    $('button[name=btnDelete]').on('click', function () {
        let id = $(this).attr("data-id");

        const isConfirmed = confirm(`确定要删除吗？`);

        if (isConfirmed) {
            $.ajax({
                url: 'delete.jsp',
                type: 'POST',
                data: {id: id},
                success: function (response) {
                    if (response === 'success') {
                        alert('删除成功');
                        setTimeout(() => {
                            location.reload();
                        }, 500);
                    } else {
                        alert(response);
                        setTimeout(() => {
                            location.reload();
                        }, 500);
                    }
                },
                error: function () {
                    alert('服务器错误，请稍后再试');
                }
            });
        }
    });
</script>
</body>
</html>