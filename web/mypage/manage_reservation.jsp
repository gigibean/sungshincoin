<!-- 학생회원의 예약 관리 -->

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

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>성신코인</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/mainForSt.css">
    <!-- <link rel="stylesheet" href="../css/st_reservation.css"> -->
    <link rel="stylesheet" href="../css/navForSt.css">
    <link rel="stylesheet" href="../css/manage_reservation.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>

    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/main.css">


    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</head>
<body>
<div id="cloud-front" class="cloud"></div>
<div class="screen"></div>


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


<header>
    <a href="../reservation/reser_stu_main.jsp">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
    </a>
</header>

<!-- navforst -->
<nav class="navForSt">
    <ul>
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
<%!
    Connection con = null;

    String sqlForList = "";
    PreparedStatement psmForList = null;
    ResultSet rsForList = null;

    String us_id;

    Integer hi_id = 0;
    String ca_name = "";
    String it_serial = "";
    String hi_book_time = "";
    Integer hi_delay = 0;
    String hi_return_time = "";
    String hi_status = "";
    Integer hi_isFriday = 0;
%>

<%--분류 라디오 버튼--%>
<div id="radioForCheck" align="center" style="padding-top: 150px;font-size: 15px;color: #fff;">
    <input type="radio" name="search" value="0" id="전체" checked="true" onclick="javascript:st_contentsView(0);">
    <label for="전체">&nbsp;&nbsp;전체&nbsp;&nbsp;</label>

    <input type="radio" name="search" value="1" id="예약완료" onclick="javascript:st_contentsView(1);">
    <label for="예약완료"> &nbsp;&nbsp; 예약완료 &nbsp;&nbsp;</label>

    <input type="radio" name="search" value="2" id="대여중" onclick="javascript:st_contentsView(2);">
    <label for="대여중">&nbsp;&nbsp;대여중&nbsp;&nbsp;</label>

    <input type="radio" name="search" value="3" id="연체" onclick="javascript:st_contentsView(3);">
    <label for="연체">&nbsp;&nbsp;연체&nbsp;&nbsp;</label>

    <input type="radio" name="search" value="4" id="노쇼" onclick="javascript:st_contentsView(4);">
    <label for="노쇼">&nbsp;&nbsp;노쇼&nbsp;&nbsp;</label>
</div>

