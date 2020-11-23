
<%
    ui.includeJavascript("ehrconfigs", "moment.js")
    def pageLinkPrnt = ui.pageLink("initialpatientqueueapp", "showPatientInfo");
%>

<script type="text/javascript">
    var MODEL, _attributes;
    jQuery(document).ready(function () {
        var mnth = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var date = new Date('${currentDateTime}');

        jq('#agerow').text('${patient.age}'.substring(1, 100));

        var _attributes = new Array();
        <% patient.attributes.each { k, v -> %>
        _attributes[${k}] = '${v}';
        <%}%>

        var _observations = new Array();
        var observations = "${observations}";
        jQuery.each(observations, function (key, value) {
            _observations[key] = value;
        });


        /**
         ** VALUES FROM MODEL
         **/
        MODEL = {
            patientId: "${patient.patientId}",
            patientIdentifier: "${patient.identifier}",
            patientName: "${patient.fullname}",
            patientAge: "${patient.age}",
            patientGender: "${patient.gender}",
            patientAddress: "${patient.address}",
            patientAttributes: _attributes,
            observations: _observations,
            currentDateTime: "${currentDateTime}",
            TRIAGE: "${TRIAGE}",
            OPDs: "${OPDs}",
            SPECIALCLINIC: "${SPECIALCLINIC}",
            MEDICOLEGALCASE: "${MEDICOLEGALCASE}",
            selectedTRIAGE: "${selectedTRIAGE}",
            selectedOPD: "${selectedOPD}",
            selectedSPECIALCLINIC: "${selectedSPECIALCLINIC}",
            selectedMLC: "${selectedMLC}",
            registrationFee: "${registrationFee}",
            dueDate: "${dueDate}",
            daysLeft: "${daysLeft}",
            firstTimeVisit: "${firstTimeVisit}",
            revisit: "${revisit}",
            reprint: "${reprint}",
            selectedPaymentCategory: "${selectedPaymentCategory}",
            specialSchemeName: "${specialSchemeName}",
            create: "${create}",
            creates: "${creates}",
            visitTimeDifference: "${visitTimeDifference}"
        };


        jQuery("#save").hide();
        jQuery("#patientId").val(MODEL.patientId);
        jQuery("#revisit").val(MODEL.revisit);
        jQuery("#identifier").html(MODEL.patientIdentifier);
        jQuery("#age").html(MODEL.patientAge);
        jQuery("#name").html(MODEL.patientName);
        jQuery("#printablePaymentCategoryRow").hide();
        jQuery("#printableRoomToVisitRow").hide();
        jQuery("#fileNumberRowField").hide();
        jQuery("#printableFileNumberRow").hide();

        jQuery("#mlc").hide();

        jQuery("#buySlip").hide();

        jQuery("#specialSchemeNameField").hide();

        jQuery("#triage").hide();
        jQuery("#opdWard").hide();
        jQuery("#specialClinic").hide();
        jQuery("#fileNumberRow").hide();

        jQuery("#nationalId").html(MODEL.patientAttributes[20]);
        jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
        jQuery("#maritalStatus").html(MODEL.patientAttributes[26]);
        jQuery("#gender").html(MODEL.patientGender);
        jQuery("#patientName").html(MODEL.patientName);

        MODEL.TRIAGE = " ,Please Select Triage to Visit|" + MODEL.TRIAGE;
        PAGE.fillOptions("#triage", {
            data: MODEL.TRIAGE,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.OPDs = " ,Please Select OPD to Visit|" + MODEL.OPDs;
        PAGE.fillOptions("#opdWard", {
            data: MODEL.OPDs,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.SPECIALCLINIC = " ,Please Select Special Clinic to Visit|" + MODEL.SPECIALCLINIC;
        PAGE.fillOptions("#specialClinic", {
            data: MODEL.SPECIALCLINIC,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.MEDICOLEGALCASE = " ,Please Select MEDICO LEGAL CASE|" + MODEL.MEDICOLEGALCASE;
        PAGE.fillOptions("#mlc", {
            data: MODEL.MEDICOLEGALCASE,
            delimiter: ",",
            optionDelimiter: "|"
        });

        // Set the selected triage
        if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
            jQuery("#triage").show();
            jQuery("#triage").val(MODEL.selectedTRIAGE);
            jQuery("#triage").attr("disabled", "disabled");
        }

        // Set the selected OPD
        if (!StringUtils.isBlank(MODEL.selectedOPD)) {
            jQuery("#opdWard").show();
            jQuery("#opdWard").val(MODEL.selectedOPD);
            jQuery("#opdWard").attr("disabled", "disabled");
        }

        // Set the selected SPECIAL CLINIC
        if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
            jQuery("#specialClinicField").show();
            jQuery("#specialClinic").val(MODEL.selectedSPECIALCLINIC);
            jQuery("#specialClinic").attr("disabled", "disabled");
        }

        if (!StringUtils.isBlank(MODEL.selectedMLC)) {
            jQuery("#mlc").show();
            jQuery("#mlc").val(MODEL.selectedMLC);
            jQuery("#mlc").attr("disabled", "disabled");
        }


        jQuery("#paying").click(function () {
            VALIDATORS.payingCheck();
        });
        jQuery("#nonPaying").click(function () {
            VALIDATORS.nonPayingCheck();
        });
        jQuery("#specialSchemes").click(function () {
            VALIDATORS.specialSchemeCheck();
        });

        jQuery("#mlcCaseYes").click(function () {
            VALIDATORS.mlcYesCheck();
        });
        jQuery("#mlcCaseNo").click(function () {
            VALIDATORS.mlcNoCheck();
        });

        jQuery("#triageRoom").click(function () {
            VALIDATORS.triageRoomCheck();
        });
        jQuery("#opdRoom").click(function () {
            VALIDATORS.opdRoomCheck();
        });
        jQuery("#specialClinicRoom").click(function () {
            VALIDATORS.specialClinicRoomCheck();
        });

        if (!StringUtils.isBlank(MODEL.selectedTRIAGE) || !StringUtils.isBlank(MODEL.selectedOPD) || !StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
            jQuery("#triageRoomField").hide();
            jQuery("#opdRoomField").hide();
            jQuery("#specialClinicRoomField").hide();
        }


        if (MODEL.patientAttributes[14] == "Paying") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[44];
            var c = a + "/" + b;
            jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
            jQuery("#printPaymentCategory").append("<span style='border:0px'>" + c + "</span>");
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[45];
            if (MODEL.patientAttributes[45] == "NHIF CIVIL SERVANT") {
                var c = MODEL.patientAttributes[34];
                var d = a + "/" + b + "/" + c;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
                jQuery("#printPaymentCategory").append("<span style='border:0px'>" + d + "</span>");
            }
            else {
                var c = a + "/" + b;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
                jQuery("#printPaymentCategory").append("<span style='border:0px'>" + c + "</span>");
            }
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[46];
            if (MODEL.patientAttributes[46] == "STUDENT SCHEME") {
                var c = MODEL.patientAttributes[47];
                var d = MODEL.patientAttributes[42];
                var e = a + "/" + b + "/" + c + "/" + d;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + e + "</span>");
                jQuery("#printPaymentCategory").append("<span style='border:0px'>" + e + "</span>");
            }
            else if (MODEL.patientAttributes[46] == "WAIVER CASE") {
                var c = MODEL.patientAttributes[32];
                var d = a + "/" + b + "/" + c;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
                jQuery("#printPaymentCategory").append("<span style='border:0px'>" + d + "</span>");
            }
            else {
                var c = a + "/" + b;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
                jQuery("#printPaymentCategory").append("<span style='border:0px'>" + c + "</span>");
            }
        }
        jQuery("#printablePaymentCategoryRow").show();

        // Set data for first time visit,revisit,reprint
        if (MODEL.firstTimeVisit == "true") {
            jQuery("#reprint").hide();
            jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();

            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseYesField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#triageRowField").hide();
            jQuery("#opdRowField").hide();
            jQuery("#specialClinicRowField").hide();

            jQuery("#printableRoomToVisitRow").show();
            if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedOPD)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                jQuery("#printableFileNumber").empty();
                if (MODEL.patientAttributes[43] != undefined) {
                    jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");
                }
                jQuery("#printableFileNumberRow").show();
            }

        }
        else if (MODEL.revisit == "true") {
            jQuery("#reprint").hide();
            jQuery("#printableRegistrationFeeForRevisitRow").hide();
            jQuery("#selectedPaymentCategory").val(MODEL.patientAttributes[14]);
            if (MODEL.patientAttributes[14] == "Paying") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[44]);
            }
            if (MODEL.patientAttributes[14] == "Non-Paying") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[45]);
            }
            if (MODEL.patientAttributes[14] == "Special Schemes") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[46]);
            }

        }
        else if (MODEL.reprint == "true") {

            jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();
            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseYesField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#triageRowField").hide();
            jQuery("#opdRowField").hide();
            jQuery("#specialClinicRowField").hide();

            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#printableRoomToVisitRow").show();
            if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");

            }
            if (!StringUtils.isBlank(MODEL.selectedOPD)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                jQuery("#printableFileNumber").empty();
                if (MODEL.patientAttributes[43] != undefined) {
                    jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");
                }
                jQuery("#printableFileNumberRow").show();
            }

            //alert("hmmm");
            if ((MODEL.create != 0) && (MODEL.creates != 0)) { //alert("hiii");
                jQuery("#patientrevisit").hide();
                jQuery("#patRevisit").hide();
            }
            else { //alert("hello");
                jQuery("#patientrevisit").show();
                jQuery("#patRevisit").show();
            }

            jQuery("#printSlip").hide();
            jQuery("#save").hide();
        }

        triageRoomSelection();

    });

    /**
     ** PAGE METHODS
     **/
    PAGE = {
        /** Validate and submit */
        submit: function (reprint) {
            if (PAGE.validate()) {
                if (MODEL.revisit == "true") {
                    if (jQuery("#mlcCaseYes").is(':checked')) {
                        jQuery("#mlcCaseNoRowField").hide();
                        jQuery("#mlcCaseYesField").hide();
                        jQuery("#mlc").hide();
                        jQuery("#mlc").after("<span style='border:0px'>" + jQuery("#mlc option:checked").html() + "</span>");
                    }
                    else if (jQuery("#mlcCaseNo").is(':checked')) {
                        jQuery("#medicoLegalCaseRowField").hide();
                        jQuery("#mlcCaseNoRowField").hide();
                    }

                    jQuery("#triageRowField").hide();
                    jQuery("#opdRowField").hide();
                    jQuery("#specialClinicRowField").hide();

                    if (jQuery("#paying").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#paying").val() + "</span>");
                        jQuery("#printPaymentCategory").append("<span style='border:0px'>" + jQuery("#paying").val() + "</span>");
                    }
                    if (jQuery("#nonPaying").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#nonPaying").val() + "</span>");
                        jQuery("#printPaymentCategory").append("<span style='border:0px'>" + jQuery("#nonPaying").val() + "</span>");
                    }

                    if (jQuery("#specialSchemes").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#specialSchemes").val() + "</span>");
                        jQuery("#printPaymentCategory").append("<span style='border:0px'>" + jQuery("#specialSchemes").val() + "</span>");
                    }

                    jQuery("#printablePaymentCategoryRow").show();

                    jQuery("#printableRoomToVisitRow").show();
                    if (jQuery("#triageRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
                    }
                    if (jQuery("#opdRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");

                    }
                    if (jQuery("#specialClinicRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                        jQuery("#printableFileNumber").empty();
                        jQuery("#printableFileNumber").append("<span style='border:0px'>" + jQuery("#fileNumber").val() + "</span>");
                        jQuery("#fileNumberRowField").hide();
                        jQuery("#printableFileNumberRow").show();
                    }

                }

                // submit form and print
                if (!reprint) {
                    jQuery.ajax({
                        type: "POST",
                        url: '${ ui.actionLink("registration", "newPatientRegistrationForm", "savePatientInfo") }',
                        dataType: "json",
                        data: jQuery("#patientInfoForm").serialize(),
                        success: function (data) {
                            PAGE.print();
                            window.location.href = '${ ui.pageLink("registration", "patientRegistration")}';
                        }
                    });
//
                } else {
                    PAGE.print();
                    window.location.href = '${ ui.pageLink("registration", "patientRegistration")}';
                }

            }
        },

        // Print the slip
        print: function () {
            var myStyle = '<link rel="stylesheet" href="http://localhost:8080/openmrs/ms/uiframework/resource/registration/styles/onepcssgrid.css" />';
            var printDiv = jQuery("#printDiv").html();
            var printWindow = window.open('', '', 'height=500,width=400');

            printWindow.document.write('<html><head><title>Patient Information</title>');
            printWindow.document.write('<body style="font-family: Dot Matrix Normal,Arial,Helvetica,sans-serif; font-size: 12px; font-style: normal;">');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body>');
            printWindow.document.write('</html>');
            printWindow.print();
            printWindow.close();

        },

        // harsh #244 Added a save button.
        save: function () {
            if (PAGE.validate()) {
                var save = document.getElementById("save");
                if (save === save) {
                    document.getElementById("save").disabled = true;
                }
                jQuery("#patientInfoForm").ajaxSubmit({
                    success: function (responseText, statusText, xhr) {
                        if (responseText === "success") {

                            window.location.href = getContextPath() + "/findPatient.htm";
                        }
                    }
                });
            }
        },


        /** FILL OPTIONS INTO SELECT
         * option = {
         * 		data: list of values or string
         *		index: list of corresponding indexes
         *		delimiter: seperator for value and label
         *		optionDelimiter: seperator for options
         * }
         */
        fillOptions: function (divId, option) {
            jQuery(divId).empty();
            if (option.delimiter == undefined) {
                if (option.index == undefined) {
                    jQuery.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
                        }
                    });
                } else {
                    jQuery.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
                        }
                    });
                }
            } else {
                options = option.data.split(option.optionDelimiter);
                jQuery.each(options, function (index, value) {
                    values = value.split(option.delimiter);
                    optionValue = values[0];
                    optionLabel = values[1];
                    if (optionLabel != undefined) {
                        if (optionLabel.length > 0) {
                            jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
                        }
                    }
                });
            }
        },

        /** Buy A New Slip */
        buySlip: function () {
            jQuery.ajax({
                type: "GET",
                url: openmrsContextPath + "/module/registration/ajax/buySlip.htm",
                data: ({
                    patientId: MODEL.patientId
                }),
                success: function (data) {
                    window.location.href = window.location.href;
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(thrownError);
                }
            });
        },

        /** Validate Form */
        validate: function () {
            if (MODEL.revisit == "true") {
                var verified = 0;

                if (jQuery("#mlcCaseYes").is(':checked') && StringUtils.isBlank(jQuery("#mlc").val())) {
                    jq().toastmessage('showErrorToast', "Please select the medico legal case");
                    jQuery('#mlc').addClass("red-border");
                    verified++;
                }
                else {
                    jQuery('#mlc').removeClass("red-border");
                }

                if (!jq('[name="visitRoom"]').is(':checked')) {
                    jq().toastmessage('showErrorToast', "You did not choose any room for visit");
                    verified++;
                }

                if (jQuery("#triageRoom").attr('checked') && StringUtils.isBlank(jQuery("#triage").val())) {
                    jq().toastmessage('showErrorToast', "Please select the triage room to visit");
                    jQuery('#triage').addClass("red-border");
                    verified++;
                }
                else {
                    jQuery('#triage').removeClass("red-border");
                }

                if (jQuery("#opdRoom").attr('checked') && StringUtils.isBlank(jQuery("#opdWard").val())) {
                    jq().toastmessage('showErrorToast', "Please select the OPD room to visit");
                    jQuery('#opdWard').addClass("red-border");
                    verified++;
                }
                else {
                    jQuery('#opdWard').removeClass("red-border");
                }

                if (jQuery("#specialClinicRoom").attr('checked')) {
                    if (StringUtils.isBlank(jQuery("#specialClinic").val())) {
                        jq().toastmessage('showErrorToast', "Please select the Special Clinic to visit");
                        jQuery('#specialClinic').addClass("red-border");
                        verified++;
                    }
                    else {
                        jQuery('#specialClinic').removeClass("red-border");
                    }

                    if (StringUtils.isBlank(jQuery("#fileNumber").val())) {
                        jq().toastmessage('showErrorToast', "Please specify the File Number");
                        jQuery('#fileNumber').addClass("red-border");
                        verified++;
                    }
                    else {
                        jQuery('#fileNumber').removeClass("red-border");
                    }
                }
                else {
                    jQuery('#specialClinic').removeClass("red-border");
                    jQuery('#fileNumber').removeClass("red-border");
                }

                var age = ${patientAge};
                var gender = '${patientGender}';
                var opd_room = jq('#triage').val();
                var tri_room = jq('#specialClinic').val();

                if (age > 5 && gender == 'M' && (opd_room == '5123' || tri_room == '5704')){
                    jq().toastmessage('showErrorToast', "MCH is only valid for Women and Children under 5yrs");
                    jQuery('#triage').addClass("red-border");
                    verified++;
                }
                else{
                    jQuery('#triage').removeClass("red-border");
                }

            }

            if (verified == 0) {
                return true;
            }
            else {
                return false;
            }

        }
    };

    //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
    VALIDATORS = {

        /** CHECK WHEN PAYING CATEGORY IS SELECTED */
        payingCheck: function () {
            if (jQuery("#paying").is(':checked')) {
                jQuery("#nonPaying").removeAttr("checked");

                jQuery("#specialSchemes").removeAttr("checked");
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
            }
        },

        /** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
        nonPayingCheck: function () {
            if (jQuery("#nonPaying").is(':checked')) {
                jQuery("#paying").removeAttr("checked");

                jQuery("#specialSchemes").removeAttr("checked");
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
            }
        },

        /** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
        specialSchemeCheck: function () {
            if (jQuery("#specialSchemes").is(':checked')) {
                jQuery("#paying").removeAttr("checked");

                jQuery("#nonPaying").removeAttr("checked");
                jQuery("#specialSchemeNameField").show();
            }
            else {
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
            }
        },

        mlcYesCheck: function () {
            if (jQuery("#mlcCaseYes").is(':checked')) {
                jQuery("#mlcCaseNo").removeAttr("checked");
                jQuery("#mlc").show();
            }
            else {
                jQuery("#mlc").hide();
            }
        },

        mlcNoCheck: function () {
            if (jQuery("#mlcCaseNo").is(':checked')) {
                jQuery("#mlcCaseYes").removeAttr("checked");
                jQuery("#mlc").hide();
            }
        },

        triageRoomCheck: function () {
            if (jQuery("#triageRoom").is(':checked')) {
                jQuery("#triage").show();

                jQuery("#opdWard").val("");
                jQuery("#opdWard").hide();

                jQuery("#specialClinic").val("");
                jQuery("#specialClinic").hide();

                jQuery("#fileNumber").val("");
                jQuery("#fileNumberRow").hide();
            }
            else {
                jQuery("#triage").hide();
            }
        },

        opdRoomCheck: function () {
            if (jQuery("#opdRoom").is(':checked')) {
                jQuery("#opdWard").show();

                jQuery("#triage").val("");
                jQuery("#triage").hide();

                jQuery("#specialClinic").val("");
                jQuery("#specialClinic").hide();

                jQuery("#fileNumber").val("");
                jQuery("#fileNumberRow").hide();
            }
            else {
                jQuery("#opdWard").hide();
            }
        },

        specialClinicRoomCheck: function () {
            if (jQuery("#specialClinicRoom").is(':checked')) {
                jQuery("#fileNumberRow").show();
                jQuery("#specialClinic").show();

                jQuery("#triage").val("");
                jQuery("#triage").hide();
                jQuery("#opdWard").val("");
                jQuery("#opdWard").hide();
            }
            else {
                jQuery("#fileNumberRow").hide();
                jQuery("#specialClinic").hide();
            }
        },


        categoryCheck: function () {

            if (jQuery("#paymentCategory").val() == "Paying") {

                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();

            } else if (jQuery("#paymentCategory").val() == "Non-Paying") {
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();


            } else if (jQuery("#paymentCategory").val() == "Special Schemes") {
                jQuery("#specialSchemeNameField").show();
            }
        },
    };

    function triageRoomSelection() {

        if (MODEL.patientAttributes[14] == "Paying") {
            if ((MODEL.visitTimeDifference <= 24)) {  //alert("Patient Revisit within 24 hr");
                // alert("hello");
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();
                jQuery("#patRevisit").show();
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else {
                jQuery("#selectedRegFeeValue").val('${reVisitFee}');
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + ".00</span>");
        jQuery("#printRegistrationFee").text( selectedRegFeeValue + '.00');

    }

    function opdRoomSelection() {
        if ((MODEL.patientAttributes[14] == "Paying")) {
            //	alert("hii");
            if ((MODEL.visitTimeDifference <= 24)) {
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();
                jQuery("#patRevisit").show();

                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                    //jQuery("#selectedRegFeeValue").show("(Patient Revisit within 24 hr)");
                }
            }
            else {
                jQuery("#selectedRegFeeValue").val('${reVisitFee}');
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + ".00</span>");
        jQuery("#printRegistrationFee").text(selectedRegFeeValue + '.00');

    }

    function specialClinicSelection() {

        if (!StringUtils.isBlank(jQuery("#specialClinic").val())) {
            jQuery("#fileNumberRowField").show();
            if (MODEL.patientAttributes[43] != null) {
                jQuery("#fileNumber").val(MODEL.patientAttributes[43]);
                jQuery("#fileNumber").attr("disabled", "disabled");
            }
        }
        else {
            jQuery("#fileNumberRowField").hide();
        }

        if (MODEL.patientAttributes[14] == "Paying") {
            if ((MODEL.visitTimeDifference <= 24)) {    //alert("Patient Revisit within 24 hr");
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();
                jQuery("#patRevisit").show();
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else {
                var reVisitRegFee = parseInt('${reVisitFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = reVisitRegFee + specialClinicRegFee;
                jQuery("#selectedRegFeeValue").val(totalRegFee);
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
            if (MODEL.patientAttributes[45] == "TB PATIENT") {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
            if (MODEL.patientAttributes[45] == "CCC PATIENT") {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + ".00</span>");
        jQuery("#printRegistrationFee").text(selectedRegFeeValue + ".00");

    }
</script>

<style>
.donotprint {
    display: none;
}

.spacer {

    font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
    font-style: normal;
    font-size: 12px;
}

.printfont {
    font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
    font-style: normal;
    font-size: 12px;
}

.new-patient-header .identifiers {
    padding-top: 15px;
}

ul.left-menu {
    border-color: #ccc #ccc #ccc -moz-use-text-color;
    border-image: none;
    border-style: solid solid solid solid;
    border-width: 1px 1px 1px medium;
}

.col15 {
    min-width: 22%;
    max-width: 22%;
    float: left;
    display: inline-block;
}

.col16 {
    min-width: 56%;
    max-width: 56%;
    float: left;
    display: inline-block;
}

.dashboard .info-body label {
    width: 170px;
    display: inline-block;
    margin-bottom: 6px;
    font-size: 90%;
    font-weight: bold;
}
.dashboard .info-body label span{
    color: #f00;
    padding-left: 10px;
}

.checks {
    width: 			140px !important;
    margin-bottom: 	0px !important;
    margin-top:  	5px !important;
    font-size: 100% !important;
    font-weight: normal !important;
    cursor: pointer;
}

input[type="radio"] {
    cursor: pointer;
}

.dashboard .action-section {
    margin-top: 35px;
}

input[type="text"], input[type="password"], select {
    border: 1px solid #888;
    border-radius: 3px !important;
    box-shadow: none !important;
    box-sizing: border-box !important;
    height: 32px !important;
    line-height: 18px !important;
    padding: 0px 10px !important;
    width: 200px !important;
}

#fileNumberRow {
    margin: 2px 0px 10px 0px;
}

.status-container {
    padding: 5px 10px 5px 5px;
}

.button {
    height: 25px;
    width: 150px !important;
    text-align: center;
    padding-top: 15px !important;
}

.toast-item {
    background-color: #222;
}

.red-border {
    border: 1px solid #f00 !important;
}
form label, .form label {
    margin-top: 0px;
}
form input, form select, form textarea, form ul.select, .form input, .form select, .form textarea, .form ul.select {
    margin: 0;
}
form input, form select, form textarea, form ul.select, .form input, .form select, .form textarea, .form ul.select {
    min-width: 0;
}
form input[type="radio"]:focus {
    outline: 2px none #007fff;
}
#patientrevisit,
#patRevisit {
    color: #f00;
    display: none;
}
form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus{
    outline: 1px none #007fff;
    box-shadow: 0 0 2px 0px #888!important;
}
</style>

<body>
<div class="clear"></div>

<form id="patientInfoForm" method="POST">
	<div class="container">
		<div class="example">
			<ul id="breadcrumbs">
				<li>
					<a href="${ui.pageLink('referenceapplication', 'home')}">
<i class="icon-home small"></i></a>
				</li>
<li>
    <i class="icon-chevron-right link"></i>
    <a href="${ui.pageLink('registration', 'patientRegistration')}">Registration</a>
</li>
<li>
    <i class="icon-chevron-right link"></i>
    Revist Patient
</li>
</ul>
</div>

<div class="patient-header new-patient-header">
    <div class="demographics">
        <h1 class="name">
            <span>${patient.surName},<em>surname</em></span>
            <span>${patient.firstName} ${patient.otherName} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em>
            </span>
        </h1>

        <br>

        <div class="status-container">
            <span class="status active"></span>
            Active Visit
        </div>

        <div class="tag">Outpatient</div>
    </div>

    <div class="identifiers">
        <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
        <span>${patient.identifier}</span>
        <br>
    </div>

    <div class="close"></div>
</div>

<div class="onerow">
    <div class="col15 clear" style="padding-top: 15px;">
        <ul class="left-menu" id="left-menu">
            <li visitid="54" class="menu-item selected">
                <span class="menu-date">
                    <i class="icon-time"></i>
                    <span>
                        ${ui.formatDatePretty(lastVisit)}<br/>
                        (Active Since ${lastVisit.toString().substring(10,16)} Hrs)
                    </span>
                </span>
                <span class="menu-title">
                    <i class="icon-stethoscope"></i>
                    ${outcomes?outcomes:'No diagnosis yet'}
                </span>
                <span class="arrow-border"></span>
                <span class="arrow"></span>
            </li>

            <li visitid="53" class="menu-item" style="height: 230px;">
            </li>
        </ul>
    </div>

    <div id="patientInfoPrintArea">


        <div class="col16 dashboard">
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-diagnosis"></i>

                    <h3>PATIENT DETAILS</h3>
                </div>

                <div class="info-body">
                    <label>Previous Visit:</label>
                    <span>${currentDateTime}</span>
                    <br/>

                    <label>Patient Age :</label>
                    <span id="agerow">&nbsp;</span>
                    <br/>

                    <label>Patient Gender :</label>
                    <span>${patient.gender}</span>

                    <br/>

                    <div id="printablePaymentCategoryRow">
                        <label>Payment Category :</label>
                        <span id="printablePaymentCategory"></span>
                    </div>

                </div>
            </div>

            <div class="info-section">
                <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>VISIT INFORMATION</h3>
                </div>

                <div class="info-body">
                    <input type="hidden" id="patientId" name="patientId" value="${patient.patientId}"/>
                    <label>Medical Legal Case:<span>*</span></label>
                    <label for="mlcCaseYes" class="checks">
                        <input type="radio" name="mlcCaseYes" id="mlcCaseYes"/> YES
                    </label>
                    <select id="mlc" name="patient.mlc" style='width: 152px; display:inline-block;'></select>

                    <br/>

                    <label>&nbsp;</label>
                    <label for="mlcCaseNo" class="checks">
                        <input type="radio" name="mlcCaseYes" id="mlcCaseNo" checked=""/> NO
                    </label>
                    <br/>
                    <br/>

                    <label>Room to Visit :<span>*</span></label>
                    <label for="triageRoom" class="checks">
                        <input type="radio" name="visitRoom" id="triageRoom"/> TRIAGE
                    </label>
                    <select id="triage" name="patient.triage" onchange="triageRoomSelection();"
                            style='width: 152px; display:inline-block;'></select>
                    <br/>

                    <label>&nbsp;</label>
                    <label for="opdRoom" class="checks">
                        <input type="radio" name="visitRoom" id="opdRoom"/> OPD ROOM
                    </label>
                    <select id="opdWard" name="patient.opdWard" onchange="opdRoomSelection();"
                            style='width: 152px; display:inline-block;'></select>
                    <br/>

                    <label>&nbsp;</label>
                    <label for="specialClinicRoom" class="checks">
                        <input type="radio" name="visitRoom" id="specialClinicRoom"/> SPECIAL CLINIC
                    </label>
                    <select id="specialClinic" name="patient.specialClinic" onchange="specialClinicSelection();"
                            style='width: 152px; display:inline-block;'></select>
                    <br/>

                    <div id="fileNumberRow" class="onerow">
                        <label>&nbsp;</label>
                        <label class="checks">&nbsp;</label>
                        <input type="text" id="fileNumber" name="person.attribute.43" placeholder="File Number"
                               style='display:inline-block;'/>
                    </div>

                </div>
            </div>

            <div class="info-section">
                <div class="info-header">
                    <i class="icon-diagnosis"></i>

                    <h3>REVISIT SUMMARY DETAILS</h3>
                </div>

                <div class="info-body">
                    <label>Registration Fee:</label>
                    <span id="printableRegistrationFee">0.00</span>
                    <span id="patientrevisit"> (Revisit Within 24hrs)</span>
                    <br/>

                    <label>Served By :</label>
                    <span>${user}</span>
                    <br/>
                </div>
            </div>

        </div>


        <input type="hidden" id="selectedPaymentCategory" name="patient.selectedPaymentCategory"/>
        <input type="hidden" id="selectedPaymentSubCategory" name="patient.selectedPaymentSubCategory"/>
        <input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee"/>

    </div>
</div>


<div class="onerow">
    <div class="col15">
        &nbsp;
    </div>

    <div class="col16 dashboard">
        <a class="button confirm" style="float: right;" onClick="PAGE.submit(false);">
            <i class="icon-user-md" style="font-size: 20px; width: 40px; display: inline;"></i>
            REVISIT PATIENT
        </a>

    </div>

    <div class="row15 last">
        &nbsp;
    </div>
</div>


<div class="onerow" align="left">
    <span id="validationDate"></span>
</div>
</div>
</form>

<div id="printDiv" style="display: none;">
    <center>
        <center>
            <img width="60" height="60" align="center" title="OpenMRS" alt="OpenMRS"
                 src="${ui.resourceLink('registration', 'images/kenya_logo.bmp')}">
        </center>
    </center>

    <h3><center><u><b>${userLocation}</b></u></center></h3>
    <h4 style="font-size: 1.4em;"><center><b>Registration Receipt</b></center></h4>
    <div style="display: block;	margin-left: auto; margin-right: auto; width: 350px">
        <div>
            <div class="col2" align="left" style="display:inline-block; width: 150px">
                <b>Receipt Date:</b>
            </div>

            <div class="col2" align="left" style="display: inline-block; width: 150px;">
                <span>${receiptDate}</span>
            </div>
        </div>

        <div class="onerow" align="left">
            <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Name:</b></div>
            <div class="col2" align="left" style="display:inline-block; width: 150px"><span id="patientName"></span></div>
        </div>

        <div class="onerow" align="left">
            <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Patient ID:</b></div>
            <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="identifier"></span></div>
    </div>

    <div class="onerow" align="left">
        <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Age:</b></div>
        <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="age"></span></div>
</div>

<div class="onerow" align="left">
    <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Gender:</b></div>
    <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="gender"></span></div>
</div>

<div class="onerow" align="left" id="printablePaymentCategoryRow">
    <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Payment Category:</b></div>
    <div class="col2" align="left" style="display:inline-block; width: 150px""><div id="printPaymentCategory"></div></div>
</div>

<div class="onerow" align="left">
    <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Previous Visit Date:</b></div>
    <div class="col2" align="left" style="display:inline-block;">
        ${currentDateTime}
    </div>
</div>

<div class="onerow" align="left">
    <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Registration Fee:</b></div>
    <div class="col2" align="left" style="display:inline-block;" id="printRegistrationFee">
        ${registrationFee?:"0"}.00
    </div>
</div>

<div class="onerow" align="left" id="patRevisit" style="display:none">
    <div class="col2" align="left" style="display:inline-block; width: 150px">&nbsp;</div>
    <div class="col2" align="left" style="display:inline-block; width: 175px"><font color="#ff0000 ">(Patient Revisit with in 24 hr)</font></div>
</div>

<div class="onerow" align="left" id="printableSpacing">
    <div class="col2" align="left" style="display:inline-block; width: 150px">&nbsp;</div>
    <div class="col2" align="left" style="display:inline-block; width: 150px"></div>
</div>

<div class="onerow" align="left" id="printableUserRow">
    <div class="col2" align="left" style="display:inline-block; width: 150px"><b>You were served by:</b></div>
    <div class="col2" align="left" style="display:inline-block;">
        ${user}
    </div>

    <div class="col4 last">&nbsp;</div>
</div>
</div>

</body>