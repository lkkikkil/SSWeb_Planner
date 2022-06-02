<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Vector"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    String userPosition = "";
    String userDepartment = "";

    if(userId != null) {
        userPosition = (String)session.getAttribute("userPosition");
        userDepartment = (String)session.getAttribute("userDepartment");
    }

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    String sql;
    PreparedStatement query = null;
    ResultSet result = null;
    if(userPosition.equals("관리")) {
        sql = "SELECT user_id, user_name, user_department, user_position FROM accounts";
        query =  connect.prepareStatement(sql);
    }
    else if(userPosition.equals("부장")) {
        sql = "SELECT user_id, user_name, user_department, user_position FROM accounts WHERE user_department = ?";
        query =  connect.prepareStatement(sql);
        query.setString(1, userDepartment);
    }

    Vector<String> userInfoList = new Vector<String>();
    if(query != null) {
        result = query.executeQuery();
        while(result.next()) {
            String userInfo = "";
            for(int index = 1; index < 4; index++) {
                userInfo += result.getString(index) + ",";
            }
            userInfo += result.getString(4);
            userInfoList.add(userInfo);
        }
    }
%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/basic.css?as">
    <link rel="stylesheet" type="text/css" href="../css/commonNav.css?a">
</head>
<body>
    <nav id="headNav">
        <button id="menuBtn" class="navBtn" onclick="openAsidNav()">
            <img src="../resources/images/menu.png">
        </button>
        <h1 id="titleText">SSWEB PLANNER</h1>
    </nav>
    <nav id="asideNav">
        <div id="asideNavHeader">
            <button id="closeBtn" class="navBtn" onclick="closeAsidNav()">
                <img src="../resources/images/close.png">
            </button>
        </div>
        <form id="asideNavMain" action="plannerPage.jsp">
            <div class="teamContainer" id="developmentTeamContainer">
                <div class="teamNameBox">
                    <h2 class="largeFont teamNameText">개발팀</h2>
                </div>
                <ul id="developmentTeamList">
                </ul>
            </div>
            <div class="teamContainer" id="educationTeamContainer">
                <div class="teamNameBox">
                    <h2 class="largeFont teamNameText">교육팀</h2>
                </div>
                <ul id="educationTeamList">
                </ul>
            </div>
            <div class="teamContainer" id="operationTeamContainer">
                <div class="teamNameBox">
                    <h2 class="largeFont teamNameText">운용팀</h2>
                </div>
                <ul id="operationTeamList">
                </ul>
            </div>
            <div class="teamContainer" id="financeTeamContainer">
                <div class="teamNameBox">
                    <h2 class="largeFont teamNameText">재무팀</h2>
                </div>
                <ul id="financeTeamList">
                </ul>
            </div>
        </form>
    </nav>

    <script>
        window.onload = function() {
            showMenuBtn()
            loadAsideNav()
        }

        function openAsidNav() {
            document.getElementById("asideNav").style.left = "0px";
        }

        function closeAsidNav() {
            var asideNav = document.getElementById("asideNav")
            asideNav.style.left = -asideNav.scrollWidth;
        }

        function showMenuBtn() {
            var userPosition = "<%=userPosition%>"
            if(userPosition != "부장" && userPosition != "관리") {
                document.getElementById("menuBtn").style.display = "none"
                document.getElementById("titleText").style.marginLeft = "64px"
                document.getElementById("headNav").style.height = "55px"
            }
        }

        function loadAsideNav() {
            showTeamContainer()
            var userInfoList = makeUserInfoList()
            for(var index = 0; index < userInfoList.length; index++) {
                loadUser(userInfoList[index])
            }
        }

        function showTeamContainer() {
            var userPosition = "<%=userPosition%>"
            var userDepartment = "<%=userDepartment%>"
            if(userPosition == "관리") {
                var teamContainerLsit = document.getElementsByClassName("teamContainer")
                for(var index = 0; index < teamContainerLsit.length; index++) {
                    teamContainerLsit[index].style.display = "block"
                }
            }
            else if(userPosition == "부장") {
                if(userDepartment == "개발") {
                    document.getElementById("developmentTeamContainer").style.display = "block"
                }
                else if(userDepartment == "교육") {
                    document.getElementById("educationTeamContainer").style.display = "block"
                }
                else if(userDepartment == "운용") {
                    document.getElementById("operationTeamContainer").style.display = "block"
                }
                else {
                    document.getElementById("financeTeamContainer").style.display = "block"
                }
            }
        }

        function makeUserInfoList() {
            var userInfoList = []
            <%for(int index = 0; index < userInfoList.size(); index++){%>
                var userInfo = "<%=userInfoList.get(index)%>".split(',')
                userInfoList.push(userInfo)
            <%}%>
            userInfoList.sort(function (userInfo1, userInfo2) {
                if (userInfo1[3] != userInfo2[3]) {
                    return userInfo1[3] > userInfo2[3] ? 1 : -1;
                }
                else if (userInfo1[2] != userInfo2[2]) {
                    return userInfo1[2] - userInfo2[2];
                }
                else {
                    return userInfo1[1] > userInfo2[1] ? 1 : -1;
                }
            })
            return userInfoList
        }

        function loadUser(userInfo) {
            var userBox = document.createElement("li")
            userBox.className = "userBox"

            var userBtn = document.createElement("input")
            userBtn.type = "button"
            userBtn.className = "basicFont userBtn"
            userBtn.value = "• " + userInfo[1] + " " + userInfo[3]
            userBtn.onclick = function() {
                changePlanner(userInfo[0])
            }
            userBox.appendChild(userBtn)

            var userDepartment = userInfo[2]
            if(userDepartment == "개발") {
                document.getElementById("developmentTeamContainer").appendChild(userBox)
            }
            else if(userDepartment == "교육") {
                document.getElementById("educationTeamContainer").appendChild(userBox)
            }
            else if(userDepartment == "운용") {
                document.getElementById("operationTeamContainer").appendChild(userBox)
            }
            else {
                document.getElementById("financeTeamContainer").appendChild(userBox)
            }
        }

        function changePlanner(plannerOwnerId) {
            var plannerOwnerIdInput = document.getElementById("plannerOwnerIdInput")
            var asideNavMain = document.getElementById("asideNavMain")

            if(plannerOwnerIdInput == null) {
                plannerOwnerIdInput = document.createElement("input")
                plannerOwnerIdInput.type = "hidden"
                plannerOwnerIdInput.id = "plannerOwnerIdInput"
                plannerOwnerIdInput.name = "plannerOwnerId"
                asideNavMain.appendChild(plannerOwnerIdInput)
            }
            
            plannerOwnerIdInput.value = plannerOwnerId

            asideNavMain.submit()
        }
    </script>
</body>
