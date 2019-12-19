<!-- 학생 회원의 수정구 관리 -->

<%@ page import="model.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

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
    <link rel="stylesheet" href="../css/mainForSt.css">
    <%--    <link rel="stylesheet" href="../css/manage_sujung.css">--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel="stylesheet" href="../css/navForSt.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
<%--    <link rel="stylesheet" href="../css/exchange_sujung.css"> 여기 풀기--%>



    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>


    <style>
        @font-face { font-family: 'KOMACON'; src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_seven@1.2/KOMACON.woff') format('woff'); font-weight: normal; font-style: normal; }
        body {
            background: url(../imgs/backgroundreser.svg);
            background-size: cover;
            margin: 0;
            height: 100vh;
            font-family: 'KOMACON';
            overflow: hidden;
        }

        #cloud-front {
            background:url(/imgs/home-clouds-fg1.png) repeat-x 0 0 transparent;
            width: 100%;
            height: 687px;
            min-height: 687px;
            position: absolute;
            bottom:-22%;
            left:0;
            z-index: -1;
            -webkit-transform:translate3d(0,0,0.01);
            transform:translate3d(0,0,0.01);
            will-change: transform;
        }

        canvas {
            display: block;
            position: fixed;
            left: 230px;
            top: 170px;
            z-index: -2;
            /* TO DO: MAKE canvas righ */
        }

        .suryong img {
            display: inline-block;
            position: fixed;
            left: 62%;
            top: 14%;
            z-index: -2;
        }

        .maincard {
            background: url(../imgs/speechbubble.png);
            width: 775px;
            height: 536px;
            align-self: left;
            margin-top : -250px;
            margin-left: 150px;
            position: absolute;
            top: 50%;

        }

        .header, .exchange {

            text-align: center;
        }

        .header {
            margin-top : 20px;
            margin-bottom: 20px;
            margin-left: -120px;
        }

        .header h3 {
            display: inline;
            position: relative;
            top: 20px;
            color:#787DBB;
            font-size: 40px;
        }
        .manage {
            margin-left: 150px;
            width: 360px;
            display: table;

        }
        .manage h4 {
            margin-top: 20px;
            margin-bottom: 10px;
            font-size: 20px;
            display: table-cell;
        }
        .manage p {
            display : block;
            font-size : 15px;
            text-align: right;

            /*margin-top: 15px;*/
        }

        .manage {
            color: #565656;
        }

        .metaMaskDiv {
            margin-left: 150px;
            width: 360px;
        }

        .metaMaskDiv p {
            text-align : right;
            width: 360px;
            display: block;
        }

        .exchange {
            margin-left : -80px;
            margin-top : 20px;
            /*font-size: 25px;*/
        }

        /*.exchange a:link {*/
        /*    text-decoration: none;*/
        /*    color: #565656;*/
        /*}*/

        /*.exchange a:visited {*/
        /*    text-decoration: none;*/
        /*    color: #565656;*/
        /*}*/

        /*.exchange a:active {*/
        /*    text-decoration: none;*/
        /*    color: #272727;*/
        /*}*/

        /*.exchange a:hover {*/
        /*    text-decoration: none;*/
        /*    color: #272727;*/
        /*}*/


        .btn{
            display: inline-block;
            /*     font-weight: 400; */
            text-align: center;
            vertical-align: middle;
            user-select: none;
            font-size: 15px !important;
            font-weight: 400;
            color : #fff !important;


        }
        .btn:visited {
            display: inline-block;
            text-decoration: none;
            color: #fff !important;
            font-size: 15px;
            font-wheight: 400;
        }
        .btn:hover {
            display: inline-block;
            text-decoration: none;
            color: #fff;
            font-size: 15px;
            font-wheight: 400;
        }
        .btn:link {
            display: inline-block;
            text-decoration: none;
            color: #fff !important;
            font-size: 15px;
            font-wheight: 400;
        }
        .btn:active {
            display: inline-block;
            text-decoration: none;
            color: #fff;
            font-size: 15px;
            font-wheight: 400;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            z-index: 1000;
            display: none;
            /* float: left; */
            min-width: 10rem;
            padding: .5rem 0;
            margin: .125rem 0 0;
            color: #212529;
            text-align: left;
            list-style: none;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid rgba(0,0,0,.15);
            border-radius: .25rem;
        }

        .dropdown-menu .show {
            display: block;
        }

        .dropdown-item {
            display: block;
            width: 100%;
            padding: .25rem 1.5rem;
            clear: both;
            font-weight: 400;
            color: #212529;
            text-align: inherit;
            white-space: nowrap;
            background-color: transparent;
            border: 0;
            font-size: 15px !important;
            font-family: 'KOMACON';
        }

        .dropdown .show {
            display: inline !important;
        }

        .btn-secondary {
            color: #fff;
        }
        .exchange input[type=number] {
            width: 200px;
            height: 50px;
            background: transparent;
            border-top: none;
            border-left: none;
            border-right: none;
            border-bottom: 1.5px solid #272727 !important;
            border-radius: 2px;
            font-family: 'KOMACON';
            font-size: 18px;
            color: #000;
            opacity: 0.4;
            margin-top : 15px;
            margin-bottom: 3px;
        }

        .exchange input[type=number]:focus {
            outline: none;
            width: 200px;
            height: 50px;
            background: transparent;
            border-top: none;
            border-left: none;
            border-right: none;
            border-bottom: 1.5px solid #272727 !important;
            border-radius: 2px;
            font-family: 'KOMACON';
            font-size: 18px;
            color: #000;
            opacity: 1;
            margin-top: 15px;
            margin-bottom: 3px;
        }

        .exchange input[type=submit] {
            border-color: #272727;
            border-width: 1.3px;
            background: none;
            border-style: solid !important;
            border-radius: 3px;
            color: #272727;
            width: 70px;
            height: 40px;
            opacity: 0.7;
            font-size: 18px;
        }

        .exchange input[type=submit]:active {
            border-color: #272727;
            border-width: 1px;
            background: none;
            border-style: solid !important;
            border-radius: 3px;
            color: #272727;
            width: 70px;
            height: 40px;
            opacity: 0.7;
            font-size: 18px;
        }

        .exchange input[type=submit]:focus {
            border-color: #272727 !important;
            border-width: 1px !important;
            border-style: solid !important;
            border-radius: 3px;
            color: #272727;
            width: 70px;
            height: 40px;
            font-size: 18px;
            outline: none;
            opacity: 1;
            background: #44444480;
        }

        .exchange input[type=submit]:hover {
            border-color: #272727 !important;
            border-width: 1px !important;
            border-style: solid !important;
            border-radius: 3px;
            color: #272727;
            width: 70px;
            height: 40px;
            font-size: 18px;
            outline: none;
            background: #44444480;
            opacity: 0.9;
        }


    </style>

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

    if (login_id == null || !DBUtil.assureStudent(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {

%>


<div id="login_threejs_gooLogin_scene"></div>
<div id="cloud-front" class="cloud"></div>
<header>
    <a href="../reservation/reser_stu_main.jsp">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
    </a>
</header>
<!-- navforst -->
<nav class="navForSt">
    <ul style="display: inline-flex;">
        <div class="dropdown show" style="display: inline;">

            <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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
<span class="suryong">
        <img src="/designImages/suryong_marble@2x.png" alt="suryong">
</span>

<div class="maincard">
    <div class="header">
        <img src="/designImages/iconmarble.svg" alt="marble"
             style="width:60px; height:60px; display:inline-block; margin: 30px; margin-left: 50px; margin-top: 50px; position: relative;">
        <h3>수정구 교환 </h3>
    </div>

    <div class="manage">
        <h4>총 수정구슬 발행량</h4>
        <!-- !! 수정구 개수 연결 -->
        <p class="dapp-balance" > </p>
    </div>

    <br>

    <div class="manage">
        <h4>남은 수정구슬</h4>
        <!-- !! 수정구 개수 연결 -->
        <p class="tokens-available"> </p>

    </div>
    <br>

    <div class="manage">
        <h4>나의 남은 수정구슬 개수</h4>
        <!-- !! 수정구 개수 연결 -->
        <p class="tokens-sold"> </p>
    </div>
    <br>
    <div class="metaMaskDiv">
        <h4 style="font-size: 20px;">META MASK에 연결된 계정</h4>
        <p style="text-align: right; font-size: 15px" id="accountAddress"> </p>
    </div>
    <div class="exchange">
        <form onSubmit="App.buyTokensBtn(); return false;">
            <input id="numberOfTokens" type="number" placeholder="교환할 수정구슬 개수" style="display: inline;" value="1" min="1" pattern="[0-9]">
            <input type="submit" value="교환" style="display: inline;" class="tokens-sold">
        </form>
        <div calss="anoButton">
    </div>
</div>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script src="../js/obj.js"></script>
<script src="../js/mtl.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>
<script type="text/javascript" src="../js/gooManage.js"></script>
<script src="../js/web3.min.js"></script>
<script src="../js/truffle-contract.min.js"></script>
<script src="../js/app.js"></script>

</body>

<%
    }
%>
</html>
