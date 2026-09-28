package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/60db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                // Fallback for older MySQL connector
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                System.err.println("MySQL JDBC Driver not found in classpath: " + ex.getMessage());
            }
        }
    }

    public static Connection getConnection() throws SQLException {
        String dbUrl = System.getenv("DB_URL");
        if (dbUrl == null || dbUrl.trim().isEmpty()) {
            dbUrl = DEFAULT_URL;
        }

        String dbUser = System.getenv("DB_USER");
        if (dbUser == null || dbUser.trim().isEmpty()) {
            dbUser = DEFAULT_USER;
        }

        String dbPassword = System.getenv("DB_PASSWORD");
        if (dbPassword == null) {
            dbPassword = DEFAULT_PASSWORD;
        }

        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    public static void closeConnection(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignored) {
            }
        }
    }
}
