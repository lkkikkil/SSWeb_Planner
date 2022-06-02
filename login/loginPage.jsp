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
    <link rel="stylesheet" type="text/css" href="../css/basic.css?as">
    <link rel="stylesheet" type="text/css" href="../css/login.css?s">
</head>
<body>
    <jsp:include page="../commonNav.jsp"></jsp:include>

    <main>
        <form id="loginForm" action="loginModule.jsp">
            <input type="text" class="basicFont loginInput" placeholder="아이디" name="userId">
            <input type="password" class="basicFont loginInput" placeholder="비밀번호" name="userPw">
            <input type="button" class="basicFont" id="loginBtn" onclick="loginEvent()" value="로그인">
        </form>
        <a href="../join/joinPage.jsp" class="smallFont" id="marginBottom">회원가입</a>
    </main>

    <script>
        function loginEvent() {
            var checkNull = checkNullLoginInputLogin()
            if(checkNull) {
                alert("아이디와 비밀번호를 입력해주세요")
                return;
            }

            document.getElementById("loginForm").submit()
        }

        function checkNullLoginInputLogin() {
            var loginInputList = document.getElementsByClassName("loginInput")
            for(var index = 0; index < loginInputList.length; index++) {
                if(loginInputList[index].value == "") {
                    return true
                }
            }

            return false
        }
    </script>
</body>
