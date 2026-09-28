package controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import models.User;
import utils.DBConnection;

@WebServlet("/pic_handler.do")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class PicHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads/users";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String picPath = request.getParameter("pic_path");
        if (picPath == null || picPath.trim().isEmpty()) {
            response.sendRedirect("images/user.png");
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        File file = new File(applicationPath + File.separator + picPath);
        if (!file.exists()) {
            file = new File(picPath);
        }

        if (file.exists()) {
            String mimeType = request.getServletContext().getMimeType(file.getAbsolutePath());
            if (mimeType == null) {
                mimeType = "image/jpeg";
            }
            response.setContentType(mimeType);
            response.setContentLength((int) file.length());

            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead = -1;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendRedirect("images/user.png");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("signin.jsp");
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadFolder = new File(uploadFilePath);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        Part part = request.getPart("pic");
        if (part != null && part.getSize() > 0) {
            String fileName = "user_" + user.getUserId() + "_" + System.currentTimeMillis() + "_" + extractFileName(part);
            String relativeSavePath = UPLOAD_DIR + "/" + fileName;
            part.write(uploadFilePath + File.separator + fileName);

            // Update user in DB
            Connection con = null;
            try {
                con = DBConnection.getConnection();
                String sql = "UPDATE users SET pic = ? WHERE user_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, relativeSavePath);
                ps.setInt(2, user.getUserId());
                ps.executeUpdate();
                ps.close();

                user.setPic(relativeSavePath);
                session.setAttribute("user", user);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBConnection.closeConnection(con);
            }
        }

        response.sendRedirect("user_profile.do");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "avatar.jpg";
    }
}
