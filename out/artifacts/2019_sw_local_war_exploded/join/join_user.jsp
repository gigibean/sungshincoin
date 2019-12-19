<!-- 학생, 관리자 회원가입 폼 작성 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DailyUpdate" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인: 회원가입</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/signup.css">
    <!-- <link rel="style.sheet" href="css/main.css"> -->
    <link rel="stylesheet" href="../css/navForSt.css">

    <style>
        .dropdown-item:link {
            text-decoration: none;
            color: #212529;
        }

        .dropdown-item:visited {
            text-decoration: none;
            color: #212529;
        }

        .dropdown-item:active {
            text-decoration: none;
            color: #ffffff;
        }

        .dropdown-item:focus {
            text-decoration: none;
            color: #ffffff;
        }


    </style>

    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>


<body>
<%!
    String joinDate;
%>
<%
    joinDate = DailyUpdate.getTodayDate(); // yyyy-MM-dd
%>

<div id="login_threejs_gooLogin_scene"></div>
<header>
    <a href="../index.html">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
    </a>
</header>

<br>
<div class="signup">
    <form method="post" action="ConfirmJoinUser.jsp" name="joinformUser" enctype="multipart/form-data"
          autocomplete="off">
        <div id="jfu_ra" class="process-radio">
            <div class="header">
                <input type="button" onClick="javascript:joinFormViewBack(0)" class="back" style="display:inline"> <!-- 이전 -->
                <div class="close"></div>
                <script>
                    $('.close').on('click', function() {
                        window.history.back();
                    });
                </script>
                <br><br>
                <div class="headertext">
                    <h1>SIGNUP:MAKE YOURS !</h1>
                </div>
                <div id="progress1"></div>
                <script>
                    $('#progress1').progressbar({
                        value: (100/5)*1
                    });
                </script>
            </div>
            <br><br>

            <input type="radio" name="us_level" value="0" id="student" checked> <label for="student">&nbsp;Student
            &nbsp;&nbsp;&nbsp;</label>
            <input type="radio" name="us_level" value="3" id="admin"
                   onClick="alert('관리자 ID는 학번이 아닌 숫자 8자리로 입력해주세요');"><label for="admin">&nbsp;Admin &nbsp;</label>

            <input type="button" onClick="javascript:joinFormView(0)" class="next"> <!-- 다음 -->
        </div>

        <div id="jfu_id" style="display:none" class="process-id" autocomplete="off">
            <div class="header">
                <input type="button" onClick="javascript:joinFormViewBack(1)" class="back"> <!-- 이전 -->
                <div class="close"></div>
                <script>
                    $('.close').on('click', function() {
                        window.history.back();
                    });
                </script>
                <br><br>
                <div class="headertext">
                    <h1>SIGNUP:MAKE YOURS !</h1>
                </div>
                <div id="progress2"></div>
            </div>
            <br><br>

            <input type="text" placeholder="ID NUMBER" name="us_id" id="idsignup"><br><br>
            <input type="button" value="CONFIRM" name="idcheck" onClick="javascript:checkedId()" class="idcheck"> <!--아이디중복검사-->

            <input type="button" onClick="javascript:joinFormView(1)" class="next"> <!-- 다음 -->
        </div>

        <div id="jfu_pw" style="display:none" class="process-psswd">
            <div class="header">
                <input type="button" onClick="javascript:joinFormViewBack(2)" class="back"> <!-- 이전 -->
                <div class="close"></div>
                <script>
                    $('.close').on('click', function() {
                        window.history.back();
                    });
                </script>
                <br><br>
                <div class="headertext" autocomplete="off">
                    <h1>SIGNUP:MAKE YOURS !</h1>
                </div>
                <div id="progress3"></div>
            </div>
            <br><br>

            <input type="password" placeholder="PASSWORD" name="us_pw" id="psswdsignup"><br>
            <input type="password" placeholder="PASSWORD CHECK" name="userpasswordconfirm" id="psswdcheck"><br>

            <input type="button" onClick="javascript:joinFormView(2)" class="next"> <!-- 다음 -->
        </div>

        <div id="jfu_personal" style="display:none" class="process-personal" autocomplete="off">
            <div class="header">
                <input type="button" onClick="javascript:joinFormViewBack(3)" class="back"> <!-- 이전 -->
                <div class="close"></div>
                <script>
                    $('.close').on('click', function() {
                        window.history.back();
                    });
                </script>
                <br><br>
                <div class="headertext">
                    <h1>SIGNUP:MAKE YOURS !</h1>
                </div>
                <div id="progress4"></div>
            </div>
            <br><br>

            <input type="text" placeholder="NAME" name="us_name" id="namesignup"><br>
            <input type="text" placeholder="EMAIL ADDRESS" name="us_email" id="emailsignup"><br>
            <input type="text" placeholder="PHONE NUMBER" onkeyup="inputPhoneNumber(this)" name="us_tel" id="phonesignup"><br>
            <input type="button" onClick="javascript:joinFormView(3)" class="next"> <!-- 다음 -->
        </div>

        <div id="jfu_confirm" style="display:none" class="process-file">
            <div class="header">
                <input type="button" onClick="javascript:joinFormViewBack(4)" class="back"> <!-- 이전 -->
                <div class="close"></div>
                <script>
                    $('.close').on('click', function() {
                        window.history.back();
                    });
                </script>
                <br><br>
                <div class="headertext">
                    <h1>SIGNUP:MAKE YOURS !</h1>
                </div>
                <div id="progress5"></div>
            </div>
            <br><br>

            신용정보가 가려진 학생증 이미지를 첨부해주세요.<br>
            혹은 <a href="https://acm.sungshin.ac.kr/">acm.sungshin.ac.kr</a> 로그인된 화면을 캡쳐하여 첨부해주세요.(※ 모바일 학생증 불가능)<br>

            <div class=filediv>
                <input type="file" name="fileName1" id="fileName1">
                <input class="upload-name" value="upload file" disabled="disabled">
                <label for="fileName1" id="filelabel" class="upload-name"></label>
            </div>

            <input type="hidden" name="us_date" value="<%=joinDate%>">

            <a href="javascript:openPop(1)">서비스 이용 약관 동의(필수)</a> :
            <input type="checkbox" name="checkbox1" value="check" class="checkbox"><br>
            <a href="javascript:openPop(2)"> 개인정보 수집 및 이용 동의(필수)</a> :
            <input type="checkbox" name="checkbox2" value="check" class="checkbox"><br>

            <input type="button" value="JOIN" onclick="joinFormView(4);" class="submitlast">
        </div>
    </form>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script src="../js/obj.js"></script>
