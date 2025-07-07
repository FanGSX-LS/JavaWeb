<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String deviceId = request.getParameter("device_id");
    if (deviceId == null) deviceId = "";
    String supplier = request.getParameter("supplier");
    if (supplier == null) supplier = "";

    String sql = "SELECT COUNT(*) AS total FROM `stock_ins` " +
            "WHERE `id` LIKE ? AND `device_id` LIKE ? AND `supplier` LIKE ?;";
    Object[] params = new Object[]{"%" + id + "%", "%" + deviceId + "%", "%" + supplier + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");
    int pageSize = 5;
    int pageTotal = (int) Math.ceil((float) total / pageSize);
    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);

    int start = (pageNo - 1) * pageSize;
    sql = "SELECT si.id, d.name AS device_name, si.quantity, si.supplier, si.price, si.total_price, si.receipt_no, a.username AS operator_name, si.operation_time, si.remark " +
            "FROM `stock_ins` si " +
            "JOIN `devices` d ON si.device_id = d.id " +
            "JOIN `admins` a ON si.operator_id = a.id " +
            "WHERE si.id LIKE ? AND si.device_id LIKE ? AND si.supplier LIKE ? " +
            "ORDER BY si.id ASC " +
            "LIMIT ?,?;";
    params = new Object[]{
            "%" + id + "%", "%" + deviceId + "%", "%" + supplier + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>入库记录列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!-- 查询区域 S -->
<div class="search-box">
    <form id="searchForm">
        <label for="id">入库记录 ID：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="device_id">设备 ID：</label>
        <input value="<%=deviceId%>" id="device_id" name="device_id" type="text">
        <label for="supplier">供应商：</label>
        <input value="<%=supplier%>" id="supplier" name="supplier" type="text">
        <button id="btnSearch" class="primary" type="button">查询</button>
        <button id="btnReset" type="button">重置</button>

    </form>
    <div class="btn-box">
        <button id="btnAdd" class="add" type="button">新增</button>
    </div>
</div>
<!-- 查询区域 E -->

<!-- 按钮区域 S -->

<!-- 按钮区域 E -->

<!-- 表格区域 S -->
<div class="table-box">
    <table>
        <tr>
            <th>入库记录 ID</th>
            <th>设备名称</th>
            <th>入库数量</th>
            <th>供应商</th>
            <th>单价</th>
            <th>总价</th>
            <th>收据编号</th>
            <th>操作人</th>
            <th>操作时间</th>
            <th>备注</th>
            <th class="option">操作</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%=rs.getInt("id") %>
            </td>
            <td><%=rs.getString("device_name") %>
            </td>
            <td><%=rs.getInt("quantity") %>
            </td>
            <td><%=rs.getString("supplier") %>
            </td>
            <td><%=rs.getDouble("price") %>
            </td>
            <td><%=rs.getDouble("total_price") %>
            </td>
            <td><%=rs.getString("receipt_no") %>
            </td>
            <td><%=rs.getString("operator_name") %>
            </td>
            <td><%=rs.getTimestamp("operation_time") %>
            </td>
            <td><%=rs.getString("remark") %>
            </td>
            <td>
                <button data-id="<%=rs.getString("id")%>" name="btnEdit" class="primary" type="button">编辑</button>
                <button data-id="<%=rs.getString("id")%>" name="btnDelete" class="danger" type="button">删除</button>
            </td>
        </tr>
        <% } %>
    </table>
</div>
<!-- 表格区域 E -->

<!-- 页码区域 S -->
<div class="pager">
    <%
        String url = "list.jsp?id=" + id + "&device_id=" + deviceId + "&supplier=" + supplier;
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
<!-- 页码区域 E -->

<script src="../js/jquery-3.5.1.min.js"></script>
<script src="../js/common.js"></script>
<script>
    $('#btnSearch').on('click', function () {
        window.location.href = 'list.jsp?' + $('#searchForm').serialize();
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