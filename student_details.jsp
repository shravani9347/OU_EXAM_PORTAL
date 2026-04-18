<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Calendar" %>
<%
    String hallTicket = request.getParameter("hallticket");
    String studentName = "Not Found"; 
    String courseName = "not found"; // Default values
    String examCenter = "Osmania University (OU-86)";
    
    // 1. Time Check Logic
    Calendar cal = Calendar.getInstance();
    int hour = cal.get(Calendar.HOUR_OF_DAY);
    // Exam time 10 AM nundi Night 11 PM varaku match ayyeలా set chesa
    boolean isExamTime = (hour >= 9 && hour < 23); 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/ou_exam_portal", "root", "");
        
        // Database nundi name, course details fetch chesthunnam
        String query = "SELECT s_name FROM student_info WHERE h_no = ?"; 
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, hallTicket);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            studentName = rs.getString("s_name");
        }
        con.close();
    } catch(Exception e) {
        studentName = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Examination Verification</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; display: flex; justify-content: center; padding: 20px; }
        .card { background: white; width: 650px; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .info-row { margin-bottom: 12px; font-size: 16px; border-bottom: 1px solid #eee; padding-bottom: 5px; }
        .label { font-weight: bold; color: #555; width: 150px; display: inline-block; }
        .value { color: #0056b3; font-weight: bold; }
        .loc-box { padding: 15px; border-radius: 8px; margin: 20px 0; font-weight: bold; text-align: center; }
        .loc-checking { background: #fff3cd; color: #856404; }
        .loc-success { background: #d4edda; color: #155724; }
        #otpArea { display: none; border-top: 2px dashed #ddd; padding-top: 20px; text-align: center; }
        .schedule-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .schedule-table th, .schedule-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .schedule-table th { background: #f8f9fa; }
        .btn-start { background: #2e7d32; color: white; padding: 15px 40px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .timer { float: right; background: #fff; border: 2px solid #d9534f; color: #d9534f; padding: 5px 15px; border-radius: 20px; font-weight: bold; }
    </style>
</head>
<body onload="startTimer()">
    <div class="card">
        <div id="timerDisplay" class="timer">00:30</div>
        <h2 style="color: #004a99; margin-top: 0;">Verification Module</h2>
        
        <div class="info-row"><span class="label">Student Name:</span> <span class="value"><%= studentName %></span></div>
        <div class="info-row"><span class="label">Hall Ticket:</span> <span class="value"><%= hallTicket %></span></div>
        <div class="info-row"><span class="label">Course:</span> <span class="value"><%= courseName %></span></div>
        <div class="info-row"><span class="label">Exam Center:</span> <span class="value" style="color: #d9534f;"><%= examCenter %></span></div>

        <div id="locationStatus" class="loc-box loc-checking">Checking Examination Center Geolocation...</div>

        <h3>Upcoming Exam Schedule</h3>
        <table class="schedule-table">
            <tr><th>Subject</th><th>Date</th><th>Timing</th></tr>
            <tr style="background: #e3f2fd;"><td><b>Java Programming</b></td><td>Today</td><td>10:00 AM - 01:00 PM</td></tr>
            <tr><td>DBMS</td><td>2026-04-18</td><td>02:00 PM - 05:00 PM</td></tr>
        </table>

        <% if (isExamTime) { %>
            <div id="otpArea">
                <p style="font-weight: bold;">Verification Required: Enter 6-Digit OTP Sent to Email</p>
                <input type="password" id="otpInput" maxlength="6" placeholder="**" style="font-size: 24px; width: 200px; text-align: center; padding: 10px; margin-bottom: 20px; border: 2px solid #ddd; border-radius: 8px;">
                <br>
                <button onclick="verifyAndStart()" class="btn-start">VERIFY & START EXAM</button>
            </div>
        <% } else { %>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-top: 20px; font-weight: bold; text-align: center;">
                ⚠️ Session Locked. Exam starts at 10:00 AM.
            </div>
        <% } %>
    </div>

    <script>
        let seconds = 30;
        function startTimer() {
            checkGeoLocation();
            const countdown = setInterval(() => {
                seconds--;
                document.getElementById("timerDisplay").innerHTML = "00:" + (seconds < 10 ? "0" : "") + seconds;
                if (seconds <= 0) {
                    clearInterval(countdown);
                    alert("Session Expired! Please login again.");
                    window.location.href = "index.html";
                }
            }, 1000);
        }

        function checkGeoLocation() {
            const status = document.getElementById("locationStatus");
            const otpBox = document.getElementById("otpArea");

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((position) => {
                    // Success case: Location verify ayindi
                    status.className = "loc-box loc-success";
                    status.innerHTML = "✓ Location Verified: Examination Center Match!";
                    if(otpBox) otpBox.style.display = "block"; 
                }, (error) => {
                    status.innerHTML = "❌ Error: Please enable GPS/Location to unlock OTP session.";
                    status.style.background = "#f8d7da";
                    status.style.color = "#721c24";
                });
            }
        }

        function verifyAndStart() {
            const otp = document.getElementById("otpInput").value;
            if(otp === "123456") { // Demo OTP
                alert("Identity Verified! Good Luck for your Exam.");
                window.location.href = "exam_page.jsp";
            } else {
                alert("Incorrect OTP! Please check again.");
            }
        }
    </script>
</body>
</html>