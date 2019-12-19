<!-- 학생회원의 마이페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/main.css">
<%--    <link rel="stylesheet" href="../css/myPage.css">--%>
    <link rel="stylesheet" href="../css/navForSt.css">
    <style>
        @font-face { font-family: 'KOMACON'; src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_seven@1.2/KOMACON.woff') format('woff'); font-weight: normal; font-style: normal; } body { background: url(../imgs/backgroundreser.svg); background-size: cover; margin: 0; height: 100vh; font-family: 'KOMACON'; overflow: hidden; } #cloud-front { background:url(/imgs/home-clouds-fg1.png) repeat-x 0 0 transparent; width: 100%; height: 687px; min-height: 687px; position: absolute; bottom:-22%; left:0; z-index: -1; -webkit-transform:translate3d(0,0,0.01); transform:translate3d(0,0,0.01); will-change: transform; } .cardlist { /* align-content: center; */ overflow-x: auto; overflow-y: hidden; white-space: nowrap; text-align: center; top: 20%; position: relative; /*margin-top: -115px;*/ width: -webkit-fill-available; } .cardForMyPage { background: url(../imgs/card_mypage.svg); width: 365px; height: 430px; display: inline-block; margin-inline-start: 40px; margin-inline-end: 40px; /* text-align: center; */ position: relative; vertical-align: middle; } ::-webkit-scrollbar{width: 2px;} h3{ display: inline; position: relative; /*top: -50px;*/ color:#787DBB; font-size: 30px; } .cardtitle p { text-align: left; margin-left: 70px; margin-top:20px; position: relative; color: #66687D; }
    </style>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>

    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>

<body>

<%!
    String login_id;
    String login_tel;
    String us_name;
%>
<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");
    us_name = (String) session.getAttribute("us_name");

    System.out.println("mypage.jsp 실행 (us_id :" + login_id + ")");

    if (login_id == null || !DBUtil.assureStudent(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<div id="cloud-front" class="cloud"></div>
<header>
    <a href="../reservation/reser_stu_main.jsp">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
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
        <li><a href="exchange_sujung.jsp">환전하기</a></li>
    </ul>
</nav>
<br>
<div class="cardlist">
    <a href="manage_profile.jsp">
        <span class="cardForMyPage" id="profile">
            <div class="cardtitle">
                <img src="/designImages/iconprofile.svg" alt="profile" style="width:60px; height:60px; display:inline-block; margin: 30px; margin-left: 10px; margin-top: 50px; position: relative;">
                <h3>개인정보수정</h3>
                <img src="/designImages/line.svg" alt="line" style="display: block; position:relative; width:260px; margin-left: 63px; margin-top: -10px;">
                <p>ㆍ이메일 수정</p>
                <p>ㆍ전화번호 수정</p>
                <p>ㆍ비밀번호 수정</p>
                <p>ㆍ회원탈퇴</p>
            </div>
        </span>
    </a>

    <a href="manage_sujung.jsp">
        <span class="cardForMyPage" id="marble">
            <div class="cardtitle">
                <img src="/designImages/iconmarble.svg" alt="marble" style="width:60px; height:60px; display:inline-block; margin: 30px; margin-left: 10px; margin-top: 50px; position: relative;">
                <h3>수정구관리</h3>
                <img src="/designImages/line.svg" alt="line" style="display: block; position:relative; width:260px; margin-left: 63px; margin-top: -10px;">
                <p>ㆍ내 수정구 조회</p>
                <p>ㆍ수정구 교환</p>
                <p>ㆍ페널티 지불</p>
            </div>
        </span>
    </a>

    <a href="manage_reservation.jsp">
        <span class="cardForMyPage" id="manage">
            <div class="cardtitle">
                <img src="/designImages/iconmanage.svg" alt="manage" style="width:60px; height:60px; display:inline-block; margin: 30px; margin-left: 10px; margin-top: 50px; position: relative;">
                <h3>예약/대여관리</h3>
                <img src="/designImages/line.svg" alt="line" style="display: block; position:relative; width:260px; margin-left: 63px; margin-top: -10px;">
                <p>ㆍ예약 내역 조회</p>
                <p>ㆍ대여 내역 조회</p>
                <p>ㆍ예약 취소</p>
                <p>ㆍ연체일 조회</p>
            </div>
        </span>
    </a>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>

<%
    }
%>
</body>
</html>