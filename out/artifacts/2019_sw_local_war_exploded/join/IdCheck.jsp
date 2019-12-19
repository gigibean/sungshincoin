<!-- 아이디 중복 확인창 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>성신코인: 아이디 중복체크</title>
    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <script>
        function IdCheckedClose(us_id) {
            opener.document.joinformUser.us_id.value = us_id;
            window.opener.getTrueReturn();
            window.close();
            opener.document.joinformUser.us_pw.focus();
        }
        function IdUnCheckedClose(us_id) {
            opener.document.joinformUser.us_id.value = us_id;
            window.opener.getFalseReturn();
            window.close();
            opener.document.joinformUser.us_pw.focus();
        }
    </script>
</head>

<body>

<form method="post">
    <%!
        String us_id;
        PreparedStatement pstmt;
        ResultSet rs;
        Connection con;
    %>
    <%
        us_id = request.getParameter("us_id");

        try {
            System.out.print("IdCheck.jsp가 호출한 ");
            con = DBConnection.getCon();
            pstmt = con.prepareStatement("SELECT * FROM user WHERE us_id = ?"); // SQL문 한 개만 있는 파일임
            pstmt.setString(1, us_id);
            rs = pstmt.executeQuery();

            if (rs.next() || (us_id == null)) {
    %>
    <p>아이디 : <%=us_id%> </p>
    <p>이미 사용 중인 아이디 입니다.</p>
    <input type="button" value="닫기" onclick="IdUnCheckedClose('<%=us_id%>')"></input>
    <%
            } else {
    %>
    <p>아이디 : <%=us_id%> </p>
    <p>사용 가능한 아이디입니다.</p>
    <input type="button" value="현재 아이디 선택 " onclick="IdCheckedClose('<%=us_id%>')"></input>
    <%
            }
        } catch ( SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if(pstmt != null)
                    pstmt.close();
                if(con != null)
                    con.close();
            } catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
    %>
</form>
</body>
</html>