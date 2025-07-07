<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    if (username == null) username = "";
    String employee_no = request.getParameter("employee_no");
    if (employee_no == null) employee_no = "";

    String sql = "select count(*) as total from  `employees` " +
            "where `username` like ? and `employee_no` like ?;";
    Object[] params = new Object[]{"%" + username + "%", "%" + employee_no + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");

    int pageSize = 5;

    int pageTotal = (int) Math.ceil((float) total / pageSize);

    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);

    int start = (pageNo - 1) * pageSize;
    sql = "select *  from `employees` " +
            "where `username` like ? and `employee_no` like ? " +
            "order by id asc " +
            "limit ?,?;";
    params = new Object[]{
            "%" + username + "%", "%" + employee_no + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>管理员列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!--查询区域 S-->
<div class="search-box">
    <form id="searchForm">
        <label for="username">用户名：</label>
        <input value="<%=username%>" id="username" name="username" type="text">
        <label for="employee_no">员工编号：</label>
        <input value="<%=employee_no%>" id="employee_no" name="employee_no" type="text">
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
            <th>ID</th>
            <th>员工编号</th>
            <th>所属部门</th>
            <th>用户名</th>
            <th>邮箱</th>
            <th>联系电话</th>
            <th>是否在职</th>
            <th class="option">操作</th>
        </tr>
        <%
            java.util.HashMap<String, String> departmentMap = new java.util.HashMap<>();
            departmentMap.put("1", "技术部");
            departmentMap.put("2", "行政部");
            departmentMap.put("3", "市场部");
            departmentMap.put("4", "财务部");
            departmentMap.put("5", "人力资源部");

            while (rs.next()) {
                String departmentId = rs.getString("department_id");
                String departmentName = departmentMap.getOrDefault(departmentId, departmentId);
        %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("employee_no")%>
            </td>
            <td><%=departmentName%>
            </td>
            <td><%=rs.getString("username")%>
            </td>
            <td><%=rs.getString("email")%>
            </td>
            <td><%=rs.getString("phone")%>
            </td>
            <td><%=rs.getString("is_active")%>
            </td>

            <td>
                <button data-id="<%=rs.getString("id")%>" name="btnEdit" class="primary" type="button">编辑</button>
                <button data-id="<%=rs.getString("id")%>" name="btnDelete" class="danger" type="button">删除</button>
            </td>
        </tr>
        <% }%>
    </table>
</div>
<!--表格区域 E-->

<!--页码区域 S-->
<div class="pager">
    <%
        String url = "list.jsp?username=" + username + "&employee_no=" + employee_no;
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
<!--页码区域 E-->

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>

    $('#btnSearch').on('click', function () {

        window.location.href = 'list.jsp?' + $('#searchForm').serialize()
    });

    $('#btnReset').on('click', function () {

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
    