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

    String planNum = request.getParameter("planNum");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    String sql = "DELETE FROM plans WHERE plan_num = ?";
    PreparedStatement query =  connect.prepareStatement(sql);
    query.setString(1, planNum);
    query.executeUpdate();
%>

<script>
    window.onload = function() {
        window.location = document.referrer
    }
</script>
