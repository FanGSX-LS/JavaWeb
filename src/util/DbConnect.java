package util;

import java.sql.*;

/**
 * 数据库操作类：封装对数据库表中的数据进行增、删、改、查
 */
public class DbConnect {
    /**
     * 数据库的连接串
     */
    private static final String url = "jdbc:mysql://127.0.0.1:3306/guanli?characterEncoding=UTF-8&useUnicode=true&useSSL=false&tinyInt1isBit=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai";
    /**
     * 数据库账号
     */
    private static final String user = "root";
    /**
     * 数据库密码
     */
    private static final String psw = "root";

    /**
     * 登录数据库，返回数据库的连接对象
     *
     * @return
     * @throws ClassNotFoundException
     * @throws SQLException
     */
    private static Connection getConnect() throws ClassNotFoundException, SQLException {
        //引用数据库驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        //登录数据库
        return DriverManager.getConnection(url, user, psw);
    }

    /**
     * 初始化sql语句（预处理），替换sql语句中的?
     *
     * @param sql    要执行的sql语句
     * @param params 泛型数组：对应问号的值
     * @return 预处理的结果
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    private static PreparedStatement initParams(String sql, Object[] params) throws SQLException, ClassNotFoundException {
        PreparedStatement ps = getConnect().prepareStatement(sql);
        if (params == null || params.length == 0) return ps;
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
        return ps;
    }

    /**
     * 添加
     *
     * @param sql    执行添加的sql语句，可能带?
     * @param params 泛型数组，长度与sql语句中的?数量一致
     * @return 返回成功执行的行数
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public static int insert(String sql, Object[] params) throws SQLException, ClassNotFoundException {
        return initParams(sql, params).executeUpdate();//执行
    }

    /**
     * 修改
     *
     * @param sql    执行修改的sql语句，可能带?
     * @param params 泛型数组，长度与sql语句中的?数量一致
     * @return 返回成功执行的行数
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public static int update(String sql, Object[] params) throws SQLException, ClassNotFoundException {
        return initParams(sql, params).executeUpdate();//执行
    }

    /**
     * 删除
     *
     * @param sql    执行删除的sql语句，可能带?
     * @param params 泛型数组，长度与sql语句中的?数量一致
     * @return 返回成功执行的行数
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public static int delete(String sql, Object[] params) throws SQLException, ClassNotFoundException {
        return initParams(sql, params).executeUpdate();//执行
    }

    /**
     * 查询
     *
     * @param sql    执行查询的sql语句，可能带?
     * @param params 泛型数组，长度与sql语句中的?数量一致
     * @return 返回成功执行后获取的数据集
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public static ResultSet select(String sql, Object[] params) throws SQLException, ClassNotFoundException {
        return initParams(sql, params).executeQuery();
    }
}
