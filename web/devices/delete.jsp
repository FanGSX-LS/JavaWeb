<%@ page import="util.DbConnect" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%
    // 设置响应头，防止中文乱码
    response.setCharacterEncoding("UTF-8");

    // 获取要删除的管理员ID
    String id = request.getParameter("id");

    // 检查ID是否有效
    if(id == null || id.isEmpty()) {
        out.print("无效的员工ID");
        return;
    }

    try {
        // 执行删除操作
        String sql = "DELETE FROM `devices` WHERE `id` = ?";
        Object[] params = new Object[]{Integer.parseInt(id)};
        int rowsAffected = DbConnect.update(sql, params);
        if(rowsAffected > 0) {
            out.print("成功删除");
        } else {
            out.print("未找到该员工");
        }
    } catch (Exception e) {
        // 记录错误日志
        e.printStackTrace();
        out.print("删除过程中发生错误：" + e.getMessage());
    }
%>

