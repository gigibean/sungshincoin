<!-- 디자인할 부분 없음 -->
<!-- '대여하기'할 때 최초 1회 인증 안 한 회원들 -> 전화번호 수정할 경우 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>성신코인: 예약관리</title>
</head>
<body>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");
    } else {
%>

<%!
    Integer hi_id = 0;
    String us_id = "";
    String us_tel_new = "";

    Connection conn = null;
    PreparedStatement psm = null;
%>

<%
        System.out.println("ad_telChange.jsp 실행");

        us_id = request.getParameter("us_id");
        us_tel_new = request.getParameter("us_tel_new");
        hi_id = Integer.parseInt(request.getParameter("hi_id"));

        try {
            conn = DBConnection.getCon();

            String sql = "UPDATE user SET us_tel = ? WHERE us_id = ? "; // SQL문 한 개만 존재하는 파일
            psm = conn.prepareStatement(sql);
            psm.setString(1, us_tel_new);
            psm.setString(2, us_id);
            psm.executeUpdate();
            System.out.println("전화번호 변경 수행 완료");

            out.println("<script>alert('전화번호가 변경되었습니다.');</script>");
            String rstMsg = "<script>location.replace('ad_telCheck.jsp?us_id=";
            rstMsg += us_id;
            rstMsg += "&hi_id=";
            rstMsg += hi_id;
            rstMsg += "');</script>";
            out.print(rstMsg);

        } catch (Exception e) {
            out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
            System.out.println("전화번호 변경 실패 1");
            e.printStackTrace();
            System.out.println(e.getMessage());
        } finally {
            try {
                if (psm != null)
                    psm.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e1) {
                System.out.println("전화번호 변경 실패 2");
                e1.printStackTrace();
                System.out.println(e1.getMessage());
            }
        }
    }
%>
</body>
</html>