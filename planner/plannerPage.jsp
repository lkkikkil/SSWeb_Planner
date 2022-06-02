<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Vector"%>

<%
    request.setCharacterEncoding("UTF-8");

    String sessionId = "";
    Cookie[] cookieList = request.getCookies() ;
	if(cookieList != null){
		for(int index = 0; index < cookieList.length; index++){
			Cookie cookie = cookieList[index] ;
            if(cookie.getName().equals("sessionId")) {
                sessionId = cookie.getValue();
            }
		}
	}

    String userId = (String)session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("../login/loginPage.jsp");
        return;
    }
    String plannerOwnerId = null;
    if(request.getParameter("plannerOwnerId") == null) {
        plannerOwnerId = userId;
    }
    else {
        plannerOwnerId = request.getParameter("plannerOwnerId");
    }

    boolean ownerCheck = false;
    if(plannerOwnerId.equals(userId)) {
        ownerCheck = true;
    }

    String plannerYear = (String)session.getAttribute("plannerYear");
    String plannerMonth = (String)session.getAttribute("plannerMonth");
    String plannerDate = plannerYear + "-" + plannerMonth;

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    String sql = "SELECT user_name FROM accounts WHERE user_id = ?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, plannerOwnerId);
    ResultSet result = query.executeQuery();

    String plannerOwnerName = "";
    if(result.next()) {
        plannerOwnerName = result.getString(1);
    }

    sql = "SELECT plan_num, plan_date, plan_content FROM plans WHERE user_id = ? AND plan_date LIKE ?";
    query = connect.prepareStatement(sql);
    query.setString(1, plannerOwnerId);
    query.setString(2, plannerDate + "%");
    result = query.executeQuery();

    Vector<String> planInfoList = new Vector<String>();
    while(result.next()) {
        String planInfo = "";
        for(int index = 1; index < 3; index++) {
            planInfo += result.getString(index) + ",";
        }
        planInfo += result.getString(3);
        planInfoList.add(planInfo);
    }
%>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/basic.css?ss">
    <link rel="stylesheet" type="text/css" href="../css/planner.css?as">
