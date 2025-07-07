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
    String sql = "select count(*) as total from  `user` " +
            "where `username` like ? and `realname` like ?;";
    Object[] params = new Object[]{"%" + username + "%", "%" + realname + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");//总行数
    //每页显示的行数
    int pageSize = 5;
    //计算总页数（向上取整）
    int pageTotal = (int) Math.ceil((float) total / pageSize);//向上取整
    //当前页码
    String pageNoStr = request.getParameter("pageNo");
    //if(pageNoStr==null) pageNoStr = "1";
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);//将字符串转换成整数类型


    //通过执行sql查询语句，获得数据库用户表的数据
    int start = (pageNo - 1) * pageSize;//开始行号
    sql = "select *  from `user` " +
            "where `username` like ? and `realname` like ? " +
            "order by id desc " +
            "limit ?,?;";
    params = new Object[]{
            "%" + username + "%", "%" + realname + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>用户列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<%--查询区域 S--%>
<div class="search-box">
    <form id="searchForm">
        <label for="username">账号：</label>
        <input value="<%=username%>" id="username" name="username" type="text">
        <label for="username">姓名：</label>
        <input value="<%=realname%>" id="realname" name="realname" type="text">
        <button id="btnSearch" class="primary" type="button">查询</button>
        <button id="btnReset" type="button">重置</button>
    </form>
</div>
<%--查询区域 E--%>

<%--按钮区域 S--%>
<div class="btn-box">
    <button id="btnAdd" class="primary" type="button">新增</button>
</div>
<%--按钮区域 E--%>

<%--表格区域 S--%>
<div class="table-box">
    <%--    编号、账号、姓名    --%>
    <table>
        <tr>
            <th>编号</th>
            <th>账号</th>
            <th>姓名</th>
            <th class="option">操作</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("username")%>
            </td>
            <td><%=rs.getString("realname")%>
            </td>
            <td>
                <button data-id="<%=rs.getString("id")%>" name="btnEdit" class="primary" type="button">编辑</button>
                <button data-id="<%=rs.getString("id")%>" name="btnDelete" class="danger" type="button">删除</button>
            </td>
        </tr>
        <% }%>
    </table>
</div>
<%--表格区域 E--%>

<%--页码区域 S--%>
<%--    每页十行，共20条--%>
<div class="pager">
    <%
        String url = "list.jsp?username=" + username + "&realname=" + realname;
    %>
    <ul>
        <li>共 <%=total%> 条数据/每页 <%=pageSize%> 行</li>
        <% if (pageNo > 1) { %>
        <li><a href="<%=url%>&pageNo=1">首页</a></li>
        <li><a href="<%=url%>&pageNo=<%=pageNo-1%>">上一页</a></li>
        <% } %>
        <% for (int i = 1; i <= pageTotal; i++) {%>
        <li class="<%=(pageNo==i?"active":"") %>">
            <a href="<%=url%>&pageNo=<%=i%>"><%=i%>
            </a>
        </li>
        <% } %>
        <% if (pageTotal > pageNo) { %>
        <li><a href="<%=url%>&pageNo=<%=pageNo+1%>">下一页</a></li>
        <li><a href="<%=url%>&pageNo=<%=pageTotal%>">尾页</a></li>
        <% } %>
    </ul>
</div>
<%--页码区域 E--%>

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    //查询按钮的点击事件
    $('#btnSearch').on('click', function () {
        //获取搜索表单中的数据：账号、姓名
        window.location.href = 'list.jsp?' + $('#searchForm').serialize()
    });

    //绑定重置按钮的点击事件
    $('#btnReset').on('click', function () {
        //不携带数据，相当于清空搜索内容
        window.location.href = 'list.jsp';
    });

    //绑定新增按钮的点击事件
    $('#btnAdd').on('click', function () {
        window.location.href = 'add.jsp';
    });

    //批量绑定编辑按钮的点击事件
    $('button[name=btnEdit]').on('click', function () {
        //获取当前点击的编辑按钮data-id值
        //attr("属性名")：获取当前元素中的对应属性值
        let id = $(this).attr("data-id");
        window.location.href = 'edit.jsp?id=' + id;
    });
    //批量绑定删除按钮的点击事件
    $('button[name=btnDelete]').on('click', function () {
        //1.判断用户是否是真正需要删除数据：确认提示
        if (confirm("确定要删除此数据吗？")) {
            //确定要删除，获取要删除的数据编号
            let id = $(this).attr('data-id');
            //进行无刷新提交（以POST方式发送删除的请求）
            postAction('/user/delete', {id: id}, function (res) {
                //提示
                alert(res.msg)
                //成功：刷新列表界面(重新打开列表页面)
                if (res.result) window.location.href = res.url;
            });
        }
    });

</script>
</body>
</html>
