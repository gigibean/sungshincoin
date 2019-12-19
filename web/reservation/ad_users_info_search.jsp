<!-- 검색 결과 -->

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
        function check() {
            var uidCheck = /^[0-9]{8}$/;

            if (document.searchUserById.us_id.value == "") {
                alert("아이디를 입력해주세요.");
                document.searchUserById.us_id.focus();
                return;
            } else if (uidCheck.test(document.searchUserById.us_id.value) == false) {
                alert("아이디를 올바르게 입력해주세요.");
                document.searchUserById.us_id.focus();
                return;
            } else {
                document.searchUserById.submit();
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
                <p>성신코인: 회원관리<br><%=login_name %>
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

    <!-- 내브바 버튼 -->
    <button type="button" class="hamburger is-closed animated fadeInLeft" data-toggle="offcanvas">
        <span class="hamb-top"></span>
        <span class="hamb-middle"></span>
        <span class="hamb-bottom"></span>
    </button>

        <%!
            Connection con = null;

            PreparedStatement psmSearch = null;
            ResultSet rsSearch = null;

            PreparedStatement psmGetDeposit = null;

            String us_id;

            String us_name;
            String us_email;
            String us_tel;
            String us_filename;
            String us_level;
            String us_date;
            Integer us_black_count;
        %>

    <!-- 메인 -->

    <main style="margin-top:80px; margin-bottom: 100px;"><br>

        <%--검색창--%>
        <form method="post" action="ad_users_info_search.jsp" name="searchUserById" align="center" class="search"
              autocomplete="off">
            <input type="text" placeholder="예약자 ID를 검색하세요" name="us_id" id="searchID">
            <input type="button" class="btn" value="검색" onClick="javascript:check()">
        </form>

        <%--table--%>
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
                                학생인증 이미지
                            </div>
                            <div class="cell">
                                회원레벨
                            </div>
                            <div class="cell">
                                가입/탈퇴
                            </div>
                            <div class="cell">
                                페널티
                            </div>
                            <div class="cell">
                                처리
                            </div>
                        </div>

            <%
                System.out.println("ad_users_info_search.jsp 실행");

                try {
                    System.out.print("ad_users_info_search.jsp가 호출한 ");
                    con = DBConnection.getCon();

                    us_id = "%";
                    us_id += request.getParameter("us_id");
                    us_id += "%";

                    String sqlSearch = "SELECT * FROM user WHERE us_id LIKE '" + us_id +"'";
                    psmSearch = con.prepareStatement(sqlSearch);
                    // psmSearch.setString(1, us_id);
                    rsSearch = psmSearch.executeQuery();

                    if (!rsSearch.next()) {
                        out.println("<script>alert('검색결과가 없습니다.');</script>");
                        out.println("<script>location.replace('ad_users_info.jsp');</script>");

                    } else {
                        rsSearch.beforeFirst();

                        while (rsSearch.next()) {
                        us_id = rsSearch.getString("us_id");
                        us_name = rsSearch.getString("us_name");
                        us_email = rsSearch.getString("us_email");
                        us_tel = rsSearch.getString("us_tel");
                        us_filename = rsSearch.getString("us_filename");
                        us_level = rsSearch.getString("us_level");
                        us_date = rsSearch.getString("us_date");
                        us_black_count = rsSearch.getInt("us_black_count");

                        System.out.println("검색결과 us_id : " + us_id);
            %>
                        <div class="row">
                            <div class="cell" data-title="아이디">
                                <%=us_id %>
                            </div>
                            <div class="cell" data-title="이름">
                                <%=us_name %>
                            </div>
                            <div class="cell" data-title="이메일">
                                <%=us_email %>
                            </div>
                            <div class="cell" data-title="전화번호">
                                <%=us_tel%>
                            </div>
                            <div class="cell" data-title="학생인증 이미지">
                                <a href="fileDown.jsp?file_name=<%=us_filename%>"><%=us_filename%>
                                </a>
                            </div>

                                <%
                                switch (us_level) {
                                    case "0": // 학생회원 대기
                            %>
                            <div class="cell" data-title="회원레벨">
                                학생 승인 대기
                            </div>
                                <%
                                    break;
                                case "1": // 학생회원 - 전화번호 인증 미완료
                            %>
                            <div class="cell" data-title="회원레벨">
                                학생(전번 인증 미완료)
                            </div>
                                <%
                                    break;
                                case "2": // 승인 거절
                            %>
                            <div class="cell" data-title="회원레벨">
                                승인 거절
                            </div>
                                <%
                                    break;
                                case "3": // 관리자 회원 대기
                            %>
                            <div class="cell" data-title="회원레벨">
                                관리자 승인 대기
                            </div>
                                <%
                                    break;
                                case "4": // 관리자 회원 승인
                            %>
                            <div class="cell" data-title="회원레벨">
                                관리자 승인 완료
                            </div>
                                <%
                                    break;
                                    case "5": // 탈퇴 회원
                                %>
                            <div class="cell" data-title="회원레벨">
                                탈퇴 회원
                            </div>
                            <%
                                    break;
                                case "6": // 학생회원 - 전화번호 인증 완료
                            %>
                            <div class="cell" data-title="회원레벨">
                                학생(전번 인증 완료)
                            </div>
                                <%
                                    break;
                                case "7": //사용중지된 학생 회원
                            %>
                            <div class="cell" data-title="회원레벨">
                                사용 중지 학생
                            </div>
                                <%
                                    break;
                                case "8": // 사용중지된 관리자 회원
                            %>
                            <div class="cell" data-title="회원레벨">
                                사용 중지 관리자
                            </div>
                                <%
                                        break;
                                    default:
                                        System.out.println("있어선 안 되는 회원레벨");
                                }
                            %>

                            <div class="cell" data-title="가입/탈퇴">
                                <%=us_date%>
                            </div>

                            <%
                                if (!us_level.equals("5")) { // 탈퇴회원이 아닌 경우우
                            %>
                            <div class="cell" data-title="페널티">
                                <%=us_black_count%>개
                            </div>
                            <div class="cell" data-title="처리">
                                <form method="post" action="ad_users_info_2.jsp" name="res3">
                                    <input type="hidden" name="us_id" value="<%=us_id%>">
                                    <input type="hidden" name="us_name" value="<%=us_name%>">
                                    <input type="hidden" name="us_email" value="<%=us_email%>">
                                    <input type="hidden" name="us_tel" value="<%=us_tel%>">
                                    <input type="hidden" name="us_level" value="<%=us_level%>">
                                    <input class="btn" type="submit" name="button" value="선택">
                                </form>
                            </div>
                            <%
                            } else { // 탈퇴회원인 경우
                            %>
                            <div class="cell" data-title="페널티">
                                -
                            </div>
                            <div class="cell" data-title="처리">
                                -
                            </div>
                            <%
                                }
                            %>
                        </div>
        <%
                    } // while문 종료
                    }
                } catch (IOException | SQLException e) {
                    e.printStackTrace();
                    System.out.println(e.getMessage());
                }  finally {
                    try {
                        if (rsSearch != null)
                            rsSearch.close();
                        if (psmSearch != null)
                            psmSearch.close();
                        if (psmGetDeposit != null)
                            psmGetDeposit.close();
                        if (con != null)
                            con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.out.println(e.getMessage());
                    }
                }
            }
        %>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>