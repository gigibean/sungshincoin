<!-- 관리자 메인 페이지(reser_ad_main.jsp)에서 '예약 관리' -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.io.IOException" %>
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

    <title>성신코인: 예약관리</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/ad_reservation1.css">
    <link rel="stylesheet" href="../css/style_reser_main_edit_ver2.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/header_style.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>

    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/mainForAd.css">

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <script src="../js/index.js"></script>


    <script>
        function check() {
            var uidCheck = /^[0-9]{8}$/;

            if (document.searchReserveByUid.us_id.value == "") {
                alert("아이디를 입력해주세요.");
                document.searchReserveByUid.us_id.focus();
                return;
            } else if (uidCheck.test(document.searchReserveByUid.us_id.value) == false) {
                alert("아이디를 올바르게 입력해주세요.");
                document.searchReserveByUid.us_id.focus();
                return;
            } else {
                document.searchReserveByUid.submit();
            }
        }

        function contentsView(objValue) {
            if (objValue == 0) { // 전체
                $('#all').css('display', 'block');
                $('#registered').css('display', 'none');
                $('#rented').css('display', 'none');
                $('#delayed').css('display', 'none');
                $('#noShow').css('display', 'none');
                return false;
            }

            if (objValue == 1) { // 예약완료
                $('#all').css('display', 'none');
                $('#registered').css('display', 'block');
                $('#rented').css('display', 'none');
                $('#delayed').css('display', 'none');
                $('#noShow').css('display', 'none');
                return false;
            }

            if (objValue == 2) { // 대여중
                $('#all').css('display', 'none');
                $('#registered').css('display', 'none');
                $('#rented').css('display', 'block');
                $('#delayed').css('display', 'none');
                $('#noShow').css('display', 'none');
                return false;
            }

            if (objValue == 3) { // 연체
                $('#all').css('display', 'none');
                $('#registered').css('display', 'none');
                $('#rented').css('display', 'none');
                $('#delayed').css('display', 'block');
                $('#noShow').css('display', 'none');
                return false;
            }

            if (objValue == 4) { // 노쇼
                $('#all').css('display', 'none');
                $('#registered').css('display', 'none');
                $('#rented').css('display', 'none');
                $('#delayed').css('display', 'none');
                $('#noShow').css('display', 'block');
                return false;
            }
        }
    </script>
</head>

<body>
<%!
    String login_id;
    String login_tel;
    String login_name;
    String login_email;
