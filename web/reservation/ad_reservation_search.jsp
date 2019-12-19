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

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png" />
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
            <img src="../imgs/admin/logiForAdMain.png" alt="logo" style="margin-left: 60px; margin-top: 10px;"">
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
                        <img src="../imgs/admin/ic_arrow_drop_down.svg" alt="drop-down" style="float: right; margin-right: 20px;" id="dropdownImg">
                        <img src="../imgs/admin/ic_arrow_drop_up.svg" alt="drop-down" style="float: right; margin-right: 20px;" id="dropupImg">
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

        PreparedStatement psmForList = null;
        ResultSet rsForList = null;

        PreparedStatement psmGetDeposit = null;

        String us_id = "";
        String search_id = "";

        Integer hi_id = 0;
        String ca_name = "";
        String it_serial = "";
        String hi_book_time = "";
        Integer hi_delay = 0;
        String hi_return_time = "";
        String hi_status = "";
        String result_id = "";
    %>

    <form method="post" action="ad_reservation_search.jsp" name="searchReserveByUid" align="center" class="search" autocomplete="off" style="margin-top:126px;">
        <input type="text" placeholder="예약자 ID를 검색하세요" name="us_id" id="searchID">
        <input type="button" class="btn" value="검색" onClick="javascript:check()">
    </form>
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
                        try {
                            con = DBConnection.getCon();

                            us_id = request.getParameter("us_id");

                            // 예약 내역을 최신순으로 보여줌
                            String sqlForList = "SELECT * FROM history WHERE us_id LIKE ?";
                            psmForList = con.prepareStatement(sqlForList);
                            search_id = us_id;
                            search_id += "%";
                            psmForList.setString(1, search_id);
                            rsForList = psmForList.executeQuery();

                            if (!rsForList.next()) {
                                out.println("<script>alert('검색결과가 없습니다.');</script>");
                                out.println("<script>location.replace('ad_reservation.jsp');</script>");

                            } else do {
                                result_id = rsForList.getString("us_id");
                                hi_id = rsForList.getInt("hi_id");
                                ca_name = rsForList.getString("ca_name");
                                it_serial = rsForList.getString("it_serial");
                                hi_book_time = rsForList.getString("hi_book_time");
                                hi_delay = rsForList.getInt("hi_delay");
                                hi_return_time = rsForList.getString("hi_return_time");
                                hi_status = rsForList.getString("hi_status");

                                System.out.println("검색결과 us_id, hi_id : " + us_id + "," + hi_id);
                    %>
                    <div class="row">
                        <div class="cell" data-title="예약번호">
                            <%=hi_id %>
                        </div>
                        <div class="cell" data-title="예약자 ID">
                            <%=result_id%>
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
                            if (hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일">
                            -
                        </div>
                        <%
                        } else if (hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일"><%=hi_delay%>
                        </div>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일"><%=hi_delay%>
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
                        <div class="cell" data-title="반납시간"><%=hi_return_time%>
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
                    </div> <!-- row 종료 -->
                    <%
                                    } while (rsForList.next());
                            } catch (IOException | SQLException e) {
                                e.printStackTrace();
                                System.out.println(e.getMessage());
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
                                    e.printStackTrace();
                                    System.out.println(e.getMessage());
                                }
                            }
                            // !! 버튼 누를 때 confirm()나오면 좋겠음. 시간 나면 보강하기.
                        }
                    %>
                </div><%--table--%>
            </div><%--wrap table--%>
        </div><%--container table--%>
    </div><%--limiter--%>
</div><%--wrapper--%>
</body>
</html>