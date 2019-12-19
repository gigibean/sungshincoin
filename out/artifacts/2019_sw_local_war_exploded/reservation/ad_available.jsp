<!-- 디자인할 부분 없음 -->
<!-- 회원 사용중지/사용재개 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>
<%@ page import="java.io.IOException" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%!
    String login_id;
    String login_tel;
%>
<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    Connection con = null;
    PreparedStatement psm = null;

    String us_id;
    String decision;
    String us_level;
%>

<%
        System.out.println("ad_available.jsp 실행");

        us_id = request.getParameter("us_id");
        decision = request.getParameter("decision");
        us_level = request.getParameter("us_level");

        try {
            con = DBConnection.getCon();

            // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
            assert con != null;
            con.setAutoCommit(false);

            String sql;

            if (decision.equals("1")) { // 1: 사용중지된 회원들 -> 사용재개
                switch (us_level) {
                    case "7": // 사용중지된 학생 회원
                        sql = "UPDATE user SET us_level = '0' WHERE us_id = ?";
                        psm = con.prepareStatement(sql);
                        psm.setString(1, us_id);
                        psm.executeUpdate();
                        out.println("<script>alert('학생 회원의 승인 이후 정상적인 사용재개가 가능합니다.');</script>");
                        break;

                    case "8": // 사용중지된 관리자 회원
                        sql = "UPDATE user SET us_level = '3' WHERE us_id = ?";
                        psm = con.prepareStatement(sql);
                        psm.setString(1, us_id);
                        psm.executeUpdate();
                        out.println("<script>alert('관리자 회원의 승인 이후 정상적인 사용재개가 가능합니다.');</script>");
                        break;
                }

            } else { // 2: 사용중인 회원들 -> 사용중지
                if (us_id.equals(login_id)) {
                    out.println("<script>alert('본인에 대해서 사용중지 처리할 수 없습니다.');</script>");
                } else if (DBUtil.checkUsB4LevelDown(us_id)){
                    out.println("<script>alert('예약 중인 내역이 있어서 사용중지 처리할 수 없습니다.');</script>");
                } else {
                    switch (us_level) {
                        case "1": // 학생회원 승인
                        case "6": // 학생회초1회 본인인증 완료
                            sql = "UPDATE user SET us_level = '7' WHERE us_id = ?";
                            psm = con.prepareStatement(sql);
                            psm.setString(1, us_id);
                            psm.executeUpdate();
                            out.println("<script>alert('학생 회원의 사용중지 처리가 완료되었습니다.');</script>");
                            break;

                        case "4": // 관리자 회원 승인
                            sql = "UPDATE user SET us_level = '8' WHERE us_id = ?";
                            psm = con.prepareStatement(sql);
                            psm.setString(1, us_id);
                            psm.executeUpdate();
                            out.println("<script>alert('관리자 회원의 사용중지 처리가 완료되었습니다.');</script>");
                            break;
                    }
                }
            }

            // SQL) COMMIT
            con.commit();

            out.println("<script>location.replace('ad_users_info.jsp');</script>");

        } catch (IOException | SQLException e1) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException e2) {
                    System.out.println("ad_available.jsp: 회원 사용중지/재개 처리 실패");
                    e2.printStackTrace();
                    System.out.println(e2.getMessage());
                }
            }
            System.out.println("ad_available.jsp: 회원 사용중지/재개 처리 실패");
            e1.printStackTrace();
            System.out.println(e1.getMessage());
        } finally {
            try {
                if (psm != null)
                    psm.close();
                if (con != null)
                    con.close();
            } catch (SQLException e3) {
                System.out.println("ad_available.jsp: 회원 사용중지/재개 처리 실패");
                e3.printStackTrace();
                System.out.println(e3.getMessage());
            }
        }
    }
%>

</body>
</html>
