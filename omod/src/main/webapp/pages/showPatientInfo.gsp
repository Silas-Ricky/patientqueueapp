<% ui.decorateWith("kenyaemr", "standardEmrPage", [title: "Patient Summary"]) %>
<%
    ui.includeCss("ehrconfigs", "onepcssgrid.css")
    ui.includeCss("initialpatientqueueapp", "main.css")

%>

<style>
.name {
    color: #f26522;
}
</style>

<div class="onepcssgrid-1000">

    ${ui.includeFragment("initialpatientqueueapp", "js_css")}

    <%
        if(revisit) {
    %>
    ${ui.includeFragment("initialpatientqueueapp", "patientInfoPage")}
    <%
        }else {
    %>
    ${ui.includeFragment("initialpatientqueueapp", "patientInfoForm")}
    <%
        }
    %>

</div>