<script src="../js/mtl.js"></script>
<script type="text/javascript" src="../js/inputFill.js"></script>
<script type="text/javascript" src="../js/gooLogin1.js"></script>
<script type="text/javascript" src="../js/fileuploadname.js"></script>

<script>
    var idcheck = false;

    function getTrueReturn() { // 아이디 중복 아님 (아이디 선택)
        idcheck = true;
    }

    function getFalseReturn() {
        idcheck = false;
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

    function openPop(num) {
        switch (num) {
            case 1:
                window.open('contractService.jsp', '서비스 이용 약관 동의', 'width=500, height=500');
                break;
            case 2:
                window.open('contractPrivacy.jsp', '개인정보 수집 및 이용 약관 동의', 'width=500, height=500');
                break;
        }
    }

    var uidCheck = /^[0-9]{8}$/;
    var sid = "";
    var pwCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}$/;
    var nameCheck = /^[가-힣]+$/;
    var emailCheck = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
    var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

    function checkedId() { // 아이디 숫자입력 + 중복 검사
        sid = document.joinformUser.us_id.value;
        if (document.joinformUser.us_id.value == "") {
            alert("아이디를 입력해주세요.");
            document.joinformUser.us_id.focus();
            return;
        } else if (uidCheck.test(document.joinformUser.us_id.value) == false) {
            //아이디에 숫자 8자리로 입력가능하도록 검사 (학번)
            if (document.joinformUser.us_level.value == "3") {
                alert("아이디형식은 숫자만 가능합니다. 관리자는 학번이 아닌 숫자 8자리로 입력해주세요");
            } else {
                alert("아이디형식은 숫자만 가능합니다. 학번 8자리로 입력해주세요.");
            }
            document.joinformUser.us_id.focus();
            return;
        } else {
            window.open("IdCheck.jsp?us_id=" + document.joinformUser.us_id.value, "아이디 중복 체크", "width =300,height = 200");
        }

    }

    function isImageFile(fileName) {
        var fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1);
        fileSuffix = fileSuffix.toLowerCase();
        if ("jpg" == fileSuffix || "jpeg" == fileSuffix || "gif" == fileSuffix || "bmp" == fileSuffix || "svg" == fileSuffix || "png" == fileSuffix)
            return true;
        else
            return false;
    }

    function joinFormView(objValue) {
        if (objValue == 0) {
            if (document.joinformUser.us_level.value == "") {
                alert('사용자/관리자 여부 선택을 해주세요.');
                return;
            } else {
                $('#progress2').progressbar({
                    value: (100/5)*2
                });
                $('#jfu_ra').css('display', 'none');
                $('#jfu_id').css('display', 'block');
                $('#jfu_pw').css('display', 'none');
                $('#jfu_personal').css('display', 'none');
                $('#jfu_confirm').css('display', 'none');
                return false;
            }
        }

        if (objValue == 1) {
            if (document.joinformUser.us_id.value == "") {
                alert("아이디를 입력해주세요.");
                document.joinformUser.us_id.focus();
                return;
            } else if (uidCheck.test(document.joinformUser.us_id.value) == false) {
                //아이디에 숫자 8자리로 입력가능하도록 검사 (학번)
                if (document.joinformUser.us_level.value == "3") {
                    alert("아이디형식은 숫자만 가능합니다. 관리자는 학번이 아닌 숫자 8자리로 입력해주세요");
                } else {
                    alert("아이디형식은 숫자만 가능합니다. 학번 8자리로 입력해주세요.");
                }
                document.joinformUser.us_id.focus();
                return;
            } else if (sid != document.joinformUser.us_id.value) {
                alert('아이디 중복검사를 해주세요.');
            } else if (idcheck == false) {
                alert('아이디 중복검사를 해주세요.');
            } else {
                $('#progress3').progressbar({
                    value: (100/5)*3
                });
                $('#jfu_ra').css('display', 'none');
                $('#jfu_id').css('display', 'none');
                $('#jfu_pw').css('display', 'block');
                $('#jfu_personal').css('display', 'none');
                $('#jfu_confirm').css('display', 'none');
                return false;
            }
        }

        if (objValue == 2) {
            if (document.joinformUser.us_pw.value == "") {
                alert('비밀번호를 입력해주세요.');
                return;
            } else if (pwCheck.test(document.joinformUser.us_pw.value) == false) {
                // 비밀번호에 숫자 특수문자 영어로 유효성 검사  비밀번호의 수는 6~12
                alert("비밀번호는 영어,숫자,특수문자 조합으로 해주세요.(글자수는 6~12)");
                document.joinformUser.us_pw.focus();
                return;
            } else if (document.joinformUser.userpasswordconfirm.value == "") {
                alert('비밀번호 확인을 해주세요.');
                return;
            } else if (document.joinformUser.us_pw.value != document.joinformUser.userpasswordconfirm.value) {
                //비밀번호와 비밀번호확인의 값이 다를 경우
                alert("비밀번호가 일치하지 않습니다.");
                document.joinformUser.us_pw.focus();
                return;
            } else {
                $('#progress4').progressbar({
                    value: (100/5)*4
                });
                $('#jfu_ra').css('display', 'none');
                $('#jfu_id').css('display', 'none');
                $('#jfu_pw').css('display', 'none');
                $('#jfu_personal').css('display', 'block');
                $('#jfu_confirm').css('display', 'none');
                return false;
            }
        }

        if (objValue == 3) {
            if (document.joinformUser.us_name.value == "") {
                alert('이름을 입력해주세요.');
                return;
            } else if (nameCheck.test(document.joinformUser.us_name.value) == false) {
                //이름에 한글만 가능하도록 설정
                alert("이름형식은 한글만 가능합니다.");
                document.joinformUser.us_name.focus();
                return;
            } else if (document.joinformUser.us_email.value == "") {
                alert('이메일을 입력해주세요.');
                return;
            } else if (emailCheck.test(document.joinformUser.us_email.value) == false) {
                //이메일 형식이 알파벳+숫자@알파벳+숫자.알파벳+숫자 형식이 아닐경우
                alert("이메일형식이 올바르지 않습니다.");
                document.joinformUser.us_email.focus();
                return;
            } else if (document.joinformUser.us_tel.value == "") {
                alert('전화번호를 입력해주세요.');
                return;
            } else if (phoneCheck.test(document.joinformUser.us_tel.value) == false) {
                //휴대폰 번호 유효성 검사
                alert("전화번호 형식에 맞지 않습니다");
                document.joinformUser.us_tel.focus();
                return;
            } else {
                $('#progress5').progressbar({
                    value: (100/5)*5
                });
                $('#jfu_ra').css('display', 'none');
                $('#jfu_id').css('display', 'none');
                $('#jfu_pw').css('display', 'none');
                $('#jfu_personal').css('display', 'none');
                $('#jfu_confirm').css('display', 'block');
                return false;
            }
        }

        if (objValue == 4) {
            if (document.joinformUser.fileName1.value == "") { // !! 관리자로 회원가입한다면.. 굳이..?!
                alert("이미지를 첨부해주세요.");
                return;
            } else if (!isImageFile(document.joinformUser.fileName1.value)) {
                alert("이미지 파일(jpg, gif, bmp, png, svg)만 업로드 가능합니다.");
                return;
            } else if (document.joinformUser.checkbox1.checked == false || document.joinformUser.checkbox2.checked == false) {
                alert("약관에 모두 동의해주세요");
                return;
            } else {
                document.joinformUser.submit();
            }
        }
    }

    function joinFormViewBack(objValue) {
        if (objValue == 0) {
            window.history.back();
            return false;
        }

        if (objValue == 1) {
            $('#progress1').progressbar({
                value: (100/5)*1
            });
            $('#jfu_ra').css('display', 'block');
            $('#jfu_id').css('display', 'none');
            $('#jfu_pw').css('display', 'none');
            $('#jfu_personal').css('display', 'none');
            $('#jfu_confirm').css('display', 'none');
            return false;
        }

        if (objValue == 2) {
            $('#progress2').progressbar({
                value: (100/5)*2
            });
            $('#jfu_ra').css('display', 'none');
            $('#jfu_id').css('display', 'block');
            $('#jfu_pw').css('display', 'none');
            $('#jfu_personal').css('display', 'none');
            $('#jfu_confirm').css('display', 'none');
            return false;
        }

        if (objValue == 3) {
            $('#progress3').progressbar({
                value: (100/5)*3
            });
            $('#jfu_ra').css('display', 'none');
            $('#jfu_id').css('display', 'none');
            $('#jfu_pw').css('display', 'block');
            $('#jfu_personal').css('display', 'none');
            $('#jfu_confirm').css('display', 'none');
            return false;
        }

        if (objValue == 4) {
            $('#progress4').progressbar({
                value: (100/5)*4
            });
            $('#jfu_ra').css('display', 'none');
            $('#jfu_id').css('display', 'none');
            $('#jfu_pw').css('display', 'none');
            $('#jfu_personal').css('display', 'block');
            $('#jfu_confirm').css('display', 'none');
            return false;
        }
    }

</script>
</body>
</html>