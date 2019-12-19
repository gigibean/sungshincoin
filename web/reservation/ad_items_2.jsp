<!-- 카테고리 추가/삭제, 물품상태 변경 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
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

    <title>성신코인: 물품관리</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png" />
<%--    <link rel="stylesheet" href="../css/ad_items.css">--%>
    <link rel="stylesheet" href="../css/ad_items_2.css">
    <link rel="stylesheet" href="../css/admin.css">

    <link rel="stylesheet" href="../css/style_reser_main_edit_ver2.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/headerStyleForAdItems.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
    <link rel="stylesheet" type="text/css" href="../Table/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/animate/animate.css">
    <link rel="stylesheet" type="text/css" href="../Table/vendor/select2/select2.min.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/util.css">
    <link rel="stylesheet" type="text/css" href="../Table/css/mainForAd.css">

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <script src="../js/index.js"></script>

</head>

<body>

<%!
    String login_id;
    String login_tel;
    String login_name;
    String login_email;
%>

<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");
    login_name = (String) session.getAttribute("us_name");
    login_email = (String) session.getAttribute("us_email");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../index.html')</script>");

    } else {
%>


<div id="wrapper">
    <div class="header">
        <%--    logo--%>
        <a href="reser_ad_main.jsp" class="hambuger fadeInLeft" style="z-index: 1001; ">
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

    <!-- 메인 -->
    <main>
        <br>
        <%!
            String ca_name = "";
            String ca_filename = "";
            int booleanCheck;

            Connection con = null;
            PreparedStatement psm = null;
            ResultSet rs = null;

            String rented_sql = "";
            String brought_sql = "";
            ResultSet rs_rented = null;
            ResultSet rs_brought = null;

            String category = "";
            String ca_deposit = "";
            String it_serial = "";
            String it_status = "";
            int rowCount = 0;

            Integer hi_id = 0;
            String us_id = "";

            int count;
            int height =1;
            int getY = 0;
        %>

        <div class="rowForCategory">
            <div class="columnCategory">
                <div class="categoryList">
                    <div class="allCategory">
                        <div class="backgroundCategory" style="margin-bottom: -5px;">
                            <svg version="1.1" baseProfile="basic" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  xml:space="preserve" preserveAspectRatio="none">
                                <rect x="0" y="80" width="300" height="150" fill="#64A7DE" rx="15" ry="15"/>
                                <text x="8%" y="80%" fill="#ffffff" stroke="none" width="100%" style="font-size: 21px; font-weight: 600;">전체 카테고리</text>
                            </svg>
                        </div>

        <%
            System.out.println("ad_items_2.jsp가 호출됨");

            try {
                System.out.print("ad_items_2.jsp가 호출한 ");
                con = DBConnection.getCon();

                String sql = "SELECT * FROM category";

                psm = con.prepareStatement(sql);
                rs = psm.executeQuery();

                count = 1;

                while (rs.next()) {
                    ca_name = rs.getString("ca_name");
                    ca_filename = rs.getString("ca_filename");

                    category = request.getParameter("ca_name");

                    if(ca_name.matches(category)) {
                        booleanCheck = 1;
                    }else {
                        booleanCheck = 0;
                    }
                    count = count + 1;

        %>
                        <div class="categoryOnOff<%=booleanCheck%>" id="<%=ca_name%>" onClick="location.replace('ad_items_2.jsp?ca_name=<%=ca_name%>');">
                            <%=ca_name%>
                        </div>

        <%
            }
                height = count * 80;
                getY = 100 - height;
        %>
                        <div class="backgroundCategory" style="width: 300px;">
                            <svg version="1.1" baseProfile="basic" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  xml:space="preserve" preserveAspectRatio="none" viewBox="0 0 300 <%=height%>">
                                <rect x="0" y="<%=getY%>" width="300" height="<%=height%>" fill="#fff" rx="15" ry="15" style="z-index: 4;">
                                </rect>
                                <text x="70%" y="30" style="cursor: pointer; z-index: 5;" fill="#585858" stroke="none" width="100%" onClick="window.open('ad_category.jsp?decision=1', '카테고리 추가하기', 'width=500,height = 200'); location.replace('ad_items.jsp');")>카테고리 추가</text>
                                <text x="70%" y="50" style="cursor: pointer; z-index: 5" fill="red" stroke="none" width="100%" onClick="window.open('ad_category.jsp?decision=2', '카테고리 삭제하기', 'width=500,height = 200');">카테고리 삭제</text>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
            <hr/>
            <div class="contents">

        <%
            rs = null;

            category = request.getParameter("ca_name");
            String sql2 = "SELECT * FROM item WHERE ca_name = ? ORDER BY it_serial ASC";

            psm = con.prepareStatement(sql2);
            psm.setString(1, category);
            rs = psm.executeQuery();
            if (rs.last()) {
                rowCount = rs.getRow();
                rs.beforeFirst();
            }

        %>
            <div class="limiter" style="margin-top: 30px;margin-right: 30px;">
                <div class="container-table100">
                    <div class="wrap-table100">
                        <div class="table">
                            <div class="row headerT">
                                <div class="cell">
                                    카테고리 ID
                                </div>
                                <div class="cell">
                                    카테고리
                                </div>
                                <div class="cell">
                                    상태
                                </div>
                                <div class="cell">
                                    예약번호
                                </div>
                                <div class="cell">
                                    예약자 ID
                                </div>
                                <div class="cell">
                                    변경
                                </div>
                            </div>
        <%
            while (rs.next()) {
                it_serial = rs.getString("it_serial");
                it_status = rs.getString("it_status");
        %>
                            <div class="row">
                                <div class="cell" data-title="물품번호">
                                    <%=it_serial%>
                                </div>
                                <div class="cell" data-title="카테고리">
                                    <%=category%>
                                </div>
        <%
            switch (it_status) {
                case "0": // 예약 가능 (default), 정상반납
        %>
                                <div class="cell" data-title="상태">
                                    예약 가능
                                </div>
                                <div class="cell" data-title="예약번호">
                                    -
                                </div>
                                <div class="cell" data-title="예약자 ID">
                                    -
                                </div>
                                <div class="cell" data-title="변경">
                                    <input type="button" name="lost" value="분실 상태로 변경"
                                           onClick="location.replace('ad_items_3.jsp?change_status=3&ca_name=<%=category%>&it_serial=<%=it_serial%>');">
                                    <input type="button" name="broken" value="고장 상태로 변경"
                                           onClick="location.replace('ad_items_3.jsp?change_status=4&ca_name=<%=category%>&it_serial=<%=it_serial%>');">
                                </div>
                            </div>
        <%
                break;

            case "1": // 예약 완료(대여/대기)
                psm = null;
                rented_sql = "SELECT hi_id, us_id FROM history WHERE ca_name = ? AND it_serial = ? AND (hi_status = '0' OR hi_status = '4') ORDER BY hi_id DESC"; // hi_status = 0: 예약완료
                psm = con.prepareStatement(rented_sql);
                psm.setString(1, category);
                psm.setString(2, it_serial);
                rs_rented = psm.executeQuery();
                rs_rented.next();
                hi_id = rs_rented.getInt("hi_id");
                us_id = rs_rented.getString("us_id");
        %>
                            <div class="cell" data-title="상태">
                                대여 가능
                            </div>
                            <div class="cell" data-title="예약번호">
                                <%=hi_id%>
                            </div>
                            <div class="cell" data-title="예약자 ID">
                                <%=us_id%>
                            </div>
                            <div class="cell" data-title="변경">
                                -
                            </div>
                        </div>

        <%
                break;

            case "2": // 대여 중, 반납 대기
                psm = null;
                brought_sql = "SELECT hi_id, us_id FROM history WHERE ca_name = ? AND it_serial = ? AND hi_status = '1' ORDER BY hi_id DESC"; // hi_status = 1: 대여완료
                psm = con.prepareStatement(brought_sql);
                psm.setString(1, category);
                psm.setString(2, it_serial);
                rs_brought = psm.executeQuery();
                rs_brought.next();
                hi_id = rs_brought.getInt("hi_id");
                us_id = rs_brought.getString("us_id");
        %>
                        <div class="cell" data-title="상태">
                            대여 중
                        </div>
                        <div class="cell" data-title="예약번호">
                            <%=hi_id%>
                        </div>
                        <div class="cell" data-title="예약자 ID">
                            <%=us_id%>
                        </div>
                        <div class="cell" data-title="변경">
                            -
                        </div>
                    </div>
        <%
                break;
            case "3": // 분실
        %>
                    <div class="cell" data-title="상태">
                        분실
                    </div>
                    <div class="cell" data-title="예약번호">
                        -
                    </div>
                    <div class="cell" data-title="예약자 ID">
                        -
                    </div>
                    <div class="cell" data-title="변경">
                        <input type="button" name="available" value="예약 가능 상태로 변경"
                               onClick="location.replace('ad_items_3.jsp?change_status=0&ca_name=<%=category%>&it_serial=<%=it_serial%>');">
                        <input type="button" name="broken" value="고장 상태로 변경"
                               onClick="location.replace('ad_items_3.jsp?change_status=4&ca_name=<%=category%>&it_serial=<%=it_serial%>');">

                    </div>
                </div>
        <%
                break;
            case "4": // 고장
        %>
                <div class="cell" data-title="상태">
                    고장
                </div>
                <div class="cell" data-title="예약번호">
                    -
                </div>
                <div class="cell" data-title="예약자 ID">
                    -
                </div>
                <div class="cell" data-title="변경">
                    <input type="button" name="available" value="예약 가능 상태로 변경"
                           onClick="location.replace('ad_items_3.jsp?change_status=0&ca_name=<%=category%>&it_serial=<%=it_serial%>');">
                    <input type="button" name="lost" value="분실 상태로 변경"
                           onClick="location.replace('ad_items_3.jsp?change_status=3&ca_name=<%=category%>&it_serial=<%=it_serial%>');">
                </div>
            </div>
        <%
                break;
            default:
        %>
        ??<br/>
        <%
            }
        %>
        <%
            } // 여기서 while문 종료
        %>
            </div>
        </div>

<div class="totalCounter">
    <p> - 총 <%=rowCount%>개 - </p>
    <form method="post" action="ad_items_4.jsp" name="addItemForm" class="totalCounterForm">
        <input type="hidden" name="category" value="<%=category%>">
        <input type="submit" value="물품 추가하기"> <br/>
    </form>
</div>
        <%
                    rowCount = 0;
                } catch (SQLException e) {
                    e.printStackTrace();
                    System.out.println(e.getMessage());
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (psm != null) psm.close();
                        if (con != null) con.close();
                        if (rs_rented != null) rs_rented.close();
                    } catch (SQLException se) {
                        System.out.println(se.getMessage());
                    }
                }
            }
        %>
    </main>
</div>
</body>
</html>