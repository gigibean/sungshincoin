<!-- 비밀번호 찾기 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/mainForSt.css">
    <link rel="stylesheet" href="../css/find_pw.css">
    <link rel="stylesheet" href="../css/navForSt.css">

    <title>성신코인: 비밀번호 찾기</title>

    <script>
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

        function check() {
            var uidCheck = /^[0-9]{8}$/;
            var nameCheck = /^[가-힣]+$/;
            var emailCheck = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
            var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

            if (document.findPWForm.us_id.value == "") {
                alert("아이디를 입력해주세요.");
                document.findPWForm.us_id.focus();
                return;
            } else if (uidCheck.test(document.findPWForm.us_id.value) == false) {
                alert("아이디형식이 올바르지 않습니다.");
                document.findPWForm.us_id.focus();
                return;
            } else if (document.findPWForm.us_name.value == "") {
                alert('이름을 입력해주세요.');
                return;
            } else if (nameCheck.test(document.findPWForm.us_name.value) == false) {
                alert("이름형식은 한글만 가능합니다.");
                document.findPWForm.us_name.focus();
                return;
            } else if (document.findPWForm.findThrough.value == 'email' && document.findPWForm.us_email.value == "") {
                alert('이메일을 입력해주세요.');
                return;
            } else if (document.findPWForm.findThrough.value == 'email' && emailCheck.test(document.findPWForm.us_email.value) == false) {
                alert("이메일형식이 올바르지 않습니다.");
                document.findPWForm.us_email.focus();
                return;
            } else if (document.findPWForm.findThrough.value == 'phone' && document.findPWForm.us_tel.value == "") {
                alert('폰번호를 입력해주세요.');
                return;
            } else if (document.findPWForm.findThrough.value == 'phone' && phoneCheck.test(document.findPWForm.us_tel.value) == false) {
                alert("전화번호 형식에 맞지 않습니다");
                document.findPWForm.us_tel.focus();
                return;
            } else {
                document.findPWForm.submit();
            }
        }

        function formView(objValue) {
            if (objValue == 0) {
                $('#emailForm').css('display', 'block');
                $('#phoneForm').css('display', 'none');
                return false;
            }

            if (objValue == 1) {
                $('#emailForm').css('display', 'none');
                $('#phoneForm').css('display', 'block');
                return false;
            }
        }
    </script>
</head>

<body>

<div id="login_threejs_gooLogin_scene"></div>
<header>
    <a href="../index.html">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
    </a>
</header>

<br>
<div class="header">
    <h1 style="color: #fff; font-family: 'Roboto Condensed', sans-serif; text-spacing: -3px;">
        LET'S FIND YOUR PSSWD !
    </h1>
</div>
<br>

<div class="find_pw">
    <form method="post" action="find_pw_2.jsp" name="findPWForm" autocomplete="off">
        <input type="text" placeholder="ID NUMBER" name="us_id" class="textlogin"><br>
        <input type="text" placeholder="NAME" name="us_name" class="textlogin"><br>

        <br/>
        <input type="radio" name="findThrough" value="email" id="email" checked="true"
               onclick="javascript:formView(0);"><label for="email">이메일</label>

        <input type="radio" name="findThrough" value="phone" id="phone" onclick="javascript:formView(1);">
        <label for="phone">휴대폰 번호</label><br/>

        <input type="text" placeholder="E-MAIL" name="us_email" id="emailForm" style="margin-top:20px; margin-bottom: 10px;">
        <input type="text" placeholder="TEL NUMBER" name="us_tel" id="phoneForm" onkeyup="inputPhoneNumber(this)"
               style="display:none; margin-top: 20px; margin-bottom: 10px;">
        <br/>
        <input type="button" onclick="javascript:check();"> <!--유효성 검사 -->
    </form>

    <div class="modal-footer">
        <a href="join_user.jsp">Register</a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="../login.html">Login</a>&nbsp;&nbsp;
        <br><br>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>

<script type="text/javascript" src="../js/obj.js"></script>
<script type="text/javascript" src="../js/mtl.js"></script>
<script type="text/javascript" src="../js/inputFill.js"></script>
<script type="text/javascript" src="../js/gooLogin.js"></script>

</body>
</html>