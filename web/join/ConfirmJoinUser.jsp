<!-- 디자인할 부분 없음 -->
<!-- 회원가입 폼 작성 부분 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="model.DBUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>성신코인: 회원가입</title>
</head>
<body>

<%
    ServletContext sc = request.getSession().getServletContext();
    String uploadPath = config.getServletContext().getRealPath("/userImages/");
    System.out.println("절대경로 : " + uploadPath);

    String us_id = "";
    String us_name = "";
    String us_pw = "";
    String us_email = "";
    String us_tel = "";
    String us_level = "";
    String us_date = "";

    int maxSize = 1024 * 1024 * 10; // 한번에 올릴 수 있는 파일 용량 : 10M로 제한

    String fileName1 = ""; // 중복처리된 이름
    String originalName1 = ""; // 중복 처리전 실제 원본 이름
    long fileSize = 0; // 파일 사이즈
    String fileType = ""; // 파일 타입

    MultipartRequest multi = null;

    try {
        // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
        multi = new MultipartRequest(request, uploadPath, maxSize, "utf-8", new DefaultFileRenamePolicy());

        us_id = multi.getParameter("us_id");
        us_name = multi.getParameter("us_name");
        us_pw = multi.getParameter("us_pw");
        us_tel = multi.getParameter("us_tel");
        us_email = multi.getParameter("us_email");
        us_level = multi.getParameter("us_level");
        us_date = multi.getParameter("us_date");

        // 전송한 전체 파일이름들을 가져옴
        Enumeration files = multi.getFileNames();

        while (files.hasMoreElements()) {
            // form 태그에서 <input type="file" name"~" />을 가져온다.
            String file1 = (String) files.nextElement(); // 파일 input에 지정한 이름을 가져옴

            // 그에 해당하는 실재 파일 이름을 가져옴
            originalName1 = multi.getOriginalFileName(file1);

            // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
            // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
            fileName1 = multi.getFilesystemName(file1);

            // 파일 타입 정보를 가져옴
            fileType = multi.getContentType(file1);

            // input file name에 해당하는 실재 파일을 가져옴
            File file = multi.getFile(file1);

            // 그 파일 객체의 크기를 알아냄
            fileSize = file.length();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    boolean successJoin = DBUtil.joinUser(sc, us_id, us_name, us_pw, us_email, us_tel, fileName1, us_level, us_date);
    System.out.print("ConfirmJoinUser.jsp : 회원가입 완료");

    if (successJoin) {
        out.println("<script>alert('회원가입이 신청되었습니다.가입 승인은 2 ~3 일 정도 소요됩니다.'); " +
                "location.replace('../index.html');</script>");
    } else {
out.println("<script>alert('회원가입이 실패되었습니다.'); " +
"history.go(-1);</script>");
}
%>

</body>
</html>