<!-- 디자인할 부분 없음 -->
<!-- 관리자 예약관리 (ad_reservation.jsp)에서 '대여하기' 누른 경우 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.DBUtil" %>
<%@ page import="java.sql.SQLException" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
    String us_level = "";

    String ca_name = "";
    String it_serial = "";

    Connection conn = null;

    PreparedStatement psmCheck = null;
    ResultSet rsCheck = null;

    PreparedStatement psmSetHi = null;

    PreparedStatement psmGetHi = null;
    ResultSet rsGetHi = null;

    PreparedStatement psmSetIt = null;
%>

<%
        System.out.println("ad_historyUpdate.jsp 실행");

        hi_id = Integer.parseInt(request.getParameter("hi_id"));
        System.out.println("예약번호: " + hi_id);

        try {
            System.out.print("ad_historyUpdate.jsp에서 호출한 ");
            conn = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert conn != null;
            conn.setAutoCommit(false);

            String sqlGetHi = "SELECT * FROM history WHERE hi_id = ?";
            psmGetHi = conn.prepareStatement(sqlGetHi);
            psmGetHi.setInt(1, hi_id);
            rsGetHi = psmGetHi.executeQuery();
            rsGetHi.next();
            us_id = rsGetHi.getString("us_id");
            ca_name = rsGetHi.getString("ca_name");
            it_serial =rsGetHi.getString("it_serial");

            String sqlCheck = "SELECT us_level FROM user WHERE us_id = ?";
            psmCheck = conn.prepareStatement(sqlCheck);
            psmCheck.setString(1, us_id);
            rsCheck = psmCheck.executeQuery();
            rsCheck.next();
            us_level = rsCheck.getString("us_level");

            if (us_level.equals("1")) { // 학생회원, 최초1회 본인인증 X
                // 최초1회 본인인증 실시해야 함
                System.out.println("최초 1회 전화번호 본인인증 실시해야 함");
                String resultMsg = "";
                resultMsg += "<script>location.replace('ad_telCheck.jsp?us_id=";
                resultMsg += us_id;
                resultMsg += "&hi_id=";
                resultMsg += hi_id;
                resultMsg += "', '전화번호 최초 1회 인증', 'width=500, height=300');</script>";
                out.println(resultMsg);

            } else { // 학생회원, 최초1회 본인인증 O (us_level이 6인 회원들)

                // 1. history 테이블의 hi_status 갱신
                String sqlSetHi = "UPDATE history SET hi_status = '1' WHERE hi_id = ?"; // 대여중

                psmSetHi = conn.prepareStatement(sqlSetHi);
                psmSetHi.setInt(1, hi_id);
                psmSetHi.executeUpdate();

                // 2. item 테이블의 it_status 갱신
                String sqlSetIt = "UPDATE item SET it_status = '2' WHERE ca_name = ? AND it_serial = ? "; // 대여중
                psmSetIt = conn.prepareStatement(sqlSetIt);
                psmSetIt.setString(1, ca_name);
                psmSetIt.setString(2, it_serial);
                psmSetIt.executeUpdate();

                out.println("<script>alert('대여하기 완료');</script>");
                System.out.println("ad_historyUpdate.jsp : " + ca_name + ", " + it_serial +" 대여하기 완료");
            }

            // SQL) COMMIT
            conn.commit();

            out.println("<script>location.replace('ad_reservation.jsp');</script>");

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.'); " +
                    "location.replace('ad_reservation.jsp');</script>");
            System.out.println("aad_historyUpdate.jsp : 대여하기 실패");
            e.printStackTrace();
        } finally {
            try {
                if (psmCheck != null)
                    psmCheck.close();
                if (rsCheck != null)
                    rsCheck.close();
                if (psmSetHi != null)
                    psmSetHi.close();
                if (psmGetHi != null)
                    psmGetHi.close();
                if (rsGetHi != null)
                    rsGetHi.close();
                if (psmSetIt != null)
                    psmSetIt.close();
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        }
    }
%>
</body>
</html>