<%
    try {
        us_id = login_id;

        System.out.println("manage_reservation.jsp 실행 (by us_id: " + us_id + ")");

        System.out.print("manage_reservation.jsp가 호출한 ");
        con = DBConnection.getCon();

        // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
        assert con != null;
        con.setAutoCommit(false);

%>

<div id="st_all"> <!-- 전체 예약건 조회 -->
    <div class="limiter">
        <div class="container-table100">
            <div class="wrap-table100">
                <div class="table">
                    <div class="row headerT">
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
                    </div>


                    <%
                        sqlForList = "SELECT * FROM history WHERE us_id = ? ORDER BY hi_id DESC";
                        psmForList = con.prepareStatement(sqlForList);
                        psmForList.setString(1, us_id);
                        rsForList = psmForList.executeQuery();

                        while (rsForList.next()) {
                            hi_id = rsForList.getInt("hi_id");
                            ca_name = rsForList.getString("ca_name");
                            it_serial = rsForList.getString("it_serial");
                            hi_book_time = rsForList.getString("hi_book_time");
                            hi_delay = rsForList.getInt("hi_delay");
                            hi_return_time = rsForList.getString("hi_return_time");
                            hi_status = rsForList.getString("hi_status");
                            hi_isFriday = rsForList.getInt("hi_isFriday");
                    %>

                    <div class="row">
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
                            if (hi_isFriday + hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일">
                            -
                        </div>
                        <%
                        } else if (hi_isFriday + hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
                        </div>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
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
                        <div class="cell" data-title="반납시간">
                            <%=hi_return_time%>
                        </div>
                        <%
                            }
                        %>
                        <%
                            switch (hi_status) {
                                case "0": // 예약 완료(default)
                        %>
                        <div class="cell" data-title="현황">
                            <form method="post" action="../reservation/st_cancelReservation.jsp" name="res1">
                                <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                <input class="btn" type="submit" name="button" value="예약취소">
                            </form>
                        </div>
                        <%
                                break;
                            case "1": // 대여 완료
                        %>
                        <div class="cell" data-title="현황">
                            대여 완료
                        </div>
                        <%
                                break;
                            case "2": // 반납완료(보증금처리 완료)
                        %>
                        <div class="cell" data-title="현황">
                            반납 완료
                        </div>
                        <%
                                break;
                            case "3": // 예약 당일 취소
                        %>
                        <div class="cell" data-title="현황">
                            예약 취소
                        </div>
                        <%
                                break;
                            case "4": // 노쇼 보증금 처리 미완료
                        %>
                        <div class="cell" data-title="현황">
                            노쇼 미완
                        </div>
                        <%
                                break;
                            case "5": // 노쇼 보증금 처리 완료
                        %>
                        <div class="cell" data-title="현황">
                            노쇼 완료
                        </div>
                        <%
                                    break;
                            }
                        %>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="st_registered" style="display:none"> <!-- 예약완료 && 대여대기 건 조회 -->

    <div class="limiter">
        <div class="container-table100">
            <div class="wrap-table100">

                <div class="table">
                    <div class="row headerT">
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
                    </div>

                    <%
                        sqlForList = "SELECT * FROM history WHERE (hi_status = '0' AND us_id = ?) ORDER BY hi_id DESC";
                        psmForList = con.prepareStatement(sqlForList);
                        psmForList.setString(1, us_id);
                        rsForList = psmForList.executeQuery();

                        while (rsForList.next()) {
                            hi_id = rsForList.getInt("hi_id");
                            ca_name = rsForList.getString("ca_name");
                            it_serial = rsForList.getString("it_serial");
                            hi_book_time = rsForList.getString("hi_book_time");
                            hi_delay = rsForList.getInt("hi_delay");
                            hi_return_time = rsForList.getString("hi_return_time");
                            hi_status = rsForList.getString("hi_status");
                            hi_isFriday = rsForList.getInt("hi_isFriday");
                    %>
                    <div class="row">
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
                            if (hi_isFriday + hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일">
                            -
                        </div>
                        <%
                        } else if (hi_isFriday + hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
                        </div>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
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
                        <div class="cell" data-title="반납시간">
                            <%=hi_return_time%>
                        </div>
                        <%
                            }
                        %>
                        <div class="cell" data-title="현황">
                            <form method="post" action="../reservation/st_cancelReservation.jsp" name="res1">
                                <input type="hidden" name="hi_id" value="<%=hi_id%>">
                                <input class="btn" type="submit" name="button" value="취소하기">
                            </form>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="st_rented" style="display:none"> <!-- 대여중인 예약건 조회 -->
    <div class="limiter">
        <div class="container-table100">
            <div class="wrap-table100">

                <div class="table">
                    <div class="row headerT">
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
                    </div>

                    <%
                        sqlForList = "SELECT * FROM history WHERE (hi_status = '1' AND us_id = ?) ORDER BY hi_id DESC";
                        psmForList = con.prepareStatement(sqlForList);
                        psmForList.setString(1, us_id);
                        rsForList = psmForList.executeQuery();

                        while (rsForList.next()) {
                            hi_id = rsForList.getInt("hi_id");
                            ca_name = rsForList.getString("ca_name");
                            it_serial = rsForList.getString("it_serial");
                            hi_book_time = rsForList.getString("hi_book_time");
                            hi_delay = rsForList.getInt("hi_delay");
                            hi_return_time = rsForList.getString("hi_return_time");
                            hi_status = rsForList.getString("hi_status");
                            hi_isFriday = rsForList.getInt("hi_isFriday");

                            System.out.println("confirm list hi_id : " + hi_id);
                    %>
                    <div class="row">
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
                            if (hi_isFriday + hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일">
                            -
                        </div>
                        <%
                        } else if (hi_isFriday + hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
                        </div>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
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
                        <div class="cell" data-title="반납시간">
                            <%=hi_return_time%>
                        </div>
                        <%
                            }
                        %>
                        <div class="cell" data-title="현황">
                            대여 완료
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="st_delayed" style="display:none"> <!-- 연체 건 조회 -->
    <div class="limiter">
        <div class="container-table100">
            <div class="wrap-table100">

                <div class="table">
                    <div class="row headerT">
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
                    </div>

                    <%
                        sqlForList = "SELECT * FROM history WHERE hi_status = '1' AND us_id = ? AND (hi_delay + hi_isFriday > 0) ORDER BY hi_id DESC";
                        psmForList = con.prepareStatement(sqlForList);
                        psmForList.setString(1, us_id);
                        rsForList = psmForList.executeQuery();

                        while (rsForList.next()) {
                            hi_id = rsForList.getInt("hi_id");
                            ca_name = rsForList.getString("ca_name");
                            it_serial = rsForList.getString("it_serial");
                            hi_book_time = rsForList.getString("hi_book_time");
                            hi_delay = rsForList.getInt("hi_delay");
                            hi_return_time = rsForList.getString("hi_return_time");
                            hi_status = rsForList.getString("hi_status");
                            hi_isFriday = rsForList.getInt("hi_isFriday");

                            System.out.println("confirm list hi_id : " + hi_id);
                    %>
                    <div class="row">
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
                            if (hi_isFriday + hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일"> -</div>
                        <%
                        } else if (hi_isFriday + hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                        </div>
                        </td>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일"><%=hi_isFriday + hi_delay%>
                        </div>
                        <%
                            }
                            if (hi_return_time == null || hi_return_time.equals("")) {
                        %>
                        <div class="cell" data-title="반납시간"><%=hi_return_time%>
                        </div>
                        <%
                        } else {
                        %>
                        <div class="cell" data-title="반납시간"><%=hi_return_time%>
                        </div>
                        <%
                            }
                        %>
                        <div class="cell" data-title="현황">대여 완료</div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="st_noShow" style="display:none"> <!-- 노쇼 조회 -->
    <
    <div class="limiter">
        <div class="container-table100">
            <div class="wrap-table100">

                <div class="table">
                    <div class="row headerT">
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
                    </div>

                    <%
                        sqlForList = "SELECT * FROM history WHERE us_id = ? AND (hi_status = '4' OR hi_status = '5') ORDER BY hi_id DESC";
                        psmForList = con.prepareStatement(sqlForList);
                        psmForList.setString(1, us_id);
                        rsForList = psmForList.executeQuery();

                        while (rsForList.next()) {
                            hi_id = rsForList.getInt("hi_id");
                            ca_name = rsForList.getString("ca_name");
                            it_serial = rsForList.getString("it_serial");
                            hi_book_time = rsForList.getString("hi_book_time");
                            hi_delay = rsForList.getInt("hi_delay");
                            hi_return_time = rsForList.getString("hi_return_time");
                            hi_status = rsForList.getString("hi_status");
                            hi_isFriday = rsForList.getInt("hi_isFriday");

                            System.out.println("confirm list hi_id : " + hi_id);
                    %>
                    <div class="row">
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
                            if (hi_isFriday + hi_delay <= 0) {
                        %>
                        <div class="cell" data-title="연체일"> -</div>
                        <%
                        } else if (hi_isFriday + hi_delay < 10) {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
                        </div>
                        <% } else {
                        %>
                        <div class="cell" data-title="연체일">
                            <%=hi_isFriday + hi_delay%>
                        </div>
                        <%
                            }

                            if (hi_return_time == null || hi_return_time.equals("")) {
                        %>
                        <div class="cell" data-title="반납시간"> -</div>

                        <%
                        } else {
                        %>
                        <div class="cell" data-title="반납시간">
                            <%=hi_return_time%>
                        </div>
                        <%
                            }
                            if (hi_status.equals("4")) {
                        %>
                        <div class="cell" data-title="현황">노쇼 미완</div>

                        <%
                        } else {
                        %>
                        <div class="cell" data-title="현황">노쇼 완료</div>

                        <%
                            }
                        %>
                    </div>
                    <%

                        }

                    %>
                </div>
            </div>
        </div>
    </div>
</div>


<%
            // SQL) COMMIT
            con.commit();

        } catch (IOException e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }

            }
            e.printStackTrace();
            System.out.println(e.getMessage());
        } finally {
            try {
                if (rsForList != null)
                    rsForList.close();
                if (psmForList != null)
                    psmForList.close();
                if (con != null)
                    con.close();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println(e.getMessage());
            }
        } // !! 버튼 누를 때 confirm()나오면 좋겠음. 시간 나면 보강하기.
    }
%>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<!-- <%--for cloud--%> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>
<script type="text/javascript" src="../js/mousewheel.js"></script>


<script src="../js/index.js"></script>
<script>
    function st_contentsView(objValue) {
        if (objValue == 0) { // 전체
            $('#st_all').css('display', 'block');
            $('#st_registered').css('display', 'none');
            $('#st_rented').css('display', 'none');
            $('#st_delayed').css('display', 'none');
            $('#st_noShow').css('display', 'none');
            return false;
        }

        if (objValue == 1) { // 예약완료
            $('#st_all').css('display', 'none');
            $('#st_registered').css('display', 'block');
            $('#st_rented').css('display', 'none');
            $('#st_delayed').css('display', 'none');
            $('#st_noShow').css('display', 'none');
            return false;
        }

        if (objValue == 2) { // 대여중
            $('#st_all').css('display', 'none');
            $('#st_registered').css('display', 'none');
            $('#st_rented').css('display', 'block');
            $('#st_delayed').css('display', 'none');
            $('#st_noShow').css('display', 'none');
            return false;
        }

        if (objValue == 3) { // 연체
            $('#st_all').css('display', 'none');
            $('#st_registered').css('display', 'none');
            $('#st_rented').css('display', 'none');
            $('#st_delayed').css('display', 'block');
            $('#st_noShow').css('display', 'none');
            return false;
        }

        if (objValue == 4) { // 노쇼
            $('#st_all').css('display', 'none');
            $('#st_registered').css('display', 'none');
            $('#st_rented').css('display', 'none');
            $('#st_delayed').css('display', 'none');
            $('#st_noShow').css('display', 'block');
            return false;
        }
    }
</script>

</body>
</html>