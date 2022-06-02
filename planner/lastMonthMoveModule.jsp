<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("../login/loginPage.jsp");
        return;
    }

    String plannerYear = (String)session.getAttribute("plannerYear");
    String plannerMonth = (String)session.getAttribute("plannerMonth");
    int intPlannerYear = Integer.parseInt(plannerYear);
    int intPlannerMonth = Integer.parseInt(plannerMonth);

    intPlannerMonth -= 1;
    if(intPlannerMonth <= 0 ) {
        intPlannerYear -= 1;
        intPlannerMonth += 12;
    }

    String changedPlannerYear = Integer.toString(intPlannerYear);
    String changedPlannerMonth;
    if(intPlannerMonth >= 10) {
        changedPlannerMonth = Integer.toString(intPlannerMonth);
    }
    else {
        changedPlannerMonth = "0" + Integer.toString(intPlannerMonth);
    }

    session.setAttribute("plannerYear", changedPlannerYear);
    session.setAttribute("plannerMonth", changedPlannerMonth);
%>

<body>
    <script>
        window.onload = function() {
            window.location = document.referrer
        }
    </script>
</body>