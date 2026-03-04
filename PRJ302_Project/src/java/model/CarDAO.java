package model;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 * CarDAO - Data Access Object cho bảng Car
 * Đã fix: exception handling rõ ràng, getAllCarsFiltered thay cho getCarsByPageWithFilter 99999
 */
public class CarDAO {

    public CarDAO() {
    }

    // =====================================================
    // LẤY TẤT CẢ XE (dùng cho trang danh sách)
    // =====================================================

    /**
     * Lấy TOÀN BỘ xe, không filter, sắp xếp mới nhất trước
     */
    public List<CarDTO> getAllCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "ORDER BY c.car_id DESC";

            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractCarFromResultSet(rs));
            }
            System.out.println("[CarDAO] getAllCars() -> " + list.size() + " xe");

        } catch (ClassNotFoundException e) {
            System.err.println("[CarDAO] getAllCars() - DRIVER NOT FOUND: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("[CarDAO] getAllCars() - SQL ERROR: " + e.getMessage());
            System.err.println("[CarDAO] SQLState: " + e.getSQLState() + " | ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[CarDAO] getAllCars() - UNEXPECTED ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }

        return list;
    }

    /**
     * Lấy TOÀN BỘ xe có áp dụng filter (brand, category, giá)
     * Dùng cho trang cars khi người dùng lọc xe
     */
    public List<CarDTO> getAllCarsFiltered(Integer brandId, Integer categoryId,
                                           BigDecimal minPrice, BigDecimal maxPrice) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT DISTINCT c.car_id, c.model_id, c.price, c.color, c.engine, ");
            sql.append("c.transmission, c.mileage, c.status, c.description, ");
            sql.append("c.created_at, c.updated_at, ");
            sql.append("cm.model_name, b.brand_name, b.brand_id ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");

            // JOIN CarCategory chỉ khi cần filter theo category
            if (categoryId != null) {
                sql.append("INNER JOIN CarCategory cc ON c.car_id = cc.car_id ");
            }

            // Build WHERE
            List<String> conditions = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            if (brandId != null) {
                conditions.add("b.brand_id = ?");
                params.add(brandId);
            }
            if (categoryId != null) {
                conditions.add("cc.category_id = ?");
                params.add(categoryId);
            }
            if (minPrice != null) {
                conditions.add("c.price >= ?");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                conditions.add("c.price <= ?");
                params.add(maxPrice);
            }

            if (!conditions.isEmpty()) {
                sql.append("WHERE ");
                sql.append(String.join(" AND ", conditions));
                sql.append(" ");
            }

            sql.append("ORDER BY c.car_id DESC");

            System.out.println("[CarDAO] getAllCarsFiltered() SQL: " + sql.toString());
            System.out.println("[CarDAO] Params: brandId=" + brandId + " | categoryId=" + categoryId
                    + " | minPrice=" + minPrice + " | maxPrice=" + maxPrice);

            pst = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    pst.setInt(i + 1, (Integer) p);
                } else if (p instanceof BigDecimal) {
                    pst.setBigDecimal(i + 1, (BigDecimal) p);
                } else if (p instanceof String) {
                    pst.setString(i + 1, (String) p);
                }
            }

            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractCarFromResultSet(rs));
            }
            System.out.println("[CarDAO] getAllCarsFiltered() -> " + list.size() + " xe");

        } catch (ClassNotFoundException e) {
            System.err.println("[CarDAO] getAllCarsFiltered() - DRIVER NOT FOUND: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("[CarDAO] getAllCarsFiltered() - SQL ERROR: " + e.getMessage());
            System.err.println("[CarDAO] SQLState: " + e.getSQLState() + " | ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[CarDAO] getAllCarsFiltered() - UNEXPECTED ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }

        return list;
    }

    // =====================================================
    // PAGINATION (giữ lại để dùng chỗ khác nếu cần)
    // =====================================================

    public List<CarDTO> getCarsByPage(int page, int carsPerPage) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            int offset = (page - 1) * carsPerPage;

            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "ORDER BY c.car_id DESC " +
                         "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            pst = conn.prepareStatement(sql);
            pst.setInt(1, offset);
            pst.setInt(2, carsPerPage);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractCarFromResultSet(rs));
            }
        } catch (Exception e) {
            System.err.println("[CarDAO] getCarsByPage() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> getCarsByPageWithFilter(int page, int carsPerPage,
                                                 Integer brandId, Integer categoryId,
                                                 BigDecimal minPrice, BigDecimal maxPrice,
                                                 String status) {
        // Nếu page=1 và carsPerPage rất lớn => dùng getAllCarsFiltered cho đơn giản
        if (page == 1 && carsPerPage >= 99999) {
            return getAllCarsFiltered(brandId, categoryId, minPrice, maxPrice);
        }

        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            int offset = (page - 1) * carsPerPage;

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT DISTINCT c.car_id, c.model_id, c.price, c.color, c.engine, ");
            sql.append("c.transmission, c.mileage, c.status, c.description, ");
            sql.append("c.created_at, c.updated_at, ");
            sql.append("cm.model_name, b.brand_name, b.brand_id ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");

            if (categoryId != null) {
                sql.append("INNER JOIN CarCategory cc ON c.car_id = cc.car_id ");
            }

            List<String> conditions = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            if (brandId != null) { conditions.add("b.brand_id = ?"); params.add(brandId); }
            if (categoryId != null) { conditions.add("cc.category_id = ?"); params.add(categoryId); }
            if (minPrice != null) { conditions.add("c.price >= ?"); params.add(minPrice); }
            if (maxPrice != null) { conditions.add("c.price <= ?"); params.add(maxPrice); }
            if (status != null && !status.isEmpty()) { conditions.add("c.status = ?"); params.add(status); }

            if (!conditions.isEmpty()) {
                sql.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
            }

            sql.append("ORDER BY c.car_id DESC ");
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            pst = conn.prepareStatement(sql.toString());

            int idx = 1;
            for (Object p : params) {
                if (p instanceof Integer) pst.setInt(idx++, (Integer) p);
                else if (p instanceof BigDecimal) pst.setBigDecimal(idx++, (BigDecimal) p);
                else if (p instanceof String) pst.setString(idx++, (String) p);
            }
            pst.setInt(idx++, offset);
            pst.setInt(idx, carsPerPage);

            rs = pst.executeQuery();
            while (rs.next()) {
                list.add(extractCarFromResultSet(rs));
            }
        } catch (Exception e) {
            System.err.println("[CarDAO] getCarsByPageWithFilter() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =====================================================
    // COUNT
    // =====================================================

    public int getTotalCars() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            pst = conn.prepareStatement("SELECT COUNT(*) as total FROM Car");
            rs = pst.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            System.err.println("[CarDAO] getTotalCars() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return 0;
    }

    public int getTotalCarsWithFilter(Integer brandId, Integer categoryId,
                                       BigDecimal minPrice, BigDecimal maxPrice,
                                       String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(DISTINCT c.car_id) as total ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");

            if (categoryId != null) {
                sql.append("INNER JOIN CarCategory cc ON c.car_id = cc.car_id ");
            }

            List<String> conditions = new ArrayList<>();
            List<Object> params = new ArrayList<>();

            if (brandId != null) { conditions.add("b.brand_id = ?"); params.add(brandId); }
            if (categoryId != null) { conditions.add("cc.category_id = ?"); params.add(categoryId); }
            if (minPrice != null) { conditions.add("c.price >= ?"); params.add(minPrice); }
            if (maxPrice != null) { conditions.add("c.price <= ?"); params.add(maxPrice); }
            if (status != null && !status.isEmpty()) { conditions.add("c.status = ?"); params.add(status); }

            if (!conditions.isEmpty()) {
                sql.append("WHERE ").append(String.join(" AND ", conditions));
            }

            pst = conn.prepareStatement(sql.toString());
            int idx = 1;
            for (Object p : params) {
                if (p instanceof Integer) pst.setInt(idx++, (Integer) p);
                else if (p instanceof BigDecimal) pst.setBigDecimal(idx++, (BigDecimal) p);
                else if (p instanceof String) pst.setString(idx++, (String) p);
            }

            rs = pst.executeQuery();
            if (rs.next()) return rs.getInt("total");

        } catch (Exception e) {
            System.err.println("[CarDAO] getTotalCarsWithFilter() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return 0;
    }

    // =====================================================
    // CRUD & UTILITIES
    // =====================================================

    public CarDTO searchById(int id) {
        CarDTO car = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.car_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            if (rs.next()) car = extractCarFromResultSet(rs);
        } catch (Exception e) {
            System.err.println("[CarDAO] searchById() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return car;
    }

    public List<CarDTO> getAvailableCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.status = 'AVAILABLE' " +
                         "ORDER BY c.created_at DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getAvailableCars() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> getNewestCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.status = 'AVAILABLE' " +
                         "ORDER BY c.created_at DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getNewestCars() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> getTopExpensiveCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "ORDER BY c.price DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getTopExpensiveCars() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> getCarsByBrand(int brandId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE b.brand_id = ? ORDER BY c.car_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getCarsByBrand() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> searchCars(String keyword) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE cm.model_name LIKE ? OR b.brand_name LIKE ? " +
                         "OR c.color LIKE ? OR c.description LIKE ? " +
                         "ORDER BY c.car_id DESC";
            pst = conn.prepareStatement(sql);
            String p = "%" + keyword + "%";
            pst.setString(1, p); pst.setString(2, p);
            pst.setString(3, p); pst.setString(4, p);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] searchCars() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public boolean addCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CarDAO] addCar() ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }

    public boolean updateCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET model_id=?, price=?, color=?, engine=?, transmission=?, " +
                         "mileage=?, status=?, description=?, updated_at=GETDATE() WHERE car_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            pst.setInt(9, car.getCarId());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CarDAO] updateCar() ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }

    public boolean deleteCar(int carId) {
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = DbUtils.getConnection();
            pst = conn.prepareStatement("DELETE FROM Car WHERE car_id=?");
            pst.setInt(1, carId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CarDAO] deleteCar() ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }

    public boolean updateCarStatus(int carId, String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = DbUtils.getConnection();
            pst = conn.prepareStatement("UPDATE Car SET status=?, updated_at=GETDATE() WHERE car_id=?");
            pst.setString(1, status);
            pst.setInt(2, carId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[CarDAO] updateCarStatus() ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }

    public int countCarsByStatus(String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            pst = conn.prepareStatement("SELECT COUNT(*) as total FROM Car WHERE status=?");
            pst.setString(1, status);
            rs = pst.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            System.err.println("[CarDAO] countCarsByStatus() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return 0;
    }

    public List<CarDTO> getCarsByModel(int modelId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.model_id = ? ORDER BY c.car_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, modelId);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getCarsByModel() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> filterByPrice(BigDecimal minPrice, BigDecimal maxPrice) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.price BETWEEN ? AND ? ORDER BY c.price ASC";
            pst = conn.prepareStatement(sql);
            pst.setBigDecimal(1, minPrice);
            pst.setBigDecimal(2, maxPrice);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] filterByPrice() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    public List<CarDTO> getCarsByStatus(String status) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, " +
                         "c.transmission, c.mileage, c.status, c.description, " +
                         "c.created_at, c.updated_at, " +
                         "cm.model_name, b.brand_name, b.brand_id " +
                         "FROM Car c " +
                         "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                         "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                         "WHERE c.status = ? ORDER BY c.car_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            rs = pst.executeQuery();
            while (rs.next()) list.add(extractCarFromResultSet(rs));
        } catch (Exception e) {
            System.err.println("[CarDAO] getCarsByStatus() ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =====================================================
    // HELPER
    // =====================================================

    private CarDTO extractCarFromResultSet(ResultSet rs) throws SQLException {
        int carId        = rs.getInt("car_id");
        int modelId      = rs.getInt("model_id");
        BigDecimal price = rs.getBigDecimal("price");
        String color     = rs.getString("color");
        String engine    = rs.getString("engine");
        String transmission = rs.getString("transmission");
        int mileage      = rs.getInt("mileage");
        String status    = rs.getString("status");
        String description = rs.getString("description");
        Timestamp createdAt  = rs.getTimestamp("created_at");
        Timestamp updatedAt  = rs.getTimestamp("updated_at");
        String modelName = rs.getString("model_name");
        String brandName = rs.getString("brand_name");
        int brandId      = rs.getInt("brand_id");

        return new CarDTO(carId, modelId, price, color, engine, transmission,
                          mileage, status, description, createdAt, updatedAt,
                          modelName, brandName, brandId);
    }

    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try { if (rs   != null) rs.close();   } catch (SQLException e) { e.printStackTrace(); }
        try { if (pst  != null) pst.close();  } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close();  } catch (SQLException e) { e.printStackTrace(); }
    }
}