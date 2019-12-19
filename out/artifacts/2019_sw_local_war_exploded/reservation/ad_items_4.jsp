<!-- 디자인할 부분 없음 -->
<!-- 물품 추가 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>성신코인: 물품관리</title>
</head>
<body>
</body>
</html>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    Connection con = null;
    PreparedStatement psm1 = null;
    PreparedStatement psm2 = null;
    ResultSet rs = null;

    String ca_name = "";
    Integer getItemsCount = 0;
    String it_serial = "";
%>

<%
        System.out.println("ad_items_4.jsp: 실행");

        ServletContext sc = request.getSession().getServletContext();

        ca_name = request.getParameter("category");

        try {
            System.out.print("ad_items_4.jsp가 호출한 ");
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

            String getItemsSql = "SELECT COUNT(*) AS numItems FROM item WHERE ca_name = ? ";
            psm1 = con.prepareStatement(getItemsSql);
            psm1.setString(1, ca_name);
            rs = psm1.executeQuery();
            rs.next();
            getItemsCount = rs.getInt("numItems");
            getItemsCount += 1;
            it_serial = Integer.toString(getItemsCount);

            String insertSql = "INSERT INTO item VALUES (?, ?, ?)";

            psm2 = con.prepareStatement(insertSql);
            psm2.setString(1, ca_name);
            psm2.setString(2, it_serial);
            psm2.setString(3, "0"); // 예약가능상태(0)
            psm2.executeUpdate();

            // SQL) COMMIT
            con.commit();

            out.println("<script>alert('추가가 완료되었습니다.');</script>");

        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    System.out.println("ad_items_4.jsp 예외 발생");
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            System.out.println("ad_items_4.jsp 예외 발생");
            e.printStackTrace();
            System.out.println(e.getMessage());
        } finally {
            try {
                if (psm1 != null) psm1.close();
                if (psm2 != null) psm2.close();
                if (con != null) con.close();
                if (rs != null) rs.close();
            } catch (Exception e) {
                System.out.println("ad_items_4.jsp 예외 발생");
                System.out.println(e.getMessage());
            }
            String rstMsg = "<script>location.replace('ad_items_2.jsp?ca_name=";
            rstMsg += ca_name;
            rstMsg += "');</script>";
            out.println(rstMsg);
        }
    }
%>