%>
<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");
    login_name = (String) session.getAttribute("us_name");
    login_email = (String) session.getAttribute("us_email");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<div id="wrapper">
    <div class="header">
        <%--    logo--%>
        <a href="../reservation/reser_ad_main.jsp" class="hambuger fadeInLeft" style="z-index: 1001; ">
            <img src="../imgs/admin/logiForAdMain.png" alt="logo" style="margin-left: 60px; margin-top: 10px;">
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


    <%!
        Connection con = null;

        String sqlForList = "";
        PreparedStatement psmForList = null;
        ResultSet rsForList = null;

        PreparedStatement psmGetDeposit = null;

        Integer hi_id = 0;
        String us_id = "";
        String ca_name = "";
        String it_serial = "";
        String hi_book_time = "";
        Integer hi_delay = 0;
        String hi_return_time = "";
        String hi_status = "";
        Integer hi_isFriday = 0;
    %>

    <!-- 분류 라디오 버튼-->

    <div id="radioForCheck" style="display: block; position: relative; width: 100%; margin-top: 150px;" align="center">
        <input type="radio" name="search" value="0" id="전체" checked="true" onclick="javascript:contentsView(0);">
        <label for="전체">&nbsp;&nbsp;전체&nbsp;&nbsp;</label>

        <input type="radio" name="search" value="1" id="예약완료" onclick="javascript:contentsView(1);">
        <label for="예약완료"> &nbsp;&nbsp; 예약완료 &nbsp;&nbsp;</label>

        <input type="radio" name="search" value="2" id="대여중" onclick="javascript:contentsView(2);">
        <label for="대여중">&nbsp;&nbsp;대여중&nbsp;&nbsp;</label>

        <input type="radio" name="search" value="3" id="연체" onclick="javascript:contentsView(3);">
        <label for="연체">&nbsp;&nbsp;연체&nbsp;&nbsp;</label>

        <input type="radio" name="search" value="4" id="노쇼" onclick="javascript:contentsView(4);">
        <label for="노쇼">&nbsp;&nbsp;노쇼&nbsp;&nbsp;</label>
    </div>

    <form method="post" action="ad_reservation_search.jsp" name="searchReserveByUid" align="center" class="search"
          autocomplete="off">
        <input type="text" placeholder="예약자 ID를 검색하세요" name="us_id" id="searchID">
        <input type="button" class="btn" value="검색" onClick="javascript:check()">
    </form>

    <%
        System.out.println("ad_resercation.jsp 실행");
        try {
            System.out.print("ad_reservation.jsp가 호출한 ");
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);


    %>

    <!-- 메인 -->

    <div id="all"> <!-- 전체 예약건 조회 -->
        <div class="limiter">
            <div class="container-table100">
                <div class="wrap-table100">

                    <div class="table">

                        <div class="row headerT">
                            <div class="cell">
                                예약번호
                            </div>
                            <div class="cell">
                                예약자 ID
                            </div>
                            <div class="cell">
                                카테고리
                            </div>
                            <div class="cell">
                                물품번호
                            </div>
                            <div class="cell">
                                예약시간
                            </div>
                            <div class="cell">
                                연체일
                            </div>
                            <div class="cell">
                                반납시간
                            </div>
                            <div class="cell">
                                현황
                            </div>
                            <div class="cell">
                                처리
                            </div>
                        </div>

                        <%
                            sqlForList = "SELECT * FROM history ORDER BY hi_id DESC";
                            psmForList = con.prepareStatement(sqlForList);
                            rsForList = psmForList.executeQuery();

                            while (rsForList.next()) {
                                hi_id = rsForList.getInt("hi_id");
                                us_id = rsForList.getString("us_id");
                                ca_name = rsForList.getString("ca_name");
                                it_serial = rsForList.getString("it_serial");
                                hi_book_time = rsForList.getString("hi_book_time");
                                hi_delay = rsForList.getInt("hi_delay");
                                hi_return_time = rsForList.getString("hi_return_time");
                                hi_status = rsForList.getString("hi_status");
                                hi_isFriday = rsForList.getInt("hi_isFriday");
                        %>
                        <div class="row">
                            <div class="cell" data-title="예약번호">
                                <%=hi_id %>
                            </div>
                            <div class="cell" data-title="예약자 ID">
                                <%=us_id%>
                            </div>
                            <div class="cell" data-title="카테고리">
                                <%=ca_name%>
                            </div>
                            <div class="cell" data-title="물품번호">
                                <%=it_serial%>
                            </div>
                            <div class="cell" data-title="예약시간">
                                <%=hi_book_time%>
                            </div>
                            <%
                                if (hi_isFriday + hi_delay <= 0) {
                            %>
                            <div class="cell" data-title="연체일">
                                -
                            </div>
                            <%
                            } else if (hi_isFriday + hi_delay < 10) {
                            %>
                            <div class="cell" data-title="연체일">
                                <%=hi_isFriday + hi_delay%>
                            </div>
                            <% } else {
                            %>
                            <div class="cell" data-title="연체일">
                                <%=hi_isFriday + hi_delay%>
                            </div>
                            <%
                                }
                                if (hi_return_time == null || hi_return_time.equals("")) {
                            %>
                            <div class="cell" data-title="반납시간">
                                -
                            </div>
                            <%
                            } else {
                            %>
                            <div class="cell" data-title="반납시간">
                                <%=hi_return_time%>
                            </div>
                            <%
                                }
                            %>
                            <%
                                switch (hi_status) {
                                    case "0": // 예약 완료(default)
                            %>
                            <div class="cell" data-title="현황">
                                예약 완료
                            </div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_historyUpdate.jsp" name="res1">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="대여하기">
                                </form>
                            </div>
                            <%
                                    break;
                                case "1": // 대여 완료
                            %>
                            <div class="cell" data-title="현황">
                                대여 완료
                            </div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_returnUpdate.jsp" name="res2">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="반납하기">
                                </form>
                            </div>
                            <%
                                    break;
                                case "2": // 반납완료(보증금처리 완료)
                            %>
                            <div class="cell" data-title="현황">
                                반납 완료
                            </div>
                            <div class="cell" data-title="처리"> -</div>
                            <%
                                    break;
                                case "3": // 예약 당일 취소
                            %>
                            <div class="cell" data-title="현황">예약 취소</div>
                            <div class="cell" data-title="처리">
                                -
                            </div>
                            <%
                                    break;
                                case "4": // 노쇼 보증금 처리 미완료
                            %>
                            <div class="cell" data-title="현황">노쇼 미완</div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_noShow.jsp" name="res3">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="노쇼처리">
                                </form>
                            </div>
                            <%
                                    break;
                                case "5": // 노쇼 보증금 처리 완료
                            %>
                            <div class="cell" data-title="현황">노쇼 완료</div>
                            <div class="cell" data-title="처리"> -</div>
                            <%
                                        break;
                                }
                            %>
                        </div> <!-- row클래스 끝나는 부분 -->
                        <%
                            }
                        %>
                    </div> <!-- table클래스 끝나는 부분-->
                </div> <%--wrap table 100--%>
            </div> <%--container table 100--%>
        </div> <%--div limiter--%>
    </div> <!-- all 클래스 끝나는 부분 -->

    <div id="registered" style="display:none"> <!-- 예약완료 && 대여대기 건 조회 -->
        <div class="limiter">
            <div class="container-table100">
                <div class="wrap-table100">

                    <div class="table">
                        <div class="row headerT">
                            <div class="cell">
                                예약번호
                            </div>
                            <div class="cell">
                                예약자 ID
                            </div>
                            <div class="cell">
                                카테고리
                            </div>
                            <div class="cell">
                                물품번호
                            </div>
                            <div class="cell">
                                예약시간
                            </div>
                            <div class="cell">
                                연체일
                            </div>
                            <div class="cell">
                                반납시간
                            </div>
                            <div class="cell">
                                현황
                            </div>
                            <div class="cell" id="last">
                                처리
                            </div>
                        </div>

            <%
                sqlForList = "SELECT * FROM history WHERE hi_status = '0' ORDER BY hi_id DESC";
                psmForList = con.prepareStatement(sqlForList);
                rsForList = psmForList.executeQuery();

                while (rsForList.next()) {
                    hi_id = rsForList.getInt("hi_id");
                    us_id = rsForList.getString("us_id");
                    ca_name = rsForList.getString("ca_name");
                    it_serial = rsForList.getString("it_serial");
                    hi_book_time = rsForList.getString("hi_book_time");
                    hi_delay = rsForList.getInt("hi_delay");
                    hi_return_time = rsForList.getString("hi_return_time");
                    hi_status = rsForList.getString("hi_status");
                    hi_isFriday = rsForList.getInt("hi_isFriday");
            %>
                        <div class="row">
                            <div class="cell" data-title="예약번호">
                                <%=hi_id %>
                            </div>
                            <div class="cell" data-title="예약자 ID">
                                <%=us_id%>
                            </div>
                            <div class="cell" data-title="카테고리">
                                <%=ca_name%>
                            </div>
                            <div class="cell" data-title="물품번호">
                                <%=it_serial%>
                            </div>
                            <div class="cell" data-title="예약시간">
                                <%=hi_book_time%>
                            </div>
                    <%
                        if (hi_isFriday + hi_delay <= 0) {
                    %>
                            <div class="cell" data-title="연체일">
                                -
                            </div>
                    <%
                    } else if (hi_isFriday + hi_delay < 10) {
                    %>
                            <div class="cell" data-title="연체일">
                                <%=hi_isFriday + hi_delay%>
                            </div>
                    <% } else {
                    %>
                            <div class="cell" data-title="연체일">
                                <%=hi_isFriday + hi_delay%>
                            </div>
                    <%
                        }
                        if (hi_return_time == null || hi_return_time.equals("")) {
                    %>
                            <div class="cell" data-title="반납시간">
                                -
                            </div>
                    <%
                    } else {
                    %>
                            <div class="cell" data-title="반납시간">
                                <%=hi_return_time%>
                            </div>
                    <%
                        }
                    %>
                            <div class="cell" data-title="현황">
                                예약 완료
                            </div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_historyUpdate.jsp" name="res1">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="대여하기">
                                </form>
                            </div>
                        </div> <!-- row종료 -->
                    <%
                        } // while문 종료
                %>
                        </div>
                        <%--table--%>
                    </div>
                    <%--wrap table 100--%>
                </div>
                <%--container table 100--%>
            </div>
            <%--div limiter--%>
        </div>
        <%--div registered--%>

    <div id="rented" style="display:none"> <!-- 대여중인 예약건 조회 -->
        <div class="limiter">
            <div class="container-table100">
                <div class="wrap-table100">
                    <div class="table">

                        <div class="row headerT">
                            <div class="cell">
                                예약번호
                            </div>
                            <div class="cell">
                                예약자 ID
                            </div>
                            <div class="cell">
                                카테고리
                            </div>
                            <div class="cell">
                                물품번호
                            </div>
                            <div class="cell">
                                예약시간
                            </div>
                            <div class="cell">
                                연체일
                            </div>
                            <div class="cell">
                                반납시간
                            </div>
                            <div class="cell">
                                현황
                            </div>
                            <div class="cell" >
                                처리
                            </div>
                        </div>

            <%
                sqlForList = "SELECT * FROM history WHERE hi_status = '1' ORDER BY hi_id DESC";
                psmForList = con.prepareStatement(sqlForList);
                rsForList = psmForList.executeQuery();

                while (rsForList.next()) {
                    hi_id = rsForList.getInt("hi_id");
                    us_id = rsForList.getString("us_id");
                    ca_name = rsForList.getString("ca_name");
                    it_serial = rsForList.getString("it_serial");
                    hi_book_time = rsForList.getString("hi_book_time");
                    hi_delay = rsForList.getInt("hi_delay");
                    hi_return_time = rsForList.getString("hi_return_time");
                    hi_status = rsForList.getString("hi_status");
                    hi_isFriday = rsForList.getInt("hi_isFriday");
            %>
                        <div class="row">
                            <div class="cell" data-title="예약번호">
                                <%=hi_id %>
                            </div>
                            <div class="cell" data-title="예약자 ID">
                                <%=us_id%>
                            </div>
                            <div class="cell" data-title="카테고리">
                                <%=ca_name%>
                            </div>
                            <div class="cell" data-title="물품번호">
                                <%=it_serial%>
                            </div>
                            <div class="cell" data-title="예약시간">
                                <%=hi_book_time%>
                            </div>
                    <%
                        if (hi_isFriday + hi_delay <= 0) {
                    %>
                            <div class="cell" data-title="연체일"> -</div>
                    <%
                    } else if (hi_isFriday + hi_delay < 10) {
                    %>
                            <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                            </div>
                    <% } else {
                    %>
                <td><%=hi_isFriday + hi_delay%>
                </td>
                    <%
                        }

                        if (hi_return_time == null || hi_return_time.equals("")) {
                    %>
                            <div class="cell" data-title="반납시간"> -</div>
                    <%
                    } else {
                    %>
                            <div class="cell" data-title="반납시간"><%=hi_return_time%></div>
                    <%
                        }
                    %>
                            <div class="cell" data-title="현황">대여 완료</div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_returnUpdate.jsp" name="res2">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="반납하기">
                                </form>
                            </div>
                        </div> <!-- row 종료 -->
                    <%
                        } // while문 종료
                %>
                    </div><%--table--%>
                </div><%--wrap table 100--%>
            </div><%--container table 100--%>
        </div><%--div limiter--%>
    </div><%--div rented--%>

    <div id="delayed" style="display:none"> <!-- 연체 건 조회 -->
        <div class="limiter">
            <div class="container-table100">
                <div class="wrap-table100">

                    <div class="table">
                        <div class="row headerT">
                            <div class="cell">
                                예약번호
                            </div>
                            <div class="cell">
                                예약자 ID
                            </div>
                            <div class="cell">
                                카테고리
                            </div>
                            <div class="cell">
                                물품번호
                            </div>
                            <div class="cell">
                                예약시간
                            </div>
                            <div class="cell">
                                연체일
                            </div>
                            <div class="cell">
                                반납시간
                            </div>
                            <div class="cell">
                                현황
                            </div>
                            <div class="cell" >
                                처리
                            </div>
                        </div>

            <%
                sqlForList = "SELECT * FROM history WHERE hi_status = '1' AND (hi_delay + hi_isFriday > 0) ORDER BY hi_id DESC";
                psmForList = con.prepareStatement(sqlForList);
                rsForList = psmForList.executeQuery();

                while (rsForList.next()) {
                    hi_id = rsForList.getInt("hi_id");
                    us_id = rsForList.getString("us_id");
                    ca_name = rsForList.getString("ca_name");
                    it_serial = rsForList.getString("it_serial");
                    hi_book_time = rsForList.getString("hi_book_time");
                    hi_delay = rsForList.getInt("hi_delay");
                    hi_return_time = rsForList.getString("hi_return_time");
                    hi_status = rsForList.getString("hi_status");
                    hi_isFriday = rsForList.getInt("hi_isFriday");
            %>

                        <div class="row">
                            <div class="cell" data-title="예약번호"><%=hi_id %>
                            </div>
                            <div class="cell" data-title="예약자 ID"><%=us_id%>
                            </div>
                            <div class="cell" data-title="카테고리">
                                <%=ca_name%>
                            </div>
                            <div class="cell" data-title="물품번호"><%=it_serial%>
                            </div>
                            <div class="cell" data-title="예약시간"><%=hi_book_time%>
                            </div>

                    <%
                        if (hi_isFriday + hi_delay <= 0) {
                    %>
                            <div class="cell" data-title="연체일"> -</div>
                    <%
                    } else if (hi_isFriday + hi_delay < 10) {
                    %>
                            <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                            </div>
                    <% } else {
                    %>
                            <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                            </div>
                    <%
                        }
                        if (hi_return_time == null || hi_return_time.equals("")) {
                    %>
                            <div class="cell" data-title="반납시간"> -</div>
                    <%
                    } else {
                    %>
                            <div class="cell" data-title="반납시간"><%=hi_return_time%>
                            </div>
                    <%
                        }
                    %>
                            <div class="cell" data-title="현황">대여 완료</div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_returnUpdate.jsp" name="res2">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="반납하기">
                                </form>
                            </div>
                        </div> <!-- row 종료 -->
                    <%
                        }
                        %>
                    </div><%--table--%>
                </div><%--wrap table 100--%>
            </div><%--container table 100--%>
        </div><%--div limiter--%>
    </div><%--div rented--%>

    <div id="noShow" style="display:none"> <!-- 노쇼 조회 -->
        <div class="limiter">
            <div class="container-table100">
                <div class="wrap-table100">

                    <div class="table">
                        <div class="row headerT">
                            <div class="cell">
                                예약번호
                            </div>
                            <div class="cell">
                                예약자 ID
                            </div>
                            <div class="cell">
                                카테고리
                            </div>
                            <div class="cell">
                                물품번호
                            </div>
                            <div class="cell">
                                예약시간
                            </div>
                            <div class="cell">
                                연체일
                            </div>
                            <div class="cell">
                                반납시간
                            </div>
                            <div class="cell">
                                현황
                            </div>
                            <div class="cell" >
                                처리
                            </div>
                        </div>

            <%
                sqlForList = "SELECT * FROM history WHERE hi_status = '4' OR hi_status = '5' ORDER BY hi_id DESC";
                psmForList = con.prepareStatement(sqlForList);
                rsForList = psmForList.executeQuery();

                while (rsForList.next()) {
                    hi_id = rsForList.getInt("hi_id");
                    us_id = rsForList.getString("us_id");
                    ca_name = rsForList.getString("ca_name");
                    it_serial = rsForList.getString("it_serial");
                    hi_book_time = rsForList.getString("hi_book_time");
                    hi_delay = rsForList.getInt("hi_delay");
                    hi_return_time = rsForList.getString("hi_return_time");
                    hi_status = rsForList.getString("hi_status");
                    hi_isFriday = rsForList.getInt("hi_isFriday");
            %>
                        <div class="row">
                            <div class="cell" data-title="예약번호">
                                <%=hi_id %>
                            </div>
                            <div class="cell" data-title="예약자 ID"><%=us_id%>
                            </div>
                            <div class="cell" data-title="카테고리"><%=ca_name%>
                            </div>
                            <div class="cell" data-title="물품번호"><%=it_serial%>
                            </div>
                            <div class="cell" data-title="예약시간"><%=hi_book_time%>
                            </div>
                    <%
                        if (hi_isFriday + hi_delay <= 0) {
                    %>
                            <div class="cell" data-title="연체일"> -</div>
                    <%
                    } else if (hi_isFriday + hi_delay < 10) {
                    %>
                            <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                            </div>
                    <% } else {
                    %>
                            <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                            </div>
                    <%
                        }
                        if (hi_return_time == null || hi_return_time.equals("")) {
                    %>
                            <div class="cell" data-title="반납시간"> -</div>
                    <%
                    } else {
                    %>
                            <div class="cell" data-title="반납시간"><%=hi_return_time%>
                            </div>
                    <%
                        }
                        if (hi_status.equals("4")) {
                    %>
                            <div class="cell" data-title="현황">노쇼 미완</div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_noShow.jsp" name="res3">
                                    <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                    <input class="btn" type="submit" name="button" value="노쇼처리">
                                </form>
                            </div>

                    <%
                        } else {
                            %>
                            <div class="cell" data-title="현황">노쇼 완료</div>
                            <div class="cell" data-title="처리"> -</div>
                    <%
                        }
                        %>
                        </div> <!-- row 종료-->
                        <%
                        } // while문 종료

                %>
                    </div><%--table--%>
                </div><%--wrap table 100--%>
            </div><%--container table 100--%>
        </div><%--div limiter--%>
    </div><%--div rented--%>

