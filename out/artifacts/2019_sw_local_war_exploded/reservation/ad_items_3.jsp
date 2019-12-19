<!-- 디자인할 부분 없음 -->
<!-- 물품 상태 변경 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBUtil" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<html>
<head>
    <title>성신코인: 물품관리</title>
</head>
<body>

<%
    String login_id = (String) session.getAttribute("us_id");

    if (login_id == null || !DBUtil.assureAdmin(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {
%>

<%!
    Connection con = null;
    PreparedStatement psm = null;
    String ca_name = "";
    String it_serial = "";
    String change_status = "";
%>

<%
        change_status = request.getParameter("change_status"); // 0: 예약 가능 상태로 변경, 3: 분실 상태로 변경, 4: 고장상태로 변경
        ca_name = request.getParameter("ca_name");
        it_serial = request.getParameter("it_serial");
        System.out.println("ad_items_3.jsp가 호출됨");

        switch (change_status) {
            case "0": // 물품상태: 예약 가능 상태(0)로 변경
                System.out.println("예약 가능 상태로 변경");
                try {
                    con = DBConnection.getCon();
                    String sql = "UPDATE item SET it_status = '0' WHERE ca_name = ? AND it_serial = ?";

                    psm = con.prepareStatement(sql);
                    psm.setString(1, ca_name);
                    psm.setString(2, it_serial);
                    psm.executeUpdate();

                    String resMsg = "<script>alert('";
                    resMsg += ca_name;
                    resMsg += " ";
                    resMsg += it_serial;
                    resMsg += "번";
                    resMsg += " : 예약가능상태로 변경되었습니다');";
                    resMsg += "location.replace('ad_items_2.jsp?ca_name=";
                    resMsg += ca_name;
                    resMsg += "');</script>";
                    out.print(resMsg);

                } catch (SQLException e) {
                    e.printStackTrace();
                    System.out.println(e.getMessage());
                } finally {
                    try {
                        if (psm != null) psm.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
                break;

            case "3": // 물품상태: 분실 상태(3)로 변경
                System.out.println("분실상태로 변경");
                try {
                    con = DBConnection.getCon();
                    String sql = "UPDATE item SET it_status = '3' WHERE ca_name = ? AND it_serial = ?";

                    psm = con.prepareStatement(sql);
                    psm.setString(1, ca_name);
                    psm.setString(2, it_serial);
                    psm.executeUpdate();

                    String resMsg = "<script>alert('";
                    resMsg += ca_name;
                    resMsg += " ";
                    resMsg += it_serial;
                    resMsg += "번";
                    resMsg += " : 분실 상태로 변경되었습니다');";
                    resMsg += "location.replace('ad_items_2.jsp?ca_name=";
                    resMsg += ca_name;
                    resMsg += "');</script>";
                    out.print(resMsg);

                } catch (SQLException e) {
                    e.printStackTrace();
                    System.out.println(e.getMessage());
                } finally {
                    try {
                        if (psm != null) psm.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
                break;

            case "4": // 물품상태: 고장 상태(4)로 변경
                System.out.println("고장상태로 변경");
                try {
                    con = DBConnection.getCon();
                    String sql = "UPDATE item SET it_status = 4 WHERE ca_name = ? AND it_serial = ?";

                    psm = con.prepareStatement(sql);
                    psm.setString(1, ca_name);
                    psm.setString(2, it_serial);
                    psm.executeUpdate();
                    String resMsg = "<script>alert('";
                    resMsg += ca_name;
                    resMsg += " ";
                    resMsg += it_serial;
                    resMsg += "번";
                    resMsg += " : 고장 상태로 변경되었습니다');";
                    resMsg += "location.replace('ad_items_2.jsp?ca_name=";
                    resMsg += ca_name;
                    resMsg += "');</script>";
                    out.print(resMsg);

                } catch (SQLException e) {
                    e.printStackTrace();
                    System.out.println(e.getMessage());
                } finally {
                    try {
                        if (psm != null) psm.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
                break;
        }
    }
%>
</body>
</html>
