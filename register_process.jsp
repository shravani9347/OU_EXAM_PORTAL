<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 405 Error Fix
    if ("GET".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("index.html"); 
        return;
    }

    // Form nundi values teeskuntunnam
    String sname = request.getParameter("s_name");
    String hno = request.getParameter("h_no");
    String semail = request.getParameter("s_email");
    String scourse = request.getParameter("course_name");

    // Railway Cloud Values (9deb5158 screenshot nundi)
    String dburl = "jdbc:mysql://ozoni.proxy.rlwy.net:48731/railway";
    String dbuser = "root";
    String dbPass = "yaBcaJ3gtV1rS1G0MsgRZCXXXyQhyaRa";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dburl, dbuser, dbPass);

        // Mee table lo unna column names (s_name, h_no, s_email, course_name)
        String query = "INSERT INTO student_info (s_name, h_no, s_email, course_name) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, sname);
        ps.setString(2, hno);
        ps.setString(3, semail);
        ps.setString(4, scourse);

        int status = ps.executeUpdate();

        if(status > 0) {
%>
            <script>
                alert("Registration Success! Ippudu Hall Ticket tho login avvu.");
                window.location.href='index.html';
            </script>
<%
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
