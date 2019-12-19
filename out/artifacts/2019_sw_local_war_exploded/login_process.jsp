<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>
<%@ page import="model.Member" %>
<%@ page import="javax.servlet.*" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<%
    System.out.println("login_process.jsp 실행");

    session = request.getSession(false); // 기존에 돌아다니는 세션을 가져와서
    if (session != null) { // null이 아니면
        session.invalidate(); // 초기화해주고
    }
    session = request.getSession(true); // 새로 생성해준다.

    String login_id = (String) session.getAttribute("us_id");
    System.out.println("있어서는 안 되는 일이지만, 기존에 로그인 할 때 세션이 초기화되지 않았다면? 기존 login_id = " + login_id);

    // 사용자가 입력한 us_id, us_pw 받아오기
    String us_id = request.getParameter("us_id");
    String us_pw = request.getParameter("us_pw");

    System.out.println("login.html가 인식한 us_id: " + us_id);
    System.out.println("login.html가 인식한 us_pw: " + us_pw);

    ServletContext sc = pageContext.getServletContext();
    System.out.println("서블릿컨텍스트: " + pageContext.getServletContext().toString());

/*
    ServletContext sc = getServletContext(); // 대신에 쓸 수 있는 함수들
    ServletContext sc = pageContext.getServletContext();
    ServletContext sc = request.getSession().getServletContext();
    ServletContext sc = getServletConfig().getServletContext();
    ServletContext sc = session.getServletContext();
*/

    Member member = DBUtil.findUser(sc, us_id);
    System.out.println("us_level: " + member.getLevel() + " here");

    String isNew;
    switch (member.getLevel()) {
        case "0": // 학생 회원가입 승인 대기
        case "3": // 관리자 회원가입 승인 대기
            out.println("<script>alert('승인 대기 중입니다. 승인 문의: sungshin.coin@gmail.com'); " +
                    "history.go(-1);</script>");
            break;

        case "2": // 회원가입 승인 거절
            out.println("<script>alert('회원가입 승인이 거절되었습니다. 승인 문의: sungshin.coin@gmail.com'); " +
                    "history.go(-1);</script>");
            break;

        case "1": // 학생 회원
        case "6": // 전화번호 최초1회 인증 완료한 학생 회원
            if (member.getPasswd().equals(us_pw)) {// valid user and password

                if (session.isNew()) {
                    isNew = "새로운 세션";
                } else {
                    isNew = "기존에 로그인이 되어 있는 상태였음 (by login_id : " + login_id +") '\n'";
                    isNew += "현재 로그인 하려는 us_id = " + us_id;
                }

                System.out.println(isNew);

                session.setAttribute("us_id", us_id);
                session.setAttribute("us_pw", member.getPasswd());
                session.setAttribute("us_name", member.getName());
                session.setAttribute("us_email", member.getEmail());
                session.setAttribute("us_tel", member.getTel());

                response.sendRedirect("./reservation/st_dailyUpdateDB.jsp");

            } else { // wrong password
                out.println("<script>alert('비밀번호가 틀렸습니다.'); history.go(-1);</script>");
            }
            break;

        case "4": // 관리자 회원
            if (member.getPasswd().equals(us_pw)) {// valid user and password

                if (session.isNew()) {
                    isNew = "새로운 세션";
                } else {
                    isNew = "기존에 로그인이 되어 있는 상태였음 (by login_id : " + login_id +")";
                    isNew += "현재 로그인 하려는 us_id = " + us_id;
                }

                System.out.println(isNew);

                session.setAttribute("us_id", us_id);
                session.setAttribute("us_pw", member.getPasswd());
                session.setAttribute("us_name", member.getName());
                session.setAttribute("us_email", member.getEmail());
                session.setAttribute("us_tel", member.getTel());

                response.sendRedirect("./reservation/ad_dailyUpdateDB.jsp");

            } else { // wrong password
                out.println("<script>alert('비밀번호가 틀렸습니다.'); history.go(-1);</script>");
            }
            break;

        case "7": // 사용중지 학생 회원
        case "8": // 사용중지 관리자 회원
            out.println("<script>alert('사용이 중지된 회원입니다.'); history.go(-1);</script>");
            break;

        default: // "5"
            out.println("<script>alert('등록되지 않은 아이디입니다'); history.go(-1);</script>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>성신코인: 로그인</title>
</head>
<body>
</body>
</html>