</div><%--div wrapper--%>

<%
            // SQL) COMMIT
            con.commit();

        } catch (IOException | SQLException e1) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            System.out.println("ad_reservation.jsp 예외 발생");
            e1.printStackTrace();
            System.out.println(e1.getMessage());
        } finally {
            try {
                if (rsForList != null)
                    rsForList.close();
                if (psmForList != null)
                    psmForList.close();
                if (psmGetDeposit != null)
                    psmGetDeposit.close();
                if (con != null)
                    con.close();
            } catch (Exception e) {
                System.out.println("ad_reservation.jsp 예외 발생");
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        } // !! 버튼 누를 때 confirm()나오면 좋겠음. 시간 나면 보강하기.
    }
%>

<script>
    $("#searchID").on('propertychange change keyup paste input', function() {
        if ($(this).val().length != 0) {
            $(this).css({
                opacity: 1,
            });

        }
        else {
            $(this).css({
                opacity: 0.4,
            });

        }
    });

    (function ($) {
        var originalVal = $.fn.val;
        $.fn.val = function (value) {
            var res = originalVal.apply(this, arguments);

            if (this.is('input:text') && arguments.length >= 1) {
                // this is input type=text setter
                this.trigger("input");
            }

            return res;
        };
    })(jQuery);
</script>

<script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.1/TweenMax.min.js'></script>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
<script type="text/javascript" src="../js/dropDown.js"></script>

</body>
</html>