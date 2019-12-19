<!-- 디자인할 부분 없음 -->
<!-- 회원탈퇴 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>
<%@ page import="model.Member" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>성신코인: 회원탈퇴</title>
</head>

<body>
<%!
    String id;
    ServletContext sc;

    String path;
    Member member;
    String fileName;

    int success;
%>
<%
    id = (String) session.getAttribute("us_id");

    System.out.println("memberOut.jsp 실행 (by id: " + id + ")");

    sc = request.getSession().getServletContext();

    // 학생인증 이미지 삭제를 위한 매개변수 설정
    path = request.getRealPath("userImages");
    member = DBUtil.findUser(sc, id);
    fileName = member.getUs_filename();

    success = DBUtil.memberOut(id, path, fileName);

    if (success == 1) {  // 탈퇴 실패1 (DBUtil.memberOut()의 예외 발생)
        out.println("<script>alert('회원 탈퇴가 실패되었습니다. 관리자에게 문의하세요.');</script>");
        out.println("<script>location.replace('./mypage/manage_profile.jsp');</script>");

    } else if (success == 2) { // 탈퇴 실패2
        out.println("<script>alert('현재 예약/대여/노쇼미완처리된 내역이 있거나, 페널티가 존재하여 탈퇴가 불가능합니다.');</script>");
        out.println("<script>location.replace('./mypage/manage_profile.jsp');</script>");

    } else { // 3: 탈퇴 성공
        session.invalidate(); // 기존의 세션 데이터를 모두 삭제 (로그아웃)
        out.println("<script>alert('회원 탈퇴가 완료되었습니다. 안녕히 가십시오.');</script>");
        out.println("<script>location.replace('index.html');</script>");
    }
%>

</body>
</html>