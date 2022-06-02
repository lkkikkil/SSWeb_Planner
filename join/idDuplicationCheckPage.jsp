<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");
    String userId = request.getParameter("userId");
    boolean isDuplicated = false;

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    String sql = "SELECT user_id FROM accounts WHERE user_id = ?";
    PreparedStatement query =  connect.prepareStatement(sql);
    query.setString(1, userId);

    ResultSet result = query.executeQuery();

    if(result.next()) {
        if(!result.getString(1).equals("")){
            isDuplicated = true;
        };
    }
%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/basic.css?s">
    <link rel="stylesheet" type="text/css" href="../css/idDuplicationCheck.css?as">
</head>
<body>
    <header>
        <h1 class="largeFont" id="headerText">아이디 중복확인</h1>
    </header>
    <main>
        <p class="basicFont" id="idDuplicationCheckText">입력한 stageus는 사용 가능한 아이디입니다.</p>
    </main>

    <script>
        window.onload = function() {
            var isDuplicated = <%=isDuplicated%>
            var userId = "<%=userId%>"

            var idDuplicationCheckText = document.getElementById("idDuplicationCheckText")

            if(isDuplicated) {
                idDuplicationCheckText.innerHTML = userId + "는 이미 사용 중인 아이디 입니다."
            }
            else {
                idDuplicationCheckText.innerHTML = "입력한 " + userId + "는 사용 가능한 아이디 입니다."
                addIdUseBtnLogic()

            }
        }

        function addIdUseBtnLogic() {
            var idUseBtn = document.createElement("input")
            idUseBtn.type = "button"
            idUseBtn.className = "smallFont"
            idUseBtn.id = "idUseBtn"
            idUseBtn.value = "사용하기"
            idUseBtn.onclick = function() {
                idUseLogic()
            }

            document.getElementsByTagName("main")[0].appendChild(idUseBtn)
        }

        function idUseLogic() {
            var idCheckText = opener.document.getElementById("idCheckText")
            idCheckText.innerHTML = "아이디 중복 확인을 완료했습니다"
            idCheckText.style.color = "#00ff00"
            opener.idDuplicationCheck = true
            window.close()
        }
    </script>
</body>
