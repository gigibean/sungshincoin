<!-- 디자인할 부분 없음 -->
<!-- '카테고리 추가' 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="model.DBUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="model.DBConnection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
    Connection conn;
    PreparedStatement psmt1;
    PreparedStatement psmt2;
    ResultSet rs;
%>

<%
        String decision = request.getParameter("decision"); // 1: 추가하기, 2: 삭제하기

        if (decision.equals("1")) { // 1: 카테고리 추가하기
            ServletContext sc = request.getSession().getServletContext();
            String uploadPath = config.getServletContext().getRealPath("/categoryImages/");
            System.out.println("절대경로 : " + uploadPath);

            String ca_name = "";
            String ca_deposit = "";

            int maxSize = 1024 * 1024 * 10; // 한번에 올릴 수 있는 파일 용량 : 10M로 제한

            String fileName2 = ""; // 중복처리된 이름 (폴더에 저장되는 이름)
            String originalName2 = ""; // 중복 처리전 실제 원본 이름
            long fileSize = 0; // 파일 사이즈
            String fileType = ""; // 파일 타입

            MultipartRequest multi = null;

            try {
                // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
                multi = new MultipartRequest(request, uploadPath, maxSize, "utf-8", new DefaultFileRenamePolicy());

                ca_name = multi.getParameter("ca_name");
                ca_deposit = multi.getParameter("ca_deposit");

                // 전송한 전체 파일이름들을 가져옴
                Enumeration files = multi.getFileNames();

                while (files.hasMoreElements()) {
                    // form 태그에서 <input type="file" name"~" />을 가져온다.
                    String file2 = (String) files.nextElement(); // 파일 input에 지정한 이름을 가져옴

                    // 그에 해당하는 실재 파일 이름을 가져옴
                    originalName2 = multi.getOriginalFileName(file2);

                    // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
                    // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
                    fileName2 = multi.getFilesystemName(file2);

                    // 파일 타입 정보를 가져옴
                    fileType = multi.getContentType(file2);

                    // input file name에 해당하는 실재 파일을 가져옴
                    File file = multi.getFile(file2);

                    // 그 파일 객체의 크기를 알아냄
                    fileSize = file.length();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.setAttribute("ca_name", ca_name);
            request.setAttribute("ca_filename", fileName2);

            boolean isAddedCategory = DBUtil.addingCategory(sc, ca_name, fileName2, ca_deposit);
            System.out.println("ad_category_2.jsp : 카테고리 추가 완료");

            if (isAddedCategory) {
                out.println("<script>alert('카테고리가 성공적으로 추가되었습니다. 새로고침(F5)을 하십시오.');</script>");
                out.println("<script>self.close();</script>");

            } else {
                out.println("<script>alert('카테고리 추가가 실패했습니다.');</script>");
                out.println("<script>self.close();</script>");
            }

        } else { // 2: 카테고리 삭제하기
            String category = request.getParameter("ca_name");

            String checkSQL = "SELECT * FROM item WHERE ca_name = ? AND (it_status = '0' OR it_status = '1' OR it_status = '2')"; // 0: 예약 가능, 1: 예약 완료, 2: 대여 완료
            String deletingSQL = "DELETE FROM category WHERE ca_name = ?";

            try {
                conn = DBConnection.getCon();

                // SQL) 여러 쿼리들을 한 트랜잭션으로 묶기
                assert conn != null;
                conn.setAutoCommit(false);

                psmt1 = conn.prepareStatement(checkSQL);
                psmt1.setString(1, category);
                rs = psmt1.executeQuery();
                if (!rs.next()) { // checkSQL문의 실행결과 레코드가 0개일 때
                    psmt2 = conn.prepareStatement(deletingSQL);
                    psmt2.setString(1, category);
                    psmt2.executeUpdate();
                    out.println("<script>alert('성공적으로 삭제되었습니다. 새로고침(F5)을 하십시오.');</script>");
                    out.println("<script>self.close();</script>");

                    psmt2.close();
                } else {
                    out.println("<script>alert('사용 가능한 물품이 있는 카테고리는 삭제할 수 없습니다.');</script>");
                    out.println("<script>self.close();</script>");
                }

                // SQL) COMMIT
                conn.commit();

            } catch (SQLException e1) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException e2) {
                        e2.printStackTrace();
                        System.out.println(e2.getMessage());
                    }
                }
                e1.printStackTrace();
                System.out.println(e1.getMessage());
            } finally {
                try {
                    if (rs != null)
                        rs.close();
                    if (psmt1 != null)
                        psmt1.close();
                    if (psmt2 != null)
                        psmt2.close();
                    if (conn != null)
                        conn.close();
                } catch (SQLException e3) {
                    e3.printStackTrace();
                    System.out.println(e3.getMessage());
                }
            }
        }
    }
%>
</body>
</html>