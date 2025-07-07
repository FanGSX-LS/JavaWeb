<%@ page import="util.DbConnect" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%

    response.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");

    // 检查ID是否有效
    if(id == null || id.isEmpty()) {
        out.print("无效的管理员ID");
        return;
    }

    try {

        String sql = "DELETE FROM `admins` WHERE `id` = ?";//数据库的表必须有ID字段
        Object[] params = new Object[]{Integer.parseInt(id)};
        int rowsAffected = DbConnect.update(sql, params);
        if(rowsAffected > 0) {
            out.print("成功删除");
        } else {
            out.print("未找到该管理员");
        }
    } catch (Exception e) {

        e.printStackTrace();
        out.print("删除过程中发生错误：" + e.getMessage());
    }
%>

