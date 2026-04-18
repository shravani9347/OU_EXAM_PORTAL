<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String hallTicket = (String) session.getAttribute("hall_ticket");
    String studentName = (String) session.getAttribute("student_name");
    if (hallTicket == null) { response.sendRedirect("index.html"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Java Programming Exam - OU Portal</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .exam-card { max-width: 900px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); position: relative; }
        
        /* TIMER STYLE */
        .timer-box { position: fixed; top: 20px; right: 20px; background: #d32f2f; color: white; padding: 15px; border-radius: 8px; font-weight: bold; font-size: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); z-index: 1000; }
        
        .header-box { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #004a99; padding-bottom: 15px; margin-bottom: 20px; }
        .section-header { background: #eef5ff; color: #004a99; padding: 10px 15px; font-weight: bold; border-radius: 5px; margin: 25px 0 15px 0; border-left: 5px solid #004a99; }
        .question-wrap { margin-bottom: 20px; padding: 15px; border-bottom: 1px solid #eee; }
        .writing-area { width: 100%; height: 120px; padding: 10px; border: 1px solid #ccc; border-radius: 5px; resize: vertical; margin-top: 10px; }
        .option-item { display: block; margin: 8px 0; cursor: pointer; }
        .btn-submit { background: #2e7d32; color: white; padding: 15px; width: 100%; border: none; border-radius: 5px; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 30px; }
    </style>
</head>
<body>

<div class="timer-box" id="timer">03:00:00</div>

<div class="exam-card">
    <div class="header-box">
        <h2 style="color: #004a99; margin: 0;">Online Examination</h2>
        <div style="text-align: right; font-size: 13px; color: #666;">
            Student: <b><%= studentName %></b><br>
            HT No: <b><%= hallTicket %></b>
        </div>
    </div>

    <form id="examForm" action="exam_success.jsp" method="post">
        <input type="hidden" name="hall_ticket" value="<%= hallTicket %>">

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/ou_exam_portal", "root", "");
                Statement st = con.createStatement();

                // --- PART A ---
                out.println("<div class='section-header'>PART - A: Descriptive Questions (Paragraph Type)</div>");
                ResultSet rsA = st.executeQuery("SELECT * FROM questions WHERE q_type='Part-A' ORDER BY RAND() LIMIT 2");
                int qCountA = 1;
                while(rsA.next()) {
        %>
                    <div class="question-wrap">
                        <b>Q<%= qCountA %>. <%= rsA.getString("q_text") %></b>
                        <input type="hidden" name="qid_a_<%= qCountA %>" value="<%= rsA.getInt("q_id") %>">
                        <textarea name="ans_a_<%= qCountA %>" class="writing-area" placeholder="Write answer here..."></textarea>
                    </div>
        <%
                    qCountA++;
                }

                // --- PART B ---
                out.println("<div class='section-header'>PART - B: Objective Questions (MCQs)</div>");
                ResultSet rsB = st.executeQuery("SELECT * FROM questions WHERE q_type='Part-B' ORDER BY RAND() LIMIT 5");
                int qCountB = 1;
                while(rsB.next()) {
        %>
                    <div class="question-wrap">
                        <b>Q<%= qCountB %>. <%= rsB.getString("q_text") %></b>
                        <input type="hidden" name="qid_b_<%= qCountB %>" value="<%= rsB.getInt("q_id") %>">
                        <label class="option-item"><input type="radio" name="ans_b_<%= qCountB %>" value="A"> <%= rsB.getString("opt_a") %></label>
                        <label class="option-item"><input type="radio" name="ans_b_<%= qCountB %>" value="B"> <%= rsB.getString("opt_b") %></label>
                        <label class="option-item"><input type="radio" name="ans_b_<%= qCountB %>" value="C"> <%= rsB.getString("opt_c") %></label>
                        <label class="option-item"><input type="radio" name="ans_b_<%= qCountB %>" value="D"> <%= rsB.getString("opt_d") %></label>
                    </div>
        <%
                    qCountB++;
                }
                con.close();
            } catch (Exception e) { out.println(e); }
        %>

        <button type="submit" class="btn-submit">SUBMIT EXAMINATION</button>
    </form>
</div>

<script>
    // 3 HOURS TIMER LOGIC
    let timeInSeconds = 3 * 60 * 60; // 3 hours converted to seconds
    const timerElement = document.getElementById('timer');

    function updateTimer() {
        let hours = Math.floor(timeInSeconds / 3600);
        let minutes = Math.floor((timeInSeconds % 3600) / 60);
        let seconds = timeInSeconds % 60;

        // Display format 00:00:00
        timerElement.innerHTML = 
            (hours < 10 ? "0" + hours : hours) + ":" + 
            (minutes < 10 ? "0" + minutes : minutes) + ":" + 
            (seconds < 10 ? "0" + seconds : seconds);

        if (timeInSeconds <= 0) {
            alert("Time up! Your exam will be submitted automatically.");
            document.getElementById("examForm").submit();
        } else {
            timeInSeconds--;
        }
    }

    setInterval(updateTimer, 1000);

    // Tab switch detection
    document.addEventListener("visibilitychange", function() {
        if (document.visibilityState === 'hidden') {
            alert("Warning! Tab switching detected. Auto-submitting...");
            document.getElementById("examForm").submit();
        }
    });

    document.oncontextmenu = (e) => e.preventDefault();
</script>

</body>
</html>