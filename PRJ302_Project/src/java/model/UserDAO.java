/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.UserDTO;
import utils.DbUtils;

/**
 *
 * @author VNT
 */
public class UserDAO {

    public UserDAO() {
    }

    /**
     * Tìm user theo ID
     *
     * @param id
     * @return UserDTO hoặc null nếu không tìm thấy
     */
    public UserDTO searchById(int id) {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE user_id=?";
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String role = rs.getString("role");
                String status = rs.getString("status");
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                user = new UserDTO(userId, username, password, fullName, email, phone, role, status, createdAt, updatedAt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        System.out.println(user);
        return user;
    }

    /**
     * Tìm user theo username
     *
     * @param username
     * @return UserDTO hoặc null nếu không tìm thấy
     */
    public UserDTO searchByUsername(String username) {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE username=?";
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            rs = pst.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String uname = rs.getString("username");
                String password = rs.getString("password");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String role = rs.getString("role");
                String status = rs.getString("status");
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                user = new UserDTO(userId, uname, password, fullName, email, phone, role, status, createdAt, updatedAt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return user;
    }

    /**
     * Đăng nhập
     *
     * @param username
     * @param password
     * @return UserDTO nếu đăng nhập thành công, null nếu thất bại
     */
    public UserDTO login(String username, String password) {
        UserDTO user = searchByUsername(username);

        // Kiểm tra password và status
        if (user != null && user.getPassword().equals(password)) {
            // Kiểm tra tài khoản có active không
            if ("ACTIVE".equalsIgnoreCase(user.getStatus())) {
                return user;
            } else {
                System.out.println("Tài khoản đã bị khóa hoặc không hoạt động!");
                return null;
            }
        }

        return null;
    }

    /**
     * Lấy tất cả users
     *
     * @return List<UserDTO>
     */
    public List<UserDTO> getAllUsers() {
        List<UserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [User] ORDER BY user_id DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String role = rs.getString("role");
                String status = rs.getString("status");
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                UserDTO user = new UserDTO(userId, username, password, fullName, email, phone, role, status, createdAt, updatedAt);
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    /**
     * Tìm kiếm users theo tên hoặc email
     *
     * @param keyword
     * @return List<UserDTO>
     */
    public List<UserDTO> searchUsers(String keyword) {
        List<UserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE full_name LIKE ? OR email LIKE ? OR username LIKE ?";
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            rs = pst.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                String role = rs.getString("role");
                String status = rs.getString("status");
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                UserDTO user = new UserDTO(userId, username, password, fullName, email, phone, role, status, createdAt, updatedAt);
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    /**
     * Thêm user mới (CREATE)
     *
     * @param user
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addUser(UserDTO user) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO [User] (username, password, full_name, email, phone, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, user.getUsername());
            pst.setString(2, user.getPassword());
            pst.setString(3, user.getFullName());
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getPhone());
            pst.setString(6, user.getRole());
            pst.setString(7, user.getStatus());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Cập nhật thông tin user (UPDATE)
     *
     * @param user
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateUserByAdmin(UserDTO user) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE [User] SET username=?, password=?, full_name=?, email=?, phone=?, role=?, status=?, updated_at=GETDATE() WHERE user_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, user.getUsername());
            pst.setString(2, user.getPassword());
            pst.setString(3, user.getFullName());
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getPhone());
            pst.setString(6, user.getRole());
            pst.setString(7, user.getStatus());
            pst.setInt(8, user.getUserId());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Xóa user (DELETE) - Xóa vĩnh viễn
     *
     * @param userId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteUser(int userId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM [User] WHERE user_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, userId);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Khóa/Mở khóa user (Soft delete - thay đổi status)
     *
     * @param userId
     * @param status (ACTIVE, INACTIVE, BLOCKED)
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean changeUserStatus(int userId, String status) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE [User] SET status=?, updated_at=GETDATE() WHERE user_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            pst.setInt(2, userId);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Đổi mật khẩu
     *
     * @param userId
     * @param newPassword
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean changePassword(int userId, String newPassword) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE [User] SET password=?, updated_at=GETDATE() WHERE user_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newPassword);
            pst.setInt(2, userId);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     *
     * @param username
     * @return true nếu đã tồn tại, false nếu chưa
     */
    public boolean isUsernameExist(String username) {
        return searchByUsername(username) != null;
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     *
     * @param email
     * @return true nếu đã tồn tại, false nếu chưa
     */
    public boolean isEmailExist(String email) {
        String sql = "SELECT email FROM [User] WHERE email=?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, email);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next(); // Có tồn tại -> true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExist(String email, int userId) {
        // SQL: Tìm email này nhưng phải khác ID của người đang sửa
        String sql = "SELECT email FROM [User] WHERE email=? AND user_id <> ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, email);
            pst.setInt(2, userId);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next(); // Có người KHÁC dùng email này -> true
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đăng ký tài khoản (Register) role = CUSTOMER status = ACTIVE
     */
    public boolean register(UserDTO u) {
        int result = 0;

        try ( Connection conn = DbUtils.getConnection()) {

            String sql = "INSERT INTO [User] "
                    + "(username, [password], full_name, email, phone, role, status, created_at, updated_at) "
                    + "VALUES (?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getPhone());
            ps.setString(6, "CUSTOMER");
            ps.setString(7, "ACTIVE");
            ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

            result = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace(); // RẤT QUAN TRỌNG
        }

        return result > 0;
    }

    public boolean updateCustomerProfile(UserDTO user) {
        String sql = "UPDATE [User] SET full_name=?, email=?, phone=?, updated_at=GETDATE() WHERE user_id=?";

        // Try-with-resources: Tự động đóng resource trong ngoặc ()
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, user.getFullName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPhone());
            pst.setInt(4, user.getUserId());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
