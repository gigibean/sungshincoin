<!-- 디자인할 부분 없음 -->
<!-- 예약 취소하기 -->

<%@ page import="model.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>성신코인: 예약 취소</title>
</head>
<body>

<%!
    String us_id = "";
    String us_name = "";
%>

<%
    us_id = (String) session.getAttribute("us_id");
    us_name = (String) session.getAttribute("us_name");

    if (us_id == null || !DBUtil.assureStudent(us_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    String hi_id;
    String ca_name;
    String it_serial;

    Connection conn = null;

    PreparedStatement psm = null;
    ResultSet rs = null;

    PreparedStatement psmGet = null;
    ResultSet rsGetDeposit = null;

    double depositForReturn = 0.0;
%>

<%
        System.out.println("st_cancelReservation.jsp 실행");

        hi_id = request.getParameter("hi_id");

        try {
            System.out.print("st_cancelReservation이 호출한 ");
            conn = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert conn != null;
            conn.setAutoCommit(false);

            // 1. 해당 내역건의 정보 가져오기
            String sqlGetHi = "SELECT ca_name, it_serial FROM history WHERE hi_id = ?";
            psm = conn.prepareStatement(sqlGetHi);
            psm.setString(1, hi_id);
            rs = psm.executeQuery();
            rs.next();

            ca_name = rs.getString("ca_name");
            it_serial = rs.getString("it_serial"); // 4번을 위해서 구해야 함

            // 2. 보증금 계산하기 + 처리하기
            // 2-1) 해당카테고리의 보증금 구하기
            String sqlGet = "SELECT ca_deposit FROM category WHERE ca_name = ?";
            psmGet = conn.prepareStatement(sqlGet);
            psmGet.setString(1, ca_name);
            rsGetDeposit = psmGet.executeQuery();
            rsGetDeposit.next();
            depositForReturn = Double.parseDouble(rsGetDeposit.getString("ca_deposit"));

            // 2-2) 보증금 처리하기 !!윤형!! (이 부분은 블록체인과 연결되어야하는 부분임) 보증금은 돌려주고, 받은 us_black_count(페널티)는 돌려주면 안 됨
            System.out.println("예약취소 처리: 보증금 전체인 " + depositForReturn + " 돌려주기");


            // 3. history 테이블 갱신: 해당 내역건에 대해서 예약취소(hi_status = '3')로 상태 변경하기
            String sqlUpdateHi = "UPDATE history SET hi_status = '3' WHERE hi_id = ?";
            psm = conn.prepareStatement(sqlUpdateHi);
            psm.setString(1, hi_id);
            psm.executeUpdate();

            // 4. item 테이블 갱신: 해당 내역건에서 대여한 물품에 대해서 예약대기(it_status = '0')로 상태 변경하기
            String sqlUpdateIt = "UPDATE item SET it_status = '0' WHERE ca_name = ? AND it_serial = ?";
            psm = conn.prepareStatement(sqlUpdateIt);
            psm.setString(1, ca_name);
            psm.setString(2, it_serial);
            psm.executeUpdate();

            // SQL) COMMIT
            conn.commit();

            // 5. 다시 예약 관리 페이지로
            out.println("<script>alert('예약이 최소되었습니다.');</script>");
            out.println("<script>location.replace('../mypage/manage_reservation.jsp');</script>");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            System.out.println("st_cancelReservation.jsp 예외 발생!" + e.toString());
            out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
            out.println("<script>history.go(-1);</script>");

        } finally {
            try {
                if (psmGet != null)
                    psmGet.close();
                if (rsGetDeposit != null)
                    rsGetDeposit.close();
                if (rs != null)
                    rs.close();
                if (psm != null)
                    psm.close();
                if (conn != null)
                    conn.close();

            } catch (SQLException e) {
                System.out.println("st_cancelReservation.jsp 예외 발생!" + e.toString());
                out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
                out.println("<script>history.go(-1);</script>");
            }
        }
    }
%>

<%

%>
</body>
</html>
