<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@tag description="Text To Select Tag" pageEncoding="UTF-8" %>
<%@attribute name="id" fragment="false" required="true" %>
<%@attribute name="value" fragment="false" required="true" %>
<%@attribute name="text" fragment="false" required="true" %>
<%@attribute name="items" fragment="false" type="java.util.List<net.ehicks.bts.ISelectTagSupport>" required="true" %>
<%@attribute name="submitAction" fragment="false" required="true" %>

<c:set var="textToSelectCounter" value="${requestScope.textToSelectCounter + 1}" scope="request"/>
<c:if test="${textToSelectCounter == 1}">
    <script>
        function select2Enable(textId, selectId)
        {
            var currentText = $('#' + textId).text();

            // get value of the <option> that matches our textDiv.
            var currentValue = $('#' + selectId + ' option').filter(function () { return $(this).html() == currentText; }).val();

            //alert(currentValue);
            $('#' + textId).hide();
            $('#' + selectId).val(currentValue).trigger("change");
            $('#' + selectId).show()            ;
            $('#' + selectId).select2()         ;
            $('#' + selectId).select2('open')   ;
            $('#' + selectId).on("select2:close", function (e) {
                select2Disable(textId, selectId, $('#' + selectId).val());
            });
        }

        function select2Disable(textId, selectId, optionValue)
        {
            var newText = $("#" + selectId + " option[value=" + optionValue + "]").text();
            var newValue = $("#" + selectId + " option[value='" + optionValue + "']").val();
            //alert(newText);
            var oldText = $('#' + textId).text();
            if (newText != oldText)
            {
                update(selectId, newValue, '${submitAction}');
            }

            $('#' + textId).text(newText);
            $('#' + textId).show();
            $('#' + selectId).hide();
            $('#' + selectId).select2('destroy');
        }
    </script>
</c:if>

<select id="${id}" class="js-example-basic-single" style="display: none;">
    <c:forEach var="item" items="${items}">
        <option value="${item.value}">${item.text}</option>
    </c:forEach>
</select>
<span class="editable" id="${id}Text" onclick="select2Enable(this.id, $('#${id}').attr('id'))">${text}</span>