<!-- 디자인할 부분 없음 -->

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
    <title>성신코인</title>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
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
    Connection con;
    PreparedStatement psm;
    ResultSet rs;

    String us_id;

    String us_email_new;
    String us_tel_new;
    String us_pw_new;

    int decision = 0;
    String sqlUpdate = "";
%>

<%
    us_id = login_id;

    System.out.println("manage_profile_2.jsp 실행 (by us_id: " + us_id + ")");

    us_email_new = request.getParameter("us_email_new");
    System.out.println("us_email_new: " + us_email_new);

    us_tel_new = request.getParameter("us_tel_new");
    System.out.println("us_tel_new: " + us_tel_new);

    us_pw_new = request.getParameter("us_pw_new");
    System.out.println("us_pw_new: " + us_pw_new);


    if (us_email_new == null || us_email_new.equals("")) {
    } else {
        decision += 2;
    }

        if (us_tel_new == null || us_tel_new.equals("")) {
        } else {
            decision += 3;
        }

        if (us_pw_new == null || us_pw_new.equals("")) {
        } else {
            decision += 4;
        }

    try {
        con = DBConnection.getCon();

        // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
        assert con != null;
        con.setAutoCommit(false);

        switch (decision) {
            case 0: // nothing changed
                break;
            case 2: // us_email
                sqlUpdate = "UPDATE user SET us_email = ? WHERE us_id = ?";
                psm = con.prepareStatement(sqlUpdate);
                psm.setString(1, us_email_new);
                psm.setString(2, us_id);
                psm.executeUpdate();
                out.println("<script>alert('이메일이 성공적으로 변경되었습니다.');</script>");
                out.println("<script>location.replace('manage_profile.jsp');</script>");
                break;
            case 3: // us_tel => 전화번호 최초1회 본인인증 다시 받도록 레벨을 낮춰야 함
                if (DBUtil.checkIfRenting(us_id)) {
                    out.println("<script>alert('예약/대여중인 내역이 있으면 전화번호를 수정할 수 없습니다.');</script>");
                    out.println("<script>history.go(-1);</script>");
                } else {
                    sqlUpdate = "UPDATE user SET us_tel = ?, us_level = '1' WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_tel_new);
                    psm.setString(2, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('manage_profile.jsp');</script>");
                }
                break;
            case 4: // us_pw
                sqlUpdate = "UPDATE user SET us_pw = ? WHERE us_id = ?";
                psm = con.prepareStatement(sqlUpdate);
                psm.setString(1, us_pw_new);
                psm.setString(2, us_id);
                psm.executeUpdate();
                out.println("<script>alert('비밀번호가 성공적으로 변경되었습니다.');</script>");
                out.println("<script>location.replace('manage_profile.jsp');</script>");
                break;
            case 5: // us_email, us_tel
                if (DBUtil.checkIfRenting(us_id)) {
                    out.println("<script>alert('예약/대여중인 내역이 있으면 전화번호를 수정할 수 없습니다.');</script>");
                    out.println("<script>history.go(-1);</script>");
                } else {
                    sqlUpdate = "UPDATE user SET us_email = ?, us_tel = ?, us_level = '1' WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_email_new);
                    psm.setString(2, us_tel_new);
                    psm.setString(3, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('이메일주소, 전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('manage_profile.jsp');</script>");
                }
                break;
            case 6: // us_email, us_pw
                sqlUpdate = "UPDATE user SET us_email = ?, us_pw = ? WHERE us_id = ?";
                psm = con.prepareStatement(sqlUpdate);
                psm.setString(1, us_email_new);
                psm.setString(2, us_pw_new);
                psm.setString(3, us_id);
                psm.executeUpdate();
                out.println("<script>alert('이메일주소, 비밀번호가 성공적으로 변경되었습니다.');</script>");
                out.println("<script>location.replace('manage_profile.jsp');</script>");
                break;
            case 7: // us_tel, us_pw
                if (DBUtil.checkIfRenting(us_id)) {
                    out.println("<script>alert('예약/대여중인 내역이 있으면 전화번호를 수정할 수 없습니다.');</script>");
                    out.println("<script>history.go(-1);</script>");
                } else {
                    sqlUpdate = "UPDATE user SET us_tel = ?, us_pw = ?, us_level = '1' WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_tel_new);
                    psm.setString(2, us_pw_new);
                    psm.setString(3, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('전화번호, 비밀번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('manage_profile.jsp');</script>");
                }
                break;
            case 9: // us_email, us_tel, us_pw
                if (DBUtil.checkIfRenting(us_id)) {
                    out.println("<script>alert('예약/대여중인 내역이 있으면 전화번호를 수정할 수 없습니다.');</script>");
                    out.println("<script>history.go(-1);</script>");
                } else {
                    sqlUpdate = "UPDATE user SET us_email =?, us_tel = ?, us_pw = ?, us_level = '1' WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_email_new);
                    psm.setString(2, us_tel_new);
                    psm.setString(3, us_pw_new);
                    psm.setString(4, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('이메일주소, 전화번호, 비밀번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('manage_profile.jsp');</script>");
                }
                break;
            default:
                System.out.println("있어서는 안 되는 일");
                break;
        }
        decision = 0;

        // SQL) COMMIT
        con.commit();

    } catch (SQLException e) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException e2) {
                e2.printStackTrace();
                System.out.println(e2.getMessage());
            }
        }

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

</body>
</html>