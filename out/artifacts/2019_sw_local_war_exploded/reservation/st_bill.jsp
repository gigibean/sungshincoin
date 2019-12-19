<%@ page import="model.DBUtil" %>
<%@ page import="model.DailyUpdate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<% response.setContentType("text/html"); %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>성신코인</title>

    <link rel="icon" type="image/png" href="../imgs/sujunggoo.png"/>
    <link rel="stylesheet" href="../css/mainForSt.css">
    <link rel="stylesheet" href="../css/st_bill.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel="stylesheet" href="../css/navForSt.css">
    <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>


    <!-- CDN for navforst.css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
</head>
<body>
<%!
    String login_id;
    String login_tel;
    String us_name;
%>
<%
    login_id = (String) session.getAttribute("us_id");
    login_tel = (String) session.getAttribute("us_tel");
    us_name = (String) session.getAttribute("us_name");

    if (login_id == null || !DBUtil.assureStudent(login_id)) {
        out.println("<script>location.replace('../login.html')</script>");

    } else {

%>

<%!
    double penalty = 0.0;
    double deposit = 0.0;
    double total_bill =0.0;
    String ca_name = "";
    String bill_time = "";
%>

<%
    System.out.println("st_bill.jsp 실행");

    ca_name = request.getParameter("ca_name");
    deposit = Double.parseDouble(request.getParameter("deposit"));
    penalty = Double.parseDouble(request.getParameter("penalty"));
    total_bill = deposit+penalty;

    System.out.println("보증금 : " + deposit + " + 페널티 : " + penalty + " = 전체 : " + total_bill);

    bill_time = DailyUpdate.getConcreteTime();
%>

<div id="login_threejs_gooLogin_scene"></div>
<div id="cloud-front" class="cloud"></div>
<header>
    <a href="../reservation/reser_stu_main.jsp">
        <img src="../imgs/logo/logiForMain.svg" style="z-index: 1000; width:172px;">
    </a>
</header>

<!-- navforst -->
<nav class="navForSt">
    <ul style="display: inline-flex;">
        <div class="dropdown show" style="display: inline;">

            <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <%=us_name%>
            </a>
            <div class="dropdown-menu dropdown-menu-right">
                <a class="dropdown-item" href="../mypage/mypage.jsp">마이페이지</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="../logout.jsp">로그아웃</a>
            </div>
        </div>

        <li><a href="../reservation/reser_stu_main.jsp">예약하기</a></li>
        <li><a href="../mypage/exchange_sujung.jsp">환전하기</a></li>
    </ul>
</nav>
<span class="suryong">
        <img src="/designImages/suryong_marble@2x.png" alt="suryong">
</span>

<div class="maincard">

    <h3>영 수 증</h3>
    <br/><br/>
    <div class="contentForMainCard">
        <br/>
        <div class="manage">
            <h4 style="text-align: left;"><%=ca_name%></h4>

            <h4 style="text-align: right; display: initial;">결제 시간:<%=bill_time%></h4>
        </div>
        <hr/>

        <div class="manage">
            <h5>보증금</h5>
            <p><%=deposit%> 구슬</p>
        </div>
        <div class="manage">
            <h5>페널티</h5>
            <p><%=penalty%> 구슬</p>
        </div>
        <hr>
        <div class="manage total">
            <h5>TOTAL</h5>
            <p><%=total_bill%> 구슬</p>
        </div>
        <hr>
        <div class="agreementForCard">
            <form onSubmit="App.TransferSSTokens(); return false;" name ="agreeForm">
            <div class="checkForCard">
                <div class="dropdownForText">
                    <img src="../imgs/textOn.png" id="dropdownText" alt="text">
                    <img src="../imgs/textOff.png" id="dropupText" alt="text">
                </div>
                <div class="checkboxForCard">
                    <label for="agreeCheckbox">동의합니다.</label>
                    <input type="checkbox" id="agreeCheckbox" name="checkboxA">
                </div>
            </div>

            <hr style="border: 0.7px solid #2d2d2d">
            <div class="agreeText">
                <p>

                    수정구 사용과 보증금 지불 및 처리에 관한 약관<br>
                    <br>
                    * 본 약관을 숙지하지 않아 발생하는 일에 대해 성신코인은 책임을 지지 않습니다. <br>
                    <br>
                    1. 해당 영수증 페이지에 표시된 TOTAL 값 만큼 귀하의 수정구슬이 차감됩니다.<br>
                    2. 해당 예약 건을 취소하고자 하는 경우 마이페이지의 '예약 관리'에서 예약 당일에 한해 가능합니다.<br>
                    '예약취소'를 하실 경우, 지불하신 보증금을 모두 돌려드립니다. 단, 지불하신 페널티는 돌려드리지 않습니다.<br>
                    3. 예약 당일에 대여를 완료하시지 않아 노쇼(NoShow)를 하실 경우, 보증금 반액을 돌려드립니다.<br>
                    만약, 노쇼 미완인 예약 내역 건이 2~3일 이내에 처리되지 않을 경우, 고객센터(sungshin.coin@gmail.com)으로 연락주시기 바랍니다.<br>
                    4. 예약날짜 다음 날까지 대여하신 물품을 돌려주셔야 합니다.<br>
                    월~목요일에 예약하신 경우 다음 날, 금요일에 예약하신 경우 월요일까지 반납하시면 됩니다 .<br>
                    주말은 운영하지 않습니다.<br>
                    단, 국가공휴일이나 학교휴업일 등은 고려하지 않고 보증금 차감 및 페널티를 부과하오니, 다음 날이 평일이면서 공휴일이면 예약 당일 반납하시기 바랍니다. <br>
                    반납을 완료하시면 바로 보증금이 처리되어 받으셔야 할 보증금을 돌려 받으실 수 있습니다.<br>
                    예약날짜 다음 날 이후부터는 보증금이 매일 1수정구슬 씩 차감됩니다.<br>
                    5. 만약, 보증금액 한도를 초과하여 연체하실 경우, 페널티를 받게됨에 유의하시기 바랍니다.<br>
                    보증금액 한도 초과 당일부터 매일 페널티가 1수정구슬씩 증가합니다.<br>
                    6. 지불하지 않으신 잔여 페널티가 있다면, 다음 예약 시 자동으로 청구됩니다.<br>
                    <br>

                </p>
            </div>

                <input type="hidden" name ="ca_name" value ="<%=ca_name%>">
                <input type="hidden" name ="deposit" value ="<%=deposit%>">
                <input type="hidden" name="penalty" value ="<%=penalty%>">

                <input type="button" id="submitForAgreement" value="확인" onclick="button1_click()">
                <!-- !! type = "submit"이었는데 "button"으로 바꿈 -->
                <!-- if (Metamask 발급받은 게 없거나 보유수정구가 0) {예약 불가능} -->
                <!-- us_black_count + depositForRegister의 값을 지불할 수 없는 사용자는 예약 불가능 -->
                <!-- 블록체인 연결해서 수정구슬이 나감 -->
            </form>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/prefixfree/1.0.7/prefixfree.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/102/three.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.3/TimelineMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/1.18.0/TweenLite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/1.11.5/TweenMax.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src=" https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js"></script>
<script src="../js/obj.js"></script>
<script src="../js/mtl.js"></script>
<script type="text/javascript" src="../js/moveClouds.js"></script>
<script type="text/javascript" src="../js/gooManage.js"></script>
<script src="../js/web3.min.js"></script>
<script src="../js/truffle-contract.min.js"></script>
<script src="../js/app.js"></script>
<%--<srcipt type="text/javascript" src="../js/dropDownForBill.js"></srcipt>--%>
<script>
    $("#dropdownText").on("click", function () {
        $(this).hide();
        $("#dropupText").show();
        $(".agreeText").show();

        TimelineMax.to("#agreeText", 1, {css: {height: "200px", overflowY: "auto"}, ease: Power2.easeOut});
        console.log("성공")
    })

    $("#dropupText").on("click", function () {
        $(this).hide();
        $("#dropdownText").show();
        $(".agreeText").hide();

        TimelineMax.to("#agreeText", 1, {css: {height: "0px", overflowY: "hidden"}, ease: Power2.easeOut});
        console.log("성공")
    })

    function button1_click() {
        if(document.agreeForm.checkboxA.checked == false) {
            alert("거래 약관에 동의해주세요.");
        } else {
            document.agreeForm.submit();

            if (document.agreeForm.ca_name.value == "보증금") { // 보증금 지불
                alert("보증금 지불이 완료되었습니다.");
                location.replace('../mypage/manage_sujung.jsp');

            } else { // 일반적인 물품 예약
                var rst = 'st_reservationUpdate.jsp?ca_name=';
                rst += document.agreeForm.ca_name.value;
                location.replace(rst); // 최종적으로 DB업데이트
            }

        }
    }
</script>

<%
    }
%>
</body>

</html>
