<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>

<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String userPw = request.getParameter("userPw");
    boolean isLogin = false;

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ssweb_planner", "kkikki", "tjdals13");

    String sql = "SELECT user_id, user_name, user_department, user_position FROM accounts WHERE user_id = ? AND user_pw = ?";
    PreparedStatement query =  connect.prepareStatement(sql);
    query.setString(1, userId);
    query.setString(2, userPw);

    ResultSet result = query.executeQuery();

    if(result.next()) {
        if(!result.getString(1).equals("")){
            isLogin = true;

            String nowDate = LocalDateTime.now().plusHours(9).toString();
            String nowYear = nowDate.substring(0,4);
            String nowMonth = nowDate.substring(5,7);

            session.setAttribute("userId", result.getString(1));
            session.setAttribute("userName", result.getString(2));
            session.setAttribute("userDepartment", result.getString(3));
            session.setAttribute("userPosition", result.getString(4));
            session.setAttribute("plannerYear", nowYear);
            session.setAttribute("plannerMonth", nowMonth);

            Cookie sessionId = new Cookie("sessionId", session.getId());
            sessionId.setMaxAge(60*60*1);
            sessionId.setPath("/");

            response.addCookie(sessionId);
        };
    }
%>

<body>
</body>

<script>
    window.onload = function() {
        if(!<%=isLogin%>) {
            alert("로그인에 실패했습니다")
            history.back()
        }
        else {
            var form = document.createElement("form")
            form.action = "../planner/plannerPage.jsp"
            var body = document.getElementsByTagName("body")
            body[0].appendChild(form)
            form.submit()
        }
    }
    
</script>
