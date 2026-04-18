<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 405 Error rakunda undalante e block add cheyyali
    if ("GET".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("registration.html"); 
        return;
    }

    String name = request.getParameter("s_name");
    String hno = request.getParameter("h_no");
    String email = request.getParameter("s_email");
    String course = request.getParameter("course_name");

    // Railway Variables (Screenshot 9deb5158 nundi)
    String dburl = "jdbc:mysql://ozoni.proxy.rlwy.net:48731/railway";
    String dbuser = "root";
    String dbPass = "yaBcaJ3gtV1rS1G0MsgRZCXXXyQhyaRa";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dburl, dbuser, dbPass);

        String query = "INSERT INTO student_info (name, hall_ticket, password) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, hno);
        ps.setString(3, "123"); // Default password or use another parameter

        int status = ps.executeUpdate();

        if(status > 0) {
%>
            <script>
                alert("Registration Successful! Now login with Hall Ticket.");
                window.location.href='index.html';
            </script>
<%
        } else {
            out.println("Registration Failed. Try again.");
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
