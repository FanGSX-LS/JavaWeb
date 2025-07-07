<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //获取用户输入的查询内容：账号、姓名
    String username = request.getParameter("username");
    if (username == null) username = "";
    String realname = request.getParameter("realname");
    if (realname == null) realname = "";

    //获取数据的总行数
    String sql = "select count(*) as total from  `admins` " +
            "where `username` like ? and `realname` like ?;";
    Object[] params = new Object[]{"%" + username + "%", "%" + realname + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");

    int pageSize = 5;

    int pageTotal = (int) Math.ceil((float) total / pageSize);

    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);

    int start = (pageNo - 1) * pageSize;
    sql = "select *  from `admins` " +
            "where `username` like ? and `realname` like ? " +
            "order by id asc " +
            "limit ?,?;";
    params = new Object[]{
            "%" + username + "%", "%" + realname + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>管理员列表</title>
    <style>

    </style>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
    <style>

    </style>
</head>
<body>
<div class="container">
    <!--查询区域 S-->
    <div class="search-box">
        <form id="searchForm">
            <label for="username">账号：</label>
            <input value="<%=username%>" id="username" name="username" type="text">
            <label for="realname">姓名：</label>
            <input value="<%=realname%>" id="realname" name="realname" type="text">
            <button id="btnSearch" class="primary" type="button">查询</button>
            <button id="btnReset" class="default" type="button">重置</button>
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
                <th>编号</th>
                <th>账号</th>
                <th>姓名</th>
                <th>邮件</th>
                <th class="option">操作</th>
            </tr>
            <%
                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
            %>
            <tr>
                <td><%=rs.getString("id")%>
                </td>
                <td><%=rs.getString("username")%>
                </td>
                <td><%=rs.getString("realname")%>
                </td>
                <td><%=rs.getString("email")%>
                </td>
                <td>
                    <button data-id="<%=rs.getString("id")%>" name="btnEdit" class="primary" type="button">编辑</button>
                    <button data-id="<%=rs.getString("id")%>" name="btnDelete" class="danger" type="button">删除
                    </button>
                </td>
            </tr>
            <% }
                if (!hasData) {
            %>
            <tr>
                <td colspan="5" class="empty-tip">暂无数据</td>
            </tr>
            <% } %>
        </table>
    </div>
    <!--表格区域 E-->

    <div class="pager">
        <%
            String url = "list.jsp?id=" + username + "&title=" + realname;
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
</div>

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>

    $('#btnSearch').on('click', function () {
        window.location.href = 'list.jsp?' + $('#searchForm').serialize()
    });

    $('#btnReset').on('click', function () {

        $('#username').val('');

        $('#realname').val('');

        window.location.href = 'list.jsp';
    });

    $('#btnAdd').on('click', function () {
        window.location.href = 'add.jsp';
    });

    $('button[name=btnEdit]').on('click', function () {
        let id = $(this).attr("data-id");
        window.location.href = 'edit.jsp?id=' + id;
    });

    $('button[name=btnDelete]').on('click', function () {
        let id = $(this).attr("data-id");
        let realname = $(this).closest('tr').find('td:eq(2)').text();
        const isConfirmed = confirm(`确定要删除管理员"${realname}"吗？`);

        if (isConfirmed) {
            $.ajax({
                url: 'deleteAdmin.jsp',
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