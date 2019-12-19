<!-- 디자인할 부분 없음 -->
<!-- 아이디가 존재하는 사용자인지 확인 -->

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
    <title>성신코인: 비밀번호 찾기</title>
</head>
<body>
</body>
</html>

<%!
    String us_id;
    String us_name;
    String findThrough;
    String us_email;
    String us_tel;
%>

<%
    System.out.println("find_pw_2.jsp 실행");

    us_id = request.getParameter("us_id");
    us_name = request.getParameter("us_name");

    findThrough = request.getParameter("findThrough");

    ServletContext sc = pageContext.getServletContext();
    Member member = DBUtil.findUser(sc, us_id);

    if (member.getLevel().equals("5")) {
        out.println("<script>alert('해당하는 아이디가 존재하지 않습니다.');</script>");
        out.println("<script>history.go(-1);</script>");
    } else {

        if (!member.getName().equals(us_name)) {
            out.println("<script>alert('입력정보를 확인하십시오.');</script>");
            out.println("<script>location.replace('find_pw.jsp');</script>");
        } else {

            switch (findThrough) {
                case "email":
                    us_email = request.getParameter("us_email");
                    if (member.getEmail().equals(us_email)) {
                        String rstMsg = "<script>location.replace('find_pw_3.jsp?us_id=";
                        rstMsg += us_id;
                        rstMsg += "');</script>";
                        out.println(rstMsg);

                    } else {
                        out.println("<script>alert('이메일주소를 다시 확인해주십시오.');</script>");
                        out.println("<script>location.replace('find_pw.jsp');</script>");
                    }
                    break;

                case "phone":
                    us_tel = request.getParameter("us_tel");
                    if (member.getTel().equals(us_tel)) {
                        String rstMsg = "<script>location.replace('find_pw_3.jsp?us_id=";
                        rstMsg += us_id;
                        rstMsg += "');</script>";
                        out.println(rstMsg);

                    } else {
                        out.println("<script>alert('전화번호를 다시 확인해주십시오.');</script>");
                        out.println("<script>location.replace('find_pw.jsp');</script>");
                    }
                    break;
            }
        }
    }
%>