<!-- 디자인할 부분 없음 -->
<!-- 회원정보 수정 사항 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>
<%@ page import="javax.xml.transform.Result" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
</head>

<body>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    Connection con;
    PreparedStatement psm;
    ResultSet rs;

    String us_id;

    String us_name_new;
    String us_email_new;
    String us_tel_new;
    String us_level;


    int decision = 0;
    String sqlUpdate = "";
%>

<%
        us_id = request.getParameter("us_id");

        System.out.println("ad_users_info_4.jsp 실행 (by us_id: " + us_id + ")");

        us_name_new = request.getParameter("us_name");
        us_email_new = request.getParameter("us_email");
        us_tel_new = request.getParameter("us_tel");
        us_level = request.getParameter("us_level");


        if (us_email_new == null || us_email_new.equals("")) {
        } else {
            decision += 2;
        }

        if (us_tel_new == null || us_tel_new.equals("")) {
        } else {
            decision += 3;
        }

        if (us_name_new == null || us_name_new.equals("")) {
        } else {
            decision += 4;
        }

        try {
            System.out.print("ad_users_info_4.jsp가 호출한 ");
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
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 3: // us_tel => 전화번호 최초1회 본인인증 다시 받도록 레벨을 낮춰야 함
                    if (us_level.equals("6")) { // => 전화번호 최초1회 본인인증 다시 받도록 레벨을 낮춰야 함
                        sqlUpdate = "UPDATE user SET us_tel = ?, us_level = '1' WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_tel_new);
                        psm.setString(2, us_id);
                        psm.executeUpdate();
                    } else {
                        sqlUpdate = "UPDATE user SET us_tel = ? WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_tel_new);
                        psm.setString(2, us_id);
                        psm.executeUpdate();
                    }

                    out.println("<script>alert('전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 4: // us_name_new
                    sqlUpdate = "UPDATE user SET us_name = ? WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_name_new);
                    psm.setString(2, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('이름이 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 5: // us_email, us_tel
                    if (us_level.equals("6")) { // => 전화번호 최초1회 본인인증 다시 받도록 레벨을 낮춰야 함
                        sqlUpdate = "UPDATE user SET us_email = ?, us_tel = ?, us_level = '1' WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_email_new);
                        psm.setString(2, us_tel_new);
                        psm.setString(3, us_id);
                        psm.executeUpdate();
                    } else {
                        sqlUpdate = "UPDATE user SET us_email = ?, us_tel = ? WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_email_new);
                        psm.setString(2, us_tel_new);
                        psm.setString(3, us_id);
                        psm.executeUpdate();
                    }

                    out.println("<script>alert('이메일주소, 전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 6: // us_email, us_name
                    sqlUpdate = "UPDATE user SET us_email = ?, us_name = ? WHERE us_id = ?";
                    psm = con.prepareStatement(sqlUpdate);
                    psm.setString(1, us_email_new);
                    psm.setString(2, us_name_new);
                    psm.setString(3, us_id);
                    psm.executeUpdate();
                    out.println("<script>alert('이메일주소, 이름이 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 7: // us_tel, us_name
                    if (us_level.equals("6")) {
                        sqlUpdate = "UPDATE user SET us_tel = ?, us_name = ?, us_level = '1' WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_tel_new);
                        psm.setString(2, us_name_new);
                        psm.setString(3, us_id);
                        psm.executeUpdate();
                    } else {
                        sqlUpdate = "UPDATE user SET us_tel = ?, us_name = ? WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_tel_new);
                        psm.setString(2, us_name_new);
                        psm.setString(3, us_id);
                        psm.executeUpdate();
                    }

                    out.println("<script>alert('이름, 전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
                    break;
                case 9: // us_email, us_tel, us_name
                    if (us_level.equals("6")) {
                        sqlUpdate = "UPDATE user SET us_email =?, us_tel = ?, us_name = ?, us_level = '1' WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_email_new);
                        psm.setString(2, us_tel_new);
                        psm.setString(3, us_name_new);
                        psm.setString(4, us_id);
                        psm.executeUpdate();
                    } else {
                        sqlUpdate = "UPDATE user SET us_email =?, us_tel = ?, us_name = ? WHERE us_id = ?";
                        psm = con.prepareStatement(sqlUpdate);
                        psm.setString(1, us_email_new);
                        psm.setString(2, us_tel_new);
                        psm.setString(3, us_name_new);
                        psm.setString(4, us_id);
                        psm.executeUpdate();
                    }

                    out.println("<script>alert('이름, 이메일주소, 전화번호가 성공적으로 변경되었습니다.');</script>");
                    out.println("<script>location.replace('ad_users_info.jsp');</script>");
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
