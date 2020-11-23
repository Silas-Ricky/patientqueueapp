<%
    ui.decorateWith("kenyaemr", "standardPage", [ patient: currentPatient ])
    ui.includeCss("ehrconfigs", "referenceapplication.css")
%>
<style type="text/css">
body {
    margin-top: 20px;
}

.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
    color: #555;
    text-align: left;
}

input[type="text"]{
    border: 1px solid #aaa;
    border-radius: 5px!important;
    box-shadow: none!important;
    box-sizing: border-box!important;
    height: 38px!important;
    line-height: 18px!important;
    padding: 8px 10px!important;
    text-transform: capitalize;
    width: 100%!important;
}
form select {
    width:100%;
    border: 1px solid #aaa;
    border-radius: 5px!important;
    box-shadow: none!important;
    box-sizing: border-box!important;
    height: 38px!important;
    line-height: 18px!important;
    padding: 8px 10px!important;
}
.boostr{
    border-left: 1px solid #e4e4e4!important;
    margin-top: 4px!important;
    padding-left: 10px!important;
    right: 10px!important;
}
#estimatedAge span,
label span{
    color: #ff0000;
    padding-left: 5px;
}
.toast-item{
    background-color: #222;
}

@media all and (max-width: 768px) {
    .onerow {
        margin: 0 0 100px;
    }
}
.simple-form-ui section fieldset select:focus, .simple-form-ui section fieldset input:focus, .simple-form-ui section #confirmationQuestion select:focus, .simple-form-ui section #confirmationQuestion input:focus, .simple-form-ui #confirmation fieldset select:focus, .simple-form-ui #confirmation fieldset input:focus, .simple-form-ui #confirmation #confirmationQuestion select:focus, .simple-form-ui #confirmation #confirmationQuestion input:focus, .simple-form-ui form section fieldset select:focus, .simple-form-ui form section fieldset input:focus, .simple-form-ui form section #confirmationQuestion select:focus, .simple-form-ui form section #confirmationQuestion input:focus, .simple-form-ui form #confirmation fieldset select:focus, .simple-form-ui form #confirmation fieldset input:focus,
.simple-form-ui form #confirmation #confirmationQuestion select:focus, .simple-form-ui form #confirmation #confirmationQuestion input:focus {
    outline: 1px none #007fff;
    box-shadow: 0 0 2px 0px #888!important;
}
.no-confirmation{
    margin-top: -25px;
}
.name {
    color: #f26522;
}
form textarea:focus, .form textarea:focus{
    outline: 1px none #007fff;
}
</style>

<div class="ke-page-content">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td width="30%" valign="top">
                ${ ui.includeFragment("kenyaemr", "patient/patientSummary", [ patient: currentPatient ]) }
                ${ ui.includeFragment("kenyaemr", "patient/patientRelationships", [ patient: currentPatient ]) }
            </td>
            <td valign="top" style="padding-left: 5px">
                <div class="onepcssgrid-1000">
                ${ ui.includeFragment("initialpatientqueueapp", "queuePatient", [patient: currentPatient])}
            </div>
            </td>
            <td width="15%" valign="top" style="padding-left: 5px">
                ${ ui.includeFragment("kenyaemr", "providerAction/providerActions") }
            </td>
        </tr>
    </table>
</div>