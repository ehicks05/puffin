<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${!empty btsSystem}">
    <jsp:useBean id="btsSystem" type="net.ehicks.bts.beans.BtsSystem" scope="application"/>
</c:if>
<c:if test="${!empty userSession}">
    <jsp:useBean id="userSession" type="net.ehicks.bts.UserSession" scope="session"/>
</c:if>

<script>
    function goToIssue()
    {
        var issueId = document.getElementById('fldGoToIssue').value;
        if (issueId)
            location.href = '${pageContext.request.contextPath}/view?tab1=issue&action=form&issueId=' + issueId;
    }

    function followBreadcrumbs(tab1, tab2, tab3)
    {
        var tabs = '';
        if (tab1) tabs += 'tab1=' + tab1;
        if (tab2) tabs += '&tab2=' + tab2;
        if (tab3) tabs += '&tab3=' + tab3;
        location.href = '${pageContext.request.contextPath}/view?' + tabs + '&action=form';
    }

    function showResponseMessage()
    {
        var message;
        <c:if test="${!empty sessionScope.responseMessage}">
            message = '${sessionScope.responseMessage}';
        </c:if>
        <c:if test="${!empty requestScope.responseMessage}">
            message = '${requestScope.responseMessage}';
        </c:if>
        if (message)
        {
            alert(message);
        }
    }

    $(showResponseMessage);
    $(function () {
        $('#fldGoToIssue').on('keypress', function (e) {
            document.getElementById('goToIssueButton').disabled = false;
            if (e.keyCode === 13)
            {
                goToIssue();
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function () {

        // Get all "navbar-burger" elements
        var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

        // Check if there are any navbar burgers
        if ($navbarBurgers.length > 0) {

            // Add a click event on each of them
            $navbarBurgers.forEach(function ($el) {
                $el.addEventListener('click', function () {

                    // Get the target from the "data-target" attribute
                    var target = $el.dataset.target;
                    var $target = document.getElementById(target);

                    // Toggle the class on both the "navbar-burger" and the "navbar-menu"
                    $el.classList.toggle('is-active');
                    $target.classList.toggle('is-active');

                });
            });
        }

    });

</script>

<nav class="navbar" role="navigation" aria-label="main navigation">
    <div class="container">
        <div class="navbar-brand">
            <%--<div class="navbar-item">--%>
                <%--<span>${applicationScope['systemInfo'].appName}</span>--%>
            <%--</div>--%>
            <div class="navbar-item">
                <img src="${pageContext.request.contextPath}/images/puffin-text.png" alt="Puffin" />
            </div>

            <button class="button navbar-burger" data-target="navMenu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>

        <div class="navbar-menu" id="navMenu">
            <div class="navbar-start">
                <div class="navbar-item">
                    <a class="button" id="createIssueButton">
                        <span class="icon has-text-primary">
                          <i class="fas fa-plus-square"></i>
                        </span>
                        <span>Create Issue</span>
                    </a>
                </div>
                <div class="navbar-item">
                    <div class="field has-addons">
                        <div class="control">
                            <input id="fldGoToIssue" type="text" class="input" size="3" maxlength="16" />
                        </div>
                        <div class="control">
                            <button id="goToIssueButton" class="button has-text-primary" onclick="goToIssue();" disabled>
                                <span class="icon">
                                    <i class="fas fa-search"></i>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
                <c:set var="statusClass" value="${param.tab1 == 'dashboard' ? 'is-active' : ''}"/>
                <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=dashboard&action=form">
                    Dashboard
                </a>
                <c:set var="statusClass" value="${param.tab1 == 'search' ? 'is-active' : ''}"/>
                <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=search&action=form">
                    Search
                </a>
                <c:set var="statusClass" value="${param.tab1 == 'settings' ? 'is-active' : ''}"/>
                <div class="navbar-item has-dropdown is-hoverable">
                    <a class="navbar-link ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=settings&action=form">
                        Settings
                    </a>
                    <div class="navbar-dropdown">
                        <c:forEach var="settingsSubscreen" items="${userSession.systemInfo.settingsSubscreens}">
                            <c:set var="statusClass" value="${param.tab2 == settingsSubscreen[3] ? 'is-active' : ''}"/>

                            <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/${settingsSubscreen[0]}">
                                    <span class="icon is-medium has-text-info">
                                        <i class="fas fa-lg fa-${settingsSubscreen[1]}"></i>
                                    </span>
                                    ${settingsSubscreen[2]}
                            </a>
                        </c:forEach>
                    </div>
                </div>
                <c:set var="statusClass" value="${param.tab1 == 'admin' ? 'is-active' : ''}"/>
                <c:if test="${userSession.user.admin}">
                    <div class="navbar-item has-dropdown is-hoverable">
                        <a class="navbar-link ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=admin&action=form">
                            Admin
                        </a>
                        <div class="navbar-dropdown">
                            <c:forEach var="adminSubscreen" items="${userSession.systemInfo.adminSubscreens}">
                                <c:set var="statusClass" value="${param.tab2 == adminSubscreen[3] ? 'is-active' : ''}"/>

                                <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/${adminSubscreen[0]}">
                                    <span class="icon is-medium has-text-info">
                                        <i class="fas fa-lg fa-${adminSubscreen[1]}"></i>
                                    </span>
                                    ${adminSubscreen[2]}
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <c:set var="statusClass" value="${param.tab1 == 'profile' ? 'is-active' : ''}"/>
                <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=profile&action=form&userId=${userSession.userId}">
                    Profile
                </a>
                <a class="navbar-item ${statusClass}" href="${pageContext.request.contextPath}/view?tab1=logout&action=logout">
                    Logout
                </a>
            </div>
            <div class="navbar-end">
                <%--<div class="navbar-item">--%>
                    <%----%>
                <%--</div>--%>
            </div>
        </div>
    </div>
</nav>

<c:remove var="responseMessage" scope="session" />