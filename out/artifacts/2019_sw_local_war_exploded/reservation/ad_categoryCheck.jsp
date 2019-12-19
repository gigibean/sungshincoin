<!-- 카테고리명 중복 확인창 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>


<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBConnection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>성신코인: 물품관리</title>
    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <script>
        function categoryCheckedClose(ca_name) {
            opener.document.addingCategory.ca_name.value = ca_name;
            window.opener.getNameTrueReturn();
            window.close();
            // opener.document.addingCategory.ca_name.focus();
        }

        function categoryUnCheckedClose(ca_name) {
            opener.document.addingCategory.ca_name.value = ca_name;
            window.opener.getNameFalseReturn();
            window.close();
            opener.document.addingCategory.ca_name.focus();
        }
    </script>
</head>
<body>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<form method="post">
    <%!
        String ca_name;
        PreparedStatement pstmt;
        ResultSet rs;
        Connection con;
    %>
    <%
        ca_name = request.getParameter("ca_name");

        try {
            con = DBConnection.getCon(); // SQL문 한 개만 있는 파일임

            pstmt = con.prepareStatement("SELECT * FROM category WHERE ca_name = ?");
            pstmt.setString(1, ca_name);
            rs = pstmt.executeQuery();

            if (rs.next() || (ca_name == null)) {
    %>
    <p>카테고리명 : <%=ca_name%>
    </p>
    <p>이미 사용 중인 카테고리 이름 입니다.</p>
    <input type="button" value="닫기" onclick="categoryUnCheckedClose('<%=ca_name%>')"/>
    <%
    } else {
    %>
    <p>카테고리명 : <%=ca_name%>
    </p>
    <p>추가 가능한 카테고리명입니다.</p>
    <input type="button" value="선택" onclick="categoryCheckedClose('<%=ca_name%>')"/>
    <input type="button" value="취소" onclick="categoryUnCheckedClose('<%=ca_name%>')"/>
    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null)
                        rs.close();
                    if (pstmt != null)
                        pstmt.close();
                    if (con != null)
                        con.close();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                }
            }
        }
    %>
</form>
</body>
</html>