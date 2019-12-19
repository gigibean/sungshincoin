<!-- 디자인할 부분 없음 -->
<!-- 학생, 관리자 로그아웃 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>성신코인: 로그아웃</title>
</head>

<body>
<%
    // 1: 기존의 세션 데이터를 모두 삭제
    session.invalidate();

    // 2: index 페이지로 이동시킴.
    response.sendRedirect("../index.html");
%>
</body>
</html>