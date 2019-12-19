<!-- 개인정보 수정-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/manage_profile.css">
    <link rel="stylesheet" href="../css/navForSt.css">

    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

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

        var pwCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,16}$/;
        var emailCheck = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
        var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

        function check() {
            if (document.changeFormUser.us_email_new.value != "") {
                if (emailCheck.test(document.changeFormUser.us_email_new.value) == false) {
                    alert("이메일형식이 올바르지 않습니다.");
                    document.changeFormUser.us_email_new.focus();
                    return;
                }
            }

            if (document.changeFormUser.us_tel_new.value != "") {
                if (phoneCheck.test(document.changeFormUser.us_tel_new.value) == false) {
                    alert("전화번호 형식에 맞지 않습니다");
                    document.changeFormUser.us_tel_new.focus();
                    return;
                }
            }

            if (document.changeFormUser.us_pw_new.value != "") {
                if (pwCheck.test(document.changeFormUser.us_pw_new.value) == false) {
                    alert("비밀번호는 영어,숫자,특수문자 조합으로 해주세요.(글자수는 6~12)");
                    document.changeFormUser.us_pw_new.focus();
                    return;
                }
                if (document.changeFormUser.us_pw_confirm.value == "") {
                    alert('비밀번호 확인을 해주세요.');
                    return;
                }
                if (document.changeFormUser.us_pw_new.value != document.changeFormUser.us_pw_confirm.value) {
                    alert("비밀번호가 일치하지 않습니다.");
                    document.changeFormUser.us_pw_new.focus();
                    return;
                }
            }

            if (document.changeFormUser.us_email_new.value == "" && document.changeFormUser.us_tel_new.value == "" && document.changeFormUser.us_pw_new.value == "") {
                alert("변경사항이 없습니다.");
                return;
            } else {
                if (confirm('정말로 변경하시겠습니까?'))
                    document.changeFormUser.submit();
                else
                    return;
            }
        }

        $("#infoChange").on('propertychange change keyup paste input', function () {
            if ($(this).val().length != 0) {
                $(this).css({
                    opacity: 1,
                })
            } else {
                $(this).css({
                    opacity: 0.7,
                })
            }
        });

        function memberOutLastCheck() {
            if (confirm('정말로 탈퇴하시겠습니까? 확인을 누르시면 계정을 복구할 수 없습니다.')) {
                location.href = "../memberOut.jsp";
            }
        }
    </script>
</head>
<body>

<%!
    String login_id;
    String login_tel;
%>
<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");

    if (login_id == null || !DBUtil.assureStudent(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<div id="login_threejs_gooLogin_scene"></div>
<div id="cloud-front" class="cloud"></div>

<span class="suryong">
        <img src="/designImages/suryong_marble@2x.png" alt="suryong">
</span>

<%!
    Connection con;
    PreparedStatement psm;
    ResultSet rs;

    String us_id;

    String us_name;
    String us_email;
    String us_tel;
%>

<%
    System.out.println("manage_profile.jsp 실행 (by us_id : " + us_id + ")");

    us_id = login_id;

    try {
        System.out.print("manage_profile.jsp가 호출한 ");
        con = DBConnection.getCon(); // SQL문 한 개만 있는 파일임

        String sql = "SELECT * FROM user WHERE us_id = ?";
        psm = con.prepareStatement(sql);
        psm.setString(1, us_id);
        rs = psm.executeQuery();

        if (rs.next()) {
            us_name = rs.getString("us_name");
            us_email = rs.getString("us_email");
            us_tel = rs.getString("us_tel");
%>
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
                <a class="dropdown-item" href="mypage.jsp">마이페이지</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="../logout.jsp">로그아웃</a>

            </div>
        </div>

        <li><a href="../reservation/reser_stu_main.jsp">예약하기</a></li>
        <li><a href="../mypage/exchange_sujung.jsp">환전하기</a></li>
    </ul>
</nav>
<br>

<div class="maincard">
    <div class="header">
        <img src="/designImages/iconprofile.svg" alt="profile">
        <h3>개인정보수정</h3>
    </div>

    <form method="post" action="manage_profile_2.jsp" name="changeFormUser" class="change" id="infoChange"
          autocomplete="off">
        <input type="text" placeholder="<%=us_name%>" name="us_name" disabled> <br/>
        <input type="text" placeholder="<%=us_id%>" name="us_id" disabled> <br/>
        <input type="text" placeholder="<%=us_email%>" name="us_email_new"> <br/>
        <input type="text" placeholder="<%=us_tel%>" name="us_tel_new" onkeyup="inputPhoneNumber(this)"> <br/>
        <input type="password" placeholder="Change Password" name="us_pw_new"> <br/>
        <input type="password" placeholder="Check Password" name="us_pw_confirm"> <br>
        <input type="button" value="변경 완료" class="submitlast" onClick="javascript:check();">
        <input type="button" value="회원탈퇴" class="submitlast" onClick="javascript:memberOutLastCheck();">
    </form>
</div>

<%
        }
    } catch (Exception e) {
        out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
        System.out.println("manage_profile.jsp 예외 발생 1");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null)
                rs.close();
            if (psm != null)
                psm.close();
            if (con != null)
                con.close();
        } catch (SQLException e) {
            out.println("<script>alert('생각치 못한 예외가 발생하였습니다. 개발자에게 문의하세요.');</script>");
            System.out.println("manage_profile.jsp 예외 발생 2");
            e.printStackTrace();
        }
    }
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script src="../js/obj.js"></script>
<script src="../js/mtl.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>
<script type="text/javascript" src="../js/gooManage.js"></script>

<%
    }
%>

</body>
</html>