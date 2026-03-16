package utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * EmailService — Gửi email HTML tự động cho Luxury Cars
 * Sử dụng Gmail SMTP
 *
 * CẤU HÌNH: Thay EMAIL_FROM và EMAIL_PASSWORD bằng thông tin thật.
 * Với Gmail cần bật "App Password":
 *   Google Account → Security → 2-Step Verification → App passwords
 */
public class EmailService {

    // ── CẤU HÌNH SMTP ──────────────────────────────────────────
    private static final String SMTP_HOST     = "smtp.gmail.com";
    private static final int    SMTP_PORT     = 587;
    private static final String EMAIL_FROM    = "wluxurycars2024@gmail.com";      // << THAY ĐỔI
    private static final String EMAIL_PASSWORD = "acka rrgp teeo wwdc";         // << THAY ĐỔI
    private static final String DISPLAY_NAME  = "Luxury Cars";
    // ───────────────────────────────────────────────────────────

    /** Lấy Session SMTP */
    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust",       SMTP_HOST);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });
    }

    /**
     * Gửi email HTML cơ bản
     */
    public static boolean send(String toEmail, String subject, String htmlBody) {
        try {
            Session session = getSession();
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(EMAIL_FROM, DISPLAY_NAME, "UTF-8"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject, "UTF-8");
            msg.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("[EmailService] Sent to: " + toEmail + " | Subject: " + subject);
            return true;
        } catch (Exception e) {
            System.err.println("[EmailService] ERROR sending to " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────
    // WRAPPER HTML TEMPLATE
    // ─────────────────────────────────────────────────────────────
    private static String wrap(String title, String bodyContent) {
        return "<!DOCTYPE html><html lang='vi'><head><meta charset='UTF-8'>"
             + "<meta name='viewport' content='width=device-width,initial-scale=1'>"
             + "<title>" + title + "</title></head>"
             + "<body style='margin:0;padding:0;background:#F9F7F2;font-family:Montserrat,Arial,sans-serif;'>"
             + "<table width='100%' cellpadding='0' cellspacing='0' bgcolor='#F9F7F2'><tr><td align='center' style='padding:40px 20px;'>"
             + "<table width='600' cellpadding='0' cellspacing='0' style='max-width:600px;width:100%;'>"

             // HEADER
             + "<tr><td style='background:#0A0E27;padding:28px 36px;text-align:center;'>"
             + "<a href='#' style='font-family:Georgia,serif;font-size:26px;font-weight:900;color:#ffffff;text-decoration:none;letter-spacing:3px;'>"
             + "LUXURY<span style='color:#D4AF37;'>CARS</span></a>"
             + "</td></tr>"

             // GOLD BAR
             + "<tr><td style='background:#D4AF37;height:3px;'></td></tr>"

             // BODY
             + "<tr><td style='background:#ffffff;padding:40px 36px;'>" + bodyContent + "</td></tr>"

             // FOOTER
             + "<tr><td style='background:#0A0E27;padding:20px 36px;text-align:center;border-top:1px solid rgba(212,175,55,0.3);'>"
             + "<p style='margin:0;color:rgba(255,255,255,0.4);font-size:12px;'>"
             + "&copy; 2024 <span style='color:#D4AF37;'>LUXURY CARS</span>. All rights reserved.</p>"
             + "<p style='margin:6px 0 0;color:rgba(255,255,255,0.25);font-size:11px;'>Email này được gửi tự động, vui lòng không reply.</p>"
             + "</td></tr>"

             + "</table></td></tr></table></body></html>";
    }

    private static String h2(String text) {
        return "<h2 style='font-family:Georgia,serif;font-size:22px;color:#0A0E27;margin:0 0 16px;font-weight:700;'>"
             + text + "</h2>";
    }

    private static String p(String text) {
        return "<p style='margin:0 0 14px;font-size:14px;line-height:1.7;color:#555555;'>" + text + "</p>";
    }

    private static String infoRow(String label, String value) {
        return "<tr>"
             + "<td style='padding:10px 14px;font-size:13px;color:#888888;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;width:40%;border-bottom:1px solid #f5f2eb;'>" + label + "</td>"
             + "<td style='padding:10px 14px;font-size:13px;color:#2C2C2C;font-weight:600;border-bottom:1px solid #f5f2eb;'>" + value + "</td>"
             + "</tr>";
    }

    private static String infoTable(String[][] rows) {
        StringBuilder sb = new StringBuilder();
        sb.append("<table width='100%' cellpadding='0' cellspacing='0' style='border:1px solid #e8e4dc;margin:20px 0;'>");
        for (String[] row : rows) {
            sb.append(infoRow(row[0], row[1]));
        }
        sb.append("</table>");
        return sb.toString();
    }

    private static String btn(String text, String href) {
        return "<div style='text-align:center;margin:28px 0 8px;'>"
             + "<a href='" + href + "' style='display:inline-block;padding:14px 36px;background:#D4AF37;color:#0A0E27;text-decoration:none;"
             + "font-weight:700;font-size:13px;text-transform:uppercase;letter-spacing:2px;'>"
             + text + "</a></div>";
    }

    private static String divider() {
        return "<hr style='border:none;border-top:2px solid #D4AF37;margin:24px 0;'>";
    }

    private static String badge(String text, String color, String bg) {
        return "<span style='display:inline-block;padding:4px 14px;background:" + bg + ";color:" + color
             + ";font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;border:1px solid "
             + color + "20;'>" + text + "</span>";
    }

    // ─────────────────────────────────────────────────────────────
    // 1. ĐĂNG KÝ TÀI KHOẢN
    // ─────────────────────────────────────────────────────────────
    public static boolean sendWelcome(String toEmail, String fullName, String username) {
        String body = h2("Chào mừng bạn đến với Luxury Cars!")
            + p("Xin chào <strong>" + fullName + "</strong>,")
            + p("Tài khoản của bạn đã được tạo thành công. Dưới đây là thông tin đăng nhập:")
            + infoTable(new String[][] {
                {"Họ và tên", fullName},
                {"Tên đăng nhập", username},
                {"Email", toEmail},
            })
            + p("Bạn có thể đăng nhập ngay để khám phá bộ sưu tập xe cao cấp của chúng tôi.")
            + btn("Đăng nhập ngay", "#")
            + divider()
            + p("<small style='color:#aaa;font-size:12px;'>Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email.</small>");

        return send(toEmail,
            "[Luxury Cars] Chào mừng bạn — Tài khoản đã được tạo thành công",
            wrap("Đăng ký thành công", body));
    }

    // ─────────────────────────────────────────────────────────────
    // 2. ĐỔI MẬT KHẨU
    // ─────────────────────────────────────────────────────────────
    public static boolean sendPasswordChanged(String toEmail, String fullName) {
        String body = h2("Mật khẩu đã được thay đổi")
            + p("Xin chào <strong>" + fullName + "</strong>,")
            + p("Chúng tôi xin thông báo rằng mật khẩu tài khoản Luxury Cars của bạn vừa được thay đổi thành công.")
            + "<div style='background:#fff8e1;border-left:4px solid #D4AF37;padding:16px 20px;margin:20px 0;'>"
            + "<p style='margin:0;font-size:13px;color:#7a6520;'>"
            + "<strong>&#9888; Lưu ý bảo mật:</strong> Nếu bạn <strong>không thực hiện</strong> thay đổi này, "
            + "tài khoản của bạn có thể đã bị xâm phạm. Hãy liên hệ với chúng tôi ngay lập tức."
            + "</p></div>"
            + p("Nếu đây là bạn, không cần thực hiện thêm bước nào.")
            + btn("Liên hệ hỗ trợ", "mailto:support@luxurycars.vn")
            + divider()
            + p("<small style='color:#aaa;font-size:12px;'>Hotline hỗ trợ: <strong>1900 1234</strong> (24/7)</small>");

        return send(toEmail,
            "[Luxury Cars] Thông báo thay đổi mật khẩu",
            wrap("Đổi mật khẩu", body));
    }

    // ─────────────────────────────────────────────────────────────
    // 3. XÁC NHẬN ĐẶT HÀNG
    // ─────────────────────────────────────────────────────────────
    public static boolean sendOrderConfirmation(String toEmail, String fullName,
            int orderId, String carInfo, String totalPrice,
            String shippingAddress, String paymentMethod) {

        String payLabel;
        switch (paymentMethod) {
            case "CASH":          payLabel = "&#128181; Tiền mặt tại showroom"; break;
            case "BANK_TRANSFER": payLabel = "&#128247; QR Pay / Chuyển khoản"; break;
            case "INSTALLMENT":   payLabel = "&#127970; Trả góp ngân hàng";     break;
            default:              payLabel = paymentMethod;
        }

        String body = h2("Đặt hàng thành công!")
            + p("Xin chào <strong>" + fullName + "</strong>,")
            + p("Đơn hàng <strong style='color:#D4AF37;'>#" + orderId + "</strong> của bạn đã được đặt thành công. "
              + "Nhân viên sẽ liên hệ xác nhận trong vòng <strong>24 giờ</strong> làm việc.")
            + infoTable(new String[][] {
                {"Mã đơn hàng",    "<strong style='color:#D4AF37;font-size:16px;'>#" + orderId + "</strong>"},
                {"Xe",             carInfo},
                {"Tổng tiền",      "<strong>" + totalPrice + " VNĐ</strong>"},
                {"Địa chỉ nhận",   shippingAddress},
                {"Thanh toán",     payLabel},
                {"Trạng thái",     badge("Chờ xử lý", "#b8860b", "#fff8e1")},
            })
            + btn("Xem chi tiết đơn hàng", "#")
            + divider()
            + "<div style='background:#f9f7f2;border:1px solid #e8e4dc;padding:16px 20px;'>"
            + "<p style='margin:0 0 8px;font-size:13px;color:#555;font-weight:700;'>&#128222; Cần hỗ trợ?</p>"
            + "<p style='margin:0;font-size:13px;color:#888;'>Hotline: <strong>1900 1234</strong> &nbsp;|&nbsp; Email: support@luxurycars.vn</p>"
            + "</div>";

        return send(toEmail,
            "[Luxury Cars] Xác nhận đơn hàng #" + orderId,
            wrap("Xác nhận đặt hàng", body));
    }

    // ─────────────────────────────────────────────────────────────
    // 4. XÁC NHẬN THANH TOÁN
    // ─────────────────────────────────────────────────────────────
    public static boolean sendPaymentConfirmation(String toEmail, String fullName,
            int orderId, String totalPrice, String paymentMethod, String paymentStatus) {

        String statusLabel, statusColor, statusBg, statusMsg;
        switch (paymentStatus) {
            case "PAID":
                statusLabel = "&#10003; Đã thanh toán";
                statusColor = "#1a7a4a"; statusBg = "#e6f9f0";
                statusMsg = "Thanh toán của bạn đã được xác nhận. Chúng tôi sẽ liên hệ để sắp xếp bàn giao xe.";
                break;
            case "PENDING":
                if ("BANK_TRANSFER".equals(paymentMethod)) {
                    statusLabel = "&#9203; Chờ xác minh chuyển khoản";
                    statusColor = "#1a56db"; statusBg = "#e8f0fe";
                    statusMsg = "Chúng tôi đã nhận được thông báo chuyển khoản và đang xác minh giao dịch. Thường trong 1–2 giờ làm việc.";
                } else if ("INSTALLMENT".equals(paymentMethod)) {
                    statusLabel = "&#9203; Hồ sơ trả góp chờ duyệt";
                    statusColor = "#b8860b"; statusBg = "#fff8e1";
                    statusMsg = "Hồ sơ đăng ký trả góp đã được ghi nhận. Admin sẽ xem xét và phản hồi trong 1–3 ngày làm việc.";
                } else {
                    statusLabel = "&#9203; Chờ thanh toán";
                    statusColor = "#b8860b"; statusBg = "#fff8e1";
                    statusMsg = "Đơn hàng đang chờ bạn thanh toán.";
                }
                break;
            default:
                statusLabel = paymentStatus;
                statusColor = "#555"; statusBg = "#f5f5f5";
                statusMsg = "Trạng thái thanh toán đã được cập nhật.";
        }

        String payLabel;
        switch (paymentMethod) {
            case "CASH":          payLabel = "Tiền mặt tại showroom"; break;
            case "BANK_TRANSFER": payLabel = "QR Pay / Chuyển khoản"; break;
            case "INSTALLMENT":   payLabel = "Trả góp ngân hàng";     break;
            default:              payLabel = paymentMethod;
        }

        String body = h2("Cập nhật thanh toán đơn hàng #" + orderId)
            + p("Xin chào <strong>" + fullName + "</strong>,")
            + p(statusMsg)
            + infoTable(new String[][] {
                {"Mã đơn hàng",    "<strong style='color:#D4AF37;'>#" + orderId + "</strong>"},
                {"Tổng tiền",      "<strong>" + totalPrice + " VNĐ</strong>"},
                {"Phương thức",    payLabel},
                {"Trạng thái TT",  badge(statusLabel, statusColor, statusBg)},
            })
            + btn("Xem chi tiết đơn hàng", "#")
            + divider()
            + "<div style='background:#f9f7f2;border:1px solid #e8e4dc;padding:16px 20px;'>"
            + "<p style='margin:0 0 8px;font-size:13px;color:#555;font-weight:700;'>&#128222; Cần hỗ trợ?</p>"
            + "<p style='margin:0;font-size:13px;color:#888;'>Hotline: <strong>1900 1234</strong> &nbsp;|&nbsp; Email: support@luxurycars.vn</p>"
            + "</div>";

        return send(toEmail,
            "[Luxury Cars] Cập nhật thanh toán đơn #" + orderId,
            wrap("Thanh toán", body));
    }
}