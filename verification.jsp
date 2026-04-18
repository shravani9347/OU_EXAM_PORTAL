<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Random" %>
<%
    String hallTicket = request.getParameter("hall_ticket");
    
    if (hallTicket != null && !hallTicket.isEmpty()) {
        Connection con = null;
        // XAMPP Port 3307 mariyu Database Name kachitanga undali
        String url = "jdbc:mysql://localhost:3307/OU_EXAM_PORTAL"; 
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, "root", "");

            // Student record vethakali
            String query = "SELECT * FROM students WHERE h_no = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, hallTicket);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 1. Details ni Session lo store cheyandi
                session.setAttribute("student_name", rs.getString("s_name"));
                session.setAttribute("hall_ticket", rs.getString("h_no"));
                session.setAttribute("email", rs.getString("s_email"));

                // 2. OTP generate chesi Session lo store cheyandi
                Random rand = new Random();
                int otp = 100000 + rand.nextInt(900000);
                session.setAttribute("generated_otp", String.valueOf(otp));

                // 3. Database lo OTP update cheyandi
                String updateQuery = "UPDATE students SET h_otp = ? WHERE h_no = ?";
                PreparedStatement psUpdate = con.prepareStatement(updateQuery);
                psUpdate.setInt(1, otp);
                psUpdate.setString(2, hallTicket);
                psUpdate.executeUpdate();

                // Details page ki redirect
                response.sendRedirect("student_details.jsp");
            } else {
                out.println("<script>alert('Student Not Found!'); window.location.href='index.html';</script>");
            }
        } catch (Exception e) {
            out.println("<h2 style='color:red;'>Database Error: " + e.getMessage() + "</h2>");
        } finally {
            if (con != null) try { con.close(); } catch(Exception e) {}
        }
    } else {
        response.sendRedirect("index.html");
    }
%>