<!-- 디자인할 부분 없음 -->
<!-- 관리자 예약관리 (ad_reservation.jsp)에서 '노쇼처리' 누른 경우 -->

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

<!DOCTYPE html>
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

    String ca_name = "";
    String it_serial = "";

    String timeNow = "";

    Connection conn = null;

    PreparedStatement psmSelect = null;
    ResultSet rsSelect = null;

    PreparedStatement psmGet = null;
    ResultSet rsGetDeposit = null;

    PreparedStatement psmSet = null;
    ResultSet rsSetUserBlack = null;

    PreparedStatement psmHiUpdate = null;

    PreparedStatement psmItUpdate = null;

    double depositForReturn = 0.0;
%>
<%
        // 대여 완료(hi_status = "2")된 예약 내역에 대해서만 이 코드를 실행할 수 있음
        System.out.println("ad_returnUpdate.jsp의 실행 시작");

        hi_id = Integer.parseInt(request.getParameter("hi_id"));

        try {
            System.out.print("ad_noshow.jsp가 호출한 ");
            conn = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert conn != null;
            conn.setAutoCommit(false);

            // 1. 해당 내역건의 정보 가져오기
            String sqlDepositForReturn = "SELECT * FROM history WHERE hi_id = ?";
            psmSelect = conn.prepareStatement(sqlDepositForReturn);
            psmSelect.setInt(1, hi_id);
            rsSelect = psmSelect.executeQuery();
            rsSelect.next();

            // 2. 보증금 계산하기 + 처리하기
            ca_name = rsSelect.getString("ca_name");
            us_id = rsSelect.getString("us_id");

            // 2-1) 해당 카테고리의 보증금 구하기
            String sqlGet = "SELECT ca_deposit FROM category WHERE ca_name = ?";
            psmGet = conn.prepareStatement(sqlGet);
            psmGet.setString(1, ca_name);
            rsGetDeposit = psmGet.executeQuery();
            rsGetDeposit.next();
            depositForReturn = Double.parseDouble(rsGetDeposit.getString("ca_deposit"));

            // 2-2) 보증금 계산하기
            depositForReturn /= 2; // 보증금(벌금 제외)의 절반

            // 2-3) 보증금 처리하기 !!윤형!! (이 부분은 블록체인과 연결되어야하는 부분임)
            System.out.println("노쇼처리: 보증금의 절반인 " + depositForReturn + " 돌려주기");


            // 3. history 테이블 갱신: 해당 내역건에 대해서 노쇼 보증금 처리 완료(hi_status = '5')로 상태 변경하기
            String sqlUpdateHiStatus = "UPDATE history SET hi_status = '5' WHERE hi_id = ?";
            psmHiUpdate = conn.prepareStatement(sqlUpdateHiStatus);
            psmHiUpdate.setInt(1, hi_id);
            psmHiUpdate.executeUpdate();
            System.out.println("노쇼처리: history 테이블 hi_status = '5' (보증금처리 완료) 변경");

            // 4. item 테이블 갱신: 해당 내역건에서 대여한 물품에 대해서 예약대기(it_status = '0')로 상태 변경하기
            String sqlUpdateItStatus = "UPDATE item SET it_status = '0' WHERE ca_name = ? AND it_serial = ?";
            it_serial = rsSelect.getString("it_serial");
            psmItUpdate = conn.prepareStatement(sqlUpdateItStatus);
            psmItUpdate.setString(1, ca_name);
            psmItUpdate.setString(2, it_serial);
            psmItUpdate.executeUpdate();
            System.out.println("노쇼처리: item 테이블 it_status = '0' (예약대기) 변경");

            // SQL) COMMIT
            conn.commit();

            // 5. 다시 예약 관리 페이지로
            out.println("<script>alert('노쇼처리가 정상적으로 처리되었습니다.');</script>");
            out.println("<script>location.replace('ad_reservation.jsp');</script>");

            System.out.println("ad_noShow.jsp : 노쇼처리 완료");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e2) {
                    System.out.println("ad_noShow.jsp 예외 발생");
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }

            out.println("<script>alert('노쇼처리 실패'); " +
                    "location.replace('ad_reservation.jsp');</script>");
            System.out.println("ad_noShow.jsp : 노쇼처리 실패");
            e.printStackTrace();

        } finally {
            try {
                if (rsSelect != null)
                    rsSelect.close();
                if (psmSelect != null)
                    psmSelect.close();
                if (rsGetDeposit != null)
                    rsGetDeposit.close();
                if (psmHiUpdate != null)
                    psmHiUpdate.close();
                if (psmItUpdate != null)
                    psmItUpdate.close();
                if (psmGet != null)
                    psmGet.close();
                if (rsSetUserBlack != null)
                    rsSetUserBlack.close();
                if (psmSet != null)
                    psmSet.close();
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
                System.out.println("ad_noShow.jsp 예외 발생");
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        }
    }
%>
</body>
</html>