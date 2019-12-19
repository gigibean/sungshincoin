<!-- 임시 비밀번호 전송 (이메일) -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="sendMail.SendPw" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Random" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>수룡전</title>
</head>
<body>

<%!
    Connection con;

    PreparedStatement psmGetEmail;
    ResultSet rsGetEmail;

    PreparedStatement psmSetPw;

    String us_id;
    String us_email;
    String temporary;
%>

<%
    System.out.println("find_pw_3.jsp 실행");

    try {
        us_id = request.getParameter("us_id");

        System.out.print("find_pw_3.jsp가 호출한 ");
        con = DBConnection.getCon();

        // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
        assert con != null;
        con.setAutoCommit(false);

        // 1. 사용자의 이메일 주소(us_email)가져오기
        String sqlGetEmail = "SELECT us_email FROM user WHERE us_id = ?";
        psmGetEmail = con.prepareStatement(sqlGetEmail);
        psmGetEmail.setString(1, us_id);
        rsGetEmail = psmGetEmail.executeQuery();


        if (!rsGetEmail.next()) {
            out.println("<script>alert('회원정보에 문제가 있습니다. 관리자에게 문의하세요.');</script>");

        } else {
            us_email = rsGetEmail.getString("us_email");
            System.out.println("이메일주소: " + us_email);

            // 2. 임시 비밀번호 생성하기
            StringBuffer buffer = new StringBuffer();
            Random random = new Random();

            String chars[] = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9".split(",");
            for (int i = 0; i < 8; i ++) {
                buffer.append(chars[random.nextInt(chars.length)]);
            }

            temporary = buffer.toString();
            System.out.println("임시 비번 : " + temporary);

            // temporary = SendEmail.tempPw();

            // 3. 임시 비밀번호로 user테이블의 us_pw 갱신하기
            String sqlSetPw = "UPDATE user SET us_pw = ? WHERE us_id = ?";
            psmSetPw = con.prepareStatement(sqlSetPw);
            psmSetPw.setString(1, temporary);
            psmSetPw.setString(2, us_id);
            psmSetPw.executeUpdate();

            // 4. 임시 비밀번호를 사용자의 이메일로 전송하기
            ServletContext sc = request.getSession().getServletContext();
            if (SendPw.gMailSend(sc, us_id, us_email, temporary)) {
                out.println("<script>alert('이메일로 임시 비밀번호를 전송하였습니다.');</script>");
            } else {
                out.println("<script>alert('임시 비밀번호 전송에 실패했습니다. 관리자에게 문의하세요.');</script>");
                con.rollback(); // 비밀번호 갱신 취소
            }
       }

        // SQL) COMMIT
        con.commit();

        // 로그인 페이지로 이동
        out.println("<script>location.replace('../login.html');</script>");

    } catch (SQLException e) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
                System.out.println(e1.getMessage());
            }
        }
        e.printStackTrace();
        System.out.println(e.getMessage());
    } finally {
        try {
            if (con != null)
                con.close();
        } catch (SQLException e2) {
            e2.printStackTrace();
            System.out.println(e2.getMessage());
        }
    }
%>
</body>
</html>
