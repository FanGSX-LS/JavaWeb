<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String name = request.getParameter("name");
    if (name == null) name = "";
    String description = request.getParameter("description");
    if (description == null) description = "";

    StringBuilder whereClause = new StringBuilder("where 1=1");
    java.util.ArrayList<Object> paramList = new java.util.ArrayList<>();
    if (!id.isEmpty()) {
        whereClause.append(" and `id` like ?");
        paramList.add("%" + id + "%");
    }
    if (!name.isEmpty()) {
        whereClause.append(" and `name` like ?");
        paramList.add("%" + name + "%");
    }
    if (!description.isEmpty()) {
        whereClause.append(" and `description` like ?");
        paramList.add("%" + description + "%");
    }

    String sql = "select count(*) as total from  `device_categories` " + whereClause.toString();
    Object[] params = paramList.toArray();
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");

    int pageSize = 5;

    int pageTotal = (int) Math.ceil((float) total / pageSize);

    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);


    int start = (pageNo - 1) * pageSize;
    sql = "select *  from `device_categories` " + whereClause.toString() +
            " order by id asc " +
            " limit ?,?";
    paramList.add(start);
    paramList.add(pageSize);
    params = paramList.toArray();
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
        <label for="id">编号：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="name">设备类别名称：</label>
        <input value="<%=name%>" id="name" name="name" type="text">
        <label for="description">设备类别备注：</label>
        <input value="<%=description%>" id="description" name="description" type="text">
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
    <table id="dataTable">
        <tr>
            <th>编号</th>
            <th>设备类别名称</th>
            <th>设备类别备注</th>
            <th class="option">操作</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("name")%>
            </td>
            <td><%=rs.getString("description")%>
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
<div class="pager" id="pager">
    <%
        String url = "list.jsp?id=" + id + "&name=" + name + "&description=" + description;
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

    $('#btnSearch').on('click', function () {

        $.ajax({
            url: 'list.jsp',
            type: 'GET',
            data: $('#searchForm').serialize(),
            success: function (response) {

                let $response = $(response);
                $('#dataTable').html($response.find('#dataTable').html());
                $('#pager').html($response.find('#pager').html());
            },
            error: function () {
                alert('查询失败，请稍后再试');
            }
        });
    });


    $('#btnReset').on('click', function () {

        $('#searchForm')[0].reset();

        window.location.href = 'list.jsp';
    });


    $('#btnAdd').on('click', function () {
        window.location.href = 'add.jsp';
    });


    $(document).on('click', 'button[name=btnEdit]', function () {

        let id = $(this).attr("data-id");
        window.location.href = 'edit.jsp?id=' + id;
    });


    $(document).on('click', 'button[name=btnDelete]', function () {
        let id = $(this).attr("data-id");
        let name = $(this).closest('tr').find('td:eq(2)').text(); // 获取姓名


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