<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Form nundi data collect cheyadam
    String name = request.getParameter("s_name");
    String hno = request.getParameter("h_no");
    String email = request.getParameter("s_email");
    String course = request.getParameter("course_name");

    // Line 11 & 12 ni ila marchu (Quotes lona mee real values veyyali)
String dburl = "jdbc:mysql://mysql://nozomi.proxy.rlwy.net:48731/railway:3306/railway";
String dbuser = "root";
String dbPass = "yaBcaJJgtVIrSlGOWsgRZCKXMyQHyaRa";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // Data insert cheyadaniki Query
        String query = "INSERT INTO student_info (s_name, h_no, s_email, course_name) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, hno);
        ps.setString(3, email);
        ps.setString(4, course);
        
        int status = ps.executeUpdate();
        
        if(status > 0) {
%>
            <script>
                alert("Registration Successful! You can now login with your Hall Ticket.");
                window.location.href='index.html';
            </script>
<%
        } else {
            out.println("Registration Failed. Please try again.");
        }
        con.close();
    } catch (Exception e) {
        out.println("Database Error: " + e.getMessage());
    }
%>
