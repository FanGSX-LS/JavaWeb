<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String name = request.getParameter("name");
    if (name == null) name = "";


    String sql = "select count(*) as total from  `devices` " +
            "where `id` like ? and `name` like ?;";
    Object[] params = new Object[]{"%" + id + "%", "%" + name + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");

    int pageSize = 5;

    int pageTotal = (int) Math.ceil((float) total / pageSize);
    // 当前页码
    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);


    int start = (pageNo - 1) * pageSize;
    sql = "select *  from `devices` " +
            "where `id` like ? and `name` like ? " +
            "order by id asc " +
            "limit ?,?;";
    params = new Object[]{
            "%" + id + "%", "%" + name + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);


    String categorySql = "SELECT id, name FROM device_categories";
    ResultSet categoryRs = DbConnect.select(categorySql, null);
    java.util.HashMap<String, String> categoryMap = new java.util.HashMap<>();
    while (categoryRs.next()) {
        categoryMap.put(categoryRs.getString("id"), categoryRs.getString("name"));
    }
%>
<html>
<head>
    <title>设备列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!--查询区域 S-->
<div class="search-box">
    <form id="searchForm" action="list.jsp" method="get">
        <label for="id">设备编号：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="name">设备名称：</label>
        <input value="<%=name%>" id="name" name="name" type="text">
        <button id="btnSearch" class="primary" type="button">查询</button>
        <button id="btnReset" type="button">重置</button>
    </form>
    <div class="btn-box">
        <button id="btnAdd" class="add" type="button">新增</button>
    </div>
</div>
<!--查询区域 E-->

<!--按钮区域 E-->

<!--表格区域 S-->
<div class="table-box">
    <table>
        <tr>
            <th>ID</th>
            <th>设备编号</th>
            <th>设备类别</th>
            <th>设备名称</th>
            <th>型号</th>
            <th>规格参数</th>
            <th>制造商</th>
            <th>购买日期</th>
            <th>保修期限（月）</th>
            <th>设备状态</th>
            <th>存放位置</th>
            <th>价格</th>
            <th>创建日期</th>
            <th class="option">操作</th>
        </tr>
        <%

            java.util.HashMap<String, String> statusMap = new java.util.HashMap<>();
            statusMap.put("available", "闲置");
            statusMap.put("in_use", "正在使用");
            statusMap.put("maintenance", "维修");
            statusMap.put("scrapped", "废弃");
            while (rs.next()) {

                String statusId = rs.getString("status");
                String statusName = statusMap.getOrDefault(statusId, statusId);
                String categoryId = rs.getString("category_id");
                String categoryName = categoryMap.getOrDefault(categoryId, categoryId);
        %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("device_no")%>
            </td>
            <td><%=categoryName%>
            </td>
            <td><%=rs.getString("name")%>
            </td>
            <td><%=rs.getString("model")%>
            </td>
            <td><%=rs.getString("specification")%>
            </td>
            <td><%=rs.getString("manufacturer")%>
            </td>
            <td><%=rs.getString("purchase_date")%>
            </td>
            <td><%=rs.getString("warranty_period")%>
            </td>
            <td><%=statusName%>
            </td>
            <td><%=rs.getString("location")%>
            </td>
            <td><%=rs.getString("price")%>
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
        String url = "list.jsp?id=" + id + "&name=" + name;
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
        $('#searchForm').submit();
    });

    $('#btnReset').on('click', function () {
        $('#searchForm')[0].reset();
        $('#searchForm').submit();
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
        let name = $(this).closest('tr').find('td:eq(2)').text();
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