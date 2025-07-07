<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String deviceId = request.getParameter("device_id");
    if (deviceId == null) deviceId = "";
    String recipient = request.getParameter("recipient");
    if (recipient == null) recipient = "";
    String sql = "SELECT COUNT(*) AS total FROM `stock_outs` " +
            "WHERE `id` LIKE ? AND `device_id` LIKE ? AND `recipient` LIKE ?;";
    Object[] params = new Object[]{"%" + id + "%", "%" + deviceId + "%", "%" + recipient + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");
    int pageSize = 5;
    int pageTotal = (int) Math.ceil((float) total / pageSize);
    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);

    int start = (pageNo - 1) * pageSize;
    sql = "SELECT so.id, d.name AS device_name, so.quantity, so.recipient, so.purpose, a.username AS operator_name, so.operation_time, so.remark " +
            "FROM `stock_outs` so " +
            "JOIN `devices` d ON so.device_id = d.id " +
            "JOIN `admins` a ON so.operator_id = a.id " +
            "WHERE so.id LIKE ? AND so.device_id LIKE ? AND so.recipient LIKE ? " +
            "ORDER BY so.id ASC " +
            "LIMIT ?,?;";
    params = new Object[]{
            "%" + id + "%", "%" + deviceId + "%", "%" + recipient + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>出库记录列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!-- 查询区域 S -->
<div class="search-box">
    <form id="searchForm">
        <label for="id">出库记录 ID：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="device_id">设备 ID：</label>
        <input value="<%=deviceId%>" id="device_id" name="device_id" type="text">
        <label for="recipient">领取人：</label>
        <input value="<%=recipient%>" id="recipient" name="recipient" type="text">
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
            <th>出库记录 ID</th>
            <th>设备名称</th>
            <th>出库数量</th>
            <th>领取人</th>
            <th>用途</th>
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
            <td><%=rs.getString("recipient") %>
            </td>
            <td><%=rs.getString("purpose") %>
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
        String url = "list.jsp?id=" + id + "&device_id=" + deviceId + "&recipient=" + recipient;
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