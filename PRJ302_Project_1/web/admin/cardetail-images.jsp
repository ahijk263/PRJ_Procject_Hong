<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"><title>Ảnh xe #${carId} - Admin</title>
        <style>
            body{
                font-family:Arial,sans-serif;
                margin:0;
                background:#f4f4f4;
            }
            .wrapper{
                display:flex;
                min-height:100vh;
            }
            .sidebar{
                width:220px;
                background:#1a1a2e;
                color:#ccc;
                flex-shrink:0;
                display:flex;
                flex-direction:column;
                position:sticky;
                top:0;
                height:100vh;
                overflow-y:auto;
            }
            .sidebar .brand{
                background:#16213e;
                padding:18px 20px;
                font-size:18px;
                font-weight:bold;
                color:#e0a800;
                border-bottom:1px solid #333;
            }
            .sidebar .user-info{
                padding:14px 20px;
                border-bottom:1px solid #333;
                font-size:13px;
            }
            .sidebar .user-info span{
                display:block;
                color:#aaa;
                font-size:11px;
            }
            .sidebar nav a{
                display:block;
                padding:11px 20px;
                color:#bbb;
                text-decoration:none;
                font-size:13px;
                border-left:3px solid transparent;
            }
            .sidebar nav a:hover,.sidebar nav a.active{
                background:#0f3460;
                color:#fff;
                border-left-color:#e0a800;
            }
            .sidebar .nav-label{
                padding:10px 20px 4px;
                font-size:10px;
                color:#666;
                letter-spacing:1px;
                text-transform:uppercase;
            }
            .sidebar .logout{
                padding:14px 20px;
                border-top:1px solid #333;
                margin-top:auto;
            }
            .sidebar .logout a{
                color:#e74c3c;
                text-decoration:none;
                font-size:13px;
            }
            .main{
                flex:1;
                display:flex;
                flex-direction:column;
            }
            .topbar{
                background:#fff;
                padding:14px 24px;
                border-bottom:1px solid #ddd;
                font-size:14px;
                color:#555;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .topbar a{
                color:#2980b9;
                text-decoration:none;
            }
            .content{
                padding:24px;
            }
            h2{
                margin:0 0 4px;
                font-size:20px;
                color:#333;
            }
            .subtitle{
                font-size:13px;
                color:#888;
                margin-bottom:20px;
            }
            .alert{
                padding:10px 16px;
                border-radius:4px;
                margin-bottom:16px;
                font-size:13px;
            }
            .alert-success{
                background:#d4edda;
                color:#155724;
                border:1px solid #c3e6cb;
            }
            .alert-error{
                background:#f8d7da;
                color:#721c24;
                border:1px solid #f5c6cb;
            }

            /* Upload box */
            .upload-box{
                background:#fff;
                border-radius:8px;
                box-shadow:0 1px 4px rgba(0,0,0,.08);
                padding:20px;
                margin-bottom:24px;
            }
            .upload-box h3{
                margin:0 0 16px;
                font-size:15px;
                color:#333;
                border-bottom:1px solid #f0f0f0;
                padding-bottom:10px;
            }
            .upload-row{
                display:flex;
                gap:12px;
                flex-wrap:wrap;
                align-items:flex-end;
            }
            .form-group{
                flex:1;
                min-width:160px;
            }
            .form-group label{
                display:block;
                font-size:12px;
                color:#555;
                margin-bottom:5px;
                font-weight:600;
            }
            .form-group input[type=text],.form-group select{
                width:100%;
                padding:8px 10px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:13px;
                box-sizing:border-box;
            }

            /* Drop zone */
            .drop-zone{
                border:2px dashed #ccc;
                border-radius:8px;
                padding:28px 16px;
                text-align:center;
                cursor:pointer;
                transition:border-color .2s,background .2s;
                background:#fafafa;
                margin-bottom:12px;
            }
            .drop-zone:hover,.drop-zone.dragover{
                border-color:#2980b9;
                background:#f0f7ff;
            }
            .drop-zone .dz-icon{
                font-size:32px;
                margin-bottom:8px;
            }
            .drop-zone .dz-text{
                font-size:13px;
                color:#888;
            }
            .drop-zone .dz-text strong{
                color:#2980b9;
            }
            .drop-zone input[type=file]{
                display:none;
            }
            .file-chosen{
                font-size:12px;
                color:#27ae60;
                margin-top:6px;
                display:none;
            }

            /* Preview strip */
            .preview-strip{
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                margin-top:12px;
            }
            .preview-strip img{
                width:100px;
                height:70px;
                object-fit:cover;
                border-radius:4px;
                border:2px solid #e0a800;
            }

            .hint{
                font-size:11px;
                color:#aaa;
                margin-top:4px;
            }
            .btn{
                padding:8px 16px;
                border-radius:4px;
                border:none;
                cursor:pointer;
                font-size:13px;
                text-decoration:none;
                display:inline-block;
            }
            .btn-primary{
                background:#2980b9;
                color:#fff;
            }
            .btn-success{
                background:#27ae60;
                color:#fff;
            }
            .btn-danger{
                background:#e74c3c;
                color:#fff;
            }
            .btn-warning{
                background:#f39c12;
                color:#fff;
            }
            .btn-secondary{
                background:#95a5a6;
                color:#fff;
            }
            .btn-info{
                background:#17a2b8;
                color:#fff;
            }
            .btn-sm{
                padding:5px 10px;
                font-size:12px;
            }

            /* Grid ảnh hiện có */
            .section-title{
                font-size:14px;
                font-weight:600;
                color:#555;
                margin-bottom:12px;
            }
            .img-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(210px,1fr));
                gap:16px;
            }
            .img-card{
                background:#fff;
                border-radius:8px;
                box-shadow:0 1px 4px rgba(0,0,0,.08);
                overflow:hidden;
                position:relative;
            }
            .primary-badge{
                position:absolute;
                top:8px;
                left:8px;
                background:#e0a800;
                color:#000;
                font-size:10px;
                font-weight:700;
                padding:2px 8px;
                border-radius:3px;
                z-index:1;
            }
            .img-card img{
                width:100%;
                height:160px;
                object-fit:cover;
                display:block;
                background:#f0f0f0;
            }
            .no-preview{
                width:100%;
                height:160px;
                display:flex;
                align-items:center;
                justify-content:center;
                background:#f8f8f8;
                color:#ccc;
                font-size:36px;
            }
            .img-body{
                padding:10px 12px;
            }
            .img-url{
                font-size:11px;
                color:#555;
                word-break:break-all;
                margin-bottom:8px;
                line-height:1.5;
                max-height:36px;
                overflow:hidden;
            }
            .img-actions{
                display:flex;
                gap:6px;
                flex-wrap:wrap;
            }
            .edit-row{
                display:none;
                padding:8px 12px 12px;
                border-top:1px solid #f0f0f0;
                background:#fafafa;
            }
            .edit-row.show{
                display:block;
            }
            .edit-row input{
                width:100%;
                padding:6px 8px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:12px;
                box-sizing:border-box;
                margin-bottom:6px;
            }
            .edit-row .edit-actions{
                display:flex;
                gap:6px;
            }
            .empty-imgs{
                text-align:center;
                padding:40px;
                color:#aaa;
                background:#fff;
                border-radius:8px;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <div class="brand">&#9670; LuxAuto Admin</div>
                <div class="user-info">${sessionScope.user.fullName}<span>Administrator</span></div>
                <nav>
                    <div class="nav-label">Menu</div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">&#128200; Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/cars">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images" class="active">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>

            <div class="main">
                <div class="topbar">
                    <a href="${pageContext.request.contextPath}/admin/images">&#8592; Manage Images</a>
                    <span style="color:#ccc;">/</span>
                    <strong>Xe #${carId} &mdash; ${carName}</strong>
                </div>
                <div class="content">
                    <h2>&#128444; Ảnh xe #${carId}</h2>
                    <div class="subtitle">${carName} &nbsp;<span style="background:#eee;padding:2px 8px;border-radius:3px;font-size:11px;">${carStatus}</span></div>

                    <c:if test="${not empty param.msg}"><div class="alert alert-success">&#10003; ${param.msg}</div></c:if>
                    <c:if test="${not empty param.error}"><div class="alert alert-error">&#10007; ${param.error}</div></c:if>

                        <!-- ===== UPLOAD FILE ===== -->
                        <div class="upload-box">
                            <h3>&#128247; Thêm ảnh mới</h3>
                        <%-- enctype="multipart/form-data" bắt buộc để upload file --%>
                        <form method="post" action="${pageContext.request.contextPath}/AdminImageController"
                              enctype="multipart/form-data" id="uploadForm">
                            <input type="hidden" name="action" value="uploadImage">
                            <input type="hidden" name="carId" value="${carId}">

                            <%-- Drop zone chọn file --%>
                            <div class="drop-zone" id="dropZone" onclick="document.getElementById('fileInput').click()">
                                <div class="dz-icon">&#128443;</div>
                                <div class="dz-text">Kéo thả file ảnh vào đây hoặc <strong>bấm để chọn</strong></div>
                                <div class="dz-text" style="font-size:11px;margin-top:4px;">Hỗ trợ: JPG, PNG, GIF, WEBP &bull; Tối đa 10MB</div>
                                <input type="file" name="imageFile" id="fileInput" accept="image/*" onchange="onFileChosen(this)">
                            </div>
                            <div class="file-chosen" id="fileChosen">&#10003; Đã chọn: <span id="chosenName"></span></div>

                            <%-- Preview ảnh đã chọn --%>
                            <div class="preview-strip" id="previewStrip"></div>

                            <div class="upload-row" style="margin-top:14px;">
                                <div class="form-group" style="flex:2;">
                                    <label>Tên file lưu vào project <span style="font-weight:normal;color:#aaa">(không cần đuôi .jpg)</span></label>
                                    <input type="text" name="saveName" id="saveName"
                                           placeholder="vd: bmw-x5-black-2024  →  lưu thành bmw-x5-black-2024.jpg">
                                    <div class="hint">
                                        Để trống → tự đặt tên: <code>car_${carId}_timestamp.jpg</code><br>
                                        File sẽ lưu vào: <code>web/images/cars/</code> &nbsp;|&nbsp;
                                        DB lưu: <code>images/cars/tên-file.jpg</code>
                                    </div>
                                </div>
                                <div class="form-group" style="flex:0 0 170px;">
                                    <label>Đặt làm ảnh đại diện?</label>
                                    <select name="isPrimary">
                                        <option value="0">Không</option>
                                        <option value="1">Có (Primary)</option>
                                    </select>
                                </div>
                                <div class="form-group" style="flex:0 0 auto;align-self:flex-end;">
                                    <button type="submit" class="btn btn-success" id="submitBtn" disabled>
                                        &#128228; Upload ảnh
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- ===== DANH SÁCH ẢNH HIỆN CÓ ===== -->
                    <div class="section-title">&#128247; Ảnh hiện có (${images.size()} ảnh)</div>

                    <c:choose>
                        <c:when test="${not empty images}">
                            <div class="img-grid">
                                <c:forEach var="img" items="${images}">
                                    <div class="img-card">
                                        <c:if test="${img.isPrimary == 1}">
                                            <span class="primary-badge">&#11088; Primary</span>
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${not empty img.imageUrl}">
                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                     alt="car image"
                                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                                <div class="no-preview" style="display:none;">&#128663;</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-preview">&#128663;</div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="img-body">
                                            <div class="img-url" title="${img.imageUrl}">${img.imageUrl}</div>
                                            <div class="img-actions">
                                                <c:if test="${img.isPrimary != 1}">
                                                    <form method="post" action="${pageContext.request.contextPath}/AdminImageController" style="display:inline;">
                                                        <input type="hidden" name="action" value="setPrimary">
                                                        <input type="hidden" name="carId" value="${carId}">
                                                        <input type="hidden" name="imageId" value="${img.imageId}">
                                                        <button type="submit" class="btn btn-info btn-sm">&#11088; Primary</button>
                                                    </form>
                                                </c:if>
                                                <button class="btn btn-warning btn-sm"
                                                        onclick="toggleEdit('edit_${img.imageId}')">&#9998; Sửa URL</button>
                                                <form method="post" action="${pageContext.request.contextPath}/AdminImageController"
                                                      style="display:inline;" onsubmit="return confirm('Xóa ảnh này?')">
                                                    <input type="hidden" name="action" value="deleteImage">
                                                    <input type="hidden" name="carId" value="${carId}">
                                                    <input type="hidden" name="imageId" value="${img.imageId}">
                                                    <button type="submit" class="btn btn-danger btn-sm">&#10007; Xóa</button>
                                                </form>
                                            </div>
                                        </div>

                                        <%-- Sửa URL inline --%>
                                        <div class="edit-row" id="edit_${img.imageId}">
                                            <div style="font-size:11px;color:#888;margin-bottom:6px;">Sửa đường dẫn trong DB:</div>
                                            <form method="post" action="${pageContext.request.contextPath}/AdminImageController">
                                                <input type="hidden" name="action" value="updateImageUrl">
                                                <input type="hidden" name="carId" value="${carId}">
                                                <input type="hidden" name="imageId" value="${img.imageId}">
                                                <input type="hidden" name="isPrimary" value="${img.isPrimary}">
                                                <input type="text" name="imageUrl" value="${img.imageUrl}" required>
                                                <div class="edit-actions">
                                                    <button type="submit" class="btn btn-warning btn-sm">Lưu</button>
                                                    <button type="button" class="btn btn-secondary btn-sm"
                                                            onclick="toggleEdit('edit_${img.imageId}')">Hủy</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-imgs">
                                <div style="font-size:40px;margin-bottom:10px;">&#128247;</div>
                                <div>Xe này chưa có ảnh. Upload ảnh đầu tiên ở trên.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script>
            // Khi chọn file → enable nút Upload + preview
            function onFileChosen(input) {
                var file = input.files[0];
                if (!file)
                    return;

                document.getElementById('chosenName').textContent = file.name;
                document.getElementById('fileChosen').style.display = 'block';
                document.getElementById('submitBtn').disabled = false;

                // Gợi ý tên file: lấy tên gốc bỏ đuôi
                var suggest = file.name.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9_\-]/g, '-');
                if (!document.getElementById('saveName').value)
                    document.getElementById('saveName').value = suggest;

                // Preview
                var reader = new FileReader();
                reader.onload = function (e) {
                    var strip = document.getElementById('previewStrip');
                    strip.innerHTML = '<img src="' + e.target.result + '" alt="preview">';
                };
                reader.readAsDataURL(file);
            }

            // Drag & drop
            var dz = document.getElementById('dropZone');
            dz.addEventListener('dragover', function (e) {
                e.preventDefault();
                dz.classList.add('dragover');
            });
            dz.addEventListener('dragleave', function () {
                dz.classList.remove('dragover');
            });
            dz.addEventListener('drop', function (e) {
                e.preventDefault();
                dz.classList.remove('dragover');
                var fi = document.getElementById('fileInput');
                fi.files = e.dataTransfer.files;
                onFileChosen(fi);
            });

            function toggleEdit(id) {
                document.getElementById(id).classList.toggle('show');
            }
        </script>
    </body></html>
