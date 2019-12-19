<!-- 회원정보 수정 사항 입력 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인: 회원정보</title>

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
            var nameCheck = /^[가-힣]+$/;
            var emailCheck = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
            var phoneCheck = /^\d{3}-\d{3,4}-\d{4}$/;

            if (document.changeInfoForm.us_name.value == "" && document.changeInfoForm.us_email.value == "" && document.changeInfoForm.us_tel.value == "") {
                alert("변경사항이 없습니다.");
                return;
            }

            if (document.changeInfoForm.us_name.value != "") {
                if (nameCheck.test(document.changeInfoForm.us_name.value) == false) {
                    alert("이름형식은 한글만 가능합니다.");
                    document.changeInfoForm.us_name.focus();
                    return;
                }
            }

            if (document.changeInfoForm.us_email.value != "") {
                if (emailCheck.test(document.changeInfoForm.us_email.value) == false) {
                    alert("이메일형식이 올바르지 않습니다.");
                    document.changeInfoForm.us_email.focus();
                    return;
                }
            }

            if (document.changeInfoForm.us_tel.value != "") {
                if (phoneCheck.test(document.changeInfoForm.us_tel.value) == false) {
                    alert("전화번호 형식에 맞지 않습니다");
                    document.changeInfoForm.us_tel.focus();
                    return;
                }
            }

            if (confirm('정말로 변경하시겠습니까?')) {
                document.changeInfoForm.submit();
            }
        }

    </script>
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
            <img src="../imgs/admin/logiForAdMain.png" alt="logo" style="margin-left: 60px; margin-top: 10px;">
        </a>
    </div>

    <!-- 내브바 -->
    <nav class="navbar navbar-inverse navbar-fixed-top"
         id="sidebar-wrapper" role="navigation">
        <ul class="nav sidebar-nav">
            <br>
            <div class="sidebar-brand">
                <p>성신코인 관리자 <br/><%=login_name %></p>
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
                <li><a href="#"><i class="fa fa-fw fa-file-o"></i> 관리자 : test_admin
                </a></li>
                <li><a href="#"><i class="fa fa-fw fa-file-o"></i> 전화번호 : 010-123-4123
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
            String us_id;
            String us_name;
            String us_email;
            String us_tel;
            String us_level;
        %>

    <main style="margin-top:80px; margin-bottom: 100px;">
        <br>
        <form method="post" action="ad_users_info_4.jsp" name="changeInfoForm">
            <div class="limiter">
                <div class="container-table100">
                    <div class="wrap-table100">

                        <div class="table">
                            <div class="row headerT">
                                <div class="cell">
                                    아이디
                                </div>
                                <div class="cell">
                                    이름
                                </div>
                                <div class="cell">
                                    이메일
                                </div>
                                <div class="cell">
                                    전화번호
                                </div>
                                <div class="cell">
                                    수정
                                </div>
                                <div class="cell">
                                    회원강등
                                </div>
                            </div>


            <%
                System.out.println("ad_users_info_2.jsp 실행");

                us_id = request.getParameter("us_id");
                us_name = request.getParameter("us_name");
                us_email = request.getParameter("us_email");
                us_tel = request.getParameter("us_tel");
                us_level = request.getParameter("us_level");

            %>
                            <div class="row">
                                <input type="hidden" name="us_level" value="<%=us_level%>">
                                <input type="hidden" name="us_id" value="<%=us_id%>">
                                <div class="cell" data-title="아이디">
                                    <%=us_id%>
                                </div>
                                <div class="cell" data-title="이름">
                                    <input type="text" name="us_name" placeholder="<%=us_name%>">
                                </div>
                                <div class="cell" data-title="이메일">
                                    <input type="text" name="us_email" placeholder="<%=us_email%>">
                                </div>
                                <div class="cell" data-title="전화번호">
                                    <input type="text" name="us_tel" placeholder="<%=us_tel%>"
                                           onkeyup="inputPhoneNumber(this)">
                                </div>
                                <div class="cell" data-title="수정">
                                    <input class="btn" type="button" value="완료" onclick="javascript:check();">
                                </div>

                    <%
                        switch (us_level) {
                            case "0": // 학생회원 대기
                            case "3": // 관리자 회원 대기
                    %>
                                <div class="cell" data-title="회원강등">
                                    <input class="btn" type="button" value="승인/거절" onClick="location.replace('ad_users.jsp')">
                                </div>
                    <%
                            break;

                        case "2": // 승인 거절
                    %>

                                <div class="cell" data-title="회원강등">
                                    <input class="btn" type="button" value="탈퇴" onClick="location.replace('ad_users.jsp')">
                                </div>
                    <%
                            break;

                        case "5": // 로그인 실패(유령), 탈퇴회원
                    %>

                    <td> -</td>

                    <%
                            break;

                        case "1": // 학생회원 승인
                        case "6": // 학생회초1회 본인인증 완료
                        case "4": // 관리자 회원 승인
                    %>
                                <div class="cell" data-title="회원강등">
                                    <input class="btn" type="button" value="사용중지" onClick="location.replace('ad_available.jsp?us_id=<%=us_id%>&decision=2&us_level=<%=us_level%>')">
                                </div>
                    <%
                            break;

                        case "7": // 사용중지된 학생 회원
                        case "8": // 사용중지된 관리자 회원
                    %>
                                <div class="cell" data-title="회원강등">
                                    <input class="btn" type="button" value="사용재개" onClick="location.replace('ad_available.jsp?us_id=<%=us_id%>&decision=1&us_level=<%=us_level%>')">
                                </div>

                    <%
                            }
                        }
                    %>
                </form>
            </tr>
        </table>
    </main>
</div>
</body>
</html>