</head>
<body>
    <jsp:include page="../commonNav.jsp"></jsp:include>

    <header>
        <h2 class="largeFont" id="plannerOwnerText"></h2>
        <form id="plannerDateContainer">
            <input type="button" class="buttonCustom monthControlBtn" id="monthMinusBtn" onclick="lastMonthMove()">
            <p class="basicFont" id="plannerDateText"></p>
            <input type="button" class="buttonCustom monthControlBtn" id="monthPlusBtn" onclick="nextMonthMove()">
        </form>
    </header>

    <main>
        <form id="addPlanContainer" action="addPlanModule.jsp">
            <input type="date" class="basicFont" id="addPlanDateText" name="planDate">
            <div id="addPlanTimeContainer">
                <div class="addPlanTimeBox">
                    <input type="button" class="buttonCustom addPlanTimeMinusBtn addPlanTimeControlBtn" onclick="setAddPlanTime('Hour', '+')">
                    <input type="text" class="basicFont addPlanTimeText" id="addPlanHourText" value="00" name="planHour" readonly/>
                    <input type="button" class="buttonCustom addPlanTimePlusBtn addPlanTimeControlBtn" onclick="setAddPlanTime('Hour', '-')">
                </div>
                <p class="basicFont">시</p>
                <div class="addPlanTimeBox">
                    <input type="button" class="buttonCustom addPlanTimeMinusBtn addPlanTimeControlBtn" onclick="setAddPlanTime('Min', '+')">
                    <input type="text" class="basicFont addPlanTimeText" id="addPlanMinText" value="00" name="planMin" readonly/>
                    <input type="button" class="buttonCustom addPlanTimePlusBtn addPlanTimeControlBtn" onclick="setAddPlanTime('Min', '-')">
                </div>
                <p class="basicFont">분</p>
            </div>
            <input type="text" class="basicFont" id="addPlanContentText" placeholder="일정 내용" name="planContent">
            <input type="button" class="buttonCustom" id="addPlandAddBtn" onclick="addPlan()">
        </form>
        <form id="planContainer">
        </form>
    </main>

    <script>
        window.addEventListener("load", function() {
            loadHeader()
            loadMain()
        })

        function loadHeader() {
            var plannerOwnerName = "<%=plannerOwnerName%>"
            document.getElementById("plannerOwnerText").innerHTML = plannerOwnerName + "님의 일정"

            var plannerDate = "<%=plannerDate%>"
            document.getElementById("plannerDateText").innerHTML = plannerDate
        }

        function loadMain() {
            showAddPlan()
            var planInfoList = makePlanInfoList()
            for(var index = 0; index < planInfoList.length; index++) {
                loadPlan(planInfoList[index], index)
            }
        }

        function showAddPlan() {
            var plannerOwnerCheck = <%=ownerCheck%>
            if(!plannerOwnerCheck) {
                document.getElementById("addPlanContainer").remove()
                var planContainer = document.getElementById("planContainer")
                planContainer.style.height = "100%"
                planContainer.style.border = "1px solid #d3d3d3"
            }
        }

        function makePlanInfoList() {
            var planInfoList = []
            <%for(int index = 0; index < planInfoList.size(); index++){%>
                var planInfo = "<%=planInfoList.get(index)%>".split(',')
                planInfoList.push(planInfo)
            <%}%>
            planInfoList.sort(function (planInfo1, planInfo2) {
                var planDateTime1 = new Date(planInfo1[1])
                var planDateTime2 = new Date(planInfo2[1])

                return planDateTime1.getTime() > planDateTime2.getTime() ? 1 : -1;
            })
            return planInfoList
        }

        function loadPlan(planInfo, index) {
            var planDay = parseInt(planInfo[1].substring(8,10))
            var planTime = planInfo[1].substring(11,13) + "시 " + planInfo[1].substring(14,16) + "분"
            var planBoxId = "planBoxDay" + planDay
            if(document.getElementById(planBoxId) == null) {
                addPlanBox(planDay)
            }

            var pastPlanCheck = checkPastPlan(planInfo[1])

            var planInfoBox = document.createElement("div")
            planInfoBox.className = "planInfoBox"

            var planTimeText = document.createElement("p")
            planTimeText.className = "basicFont planTimeText"
            planTimeText.innerHTML = planTime
            planInfoBox.appendChild(planTimeText)

            var planContentText = document.createElement("p")
            planContentText.className = "basicFont planContentText"
            if(pastPlanCheck) {
                planContentText.className += " pastPlanText"
            }
            planContentText.innerHTML = planInfo[2]
            planInfoBox.appendChild(planContentText)

            var ownerCheck = <%=ownerCheck%>
            if(ownerCheck) {
                var planBtnContainer = makeplanBtnContainer(index, planInfo[0])
                planInfoBox.appendChild(planBtnContainer)
            }

            document.getElementById(planBoxId).appendChild(planInfoBox)
        }

        function addPlanBox(planDay) {
            var planBox = document.createElement("div")
            planBox.className = "planBox"
            planBox.id = "planBoxDay" + planDay

            var planDayText = document.createElement("p")
            planDayText.className = "basicFont planDayText"
            planDayText.innerHTML = planDay + "일"
            planBox.appendChild(planDayText)

            document.getElementById("planContainer").appendChild(planBox)
        }

        function checkPastPlan(planDateTimeText) {
            var planDateTime = new Date(planDateTimeText)
            var nowDateTime = Date.now()

            return planDateTime < nowDateTime
        }

        function makeplanBtnContainer(index, planNum) {
            var planBtnContainer = document.createElement("div")
            planBtnContainer.className = "planBtnContainer"

            var planMenuBtn =document.createElement("input")
            planMenuBtn.type = "button"
            planMenuBtn.className = "planMenuBtn"
            planMenuBtn.onclick = function() {
                controlPlanSetBtnBox(index)
            }
            planBtnContainer.appendChild(planMenuBtn)

            var planSetBtnBox = document.createElement("div")
            planSetBtnBox.className = "planSetBtnBox"

            var planTagChangeBtn = document.createElement("input")
            planTagChangeBtn.type = "button"
            planTagChangeBtn.className = "basicFont planSetBtn"
            planTagChangeBtn.value = "수정"
            planTagChangeBtn.onclick = function() {
                changePlanContentToInput(index, planNum)
            }
            planSetBtnBox.appendChild(planTagChangeBtn)

            var planDeleteBtn = document.createElement("input")
            planDeleteBtn.type = "button"
            planDeleteBtn.className = "basicFont planSetBtn"
            planDeleteBtn.value = "삭제"
            planDeleteBtn.onclick = function() {
                deletePlan(planNum)
            }
            planSetBtnBox.appendChild(planDeleteBtn)

            planBtnContainer.appendChild(planSetBtnBox)

            return planBtnContainer
        }

        function controlPlanSetBtnBox(index) {
            var planSetBtnBoxList = document.getElementsByClassName("planSetBtnBox")
            if(planSetBtnBoxList[index].style.display == "flex") {
                planSetBtnBoxList[index].style.display = "none"
            }
            else {
                planSetBtnBoxList[index].style.display = "flex"
            }
        }

        function changePlanContentToInput(index, planNum) {
            var planInfoBoxList = document.getElementsByClassName("planInfoBox")
            var planContentTextList = document.getElementsByClassName("planContentText")

            var planContentInput = document.createElement("input")
            planContentInput.className = "basicFont planContentInput"
            planContentInput.value = planContentTextList[index].innerHTML
            planContentInput.name = "planContent"
            planInfoBoxList[index].appendChild(planContentInput)

            planContentTextList[index].remove()

            removePlanBtn()
            addUpdateBtn(index)
            setPlanContainer("updatePlanModule.jsp", planNum)
        }

        function removePlanBtn() {
            var planMenuBtnList = document.getElementsByClassName("planMenuBtn")
            var planSetBtnBoxList = document.getElementsByClassName("planSetBtnBox")

            while(planMenuBtnList[0] || planSetBtnBoxList[0]) {
                planMenuBtnList[0].remove()
                planSetBtnBoxList[0].remove()
            }
        }

        function addUpdateBtn(index) {
            var planBtnContainerList = document.getElementsByClassName("planBtnContainer")

            var planUpdateBtn = document.createElement("input")
            planUpdateBtn.type = "button"
            planUpdateBtn.className = "basicFont planSetBtn"
            planUpdateBtn.value = "수정"
            planUpdateBtn.onclick = function() {
                document.getElementById("planContainer").submit()
            }
            planBtnContainerList[index].appendChild(planUpdateBtn)
        }

        function deletePlan(planNum) {
            if(confirm("일정을 정말로 삭제하시겠습니까?") == true) {
                setPlanContainer("deletePlanModule.jsp", planNum)
                document.getElementById("planContainer").submit()
            }
            else {
                return
            }
        }

        function setPlanContainer(formAction, planNum) {
            var planContainer = document.getElementById("planContainer")
            planContainer.action = formAction

            var planNumInput = document.getElementById("planNumInput")
            if(planNumInput == null) {
                planNumInput = document.createElement("input")
                planNumInput.type = "hidden"
                planNumInput.id = "planNumInput"
                planNumInput.name = "planNum"
                planContainer.appendChild(planNumInput)
            }

            planNumInput.value = planNum
        }

        function lastMonthMove() {
            var plannerDateContainer = document.getElementById("plannerDateContainer")
            plannerDateContainer.action = "lastMonthMoveModule.jsp"
            plannerDateContainer.submit()
        }

        function nextMonthMove() {
            var plannerDateContainer = document.getElementById("plannerDateContainer")
            plannerDateContainer.action = "nextMonthMoveModule.jsp"
            plannerDateContainer.submit()
        }

        function addPlan() {
            if(document.getElementById("addPlanDateText").value == "" || document.getElementById("addPlanContentText").value == "") {
                alert("입력 칸을 확인해주세요")
                return
            }
            document.getElementById("addPlanContainer").submit()
        }

        function setAddPlanTime(timeType, oper) {
            var time = document.getElementById("addPlan" + timeType + "Text")
            var timeValue = time.value
            var changedTimeValue = parseInt(timeValue)
            if(oper == "+") {
                changedTimeValue += 1
                if(changedTimeValue >= 24 && timeType == "Hour") {
                    changedTimeValue -= 24
                }
                else if(changedTimeValue >= 60) {
                    changedTimeValue -= 60
                }
            }
            else {
                changedTimeValue -= 1
                if(changedTimeValue < 0) {
                    if(timeType == "Hour") {
                        changedTimeValue += 24
                    }
                    else {
                        changedTimeValue += 60
                    }
                }
            }
            time.value = (changedTimeValue >= 10 ? changedTimeValue : "0" + changedTimeValue)
        }
    </script>
</body>
