<!-- 디자인할 부분 없음 -->
<!-- 전화번호 최증 인증 완료 처리 -->

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
    String login_tel = (String) session.getAttribute("us_tel");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");
    } else {
%>

<%!
    Integer hi_id = 0;
    String us_id = "";

    Connection conn;
    PreparedStatement psm = null;
%>
<%
        System.out.println("ad_telCheck_2.jsp 실행");

        us_id = request.getParameter("us_id");
        hi_id = Integer.parseInt(request.getParameter("hi_id"));

        try {
            conn = DBConnection.getCon(); // SQL문 한 개만 존재하는 파일

            String sql = "UPDATE user SET us_level = '6' WHERE us_id = ? ";
            psm = conn.prepareStatement(sql);
            psm.setString(1, us_id);
            psm.executeUpdate();
            System.out.println("전화번호 최초 1회 인증 완료");

            out.println("<script>alert('전화번호 인증이 완료되었습니다.');</script>");

            // 전화번호 최초 인증 후에 ad_historyUpdate.jsp로 돌아가서 대여하기를 진행해야 함
            String rstMsg = "<script>location.replace('ad_historyUpdate.jsp?hi_id=";
            rstMsg += hi_id;
            rstMsg += "');</script>";
            out.print(rstMsg);

        } catch (Exception e) {
            out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
            System.out.println("ad_telCheck_2.jsp 예외 발생");
            e.printStackTrace();
            System.out.println(e.getMessage());
        } finally {
            try {
                if (psm != null)
                    psm.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e1) {
                out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
                System.out.println("ad_telCheck_2.jsp 예외 발생");
                e1.printStackTrace();
                System.out.println(e1.getMessage());
            }
        }
    }
%>
</body>
</html>