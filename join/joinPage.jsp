<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");
%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/basic.css?s">
    <link rel="stylesheet" type="text/css" href="../css/join.css?a">
</head>
<body>
    <jsp:include page="../commonNav.jsp"></jsp:include>

    <main>
        <form id="joinForm" action="joinModule.jsp">
            <div class="inputBox">
                <p class="basicFont">아이디</p>
                <div id="idInputBox">
                    <input type="text" class="basicFont joinInput" id="idInputText" name="userId" placeholder="20자 이하 / 특수문자, 한글 X" maxlength="20" oninput="idCheckLogic()">
                    <input type="button" class="smallFont" id="duplicateCheckBtn" value="중복확인" onclick="idDuplicationCheckPageOpen()">
                </div>
                <p class="smallFont" id="idCheckText">아이디를 입력해주세요</p>
            </div>
            <div class="inputBox">
                <p class="basicFont">비밀번호</p>
                <input type="password" class="basicFont joinInput" id="pwInputText" name="userPw" placeholder="20자 이하 / 특수문자, 한글 X" maxlength="20" oninput="pwCheckLogic()">
                <p class="smallFont" id="pwCheckText">비밀번호를 입력해주세요</p>
            </div>
            <div class="inputBox">
                <p class="basicFont">비밀번호 확인</p>
                <input type="password" class="basicFont joinInput" id="pwMatchInputText" maxlength="20" oninput="pwMatchCheckLogic()">
                <p class="smallFont" id="pwMatchCheckText">비밀번호 확인 입력해주세요</p>
            </div>
            <div class="inputBox">
                <p class="basicFont">이름</p>
                <input type="text" class="basicFont joinInput" name="userName">
            </div>
            <div id="selectBox">
                <p class="basicFont">부서</p>
                <select class="basicFont joinSelect" name="userDepartment">
                    <option disabled selected value="">선택</option>
                    <option value="개발">개발</option>
                    <option value="교육">교육</option>
                    <option value="운용">운용</option>
                    <option value="재무">재무</option>
                </select>
                <p class="basicFont">직책</p>
                <select class="basicFont joinSelect" name="userPosition">
                    <option disabled selected value="">선택</option>
                    <option value="관리">관리자</option>
                    <option value="부장">부장</option>
                    <option value="사원">사원</option>
                </select>
            </div>
            <input type="button" class="basicFont" id="joinBtn" value="회원가입" onclick="joinEvent()">
        </form>
    </main>

    <script>
        var idCheck = false
        var idDuplicationCheck = false
        var pwCheck = false
        var pwMatchCheck = false

        function joinEvent() {
            var checkNull = checkNullJoinInputLogin()
            if(checkNull) {
                alert("빈칸을 확인해주세요")
            }
            else if(!idDuplicationCheck) {
                alert("아이디 중복을 확인해주세요")
            }
            else if(!(idCheck && pwCheck && pwMatchCheck)) {
                alert("입력양식을 확인해주세요")
            }
            else {
                document.getElementById("joinForm").submit()
            }
        }

        function checkNullJoinInputLogin() {
            var joinInputList = document.getElementsByClassName("joinInput")
            for(var index = 0; index < joinInputList.length; index++) {
                if(joinInputList[index].value == "") {
                    return true
                }
            }

            var joinSelectList = document.getElementsByClassName("joinSelect")
            for(var index = 0; index < joinSelectList.length; index++) {
                if(joinSelectList[index].value == "") {
                    return true
                }
            }

            return false
        }

        function idCheckLogic() {
            var textRule = /^[a-zA-Z0-9]*$/;
            var idInputText = document.getElementById("idInputText").value
            var idCheckText = document.getElementById("idCheckText")
            if(!textRule.test(idInputText)) {
                idCheck = false
                idCheckText.innerHTML = "아이디가 옳바르지 않습니다"
            }
            else {
                idCheck = true
                idDuplicationCheck = false
                idCheckText.innerHTML = "아이디 중복을 확인해주세요"
            }
            idCheckText.style.color = "#ff0000"
        }

        function idDuplicationCheckPageOpen() {
            if(!idCheck) {
                alert("옳바른 아이디를 입력해주세요")
                return
            }

            var idInputText = document.getElementById("idInputText").value
            if(idInputText == "") {
                alert("아이디를 입력해주세요")
                return
            }
            else {
                window.open("idDuplicationCheckPage.jsp?userId=" + idInputText, "아이디중복확인", "width = 500px, height = 300px")
            }
        }

        function pwCheckLogic() {
            var textRule = /^[a-zA-Z0-9]*$/;
            var pwInputText = document.getElementById("pwInputText").value
            var pwCheckText = document.getElementById("pwCheckText")
            if(!textRule.test(pwInputText)) {
                pwCheckText.innerHTML = "비밀번호가 옳바르지 않습니다"
                pwCheckText.style.color = "#ff0000"
                pwCheck = false
            }
            else {
                pwCheckText.innerHTML = ""
                pwCheck = true
            }

            pwMatchCheckLogic()
        }

        function pwMatchCheckLogic() {
            var pwInputText = document.getElementById("pwInputText")
            var pwMatchInputText = document.getElementById("pwMatchInputText")
            var pwMatchCheckText = document.getElementById("pwMatchCheckText")
            if(pwInputText.value != pwMatchInputText.value) {
                pwMatchCheckText.innerHTML = "비밀번호가 일치하지 않습니다"
                pwMatchCheckText.style.color = "#ff0000"
                pwMatchCheck = false
            }
            else {
                pwMatchCheckText.innerHTML = "비밀번호가 일치합니다"
                pwMatchCheckText.style.color = "#00ff00"
                pwMatchCheck = true
            }
        }
    </script>
</body>
