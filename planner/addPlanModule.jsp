<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if(userId == null) {
        response.sendRedirect("../login/loginPage.jsp");
        return;
    }

    String planDate = request.getParameter("planDate");
    String planHour = request.getParameter("planHour");
    String planMin = request.getParameter("planMin");
    String planDateTime = planDate + " " + planHour + ":" + planMin;
    String planContent = request.getParameter("planContent");
    boolean addplanCheck = true;

    if(planDate == "" || planContent == "") {
        addplanCheck = false;
    }
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    if(addplanCheck) {
        String sql = "INSERT INTO plans (user_id, plan_date, plan_content) VALUES (?, ?, ?)";
        PreparedStatement query =  connect.prepareStatement(sql);
        query.setString(1, userId);
        query.setString(2, planDateTime);
        query.setString(3, planContent);
    
        query.executeUpdate();
    }
%>

<script>
    window.onload = function() {
        window.location = document.referrer
    }
</script>
