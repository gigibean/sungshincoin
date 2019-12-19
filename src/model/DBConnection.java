package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection { // 데이터베이스 연결
    public static Connection getCon() throws SQLException{
        Connection con = null;
        String server = "localhost:3306"; // MySQL 서버 주소 (MySQL은 보통 3306포트를 이용함)
        String database = "mydb"; // MySQL DATABASE 이름
        String user_name ="root"; // MySQL 서버 아이디
        String password ="1234"; // MySQL 서버 비밀번호

        // 1. JDBC 드라이버 로딩
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println(" <JDBC 오류> Driver load 오류: " + e.getMessage());
            System.out.println(e.getMessage());
            e.printStackTrace();
            return null;
        }

        // 2. 연결
        try{
//            String url = "jdbc:mysql://localhost:3306/mydb"; //
            String url = "jdbc:mysql://" + server + "/" + database ;
            con=DriverManager.getConnection(url+"?useSSL=false", user_name, password);
            System.out.println("DBConnection.getCon() : Java와 MySQL 정상적으로 연결됨");
            return con;
        } catch(SQLException e){
            System.err.println(" <JDBC 오류> con 오류: " + e.getMessage());
            System.out.println(e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}