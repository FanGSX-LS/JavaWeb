<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession session1 = request.getSession();
    String username = (String) session1.getAttribute("username");
    String realname = (String) session1.getAttribute("realname");
    if (username == null) response.sendRedirect("login.jsp");
%>
<html>
<head>
    <title>设备信息管理后台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< Updated upstream
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css">
=======
    <link rel="stylesheet" href="https://lf3-cdn-tos.bytecdntp.com/cdn/expire-1-M/font-awesome/4.7.0/css/font-awesome.min.css">
>>>>>>> Stashed changes
    <link rel="stylesheet" href="css/style.css">
    <style>

    </style>
</head>
<body>
<div class="menu">
    <div class="logo">
        <a href="index.jsp"><img src="./img/ppp.png" alt="Logo" height="60px"></a>
    </div>
    <div class="menu-group">
        <div class="group-title">
            <i class="fa fa-user-circle"></i>
            <span>用户管理</span>
            <i class="fa fa-chevron-down arrow"></i>
        </div>
        <ul class="group-items">
            <li class="menu-item" data-url="administer/list.jsp" data-title="管理员管理">
                <i class="fa fa-user-secret"></i> <span>管理员管理</span>
            </li>
            <li class="menu-item" data-url="employees/list.jsp" data-title="员工信息管理">
                <i class="fa fa-users"></i> <span>员工信息管理</span>
            </li>
        </ul>
    </div>
    <div class="menu-group">
        <div class="group-title">
            <i class="fa fa-laptop"></i>
            <span>设备管理</span>
            <i class="fa fa-chevron-down arrow"></i>
        </div>
        <ul class="group-items">
            <li class="menu-item" data-url="device_categories/list.jsp" data-title="设备类别管理">
                <i class="fa fa-tags"></i> <span>设备类别管理</span>
            </li>
            <li class="menu-item" data-url="devices/list.jsp" data-title="设备管理">
                <i class="fa fa-cogs"></i> <span>设备管理</span>
            </li>
        </ul>
    </div>
    <div class="menu-group">
        <div class="group-title">
            <i class="fa fa-file-text-o"></i>
            <span>申请管理</span>
            <i class="fa fa-chevron-down arrow"></i>
        </div>
        <ul class="group-items">
            <li class="menu-item" data-url="device_application/list.jsp" data-title="设备申请管理">
                <i class="fa fa-file-text"></i> <span>设备申请管理</span>
            </li>
        </ul>
    </div>
    <div class="menu-group">
        <div class="group-title">
            <i class="fa fa-bullhorn"></i>
            <span>公告管理</span>
            <i class="fa fa-chevron-down arrow"></i>
        </div>
        <ul class="group-items">
            <li class="menu-item" data-url="announcements/list.jsp" data-title="公告管理">
                <i class="fa fa-newspaper-o"></i> <span>公告管理</span>
            </li>
        </ul>
    </div>
    <div class="menu-group">
        <div class="group-title">
            <i class="fa fa-archive"></i>
            <span>库存管理</span>
            <i class="fa fa-chevron-down arrow"></i>
        </div>
        <ul class="group-items">
            <li class="menu-item" data-url="stock_ins/list.jsp" data-title="入库管理">
                <i class="fa fa-sign-in"></i> <span>入库管理</span>
            </li>
            <li class="menu-item" data-url="stock_out/list.jsp" data-title="出库管理">
                <i class="fa fa-sign-out"></i> <span>出库管理</span>
            </li>
        </ul>
    </div>
</div>
<div class="box">
    <div class="box-top">
        <div id="currentPage">控制台概览</div>
        <div class="user-menu" id="userMenu">
            <div class="user-info">
                <div class="user-avatar">
                    <%= username != null && username.length() > 0 ? username.charAt(0) : 'U' %>
                </div>
                <span class="user-name"> <%=username%>   (<%=realname%>)</span>
                <i class="fa fa-chevron-down user-arrow"></i>
            </div>
            <div class="dropdown-menu">
                <button class="dropdown-item" id="logoutBtn">
                    <i class="fa fa-sign-out"></i> 注销
                </button>
            </div>
        </div>
    </div>
    <div class="primenu">
        <iframe id="mainIframe" src="welcome.jsp" frameborder="0"></iframe>
    </div>
    <footer>计算机2024-3 方志</footer>
</div>
<script src="js/jquery-3.6.0.min.js"></script>
<script>
    $(function () {
        let currentActiveItem = null;
        const currentPageEl = $("#currentPage");
        const userMenu = $("#userMenu");
        $(".menu-group:first .group-items").addClass("expanded");
        $(".menu-group:first .arrow").css("transform", "rotate(180deg)");
        $(".group-title").on("click", function (e) {
            e.stopPropagation();
            const $items = $(this).next(".group-items");
            const $arrow = $(this).find(".arrow");
            $items.toggleClass("expanded");
            $arrow.css("transform", $items.hasClass("expanded") ? "rotate(180deg)" : "rotate(0deg)");
        });

        $(".menu-item").on("click", function (e) {
            e.preventDefault();
            if (this === currentActiveItem) return;
            const targetUrl = $(this).data("url");
            const targetTitle = $(this).data("title");
            if (currentActiveItem) {
                $(currentActiveItem).removeClass("active");
            }
            $(this).addClass("active");
            currentActiveItem = this;
            currentPageEl.text(targetTitle);
            $("#mainIframe").attr("src", targetUrl);
        });

        function highlightMenuItemByUrl(url) {
            let found = false;

            $(".menu-item").each(function () {
                const menuUrl = $(this).data("url");
                if (url.indexOf(menuUrl) !== -1) {
                    if (currentActiveItem) {
                        $(currentActiveItem).removeClass("active");
                    }
                    $(this).addClass("active");
                    currentActiveItem = this;
                    const targetTitle = $(this).data("title");
                    currentPageEl.text(targetTitle);
                    found = true;
                    return false;
                }
            });
            if (!found) {
                if (currentActiveItem) {
                    $(currentActiveItem).removeClass("active");
                    currentActiveItem = null;
                }
                currentPageEl.text("控制台概览");
            }
        }

        highlightMenuItemByUrl($("#mainIframe").attr("src"));
        $("#mainIframe").on("load", function () {
            const currentUrl = this.contentWindow.location.href;
            highlightMenuItemByUrl(currentUrl);
        });
        userMenu.on("click", function (e) {
            e.stopPropagation();
            $(this).toggleClass("open");
        });

        $(document).on("click", function () {
            userMenu.removeClass("open");
        });

        $("#logoutBtn").on("click", function () {
            if (confirm("确定要注销吗？")) {
                window.location.href = "login.jsp";
            }
        });
    });
</script>
</body>
</html>