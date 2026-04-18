<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String hno = request.getParameter("hallticket");
    
    if (hno == null || hno.trim().isEmpty()) {
        response.sendRedirect("index.html");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Port 3307 mariyu Database Name sync chesa
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3307/ou_exam_portal", "root", "");
        
        String query = "SELECT s_name, login_status FROM student_info WHERE h_no = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, hno);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            int status = rs.getInt("login_status");
            String sname = rs.getString("s_name");

            session.setAttribute("hall_ticket", hno);
            session.setAttribute("student_name", sname);

            if (status == 2) {
                // Exam aipoindi kabatti Success page ki velthundi
                response.sendRedirect("exam_success.jsp");
            } else {
                // Modati sari login ayithe Registration Details page open avthundhi
                // Ikkada mee file name "student_details.jsp" ayithe adhe ivvandi
                response.sendRedirect("student_details.jsp?hallticket=" + hno);
            }
        } else {
            out.println("<script>alert('Hall Ticket Not Found!'); window.location.href='index.html';</script>");
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>