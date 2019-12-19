<!-- 디자인할 부분 없음 -->
<!-- 관리자 예약관리 (ad_reservation.jsp)에서 '반납하기' 누른 경우 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.DailyUpdate" %>
<%@ page import="model.DBUtil" %>

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

    int hi_delay = 0;
    int hi_isFriday = 0;
    int totalDelay = 0;

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
            conn = DBConnection.getCon();

            // 1. 해당 내역건의 정보 가져오기
            String sqlDepositForReturn = "SELECT * FROM history WHERE hi_id = ?";
            psmSelect = conn.prepareStatement(sqlDepositForReturn);
            psmSelect.setInt(1, hi_id);
            rsSelect = psmSelect.executeQuery();
            rsSelect.next();

            // 2. 연체일을 정확히 계산하기
            hi_delay = rsSelect.getInt("hi_delay"); // 예약일~오늘까지 며칠째인지
            hi_isFriday = rsSelect.getInt("hi_isFriday"); // 예약일이 금요일인 경우: -3, 월~목인 경우: -1
            totalDelay = hi_isFriday + hi_delay;

            // 3. 보증금 계산하기 + 처리하기
            ca_name = rsSelect.getString("ca_name");
            us_id = rsSelect.getString("us_id");

            // 3-1) 해당 카테고리의 보증금 구하기
            String sqlGet = "SELECT ca_deposit FROM category WHERE ca_name = ?";
            psmGet = conn.prepareStatement(sqlGet);
            psmGet.setString(1, ca_name);
            rsGetDeposit = psmGet.executeQuery();
            rsGetDeposit.next();

            // 3-2) 연체일에 따라 보증금 계산하기 + user 테이블 갱신: 벌금이 있는 경우 us_black_count를 갱신하기
            if (totalDelay == 0) { // 대여 다음 날인 경우
                depositForReturn = Double.parseDouble(rsGetDeposit.getString("ca_deposit")); // 받은 보증금 그대로 돌려줌
                System.out.println("받은 보증금 그대로 돌려주기");
            } else { // 연체된 경우
                depositForReturn = Double.parseDouble(rsGetDeposit.getString("ca_deposit")) - totalDelay; // 연체일 수 만큼 1씩 차감
                if (depositForReturn > 0) {
                    // depositForReturn 그대로
                } else { // 해당하는 user의 us_black_count를 증가시켜야 함 (다음 예약 시 벌금 징수)
                    String sqlSet = "UPDATE user SET us_black_count = (us_black_count - ?) WHERE us_id = ?";
                    psmSet = conn.prepareStatement(sqlSet);
                    psmSet.setDouble(1, depositForReturn);
                    psmSet.setString(2, us_id);
                    psmSet.executeUpdate();
                    depositForReturn = 0.0; // 돌려 줄 보증금은 없음
                }
            }

            // 3-3) 보증금 처리하기 !!윤형!! (이 부분은 블록체인과 연결되어야하는 부분임)
            System.out.println("반납처리: 보증금 " + depositForReturn + " 돌려주기");

            // 4. history 테이블 갱신: 해당 내역건에 대해서 반납완료(hi_status = '2')로 상태 변경하기, 해당 내역건에 대해서 반납시간 갱신하기
            String sqlUpdateHiStatus = "UPDATE history SET hi_status = '2', hi_return_time = ? WHERE hi_id = ?";
            psmHiUpdate = conn.prepareStatement(sqlUpdateHiStatus);
            timeNow = DailyUpdate.getConcreteTime();
            psmHiUpdate.setString(1, timeNow);
            psmHiUpdate.setInt(2, hi_id);
            psmHiUpdate.executeUpdate();
            System.out.println("반납처리: history 테이블 hi_status = '2' (반납 완료) 변경, 반납시간 갱신");

            // 5. item 테이블 갱신: 해당 내역건에서 대여한 물품에 대해서 예약대기(it_status = '0')로 상태 변경하기
            String sqlUpdateItStatus = "UPDATE item SET it_status = '0' WHERE ca_name = ? AND it_serial = ?";
            it_serial = rsSelect.getString("it_serial");
            psmItUpdate = conn.prepareStatement(sqlUpdateItStatus);
            psmItUpdate.setString(1, ca_name);
            psmItUpdate.setString(2, it_serial);
            psmItUpdate.executeUpdate();
            System.out.println("반납처리: item 테이블 it_status = '0' (예약대기) 변경");

            // 6. 다시 예약 관리 페이지로
            out.println("<script>alert('반납하기가 정상적으로 처리되었습니다.');</script>");
            out.println("<script>location.replace('ad_reservation.jsp');</script>");

            System.out.println("ad_returnUpdate.jsp : 반납하기 완료");

        } catch (Exception e) {
            out.println("<script>alert('반납하기 실패'); " +
                    "location.replace('ad_reservation.jsp');</script>");
            System.out.println("ad_returnUpdate.jsp : 반납하기 실패");
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
                System.out.println("ad_returnUpdate.jsp 예외 발생");
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        }
    }

%>

</body>
</html>