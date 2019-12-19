<!-- 예약 시 DB업데이트 -->
<!-- 디자인 부분 없음 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>
<%@ page import="model.DailyUpdate" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.ResultSet" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
    <script type="text/javascript" src="../js/moveClouds.js"></script>
    <script type="text/javascript" src="../js/mousewheel.js"></script>
    <script src="../js/web3.min.js"></script>
    <script src="../js/truffle-contract.min.js"></script>
    <script src="../js/app.js"></script>
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
    ServletContext sc;

    String ca_name;
    String book_time;


    Connection con;
%>

<%
        System.out.println("st_reservationUpdate.jsp 실행(by us_id : " + us_id + ")");

        try {
            System.out.print("st_reservationUpdate.jsp가 호출한 ");
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

            // 1. 예약에 따른 DB 갱신
            ca_name = request.getParameter("ca_name");
            sc = request.getSession().getServletContext();
            book_time = DailyUpdate.getConcreteTime();

            if (DBUtil.reserveIn(sc, us_id, ca_name, book_time)) {
                out.println("<script>alert('예약이 완료되었습니다.');</script>");
                out.println("<script>location.replace('../mypage/manage_reservation.jsp');</script>");


            } else {
                out.println("<script>alert('예약에 실패했습니다.');</script>");
                out.println("<script>location.replace('reser_stu_main.jsp');</script>");
            }

            // SQL) COMMIT
            con.commit();

        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    System.out.println("st_reservationUpdate.jsp 예외 발생");
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            System.out.println("st_reservationUpdate.jsp 예외 발생");
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
    }
%>

</body>
</html>
