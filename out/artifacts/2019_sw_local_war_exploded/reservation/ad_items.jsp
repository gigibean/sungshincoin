<!-- 관리자 메인 페이지(reser_ad_main.jsp)에서 '물품 관리' -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인: 물품관리</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/ad_items.css">
    <link rel="stylesheet" href="../css/style_reser_main_edit_ver2.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/header_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <script src="../js/index.js"></script>

    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/mainForAd.css">
</head>

<body>

<%!
    String login_id;
    String login_tel;
    String login_email;
    String login_name;
%>

<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");
    login_email = (String) session.getAttribute("us_email");
    login_name = (String) session.getAttribute("us_name");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>


<div id="wrapper">
    <div class="header">
        <%--    logo--%>
        <a href="../reservation/reser_ad_main.jsp" class="hambuger fadeInLeft" style="z-index: 1001; ">
            <img src="../imgs/admin/logiForAdMain.png" alt="logo" style="margin-left: 60px; margin-top: 10px;"">
        </a>
    </div>

    <!-- 내브바 -->
    <nav class="navbar navbar-inverse navbar-fixed-top"
         id="sidebar-wrapper" role="navigation">
        <ul class="nav sidebar-nav">
            <br>
            <div class="sidebar-brand">
                <p>성신코인 관리자 <br/><%=login_name %>
                </p>
                <br/>
                <p>
                    <%= login_email %>
                </p>
                <span class="dropDown">
                        <img src="../imgs/admin/ic_arrow_drop_down.svg" alt="drop-down"
                             style="float: right; margin-right: 20px;" id="dropdownImg">
                        <img src="../imgs/admin/ic_arrow_drop_up.svg" alt="drop-down"
                             style="float: right; margin-right: 20px;" id="dropupImg">
                </span>
            </div>
            <div class="sidebar-brand-drop">
                <li><a href="#"><i class="fa fa-fw fa-file-o"></i> 관리자 : <%=login_id %>
                </a></li>
                <li><a href="#"><i class="fa fa-fw fa-file-o"></i> 전화번호 : <%=login_tel%>
                </a></li>
            </div>
            <br/>
            <li><a href="reser_ad_main.jsp"><i class="fa fa-home fa-fw"></i> &nbsp; 홈으로 돌아가기</a></li>
            <li><a href="ad_users.jsp"><img src="../imgs/admin/Outbox.svg" alt="가입승인"> &nbsp; 가입승인</a></li>
            <li><a href="ad_reservation.jsp"><img src="../imgs/admin/Updates.svg" alt="예약관리"> &nbsp; 예약관리</a></li>
            <li><a href="ad_items.jsp"><img src="../imgs/admin/Promos.svg" alt="물품관리"> &nbsp; 물품관리</a></li>
            <li><a href="ad_users_info.jsp"><img src="../imgs/admin/Social.svg" alt="회원정보">&nbsp; 회원정보</a></li>
            <li><a href="../logout.jsp"><i class="fa fa-fw fa-twitter"></i> 로그아웃</a></li>
        </ul>
    </nav>

    <!-- 내브바버튼 -->
    <button type="button" class="hamburger is-closed animated fadeInLeft" data-toggle="offcanvas">
        <span class="hamb-top"></span>
        <span class="hamb-middle"></span>
        <span class="hamb-bottom"></span>
    </button>

    <!-- 메인 -->
    <main style="margin-top:80px; margin-bottom: 100px;">
        <br>

        <span class="eraseCategory" style="cursor: pointer;"
              onClick="window.open('ad_category.jsp?decision=2', '카테고리 삭제하기', 'width=500,height = 200');">
        <img src="../imgs/stuffMn.svg" alt="stuffX">
        <p>카테고리 삭제하기</p>
        </span>
        <br>
        <h3 align="center" class="cate_title">카테고리 조회</h3>
        <%!
            Connection con = null;
            PreparedStatement psm = null;
            ResultSet rs = null;

            String ca_name = "";
            String ca_filename = "";
            String ca_deposit = "";
        %>
        <div style="overflow-x:auto; overflow-y:hidden; white-space: nowrap;" class="stufflist">
            <%
                System.out.println("물품 관리(ad_itmes.jsp) : 실행");

                try {
                    System.out.print("ad_items.jsp가 호출한 ");
                    con = DBConnection.getCon();

                    String sql = "SELECT * FROM category"; // SQL문 한 개만 있는 파일

                    psm = con.prepareStatement(sql);
                    rs = psm.executeQuery();

                    while (rs.next()) {
                        ca_name = rs.getString("ca_name");
                        ca_filename = rs.getString("ca_filename");
                        ca_deposit = rs.getString("ca_deposit");

            %>
            <span class="stuff">
            <div class="stuffname">
              <img src="/categoryImages/<%=ca_filename%>" alt="카테고리 이미지" width="50" height="50"/>
               <input type="button" style="font-size: 25px;" value="<%=ca_name%>"
                      onClick="location.replace('ad_items_2.jsp?ca_name=<%=ca_name%>');">
                <br/><br/><br/><br/>
               <form method="post" action="ad_category_3.jsp" autocomplete="off" name="changeDeposit"
                     class="formForCategory">
                   <label for="depositInput" style="color:#000;width: 10px;">보증금</label>
                        <input type="text" name="ca_deposit" placeholder="<%=ca_deposit%>" id="depositInput">
                        <input type="hidden" name="ca_name" value="<%=ca_name%>"><br/>
                        <input type="submit" value="변경하기">
                    </form>
            </div>
        </span>
            <%
                        } // while문 종료
                    } catch (SQLException e) {
                        e.printStackTrace();
                        System.out.println(e.getMessage());
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (psm != null) psm.close();
                            if (con != null) con.close();
                        } catch (SQLException se) {
                            System.out.println(se.getMessage());
                        }
                    }
                }
            %>
            <span class="stuff">
                <a style="cursor: pointer;"
                   onClick="window.open('ad_category.jsp?decision=1', '카테고리 추가하기', 'width=500,height = 200');" )>
                    <div class="stuffPlus">
                        <img src="../imgs/stuffPlus.svg" alt="stuffPlus" width="40px" height="40px"
                             style="display:block;">
                        <h3>
                            카테고리 추가하기
                        </h3>
                    </div>
                </a>
            </span>
        </div>
        <br><br>
    </main>
</div>

<script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.1/TweenMax.min.js'></script>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
<script type="text/javascript" src="../js/dropDown.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script>
    $(function(){
        $(".stufflist").mousewheel(function (event, delta) {
            this.scrollLeft -= (delta * 30);
            event.preventDefault();
        });
    });
</script>

</body>
</html>
