<!-- 디자인할 부분 없음 -->
<!-- 카테고리의 보증금 변경 -->

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
    <title>성신코인: 물품관리</title>
</head>
<body>
<%!
    String login_id;
%>

<%
    login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");
    } else {

        System.out.println("ad_category_3.jsp 실행");

        String ca_name = request.getParameter("ca_name");
        String ca_deposit = request.getParameter("ca_deposit");

        if (ca_deposit.equals("")) {
            out.println("<script>alert('변경할 보증금 액수를 입력해주세요.');</script>");
            out.println("<script>history.go(-1);</script>");

        } else {

            try {
                Connection conn = DBConnection.getCon(); // SQL문 한 개만 있는 파일임

                if (DBUtil.checkCaB4Updating(ca_name)) {
                    out.println("<script>alert('예약중/대여중/노쇼미완 상태인 내역이 존재하여 변경이 불가능합니다.');</script>");
                    out.println("<script>history.go(-1);</script>");
                } else {
                    if (Double.parseDouble(ca_deposit) >= 10.0) {
                        String sql = "UPDATE category SET ca_deposit = ? WHERE ca_name = ?";
                        PreparedStatement smt = conn.prepareStatement(sql);
                        smt.setString(1, ca_deposit);
                        smt.setString(2, ca_name);
                        smt.executeUpdate();

                        smt.close();
                        conn.close();

                        out.println("<script>alert('보증금 변경이 완료되었습니다.');</script>");
                        out.println("<script>location.replace('ad_items.jsp');</script>");

                        System.out.println("보증금 변경 완료");
                    } else {
                        out.println("<script>alert('보증금은 10수정구슬 이상이어야 합니다.');</script>");
                        out.println("<script>history.go(-1);</script>");
                    }
                }

            } catch (Exception e) {
                System.out.println("ad_category_3.jsp: 예외 발생");
                e.printStackTrace();
            }
        }
    }
%>
</body>
</html>