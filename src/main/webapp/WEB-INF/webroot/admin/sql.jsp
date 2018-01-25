<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ct" uri="http://eric-hicks.com/bts/commontags" %>
<jsp:useBean id="users" type="java.util.List<net.ehicks.bts.beans.User>" scope="request"/>
<c:if test="${!empty sessionScope.resultSets}">
    <jsp:useBean id="resultSets" type="java.util.List<net.ehicks.bts.handlers.admin.PrintableSqlResult>" scope="session"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../inc_title.jsp"/>
    <jsp:include page="../inc_header.jsp"/>

    <script>
        $('document').ready(function ()
        {
            $('#runCommand').click(function ()
            {
                $('#frmSqlCommand').submit();
            });

            $('#sqlCommand').focus().keydown(function ()
            {
                if ((event.keyCode == 10 || event.keyCode == 13) && event.ctrlKey)
                {
                    $('#frmSqlCommand').submit();
                }
            });
        });
    </script>
</head>
<body>

<jsp:include page="../header.jsp"/>

<section class="hero is-primary is-small">
    <div class="hero-body">
        <div class="container">
            <h1 class="title">
                SQL Command
            </h1>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="columns is-multiline is-centered">
            <div class="column">
                <form id="frmSqlCommand" name="frmSqlCommand" method="post" action="${pageContext.request.contextPath}/view?tab1=admin&tab2=sql&action=runCommand">
                    <textarea class="textarea" id="sqlCommand" name="sqlCommand" rows="5" cols="80" placeholder="Enter command...">${sessionScope.sqlCommand}</textarea>
                </form>

                <div>
                    <input id="runCommand" type="button" value="Run Command" class="button is-primary" />
                </div>
                <br>

                <h3 class="subtitle is-3">Result Sets</h3>

                <div class="tableContainer">
                    <c:forEach var="resultSet" items="${resultSets}" varStatus="loop">
                        <h5 class="subtitle is-5">
                            Result Set ${loop.count}:
                            <c:if test="${resultSet.truncated}">
                                Truncated to
                            </c:if>
                            ${fn:length(resultSet.resultRows)} rows
                        </h5>
                        Command: <pre><code>${resultSet.sqlCommand}</code></pre>

                        <c:if test="${!empty resultSet.columnLabels}">
                            <table class="table is-striped is-narrow is-hoverable">
                                <thead>
                                <tr>
                                    <c:forEach var="columnLabel" items="${resultSet.columnLabels}">
                                        <th>${columnLabel}</th>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="resultRow" items="${resultSet.resultRows}">
                                        <tr>
                                            <c:forEach var="resultCell" items="${resultRow}">
                                                <td>${resultCell}</td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>

                        <c:if test="${!empty resultSet.rowsUpdated}">
                            ${resultSet.rowsUpdated} rows updated.
                        </c:if>
                        <c:if test="${!empty resultSet.error}">
                            ${resultSet.error}
                        </c:if>
                        <hr>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="../footer.jsp"/>
</body>
</html>