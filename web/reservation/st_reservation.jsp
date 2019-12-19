<!-- 학생 회원이 예약하기 -->

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

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/st_reservation.css">

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
    String ca_name;

    String rowCount;

    Connection con;

    PreparedStatement psmGetPenalty;
    ResultSet rsGetPenalty;

    PreparedStatement psmGetDeposit;
    ResultSet rsGetDeposit;

    double us_black_count = 0.0; // 예약 시 지불해야 하는 페널티
    double depositForRegister = 0.0; // 예약 시 지불해야 하는 보증금
%>

<%
        System.out.println("st_reservation.jsp 실행(by us_id : " + us_id + ")");

        ca_name = request.getParameter("ca_name");
        rowCount = request.getParameter("rowCount");
        System.out.println("rowCount = " + rowCount);

        // 1. 해당 카테고리의 예약 가능한 물품 수가 0개이면, 예약 불가능
        if (rowCount.equals("0")) {
            out.println("<script>alert('선택하신 카테고리의 예약 가능한 상품이 없습니다.');</script>");
            out.println("<script>location.replace('../mypage/manage_reservation.jsp');</script>");
        }

        // 2. 현재 연체중인 거래가 있으면, 예약 불가능
        else if (DBUtil.checkIfGreyOrBlack(us_id)) {
            out.println("<script>alert('연체중인 항목이 있어 예약이 불가능합니다.');</script>");
            out.println("<script>location.replace('../mypage/manage_reservation.jsp');</script>");

        } else {

            try {
                System.out.print("ad_reservation.jsp가 호출한 ");
                con = DBConnection.getCon();

                // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
                assert con != null;
                con.setAutoCommit(false);

                // 3. us_black_count 가져오기 (예약자의 페널티 구하기)
                String sqlGetPenalty = "SELECT us_black_count FROM user WHERE us_id = '" + us_id + "'";
                psmGetPenalty = con.prepareStatement(sqlGetPenalty);
                rsGetPenalty = psmGetPenalty.executeQuery();
                rsGetPenalty.next();
                us_black_count = rsGetPenalty.getDouble("us_black_count");

                //4. depositForResister 구하기 (해당 카테고리의 보증금 구하기)
                String sqlGetDeposit = "SELECT ca_deposit FROM category WHERE ca_name = '" + ca_name + "'";
                psmGetDeposit = con.prepareStatement(sqlGetDeposit);
                rsGetDeposit = psmGetDeposit.executeQuery();
                rsGetDeposit.next();
                depositForRegister = Double.parseDouble(rsGetDeposit.getString("ca_deposit"));


                // 5. 영수증 페이지로 넘어가기
                String rst = "<script>location.replace('st_bill.jsp?ca_name=";
                rst += ca_name;
                rst += "&penalty=";
                rst += us_black_count;
                rst += "&deposit=";
                rst += depositForRegister;
                rst += "');</script>";
                out.println(rst);

                // SQL) COMMIT
                con.commit();

            } catch (SQLException e) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException e2) {
                        System.out.println("st_reservation.jsp 예외 발생");
                        e2.printStackTrace();
                        System.out.println(e2.getMessage());
                    }
                }
                System.out.println("st_reservation.jsp 예외 발생");
                e.printStackTrace();
                System.out.println(e.getMessage());
            } finally {
                try {
                    if (con != null)
                        con.close();
                    if (psmGetPenalty != null)
                        psmGetPenalty.close();
                    if (rsGetPenalty != null)
                        rsGetPenalty.close();
                    if (psmGetDeposit != null)
                        psmGetDeposit.close();
                    if (rsGetDeposit != null)
                        rsGetDeposit.close();
                } catch (SQLException e3) {
                    System.out.println("st_reservation.jsp 예외 발생");
                    e3.printStackTrace();
                    System.out.println(e3.getMessage());
                }
            }
        }
    }
%>

</body>
</html>
