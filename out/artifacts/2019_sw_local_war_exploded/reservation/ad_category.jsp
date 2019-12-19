<!-- ad_items.jsp에서 '카테고리 추가하기' 또는 '카테고리 삭제하기' 버튼 누르면 뜨는 팝업 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="model.DBUtil" %>

<html>
<head>
    <title>성신코인: 물품관리</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>

    <script>
        var isNameChecked = false;

        function getNameTrueReturn() { // 카테고리명 중복 아님 (아이디 선택)
            isNameChecked = true;
        }

        function getNameFalseReturn() {
            isNameChecked = false;
        }

        var sName = "";
        var ca_nameCheck = /^[가-힣]+$/;

        function checkCategory() { // 아이디 숫자입력 + 중복 검사
            sName = document.addingCategory.ca_name.value;
            if (document.addingCategory.ca_name.value == "") {
                alert("카테고리명을 입력해주세요.");
                document.addingCategory.ca_name.focus();
                return;
            } else if (ca_nameCheck.test(document.addingCategory.ca_name.value) == false) {
                alert("카테고리명은 한글만 가능합니다.");
                document.addingCategory.ca_name.focus();
                return;
            } else {
                window.open("ad_categoryCheck.jsp?ca_name=" + document.addingCategory.ca_name.value, "카테고리명 중복 체크", "width =300,height = 200");
            }
        }

        function checkUpdate() {
            if (document.addingCategory.ca_name.value == "") {
                alert("카테고리명을 입력해주세요.");
                document.addingCategory.ca_name.focus();
                return;
            } else if (ca_nameCheck.test(document.addingCategory.ca_name.value) == false) {
                alert("카테고리명은 한글만 가능합니다.");
                document.addingCategory.us_id.focus();
                return;
            } else if (sName != document.addingCategory.ca_name.value) {
                alert('카테고리명 중복검사를 해주세요.');
                return;
            } else if (isNameChecked == false) {
                alert('카테고리명 중복검사를 해주세요.');
                return;
            } else if (document.addingCategory.fileName2.value == "") {
                alert("이미지를 첨부해주세요.");
                return;
            } else if (!isImageFile(document.addingCategory.fileName2.value)) {
                alert("이미지 파일(jpg, gif, bmp, png, svg)만 업로드 가능합니다.");
                return;
            } else if (document.addingCategory.ca_deposit.value == ""){
                alert("보증금을 입력하세요.");
                return;
            } else {
                document.addingCategory.submit();
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
    </script>
</head>
<body>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {

%>

<%
    System.out.println("ad_category.jsp 실행");
    String decision = request.getParameter("decision"); // 1: 추가하기, 2: 삭제하기

    if (decision.equals("1")) { // 1: 카테고리 추가하기
%>
<form method="post" action="ad_category_2.jsp?decision=1" name="addingCategory" enctype="multipart/form-data">
    <input type="text" placeholder="카테고리 명" name="ca_name">
    <input type="button" value="중복확인" name="categoryCheck" onClick="javascript:checkCategory()"><br/> <!-- 카테고리 중복검사-->
    카테고리 이미지를 첨부해주세요.<br>
    <input type="file" name="fileName2"> <br>
    <input type="text" placeholder="보증금(10수정구슬 이상부터 가능)" name="ca_deposit">
    <input type="button" value="카테고리 추가 완료하기" onclick="javascript:checkUpdate();"> <!--유효성 검사 -->
</form>
<%
} else { // 2: 카테고리 삭제하기
%>

<%!
    String ca_name = "";
    String ca_filename = "";
%>

삭제할 카테고리를 선택하세요.<br>
예약 가능, 예약 완료, 대여 완료 중인 물품이 존재하는 카테고리는 삭제되지 않습니다.<br>
분실, 고장 상태인 물품들만 존재하는 카테고리는 삭제 가능합니다.<br>
</bt>
<form name="selectCategory">

    <%
        Connection con = null;
        PreparedStatement psm = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getCon();
            String sql = "SELECT * FROM category"; // SQL문 한 개만 있는 파일임

            psm = con.prepareStatement(sql);
            rs = psm.executeQuery();

            while (rs.next()) {
                ca_name = rs.getString("ca_name");
                ca_filename = rs.getString("ca_filename");

    %>
    <input type="button" value="<%=ca_name%>"
           onClick="location.replace('ad_category_2.jsp?decision=2&ca_name=<%=ca_name%>');" )>
    <%
        }
    %>
</form>
<%
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
    }
%>
</body>
</html>
