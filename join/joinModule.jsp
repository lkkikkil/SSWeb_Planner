<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String userPw = request.getParameter("userPw");
    String userName = request.getParameter("userName");
    String userDepartment = request.getParameter("userDepartment");
    String userPosition = request.getParameter("userPosition");
    boolean joinCheck = true;

    if(userId == "" || userPw == "" || userName == "" || userDepartment == "" || userPosition == "") {
        joinCheck = false;
    }
    else if(userId.length() > 20 || userPw.length() > 20) {
        joinCheck = false;
    }
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    if(joinCheck) {
        String sql = "INSERT INTO accounts (user_id, user_pw, user_name, user_department, user_position) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement query =  connect.prepareStatement(sql);
        query.setString(1, userId);
        query.setString(2, userPw);
        query.setString(3, userName);
        query.setString(4, userDepartment);
        query.setString(5, userPosition);
    
        query.executeUpdate();
    }
%>

<script>
    window.onload = function() {
        if(<%=joinCheck%>) {
            var form = document.createElement("form")
            form.action = "../login/loginPage.jsp"
            var body = document.getElementsByTagName("body")
            body[0].appendChild(form)
            form.submit()
        }
        else {
            alert("입력값을 확인해주세요.")
        }
    }
</script>
