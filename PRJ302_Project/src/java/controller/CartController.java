package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarDAO;
import model.CarDTO;
import model.UserDTO;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        // Phải đăng nhập mới dùng được giỏ hàng
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            doAddToCart(request, response, session);

            // Sau khi thao tác xong với cart
            List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");
            session.setAttribute("cartCount", cart != null ? cart.size() : 0);

        } else if ("remove".equals(action)) {

            doRemoveFromCart(request, response, session);

            // Sau khi thao tác xong với cart
            List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");
            session.setAttribute("cartCount", cart != null ? cart.size() : 0);

        } else if ("clear".equals(action)) {

            session.removeAttribute("cart");

            // Sau khi thao tác xong với cart
            List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");
            session.setAttribute("cartCount", cart != null ? cart.size() : 0);

            response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");

        } else {
            // Mặc định: hiển thị trang giỏ hàng
            response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");
        }
    }

    /**
     * THÊM XE VÀO GIỎ HÀNG
     */
    @SuppressWarnings("unchecked")
    private void doAddToCart(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {
        try {
            int carId = Integer.parseInt(request.getParameter("carId"));

            List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
            }

            boolean alreadyInCart = false;
            for (CarDTO c : cart) {
                if (c.getCarId() == carId) {
                    alreadyInCart = true;
                    break;
                }
            }

            if (!alreadyInCart) {

                CarDAO carDAO = new CarDAO();
                CarDTO car = carDAO.searchById(carId);

                if (car != null && "AVAILABLE".equals(car.getStatus())) {
                    cart.add(car);
                    session.setAttribute("cart", cart);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");
        }
    }

    /**
     * XÓA XE KHỎI GIỎ HÀNG
     */
    @SuppressWarnings("unchecked")
    private void doRemoveFromCart(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {
        try {
            int carId = Integer.parseInt(request.getParameter("carId"));

            List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");
            if (cart != null) {
                cart.removeIf(c -> c.getCarId() == carId);
                session.setAttribute("cart", cart);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");
    }
}