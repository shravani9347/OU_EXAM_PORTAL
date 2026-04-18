<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- EE KINDHA UNNA LINE CHALA IMPORTANT - IDHI MISS AYITHE ERROR OSTHUNDHI --%>
<%@ page import="java.sql.*" %> 

<%
    String hno = (String) session.getAttribute("hall_ticket");
    String sname = (String) session.getAttribute("student_name");

    if (hno != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Meeru screenshot lo pampina port 3307 mariyu db name vaaduthunnam
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/ou_exam_portal", "root", "");
            
            // Exam submit chesharu kabatti status ni 2 ki update chesthunnam
            String query = "UPDATE student_info SET login_status = 2 WHERE h_no = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, hno);
            ps.executeUpdate();
            
            con.close();
        } catch(Exception e) {
            out.println("DB Error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Exam Submitted</title>
    <%-- 5 seconds tharuvatha automatic ga home ki velladaniki --%>
    <meta http-equiv="refresh" content="5;url=index.html">
    <script>
        // Page load avvagane alert chupisthundhi
        window.onload = function() {
            alert("Submission Successful! You have done the exam.");
        };
    </script>
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .box { background: white; padding: 40px; border-radius: 12px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 400px; }
        h1 { color: #2e7d32; margin-bottom: 10px; }
        .msg { color: #d9534f; font-weight: bold; font-size: 1.1em; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="box">
        <h1>Thank You!</h1>
        <p>Your Exam Paper has been submitted successfully.</p>
        <p>Student: <b><%= (sname != null) ? sname : "Student" %></b></p>
        <div class="msg">You have done the exam!</div>
        <p style="font-size: 0.9em; color: #666;">Redirecting to Home page in 5 seconds...</p>
        <br>
        <a href="index.html" style="color: #0056b3; font-weight: bold; text-decoration: none;">Click here if not redirected</a>
    </div>
</body>
</html>