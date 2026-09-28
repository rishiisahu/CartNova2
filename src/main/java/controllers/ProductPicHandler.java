package controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import utils.DBConnection;

@WebServlet("/product_pic.do")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ProductPicHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads/products";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String productPath = request.getParameter("product_path");
        if (productPath == null || productPath.trim().isEmpty()) {
            response.sendRedirect("images/products.png");
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        File file = new File(applicationPath + File.separator + productPath);
        if (!file.exists()) {
            file = new File(productPath);
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
            response.sendRedirect("images/products.png");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String productIdStr = request.getParameter("product_id");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("products.do");
            return;
        }

        int productId = Integer.parseInt(productIdStr.trim());
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadFolder = new File(uploadFilePath);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO product_pics (product_id, pic_path, main_pic) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            boolean isFirst = true;
            for (Part part : request.getParts()) {
                if ("product_pics".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = "prod_" + productId + "_" + System.currentTimeMillis() + "_" + extractFileName(part);
                    String relativePath = UPLOAD_DIR + "/" + fileName;
                    part.write(uploadFilePath + File.separator + fileName);

                    ps.setInt(1, productId);
                    ps.setString(2, relativePath);
                    ps.setBoolean(3, isFirst);
                    ps.executeUpdate();
                    isFirst = false;
                }
            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con);
        }

        response.sendRedirect("products.do");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "product.jpg";
    }
}
