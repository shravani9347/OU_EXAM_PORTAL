<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String h_no = request.getParameter("h_no");

    // 1. Hall ticket check
    if(h_no == null || h_no.trim().equals("")) {
        out.println("<script>alert('Please enter Hall Ticket Number'); window.location.href='index.html';</script>");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Port 3307 and DB name sync
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/ou_exam_portal", "root", "");
        
        // s_name and login_status fetch chesthunnam
        String query = "SELECT s_name, login_status FROM student_info WHERE h_no = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, h_no);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            int status = rs.getInt("login_status");
            String sname = rs.getString("s_name");

            // Session lo details store chesthunnam
            session.setAttribute("hall_ticket", h_no);
            session.setAttribute("student_name", sname);

            // 2. ALREADY SUBMITTED CHECK (Status 2)
            if (status == 2) {
                out.println("<script>alert('You have already submitted your exam!'); window.location.href='exam_success.jsp';</script>");
            } 
            else {
                // First time login ayithe status ni 1 ki marchali
                if(status == 0) {
                    String update = "UPDATE student_info SET login_status = 1 WHERE h_no = ?";
                    PreparedStatement psUp = con.prepareStatement(update);
                    psUp.setString(1, h_no);
                    psUp.executeUpdate();
                }
                // STUDENT DETAILS PAGE KI REDIRECT
                response.sendRedirect("student_details.jsp");
            }
        } else {
            out.println("<script>alert('Invalid Hall Ticket! Please check and try again.'); window.location.href='index.html';</script>");
        }
        con.close();
    } catch (Exception e) {
        // Ekkada error unna clear ga screen meedha chupisthundhi
        out.println("<body style='font-family:sans-serif; padding:20px;'>");
        out.println("<h2 style='color:red;'>Login Error!</h2>");
        out.println("<p><b>Details:</b> " + e.getMessage() + "</p>");
        out.println("<a href='index.html'>Go Back</a>");
        out.println("</body>");
    }
%>