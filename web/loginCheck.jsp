<%@ page import="util.Result" %>
<%@ page import="util.DbConnect" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //1.java代码区域
    //指定账号：admin   密码：123456
    //2.接收用户输入的账号、密码信息
    //request: 用户的请求
    //response：响应（反馈给用户）
    //Parameter: 参数（表单中的信息）
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    //根据用户输入的账号，在数据库的用户表进行查找
    String sql = "select * from `admins` where `username`=?;";
    Object[] params = new Object[]{username};
    ResultSet rs = DbConnect.select(sql, params);
    if (!rs.next()) {
        //无数据
        out.println(Result.error("账号不存在！"));
        //return;//停止往下执行，返回数据
    }
    //只需要判断密码是否正确
    else if (password.equals(rs.getString("password"))) {
        //使用数据集构建json数据：Map（数据集合）
        //获取账号、姓名，并且保存起来，供其他页面使用
        HttpSession session1 = request.getSession();
        session1.setAttribute("username", username);
        session1.setAttribute("realname", rs.getString("realname"));

        out.println(Result.success("登录成功", "index.jsp"));
    } else {
        out.println(Result.error("登录失败"));
    }
%>