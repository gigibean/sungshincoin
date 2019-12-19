<!-- 학생으로 로그인 후 보이는 화면 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.*" %>


<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인에 오신 것을 환영합니다.</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/st_reservation.css">
    <link rel="stylesheet" href="../css/navForSt.css">


    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>

<body>
<%!
    String login_id = "";
    String us_name = "";
%>
<%
    login_id = (String) session.getAttribute("us_id");
    us_name = (String) session.getAttribute("us_name");

    if (login_id == null || !DBUtil.assureStudent(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    Connection con = null;

    PreparedStatement psmCa = null;
    ResultSet rsCa = null;

    PreparedStatement psmIt = null;
    ResultSet rsIt = null;

    String ca_name;
    String ca_filename;
    String ca_deposit;

    int rowCount = 0; // 카테고리별 예약가능한 물품의 개수
%>

<div id="cloud-front" class="cloud"></div>
<div class="screen"></div>

<header>
    <a href="../reservation/reser_stu_main.jsp">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000;width: 172px;height: 67.09px;margin: 0;">
    </a>
</header>
<!-- navforst -->
<nav class="navForSt">
    <ul>
        <div class="dropdown show" style="display: inline;">

            <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <%=us_name%>
            </a>
            <div class="dropdown-menu dropdown-menu-right">
                <a class="dropdown-item" href="../mypage/mypage.jsp">마이페이지</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="../logout.jsp">로그아웃</a>
            </div>
        </div>

        <li><a href="../reservation/reser_stu_main.jsp">예약하기</a></li>
        <li><a href="../mypage/exchange_sujung.jsp">환전하기</a></li>
    </ul>
</nav>
<br>

<div style="overflow-x:auto; overflow-y:hidden; white-space: nowrap;" class="stufflist">

    <%
        System.out.println("reser_stu_main.jsp: 실행 (by us_id : " + login_id + ")");

        try {
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

            String sqlCa = "SELECT * FROM category";

            psmCa = con.prepareStatement(sqlCa);
            rsCa = psmCa.executeQuery();

            String sqlIt = "SELECT COUNT(*) AS itemCount FROM item WHERE ca_name = ? AND it_status = '0'"; // 예약 가능 상태인 물품들의 개수

            while (rsCa.next()) {
                ca_name = rsCa.getString("ca_name");
                ca_filename = rsCa.getString("ca_filename");
                ca_deposit = rsCa.getString("ca_deposit");

                psmIt = con.prepareStatement(sqlIt);
                psmIt.setString(1, ca_name);
                rsIt = psmIt.executeQuery();
                if (rsIt.next()) {
                    rowCount = rsIt.getInt("itemCount");
                } else {
                    rowCount = 0;
                }

    %>
    <span class="stuff" id="ca_<%=ca_name%>">
      <a href="st_reservation.jsp?ca_name=<%=ca_name%>&rowCount=<%=rowCount%>">
        <div class="stuffname">
            <picture>
                <source media="(max-height: 800px)" srcset="/categoryImages/<%=ca_filename%>">
                <img src="/categoryImages/<%=ca_filename%>" alt="<%=ca_name%> 이미지">
            </picture>
            <h3>
                <%=ca_name%>
            </h3>
            <p><%=rowCount%>개 예약가능</p>
        </div>

         <div class="stuffrent" style="display:none">
             <img src="/designImages/5stuffrents.svg" alt="예약" width="40px" height="40px">
             <h3>
                예약하기
             </h3>
         </div>
      </a>
    </span>
    <%
        } // while문 종료
    %>
</div>
<%
            // SQL) COMMIT
            con.commit();

        } catch (SQLException e) {
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException e2) {
                        System.out.println("reser_stu_main.jsp 예외 발생");
                        e2.printStackTrace();
                        System.out.println(e2.getMessage());
                    }
                }
                System.out.println("reser_stu_main.jsp 예외 발생");
            e.printStackTrace();
            System.out.println(e.getMessage());
        } finally {
            try {
                if (rsCa != null) rsCa.close();
                if (psmCa != null) psmCa.close();
                if (con != null) con.close();
            } catch (SQLException se) {
                System.out.println("reser_stu_main.jsp 예외 발생");
                System.out.println(se.getMessage());
            }
        }
    }
%>

<script>
    $('.stuff').on('mouseover', function () {
        var stuffId = '#';
        stuffId += this.id;
        console.log(stuffId);

        $(stuffId).find('.stuffname').hide();
        $(stuffId).find('.stuffrent').show();
    });

    $('.stuff').on('mouseout', function () {
        var stuffId = '#';
        stuffId += this.id;
        console.log(stuffId);

        $(stuffId).find('.stuffname').show();
        $(stuffId).find('.stuffrent').hide();
    });

</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>
<script type="text/javascript" src="../js/mousewheel.js"></script>

</body>
</html>