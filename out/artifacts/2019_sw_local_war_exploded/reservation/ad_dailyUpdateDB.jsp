<!-- 디자인할 부분 없음 -->
<!-- 하루 중 관리자 중 한 명이 최초로 로그인할 때 DB 자동갱신을 위해 실행된다. -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBConnection" %>
<%@ page import="model.DailyUpdate" %>

<%@ page import="java.io.File" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>성신코인: DB 갱신</title>
</head>
<body>

<%!
    String login_id;
%>

<%
    login_id = (String) session.getAttribute("us_id");

    System.out.println("ad_dailyUpdateDB.jsp 실행 (by login_id : " + login_id + ")");

    if (!DBUtil.assureAdmin(login_id) || login_id.equals("")) {
        System.out.println("ad_dailyUpdateDB.jsp : 관리자 외 us_id의 접근 제한 => login.html로 이동");
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    String todayStr = "";
    String lastUpdatedDayStr = "";

    Connection con = null;

    PreparedStatement psmForList = null;
    ResultSet rsForList = null;

    PreparedStatement psmUpdateDelay = null;

    String sqlGetPossible = null;
    PreparedStatement psmGetPossible = null;
    ResultSet rsGetPossible = null;

    PreparedStatement psmForPossible = null;

    PreparedStatement psmForNoShow = null;

    Integer hi_id = 0;
    String hi_book_time = "";
    Integer hi_delay = 0;
    String hi_return_time = "";
    String hi_status = "";
%>

<%
        try {
            System.out.print("ad_dailyUpdateDB.jsp에서 호출한 ");
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

            // 마지막 업데이트 날짜를 보관하는 파일을 열어서
            // 오늘 날짜가 최종업데이트 날짜가 아닌 경우, 처리한다.

            System.out.print("ad_dailyUpdateDB.jsp에서 호출한 ");
            todayStr = DailyUpdate.getTodayDate(); // 오늘 날짜 가져오기

            String fileName = "lastUpdatedDay.txt";
            String directory = "lastUpdatedDay"; // WebContent/lastUpdatedDay
            String directories = request.getRealPath(directory);
            String path = directories + "\\" + fileName;
            System.out.print("ad_dailyUpdateDB.jsp에서 호출한 ");
            lastUpdatedDayStr = DailyUpdate.getLastUpdatedDate(path); // history DBd의 hi_delay 계산 마지막으로 한 날짜 가져오기

            System.out.println("오늘날짜: " + todayStr + ", 최종 업데이트 날짜: " + lastUpdatedDayStr);

            if (todayStr.equals(lastUpdatedDayStr)) { // 오늘 날짜가 최종 업데이트 날짜인 경우
                System.out.println("오늘 날짜와 최종 업데이트 날짜가 동일하니까, reser_ad_main.jsp로 가자");
                response.sendRedirect("reser_ad_main.jsp");

            } else {

                // ---------여기서부터---------- 오늘 날짜가 최종 업데이트 날짜와 다른 경우 DB를 갱신한다.

                // 1. 최종 업데이트 날짜를 보관하는 파일을 갱신한다.
                // 파일 객체 생성
                File file = new File(path);

                // 출력 버퍼 생성
                BufferedWriter bufWriter = new BufferedWriter(new FileWriter(file));

                if (file.isFile() && file.canWrite()) {
                    bufWriter.write(todayStr); // 쓰기 (모든 내용 삭제 + 덮어쓰기)
                    bufWriter.close();
                }
                System.out.println("lastUpdatedDate.txt파일의 갱신 완료");


                // 2. history 테이블에서 hi_delay 테이블을 갱신한다.
                String sqlForList = "SELECT * FROM history WHERE hi_status = '0' OR hi_status = '1'";
                psmForList = con.prepareStatement(sqlForList);
                rsForList = psmForList.executeQuery();

                String sqlUpdateDelay = "UPDATE history SET hi_delay = ? WHERE hi_id = ?";

                while (rsForList.next()) {
                    hi_id = rsForList.getInt("hi_id");
                    hi_book_time = rsForList.getString("hi_book_time");
                    hi_delay = rsForList.getInt("hi_delay");
                    hi_return_time = rsForList.getString("hi_return_time");
                    hi_status = rsForList.getString("hi_status");

                    System.out.println("갱신 후보 hi_id (예약 or 대여중) : " + hi_id); // 예약 완료 상태이거나 대여 완료 상태인 예약건에 대해서

                    hi_delay = DailyUpdate.getDayCount(hi_book_time); // 예약날짜~오늘날짜
                    psmUpdateDelay = con.prepareStatement(sqlUpdateDelay);
                    psmUpdateDelay.setInt(1, hi_delay);
                    psmUpdateDelay.setInt(2, hi_id);
                    psmUpdateDelay.executeUpdate(); // hi_delay의 갱신이 이루어짐
                } // while문 종료


                // 3. history 테이블에서 노쇼처리해야할 물품을 찾아 it_status = '0'(예약가능)으로 갱신한다.

                // 예약완료 상태로 하루 이상 지난 예약건 ==> 노쇼처리 되어야 할 것들
                sqlGetPossible = "SELECT ca_name, it_serial FROM history WHERE hi_status = '0' AND hi_delay > 0";
                psmGetPossible = con.prepareStatement(sqlGetPossible);
                rsGetPossible = psmGetPossible.executeQuery();

                String sqlForPossible = "UPDATE item SET it_status ='0' WHERE ca_name = ? AND it_serial = ?";

                while (rsGetPossible.next()) {
                    String ca_name = rsGetPossible.getString("ca_name");
                    String it_serial = rsGetPossible.getString("it_serial");

                    psmForPossible = con.prepareStatement(sqlForPossible);
                    psmForPossible.setString(1, ca_name);
                    psmForPossible.setString(2, it_serial);
                    psmForPossible.executeUpdate();
                }

                // 4. history 테이블에서 hi_status가 노쇼로 변경되어야 하는 사람들을 찾아 hi_status = '4'(노쇼, 보증금 처리 미완료)로 갱신한다.
                String sqlForNoShow = "UPDATE history SET hi_status = '4' WHERE hi_status = '0' AND hi_delay > 0";
                psmForNoShow = con.prepareStatement(sqlForNoShow);
                psmForNoShow.executeUpdate();


                // SQL) COMMIT
                con.commit();

                // 마지막으로 메인 페이지로 이동한다
                response.sendRedirect("reser_ad_main.jsp");
            }
        } catch (IOException | SQLException e1) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }

            }
            e1.printStackTrace();
            System.out.println(e1.getMessage());
        } finally {
            try {
                if (rsForList != null)
                    rsForList.close();
                if (psmForList != null)
                    psmForList.close();
                if (psmUpdateDelay != null)
                    psmUpdateDelay.close();
                if (psmGetPossible != null)
                    psmGetPossible.close();
                if (rsGetPossible != null)
                    rsGetPossible.close();
                if (psmForPossible != null)
                    psmForPossible.close();
                if (psmForNoShow != null)
                    psmForNoShow.close();
                if (con != null)
                    con.close();
            } catch (Exception e3) {
                e3.printStackTrace();
                System.out.println(e3.getMessage());
            }
        }
    }
%>
</body>
</html>