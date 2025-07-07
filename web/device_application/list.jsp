<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null) id = "";
    String applicantId = request.getParameter("applicant_id");
    if (applicantId == null) applicantId = "";
    String deviceId = request.getParameter("device_id");
    if (deviceId == null) deviceId = "";
    String status = request.getParameter("status");
    if (status == null) status = "";

    String sql = "SELECT COUNT(*) as total FROM `device_applications` da " +
            "JOIN `employees` e ON da.`applicant_id` = e.`id` " +
            "JOIN `devices` d ON da.`device_id` = d.`id` " +
            "LEFT JOIN `admins` a ON da.`approver_id` = a.`id` " +
            "WHERE da.`id` LIKE ? AND e.`username` LIKE ? AND d.`name` LIKE ? AND da.`status` LIKE ?;";
    Object[] params = new Object[]{"%" + id + "%", "%" + applicantId + "%", "%" + deviceId + "%", "%" + status + "%"};
    ResultSet rs = DbConnect.select(sql, params);
    rs.next();
    int total = rs.getInt("total");
    int pageSize = 5;
    int pageTotal = (int) Math.ceil((float) total / pageSize);
    String pageNoStr = request.getParameter("pageNo");
    pageNoStr = pageNoStr == null ? "1" : pageNoStr;
    int pageNo = Integer.parseInt(pageNoStr);
    int start = (pageNo - 1) * pageSize;
    sql = "SELECT da.`id`, e.`username` AS applicant_name, d.`name` AS device_name, da.`reason`, da.`start_date`, da.`end_date`, da.`status`, a.`username` AS approver_name, da.`approval_time`, da.`rejection_reason` " +
            "FROM `device_applications` da " +
            "JOIN `employees` e ON da.`applicant_id` = e.`id` " +
            "JOIN `devices` d ON da.`device_id` = d.`id` " +
            "LEFT JOIN `admins` a ON da.`approver_id` = a.`id` " +
            "WHERE da.`id` LIKE ? AND e.`username` LIKE ? AND d.`name` LIKE ? AND da.`status` LIKE ? " +
            "ORDER BY da.`id` ASC " +
            "LIMIT ?,?;";
    params = new Object[]{
            "%" + id + "%", "%" + applicantId + "%", "%" + deviceId + "%", "%" + status + "%",
            start, pageSize
    };
    rs = DbConnect.select(sql, params);
%>
<html>
<head>
    <title>设备申请管理列表</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/list.css">
</head>
<body>
<!--查询区域 S-->
<div class="search-box">
    <form id="searchForm">
        <label for="id">申请 ID：</label>
        <input value="<%=id%>" id="id" name="id" type="text">
        <label for="applicant_id">申请人姓名：</label>
        <input value="<%=applicantId%>" id="applicant_id" name="applicant_id" type="text">
        <label for="device_id">设备名称：</label>
        <input value="<%=deviceId%>" id="device_id" name="device_id" type="text">
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
            <th>申请 ID</th>
            <th>申请人姓名</th>
            <th>申请设备名称</th>
            <th>申请原因</th>
            <th>开始日期</th>
            <th>结束日期</th>
            <th>申请状态</th>
            <th>审批人姓名</th>
            <th>审批时间</th>
            <th>拒绝原因</th>
            <th class="option">操作</th>
        </tr>
        <%
            java.util.HashMap<String, String> statusMap = new java.util.HashMap<>();
            statusMap.put("pending", "待审批");
            statusMap.put("approved", "已批准");
            statusMap.put("rejected", "已拒绝");
            statusMap.put("completed", "已完成");
            while (rs.next()) {
                // 获取状态 ID
                String statusId = rs.getString("status");
                String statusName = statusMap.getOrDefault(statusId, statusId);
        %>
        <tr>
            <td><%=rs.getString("id")%>
            </td>
            <td><%=rs.getString("applicant_name")%>
            </td>
            <td><%=rs.getString("device_name")%>
            </td>
            <td><%=rs.getString("reason")%>
            </td>
            <td><%=rs.getString("start_date")%>
            </td>
            <td><%=rs.getString("end_date")%>
            </td>
            <td><%=statusName%>
            </td>
            <td><%=rs.getString("approver_name")%>
            </td>
            <td><%=rs.getString("approval_time")%>
            </td>
            <td><%=rs.getString("rejection_reason")%>
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
        String url = "list.jsp?id=" + id + "&applicant_id=" + applicantId + "&device_id=" + deviceId + "&status=" + status;
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