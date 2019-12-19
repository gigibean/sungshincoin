<!-- 디자인할 부분 없음 -->
<!-- 페널티 지불하기 처리되는 부분 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<%@ page import="model.DBUtil" %>
<%@ page import="model.Member" %>

<html>
<head>
    <title>성신코인</title>
    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
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

<%!
    ServletContext sc;
    double penalty = 0.0;
%>

<%
    System.out.println("manage_penalty.jsp 실행");

    sc = request.getSession().getServletContext();
    Member member = DBUtil.findUser(sc, login_id);
    penalty = member.getUs_black_count();

    if (penalty > 0.0) {
        String rst = "<script>location.replace('../reservation/st_bill.jsp?ca_name=페널티&penalty=";
        rst += penalty;
        rst += "&deposit=0.0');</script>";
        out.print(rst);

    } else {
        out.print("<script>alert('지불할 페널티가 없습니다.');</script>");
        out.print("<script>location.replace('manage_sujung.jsp');</script>");
    }
%>

<%
    }
%>
</body>
</html>