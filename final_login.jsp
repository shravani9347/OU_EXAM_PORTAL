<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userOtp = request.getParameter("user_otp");
    if (userOtp != null && userOtp.equals("123456")) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Online Exam Paper</title>
    <style>
        body { font-family: sans-serif; background: #f8f9fa; padding: 20px; }
        .paper-card { background: white; padding: 30px; border-radius: 10px; max-width: 700px; margin: auto; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #d9534f; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .question { margin-bottom: 20px; font-weight: bold; }
        .options { margin-left: 20px; margin-bottom: 30px; }
        .submit-btn { background: #0275d8; color: white; padding: 15px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 18px; }
    </style>
</head>
<body>
    <div class="paper-card">
        <h2>End-Semester Examination: Web Technologies</h2>
        <p>Student: <b><%= session.getAttribute("student_name") %></b> | Time: 3 Hours</p>
        <hr>
        
        <form action="exam_success.jsp" method="POST">
            <div class="question">1. What does JSP stand for?</div>
            <div class="options">
                <input type="radio" name="q1" value="a"> Java Server Pages<br>
                <input type="radio" name="q1" value="b"> Java Service Provider<br>
                <input type="radio" name="q1" value="c"> Java State Page
            </div>

            <div class="question">2. Which tag is used to write Java code in JSP?</div>
            <div class="options">
                <input type="radio" name="q2" value="a"> &lt;script&gt;<br>
                <input type="radio" name="q2" value="b"> &lt;% %&gt;<br>
                <input type="radio" name="q2" value="c"> &lt;java&gt;
            </div>

            <div class="question">3. What is the default port for MySQL in XAMPP?</div>
            <div class="options">
                <input type="radio" name="q3" value="a"> 3306<br>
                <input type="radio" name="q3" value="b"> 8080<br>
                <input type="radio" name="q3" value="c"> 3307
            </div>

            <button type="submit" class="submit-btn">Submit Answer Sheet</button>
        </form>
    </div>
</body>
</html>
<% } else { %>
    <script>alert("Invalid OTP!"); window.location.href='student_details.jsp';</script>
<% } %>