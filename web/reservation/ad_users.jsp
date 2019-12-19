<!-- 관리자 메인 페이지(reser_ad_main.jsp)에서 '회원 승인' -->

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

    <title>성신코인: 회원관리</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <%--    <link rel="stylesheet" href="../css/reser_ad_main.css">--%>
    <link rel="stylesheet" href="../css/style_reser_main.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
    <link rel="stylesheet" href="../css/ad_user.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
    <link rel="stylesheet" href="../css/header_style.css">

    <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
    <script src="../js/index.js"></script>

    <script type="text/javascript">
        function imgDown(us_filename) {
            window.location.href = "fileDown.jsp?file_name=" + us_filename;
        }
    </script>
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
        out.println("<script>location.replace('../login.html')</script>");

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

        <ul class="nav sidebar-nav"><br>
            <div class="sidebar-brand">
                <p>성신코인 관리자 <br/><%=login_name %>
                </p><br/>
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
            <li><a href="ad_users.jsp"><img src="../imgs/admin/Outbox.svg"> &nbsp; 가입승인</a></li>
            <li><a href="ad_reservation.jsp"><img src="../imgs/admin/Updates.svg"> &nbsp; 예약관리</a></li>
            <li><a href="ad_items.jsp"><img src="../imgs/admin/Promos.svg"> &nbsp; 물품관리</a></li>
            <li><a href="ad_users_info.jsp"><img src="../imgs/admin/Social.svg">&nbsp; 회원정보</a></li>
            <li><a href="../logout.jsp"><i class="fa fa-fw fa-twitter"></i> 로그아웃</a></li>
        </ul>
    </nav>

    <!-- 내브바 버튼 -->
    <button type="button" class="hamburger is-closed animated fadeInLeft" data-toggle="offcanvas">
        <span class="hamb-top"></span>
        <span class="hamb-middle"></span>
        <span class="hamb-bottom"></span>
    </button>

    <!-- 메인 -->
    <h5 align="center">회원가입 미승인 + 거절 사용자들 목록</h5>
    <h3>회원가입 정보 확인</h3>
    <%!
        String us_id = "";
        String us_name = "";
        String us_email = "";
        String us_filename = "";
        String us_tel = "";
        String us_level = "";
        String us_date = "";
    %>
    <%
        System.out.println("관리자 메인에서 '회원 승인' 클릭 => ad_users.jsp 실행 시작");

        // (회원가입 승인을 위한) db 에서 회원목록 얻어와 테이블에 출력하기.
        Connection con = null;
        PreparedStatement psm = null;
        ResultSet rs = null;
        String savePath = "userImages";

        try {
            con = DBConnection.getCon(); // SQL문 한 개만 있는 파일임

            String sqlCheck = "SELECT COUNT(*) AS number FROM user WHERE us_level = '0' OR us_level = '3' OR us_level = '2'";
            psm = con.prepareStatement(sqlCheck);
            rs = psm.executeQuery();
            rs.next();
            if (rs.getInt("number") == 0) {
    %>

    <div class="usercardlist">
      <span class="usercard">
    -표시할 사용자가 없습니다.-
      </span>
    </div>

    <%
    } else {

        String sql = "SELECT us_id, us_name, us_email, us_tel, us_filename, us_level, us_date " +
                "FROM user " +
                "WHERE us_level = '0' OR us_level = '3' OR us_level = '2'";
        psm = con.prepareStatement(sql);
        rs = psm.executeQuery();
    %>
    <div class="usercardlist">
        <%
            while (rs.next()) {
                us_id = rs.getString("us_id");
                us_name = rs.getString("us_name");
                us_email = rs.getString("us_email");
                us_tel = rs.getString("us_tel");
                us_filename = rs.getString("us_filename");
                us_level = rs.getString("us_level");
                us_date = rs.getString("us_date");
        %>

        <span class="usercard">
          <form method="post" action="ad_users_2.jsp" name="manageUser">
                <div class="eachphoto" style="height: 262.4px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="400" height="262.4" viewBox="0 0 400 262.4"
                         preserveAspectRatio="xMidYMid slice" focusable="false" role="img"
                         aria-label="Placeholder: Thumbnail">
                        <path id="cardForuserimg"
                              d="M15,0H385a15,15,0,0,1,15,15V262.4a0,0,0,0,1,0,0H0a0,0,0,0,1,0,0V15A15,15,0,0,1,15,0Z"
                              fill="#ddd"/>
                        <image xlink:href="/userImages/<%=us_filename%>" alt="여기에 뜨지 않으면 다운로드하세요" x="0" y="0"
                               width="400"
                               height="262.4"/>
                    </svg>
                </div>

                <div class="eachcard">
                    학번 : <%=us_id%>&nbsp;&nbsp;이름 : <%=us_name%><br/>
                    가입날짜 : <%=us_date%><br/>
                    이메일 : <a href="mailto:<%=us_email%>"><%=us_email%></a> <br/>
                    전화번호 : <%=us_tel%><br/>
                    학생인증 이미지 다운로드 : <a href="/userImages/<%=us_filename%>"><%=us_filename%> </a><br/>

                    <input type="hidden" name="us_id" value="<%=us_id%>">

        <%
            if (us_level.equals("0")) { // 학생 사용자로 가입 신청
        %>
                    <label for="stuLevelUp"> 학생 가입 승인</label>
                    <input type="radio" name="level" value="1" id="stuLevelUp" checked>
                    <label for="stuLevelDown"> 가입 거절 </label>
                    <input type="radio" name="level" value="2" id="stuLevelDown">
        <%
        } else if (us_level.equals("3")) { // 관리자 사용자로 가입 신청
        %>
                    <label for="adminLevelUp"> 관리자 가입 승인</label>
                    <input type="radio" name="level" value="4" id="adminLevelUp" checked>
                    <label for="adminLevelDown"> 가입 거절 </label>
                    <input type="radio" name="level" value="3" id="adminLevelDown">
        <%
        } else {  // 가입 거절된 사람 (us_level = 2인 사용자) => (회원가입 다시 할 수 있도록 회원탈퇴 시켜야 함)
        %>
                    <label for="deleteUser"> 승인 거절된 회원 - 재회원가입을 위한 탈퇴 조치 </label>
                    <input type="radio" name="level" value="5" id="deleteUser">
        <% }
        %>
                </div> <!-- eachcard 클래스 끝 -->

              <div class="eachbutton">
                  <input class="processdonebtn" type="submit" value="처리">
              </div>
        </form>
      </span>

        <%
            } // 여기서 while문 종료
        %>

    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println(e.getMessage());
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (psm != null) psm.close();
                    if (con != null) con.close();
                } catch (SQLException se) {
                    System.out.println(se.getMessage());
                }
            }
        }
    %>
</div>
</div>

<!-- cdn & script -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/gsap/1.19.1/TweenMax.min.js'></script>
<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
<script type="text/javascript" src="../js/dropDown.js"></script>

</body>
</html>