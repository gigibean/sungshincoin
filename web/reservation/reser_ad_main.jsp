<!-- 관리자 로그인 후 메인 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<%@ page import="model.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인: 관리자페이지</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/reser_ad_main.css">
    <link rel="stylesheet" href="../css/style_reser_main_edit_ver2.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/header_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/mainForAd.css">

    <script src="../js/index.js"></script>
    <style>
        .boardDiv {
            width: 1410px;
            height: 100%;
            display: block;
            margin: 0 auto;
            margin-top: 126px;
            background-color: #EFF3F4 !important;
        }

        #board1 {
            background: url(../imgs/admin/board1.svg);
            width: 1410px;
            height: 300px;
            position: relative;
        }

        #board1 .container-table100 {
            padding-top: 15px;
        }

        #board2 {
            background: url(../imgs/admin/board2.svg);
            width: 680px;
            height: 430px;
            position: relative;
            float: left;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        #board2 label, #board2 input[type=radio] {
            display: inline;
        }

        #board3 {
            background: url(../imgs/admin/board3.svg);
            width: 680px;
            height: 430px;
            position: relative;
            right: inherit;
            float: right;
            margin-top: 30px;
            margin-bottom: 30px;
        }

        #board4 {
            clear: both;
            background: url(../imgs/admin/board1.svg);
            width: 1410px;
            height: 300px;
            margin-bottom: 30px;
        }

        .dropDown {
            cursor: pointer;
        }

        .sidebar-brand-drop {
            /* background: url(../imgs/admin/sidebar-brand-drop.svg); */
            background-color: #EFF3F4;
            width: 320px;
            height: 180px;
            display: none;
        }

        #dropupImg {
            display: none;
        }

        .navbar {
            box-shadow: 3px 0 4px rgba(0, 0, 0, 0.2);
        }

        .sidebar-brand p {
            padding-top: 10px;
            padding-left: 25px;
        }

        ::-webkit-scrollbar {
            width: 2px;
        }

        .board4-child {
            margin: 80px;
            display: inline-block;
            position: relative;
            text-align: center;
        }

        .board h3 {
            color: #0074BC;
            font-size: 25px;
        }

        .board4-child p {
            font-size: 38px;
        }

        #board4-1 {
            left: 50%;
            margin-left: -350px;
        }

        #board4-2 {
            left: 50%;
            margin-left: 350px;
        }

        #board1 h3, #board2 h3, #board3 h3 {
            margin: 50px;
        }

        #board1 h3 {
            padding-top: 50px;
        }

        #rented {
            margin: 30px;
        }

        .usercard {
            margin: 15px;
        }

        .rowForCard {
            margin-left: 5px;
            margin-right: 5px;
        }

        .columnForCard-1 {
            float: left;
            width: 300px;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
        }

        .columnForCard-2 {
            float: left;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
            margin-left: 15px;
            width: 300px;
        }

        .processdonebtn {
            margin-top: 15px;
            border-color: #aeb7cb !important;
            border-radius: 5px;
            border-width: 1.5px !important;
            background: #c7d1e4 !important;
            border-style: solid !important;
            color: #444444;
            width: 290px;
            height: 50px;
        }

        .processdonebtn:focus {
            outline: none;
            opacity: 0.8;
        }

        .processdonebtn:hover {
            opacity: 0.5;
        }

        .eachphoto {
            margin-left: 35px;
        }

        #board3 .limiter {
            height: 359px;
            display: block;
            margin: 0 auto;
            background-color: transparent !important;

        }

        #board3 .container-table100 {
            margin: 0 auto;
            width: 100%;
            height: 359px;

        }

        #board3 .wrap-table100 {
            border-radius: 10px;
            overflow: hidden;
            height: 358px;
            overflow-y: auto !important;
            overflow-x: hidden !important;
        }


        #board3 .table {
            /* display: inline-block; */
            position: relative;
            /*width: 400px;*/
            float: left;
            margin: 0 auto;
        }

        #board3 h3 {
            margin-bottom: 10px;
        }


        .header {
            background: url(/imgs/admin/navbarAd.svg);
            width: 103%;
            height: 92px;
            top: -8px;
            position: fixed;
            z-index: 1000;
            margin-top: 0;
            margin-left: -8px;
        }
    </style>
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

    System.out.println("reser_ad_main.jsp 실행 (by login_id : " + login_id + ")");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<div id="wrapper">
    <div class="header">
        <%--    logo--%>
        <a href="../reservation/reser_ad_main.jsp" class="hambuger fadeInLeft" style="z-index: 1001; ">
            <img src="../imgs/admin/logiForAdMain.png" alt="logo" style="margin-left: 60px; margin-top: 10px;"/>
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
            <li><a href="ad_users.jsp"><img src="../imgs/admin/Outbox.svg"> &nbsp; 가입승인</a></li>
            <li><a href="ad_reservation.jsp"><img src="../imgs/admin/Updates.svg"> &nbsp; 예약관리</a></li>
            <li><a href="ad_items.jsp"><img src="../imgs/admin/Promos.svg"> &nbsp; 물품관리</a></li>
            <li><a href="ad_users_info.jsp"><img src="../imgs/admin/Social.svg">&nbsp; 회원정보</a></li>
            <li><a href="../logout.jsp"><i class="fa fa-fw fa-twitter"></i> 로그아웃</a></li>
        </ul>
    </nav>

    <!-- 내브바 버튼 -->
    <button type="button" class="hamburger is-closed animated fadeInLeft" data-toggle="offcanvas">
        <span class="hamb-top"></span>
        <span class="hamb-middle"></span>
        <span class="hamb-bottom"></span>
    </button>

        <%!
        Connection con = null;

        // 대여 대기 중인 예약건
        PreparedStatement psmSearch = null;
        ResultSet rsSearch = null;
        String sqlForList = "";
        PreparedStatement psmForList = null;
        ResultSet rsForList = null;

        String hi_id;
        String us_id1 = "";
        String ca_name1 = "";
        String it_serial = "";
        String hi_book_time = "";
        Integer hi_delay = 0;
        String hi_return_time = "";
        String hi_status = "";
        Integer hi_isFriday = 0;

        // 회원가입 승인
        PreparedStatement psm = null;
        ResultSet rs = null;

        String savePath = "userImages";
        String us_id2 = "";
        String us_name = "";
        String us_email = "";
        String us_filename = "";
        String us_tel = "";
        String us_level = "";
        String us_date = "";

        // 학생회원 수 구하기
        PreparedStatement psmGetNumStudent = null;
        ResultSet rsGetNumStudent = null;

        int numStudent = 0;

        // 예약건 수 구하기
        PreparedStatement psmRowHistory = null;
        ResultSet rsRowHistory = null;

        int rowHistory = 0;

        // 물품관리
        PreparedStatement psmGetCountCategory = null;
        ResultSet rsGetCountCategory = null;
        int numCategory = 0;

        PreparedStatement psmRowPerCategory = null;
        ResultSet rsRowPerCategory = null;
        int rowPerCategory = 0;

        PreparedStatement psmAvailablePerCategory = null;
        ResultSet rsAvailablePerCategory = null;
        int availablePerCategory = 0;

        PreparedStatement psmEveryCategory = null;
        ResultSet rsEveryCategory = null;
        String ca_name2 = "";
    %>
        <%
        try {
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

    %>

    <!-- 메인 -->
    <div class="boardDiv">

        <!-- ================================= 대여 대기 중인 예약 내역 ================================= -->
        <div class="board" id="board1">
            <a href="ad_reservation.jsp"> <!-- 예약 관리 -->
                <h3>대여 대기 중인 예약 내역</h3>
            </a>
            <div id="rented"> <!-- 대여중인 예약건 조회 -->
                <%--                <%--%>
                <%--                    String sqlSearch = "SELECT COUNT(*) AS ready FROM history WHERE hi_status = '0'";--%>
                <%--                    psmSearch = con.prepareStatement(sqlSearch);--%>
                <%--                    rsSearch = psmSearch.executeQuery();--%>
                <%--                    rsSearch.next();--%>
                <%--                    int ready = 0;--%>
                <%--                    ready = rsSearch.getInt("ready");--%>

                <%--                    if (ready == 0) {--%>
                <%--                %>--%>
                <%--                <p>- 현재 대여 대기 중인 건이 없습니다.-</p>--%>
                <%--                <%--%>

                <%--                } else {--%>
                <%
                    sqlForList = "SELECT * FROM history WHERE hi_status = '0' ORDER BY hi_id DESC"; // 제일 최근 1개만
                    psmForList = con.prepareStatement(sqlForList);
                    rsForList = psmForList.executeQuery();
                %>
                <div class="limiter">
                    <div class="container-table100">
                        <div class="wrap-table100">
                            <div class="table"> <!-- 1번째 행, 8개 열 -->
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
                                    if (rsForList.next()) {
                                        hi_id = rsForList.getString("hi_id");
                                        us_id1 = rsForList.getString("us_id");
                                        ca_name1 = rsForList.getString("ca_name");
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
                                    <div class="cell" data-title="예약번호">
                                        <%=us_id1%>
                                    </div>
                                    <div class="cell" data-title="예약번호">
                                        <%=ca_name1 %>
                                    </div>
                                    <div class="cell" data-title="예약번호">
                                        <%=it_serial%>
                                    </div>
                                    <div class="cell" data-title="예약번호">
                                        <%=hi_book_time %>
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
                                    <div class="cell" data-title="반납시간"><%=hi_return_time%>-</div>
                                    <%
                                        }
                                    %>
                                    <div class="cell" data-title="현황">예약 완료</div>
                                    <div class="cell" data-title="처리">
                                        <form method="post" action="ad_historyUpdate.jsp" name="res1">
                                            <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                            <input class="btn" type="submit" name="button" value="대여하기">
                                        </form>
                                    </div>
                                </div> <!-- row종료 -->
                                <%

                                } // if문 종료
                                else {
                                %>

                                <p>- 현재 대여 대기 중인 건이 없습니다.-</p>

                                <%
                                    }
                                %>
                            </div> <!-- table 종료 -->
                        </div> <!-- -->
                    </div>
                </div>
            </div>
        </div>

        <!-- ================================= 회원 가입 승인 대기 ================================= -->
        <div class="board" id="board2"> <!-- 가입 승인 -->
            <a href="ad_users.jsp">
                <h3>회원가입 승인 대기</h3>
            </a>
            <%
                String sql = "SELECT * FROM user WHERE (us_level = '0' OR us_level = '3' OR us_level = '2') ORDER BY us_level";
                psm = con.prepareStatement(sql);
                rs = psm.executeQuery();

                if (rs.next()) {
                    us_id2 = rs.getString("us_id");
                    us_name = rs.getString("us_name");
                    us_email = rs.getString("us_email");
                    us_tel = rs.getString("us_tel");
                    us_filename = rs.getString("us_filename");
                    us_level = rs.getString("us_level");
                    us_date = rs.getString("us_date");
            %>

            <span class="usercard rowForCard">
                <div class="eachphoto columnForCard-1">
                    <!-- <img src="../imgs/admin/cardForuserimg.svg" alt="img"> -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="300" height="240" viewBox="0 0 300 240"
                         preserveAspectRatio="xMidYMid slice" focusable="false" role="img"
                         aria-label="Placeholder: Thumbnail">
                        <path id="cardForuserimg"
                              d="M15,0H385a15,15,0,0,1,15,15V262.4a0,0,0,0,1,0,0H0a0,0,0,0,1,0,0V15A15,15,0,0,1,15,0Z"
                              fill="none"/>
                        <!-- <image xlink:href="../imgs/admin/Social.svg" x="0" y="0" height="400" width="262.4"/> -->
                        <image xlink:href="/userImages/<%=us_filename%>" alt="여기에 뜨지 않으면 다운로드하세요" x="0" y="0"
                               width="300" height="240"/>
                        <!-- xlink에 회원 이미지 -->
                    </svg>
                </div>
                <div class="columnForCard-2">
                <div class="eachcard">
                    <!-- <img src="../imgs/admin/cardForuser.svg" alt="card" > -->
                    학번 : <%=us_id2%>&nbsp;&nbsp;이름 : <%=us_name%><br/>
                    가입날짜 : <%=us_date%><br/>
                    이메일 : <a href="mailto:<%=us_email%>"><%=us_email%></a> <br/>
                    전화번호 : <%=us_tel%><br/>
                    학생인증 이미지 다운로드 : <a href="../imgs/test85.jpg"><%=us_filename%> </a>
                </div>

              <div class="eachbutton">

    <form method="post" action="ad_users_2.jsp" name="manageUser">
        <input type="hidden" name="us_id" value="<%=us_id2%>">

        <%
            if (us_level.equals("0")) { // 학생 사용자로 가입 신청
        %>
        <label for="stuLevelUp"> 학생 가입 승인</label>
        <input type="radio" name="level" value="1" id="stuLevelUp" checked>
        <label for="stuLevelDown"> 가입 거절 </label>
        <input type="radio" name="level" value="2" id="stuLevelDown">
        <input class="processdonebtn" type="submit" value="처리">
        <%
        } else if (us_level.equals("3")) { // 관리자 사용자로 가입 신청
        %>
        <label for="adminLevelUp"> 관리자 가입 승인</label>
        <input type="radio" name="level" value="4" id="adminLevelUp" checked>
        <label for="adminLevelDown"> 가입 거절 </label>
        <input type="radio" name="level" value="3" id="adminLevelDown">
        <input class="processdonebtn" type="submit" value="처리">
        <%
        } else {  // 가입 거절된 사람 (us_level = 2인 사용자) => (회원가입 다시 할 수 있도록 회원탈퇴 시켜야 함)
        %>
        <label for="deleteUser"> 승인 거절된 회원 - 재회원가입을 위한 탈퇴 조치 </label>
        <input type="radio" name="level" value="5" id="deleteUser">
        <input class="processdonebtn" type="submit" value="처리">
        <% }
        } else { // 회원가입 승인/거절 목록이 없는 경우
        %>

        <p>- 표시할 사용자가 없습니다 -</p>

        <%
            }

        %>

        <br>
        <br>
    </form>
                  </div>
                    </div>
            </span>
        </div>


        <!-- ================================= 카테고리별 예약 가능 현황 ================================= -->
        <a href="ad_items.jsp">
            <div class="board" id="board3"> <!-- 물품 관리 -->
                <h3>카테고리별 예약 가능 현황</h3>
                <%
                    // 1. 현재 존재하는 카테고리 개수구하기
                    String sqlGetCountCategory = "SELECT COUNT(*) AS numCategory FROM category";
                    psmGetCountCategory = con.prepareStatement(sqlGetCountCategory);
                    rsGetCountCategory = psmGetCountCategory.executeQuery();
                    rsGetCountCategory.next(); // 테이블에 아무것도 없는 경우라도, null이 아님
                    numCategory = rsGetCountCategory.getInt("numCategory");
                    if (numCategory == 0) { // 카테고리에 하나도 없을 경우 (사실 굉장히 예외적인 경우)
                %>
                <p>- 표시할 카테고리가 존재하지 않습니다.-</p>
                <%
                } else {
                %>

                <div class="limiter">
                    <div class="container-table100">
                        <div class="wrap-table100">

                            <div class="table">
                                <div class="row headerT">
                                    <div class="cell">
                                        카테고리명
                                    </div>
                                    <div clss="cell">
                                        예약 가능 물품/전체 물품
                                    </div>
                                </div>

                                <%
                                    // 2. 카테고리이름들 다 가져오기
                                    String sqlEveryCategory = "SELECT ca_name FROM category";
                                    psmEveryCategory = con.prepareStatement(sqlEveryCategory);
                                    rsEveryCategory = psmEveryCategory.executeQuery();

                                    while (rsEveryCategory.next()) {
                                        ca_name2 = rsEveryCategory.getString("ca_name");

                                        // 3. 카테고리별로 총 개수 구하기
                                        String sqlRowPerCategory = "SELECT ca_name, COUNT(*) AS totalItems FROM item WHERE ca_name = ? GROUP BY ca_name";
                                        psmRowPerCategory = con.prepareStatement(sqlRowPerCategory);
                                        psmRowPerCategory.setString(1, ca_name2);
                                        rsRowPerCategory = psmRowPerCategory.executeQuery();
                                        if (rsRowPerCategory.next()) {
                                            rowPerCategory = rsRowPerCategory.getInt("totalItems");

                                            // 3. 카테고리별로 예약가능한 물품 개수 구하기
                                            String sqlAvailablePerCategory = "SELECT ca_name, COUNT(*) AS availableItems From item WHERE it_status = '0' AND ca_name = ? GROUP BY ca_name";
                                            psmAvailablePerCategory = con.prepareStatement(sqlAvailablePerCategory);
                                            psmAvailablePerCategory.setString(1, ca_name2);
                                            rsAvailablePerCategory = psmAvailablePerCategory.executeQuery();
                                            if (rsAvailablePerCategory.next()) {
                                                availablePerCategory = rsAvailablePerCategory.getInt("availableItems");
                                            } else {
                                                availablePerCategory = 0;
                                            }
                                        } else { // 카테고리에 해당하는 물품 하나도 없는 경우
                                            rowPerCategory = 0;
                                            availablePerCategory = 0;
                                        }
                                %>
                                <div class="row">
                                    <div class="cell" data-title="카테고리명"><%=ca_name2%>
                                    </div>
                                    <div class="cell" data-title="예약 가능 물품 / 전체 물품"><%=availablePerCategory%>
                                        / <%=rowPerCategory%>
                                    </div>
                                </div> <!-- row 끝 -->
                                <%
                                    } // while문 종료
                                %>
                            </div>
                        </div>
                    </div>
                </div>

                <%
                    }
                %>
            </div>
        </a>

        <!-- ================================= 학생 회원의 수, 총 예약건 수 ================================= -->
        <div class="board" id="board4"> <!-- 회원 정보 -->
            <a href="ad_users_info.jsp">
                <div class="board4-child" id="board4-1">
                    <h3>학생 회원의 수</h3>
                    <%
                        String getNumStudent = "SELECT COUNT(*) AS numStudent FROM user WHERE (us_level = '1' or us_level='6' or us_level = '7')";
                        psmGetNumStudent = con.prepareStatement(getNumStudent);
                        rsGetNumStudent = psmGetNumStudent.executeQuery();
                        rsGetNumStudent.next();
                        numStudent = rsGetNumStudent.getInt("numStudent");
                    %>
                    <p><%=numStudent%> 명</p>
                </div>
            </a>

            <a href="ad_reservation.jsp">
                <div class="board4-child" id="board4-2">
                    <h3>잔여 수정구슬 / 수정구슬 발행량</h3> <!-- 총 예약건 수-->
                    <%
                        String getRowHistory = "SELECT COUNT(*) AS rowHistory FROM history";
                        psmRowHistory = con.prepareStatement(getRowHistory);
                        rsRowHistory = psmRowHistory.executeQuery();
                        rsRowHistory.next();
                        rowHistory = rsRowHistory.getInt("rowHistory");
                    %>
                    <p>919750 / 1000000</p>
                </div>
            </a>
        </div>

    </div> <!-- boarddiv -->


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
            e1.printStackTrace();
            System.out.println(e1.getMessage());

        } finally {
            try {
                if (rsSearch != null)
                    rsSearch.close();
                if (psmSearch != null)
                    psmSearch.close();
                if (rsForList != null)
                    rsForList.close();
                if (psmForList != null)
                    psmForList.close();
                if (rs != null)
                    rs.close();
                if (psm != null)
                    psm.close();
                if (rsGetNumStudent != null)
                    rsGetNumStudent.close();
                if (psmGetNumStudent != null)
                    psmGetNumStudent.close();
                if (rsRowHistory != null)
                    rsRowHistory.close();
                if (psmRowHistory != null)
                    psmRowHistory.close();
                if (con != null)
                    con.close();

            } catch (SQLException e3) {
                e3.printStackTrace();
                System.out.println(e3.getMessage());
            }
        }
    }
%>

    <!-- cdn & script -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.1/TweenMax.min.js'></script>
    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <script src='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
    <script type="text/javascript" src="../js/dropDown.js"></script>

</body>
</html>