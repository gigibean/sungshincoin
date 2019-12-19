<!-- 디자인할 부분 없음 -->
<!-- 사용자 승인/거절/탈퇴 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>성신코인: 회원관리</title>
</head>
<body>
</body>
</html>

<%
    String login_id = (String) session.getAttribute("us_id");
    String login_tel = (String) session.getAttribute("us_tel");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");
    } else {
%>

<%
        String us_id = request.getParameter("us_id");
        String level = request.getParameter("level");
        ServletContext sc = request.getSession().getServletContext();
        switch (level) {
            case "1": // 학생 가입 승인 완료 (0에서 1로)
                DBUtil.levelChangeMember(sc, us_id, "1");
                out.println("<script>alert('학생 가입 승인 완료'); " +
                        "location.replace('ad_users.jsp'); </script>");
                break;
            case "2": // 학생 가입 승인 거절 (0에서 2로)
                DBUtil.levelChangeMember(sc, us_id, "2");
                out.println("<script>alert('학생 가입 승인 거절');" +
                        "location.replace('ad_users.jsp');</script>");
                break;
            case "4": // 관리자 가입 승인 완료 (3에서 4로)
                DBUtil.levelChangeMember(sc, us_id, "4");
                out.println("<script>alert('관리자 가입 승인 완료');" +
                        "location.replace('ad_users.jsp');</script>");
                break;
            case "3": // 관리자 가입 승인 거절 (3에서 2로)
                DBUtil.levelChangeMember(sc, us_id, "2");
                out.println("<script>alert('관리자 가입 승인 거절');" +
                        "location.replace('ad_users.jsp');</script>");
                break;
            case "5": // 회원 탈퇴
                out.println("<script>location.replace('memberOut.jsp');</script>");
                break;
//        case "6":
//            out.println("<script>alert('다음 사용자');" +
//                    "location.replace('ad_users.jsp');</script>");
//            break;
            default:
                out.println("<script>alert('있어서는 안 되는 일이 발생함');" +
                        "location.replace('ad_users.jsp');</script>");
//            out.println("<script>alert('있어서는 안 되는 일이 발생함');loadPage('ad_users.jsp');</script>");
        }
    }
%>