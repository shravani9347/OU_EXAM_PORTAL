<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
//405 error fix
if("GET".equalsIgnoreCase(request.getMethod())){
response.sendRedirect("index.html");
return;
}
    // Form nundi details collect chesthunnam
    String name = request.getParameter("s_name");
    String hno = request.getParameter("h_no");
    String email = request.getParameter("s_email");
    String course = request.getParameter("course_name");

    // LOCALHOST SETTINGS (XAMPP)
    // Meeru 3307 annaru kabatti adhe peduthunna
    String dburl = "jdbc:mysql://ozomi.proxy.rlwy.net:48731/railway"; 
    String dbuser = "root";
    String dbPass = "yaBcaJJgtVIrSlGOWsgRZCKXMyQHyaRa"; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dburl, dbuser, dbPass);

        // Data insert query
        String query = "INSERT INTO student_info (s_name, h_no, s_email, course_name) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, hno);
        ps.setString(3, email);
        ps.setString(4, course);

        int status = ps.executeUpdate();

        if(status > 0) {
            // Success ayithe alert vachi index page ki velthundhi
%>
            <script>
                alert("Registration Successful!");
                window.location.href='index.html';
            </script>
<%
        } else {
            out.println("Registration Failed!");
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
