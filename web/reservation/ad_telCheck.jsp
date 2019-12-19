<!-- '대여하기'할 때 최초 1회 인증 안 한 회원들 -> 전화번호 인증하는 창 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
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

    <title>성신코인: 회원정보</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/ad_reservation1.css">
    <link rel="stylesheet" href="../css/style_reser_main_edit_ver2.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/header_style.css">

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>

    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/mainForAd.css">

    <script src="../js/index.js"></script>
    <script src="../css/tableInputText.css"></script>

    <script>
        function check() {
            var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

            if (document.telChange.us_tel_new.value == "") {
                alert('전화번호를 입력해주세요.');
                return;
            } else if (phoneCheck.test(document.telChange.us_tel_new.value) == false) {
                //휴대폰 번호 유효성 검사
                alert("전화번호 형식에 맞지 않습니다");
                document.telChange.us_tel_new.focus();
                return;
            } else {
                document.telChange.submit();
            }
        }

        function inputPhoneNumber(obj) {
            var number = obj.value.replace(/[^0-9]/g, "");
            var phone = "";

            if (number.length < 4) {
                return number;
            } else if (number.length < 7) {
                phone += number.substr(0, 3);
                phone += "-";
                phone += number.substr(3);
            } else if (number.length < 11) {
                phone += number.substr(0, 3);
                phone += "-";
                phone += number.substr(3, 3);
                phone += "-";
                phone += number.substr(6);
            } else {
                phone += number.substr(0, 3);
                phone += "-";
                phone += number.substr(3, 4);
                phone += "-";
                phone += number.substr(7);
            }
            obj.value = phone;
        }
    </script>
</head>
<body>

<%!
    String login_id = "";
    String login_tel = "";
    String login_name = "";
    String login_email = "";
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
    <div class="header"></div>

    <!-- 내브바 -->
    <nav class="navbar navbar-inverse navbar-fixed-top"
         id="sidebar-wrapper" role="navigation">
        <ul class="nav sidebar-nav">
            <br>
            <div class="sidebar-brand">
                <p>성신코인: 예약관리<br/><%=login_name %>
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
                    <!-- span은 화살표로 자신의 정보 더보기 입니다. 관련 스크립트는 dropDown.js-->

                    </span>
            </div>
            <div class="sidebar-brand-drop">
                <li><a href="#"><i class="fa fa-fw fa-file-o"></i> 관리자 : <%=login_id%>
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
    Integer hi_id = 0;
    String us_id = "";
    String us_name = "";
    String us_tel = "";

    Connection conn;

    PreparedStatement smtGetTel;
    ResultSet rsGetTel;
%>

        <%
    System.out.println("ad_telCheck.jsp 실행");

    us_id = request.getParameter("us_id");
    hi_id = Integer.parseInt(request.getParameter("hi_id"));

    try {
        System.out.print("ad_telCheck.jsp가 호출한 ");
        conn = DBConnection.getCon(); // SQL문 한 개만 존재하는 파일

        String sqlGetTel = "SELECT us_name, us_tel FROM user WHERE us_id = ?";
        smtGetTel = conn.prepareStatement(sqlGetTel);
        smtGetTel.setString(1, us_id);
        rsGetTel = smtGetTel.executeQuery();
        rsGetTel.next();
        us_name = rsGetTel.getString("us_name");
        us_tel = rsGetTel.getString("us_tel");

%>
    <main style="margin-top:80px; margin-bottom: 100px;">

        <p style="text-align: center">전화번호 인증이 필요한 회원입니다.</p>
            <div class="limiter">
                <div class="container-table100">
                    <div class="wrap-table100">
                        <div class="table">
                            <div class="row headerT">
                                <div class="cell">
                                    이름
                                </div>
                                <div class="cell">
                                    학번
                                </div>
                                <div class="cell">
                                    전화번호
                                </div>
                                <div class="cell">
                                    변경
                                </div>
                            </div>

                            <div class="row">
                                <div class="cell" data-title="이름">
                                    <%=us_name%>
                                </div>
                                <div class="cell" data-title="학번">
                                    <%=us_id%>
                                </div>
                                <div class="cell" data-title="전화번호">
                                    <form method="post" action="ad_telChange.jsp" name="telChange">
                                        <input type="hidden" name="us_id" value="<%=us_id%>">
                                        <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                        <input type="text" placeholder="<%=us_tel%>" name="us_tel_new"
                                               style="float: left;" onkeyup="inputPhoneNumber(this)">
                                        <input type="button" name="telChange" value="수정하기" onClick="check()"
                                               style="float: left;">
                                    </form>
                                </div>

                                <div class="cell" data-title="변경">
                                    <form method="post" action="ad_telCheck_2.jsp" name="telCheck">
                                        <input type="hidden" name="us_id" value="<%=us_id%>">
                                        <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                        <input type="submit" name="telCheck" value="인증완료">
                                    </form>
                                </div>

                                    <%
    } catch (Exception e) {
        System.out.println("ad_telCheck.jsp 예외발생");
        e.printStackTrace();
        System.out.println(e.getMessage());
    } finally {
        try {
        if (rsGetTel != null)
            rsGetTel.close();
        if (smtGetTel != null)
            smtGetTel.close();
        if (conn != null)
            conn.close();
        } catch (SQLException e1) {
            System.out.println("ad_telCheck.jsp 예외발생");
            e1.printStackTrace();
            System.out.println(e1.getMessage());
        }
    }
    }
%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </main>
</div>
</body>
</html>