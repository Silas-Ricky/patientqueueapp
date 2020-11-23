
<script type="text/javascript">
    var MODEL,
        arrey,
        alley,
        age,
        emrMessages = {};

    var oRegX = /^[a-zA-Z-` ]*\$/;
    emrMessages["requiredField"] = "Required";
    jq(document).ready(function () {
        jq("input[name='paym_1']:radio").change(function () {
            var index = jq(this, '#simple-form-ui').val();
            alley = "";
            arrey = MODEL.payingCategory.split("|");
            if (index == 1) {
                jq('#tasktitle').text('Paying Category');
                jq('#paying').attr('checked', 'checked').change();
                jq('#nonPaying').attr('checked', false).change();
                jq('#specialSchemes').attr('checked', false).change();
                arrey = MODEL.payingCategory.split("|");
            }
            else if (index == 2) {
                jq('#tasktitle').text('Nonpaying Category');
                jq('#paying').attr('checked', false).change();
                jq('#nonPaying').attr('checked', 'checked').change();
                jq('#specialSchemes').attr('checked', false).change();
                arrey = MODEL.nonPayingCategory.split("|");
            }
            else {
                jq('#tasktitle').text('Special Schemes');
                jq('#paying').attr('checked', false).change();
                jq('#nonPaying').attr('checked', false).change();
                jq('#specialSchemes').attr('checked', 'checked').change();
                arrey = MODEL.specialScheme.split("|");
            }
            if (MODEL.payingCategory.split('|').length == 1 && index == 1){
                jq('.parent-items label').eq(0).hide();
                jq('.parent-items label').eq(1).css("border-top", "1px none #f0f2f3");
                arrey = MODEL.nonPayingCategory.split("|");
            }
            if (MODEL.nonPayingCategory.split('|').length == 1){
                jq('.parent-items label').eq(1).hide();
            }
            if (MODEL.specialScheme.split('|').length == 1){
                jq('.parent-items label').eq(2).hide();
            }
            if (MODEL.specialScheme.split('|').length == 1){
                jq('.parent-items label').eq(2).hide();
            }
            for (var i = 0; i < arrey.length - 1; i++) {
                alley += "<label class='tasks-list-item'><input style='display:none!important' type='radio' name='paym_2' id='paym_20" + (i + 1) + "' value='" + (i + 1) + "' data-name='" + arrey[i].substr(0, arrey[i].indexOf(',')) + "' class='tasks-list-cb' /> <span class='tasks-list-mark'></span> <span class='tasks-list-desc' id='ipaym_1" + (i + 1) + "'>" + arrey[i].substr(0, arrey[i].indexOf(',')) + "</span> </label>";
            }
            jq('#paycatgs').html(alley.replace("CHILD LESS THAN 5 YEARS", "CHILD UNDER 5YRS").replace("CHILD LESS THAN 5 YEARS", "CHILD UNDER 5YRS"));
            if (typeof jq('input[name=paym_2]:checked', '#patientRegistrationForm').val() == 'undefined') {
                jq("#modesummary").attr("readonly", false);
                jq("#modesummary").attr("name", 'modesummary');
                jq("#modesummary").val("N/A");
                jq('#universitydiv').hide();
                jq('#university option').eq(0).prop('selected', true);
                jq('#summtitle1').text('Details');
                jq('#modesummary').attr("placeholder", "Enter Value");
            }
            LoadPayCatgMode();
        });
        jq("#rooms1").on("change", function () {
            selectedFeeCategory();
            var nonPayingCategorySelected = jq("#nonPayingCategory").val();
            if (nonPayingCategorySelected === "CCC PATIENT" || nonPayingCategorySelected === "TB PATIENT") {
                nonPayingCategorySelection();
            }
        });
        jq("#paycatgs").on("change", "input[name='paym_2']:radio", function () {
            selectedFeeCategory();
            LoadPayCatgMode();
        });
        function selectedFeeCategory()
        {
            var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
            var select3 = '';
            if (select1 === 1) {
                jq('#payingCategory option').eq(select2).prop('selected', true);
                jq('#nonPayingCategory option').eq(0).prop('selected', true);
                jq('#specialScheme option').eq(0).prop('selected', true);
                select3 = jq('#payingCategory :selected').val().toUpperCase();
                jq('#summ_pays').text('Paying / ' + jq('#payingCategory option:selected').text());
                payingCategorySelection();
            }
            else if (select1 === 2) {
                jq('#nonPayingCategory option').eq(select2).prop('selected', true);
                jq('#payingCategory option').eq(0).prop('selected', true);
                jq('#specialScheme option').eq(0).prop('selected', true);
                select3 = jq('#nonPayingCategory :selected').val().toUpperCase();
                jq('#summ_pays').text('Non-Paying / ' + jq('#nonPayingCategory option:selected').text());
                nonPayingCategorySelection();
            }
            else {
                jq('#specialScheme option').eq(select2).prop('selected', true);
                jq('#payingCategory option').eq(0).prop('selected', true);
                jq('#nonPayingCategory option').eq(0).prop('selected', true);
                select3 = jq('#specialScheme :selected').val().toUpperCase();
                jq('#summ_pays').text('Special Scheme / ' + jq('#specialScheme option:selected').text());
                payingCategorySelection();
                nonPayingCategorySelection();
            }
            if (select3.indexOf("National Health Insurance Fund Member") >= 0) {
                jq("#modesummary").attr("readonly", false);
                jq("#modesummary").attr("name", 'person.attribute.34');
                jq("#modesummary").val("");
                jq('#universitydiv').hide();
                jq('#university option').eq(0).prop('selected', true);
                jq('#summtitle1').text('NHIF Details');
                jq('#modesummary').attr("placeholder", "NHIF Number");
            }
            else if (select3.indexOf("Student") >= 0) {
                jq("#modesummary").attr("readonly", false);
                jq("#modesummary").attr("name", 'person.attribute.42');
                jq("#modesummary").val("");
                jq('#universitydiv').show();
                jq('#university option').eq(1).prop('selected', true);
                jq('#summtitle1').text('Student Details');
                jq('#modesummary').attr("placeholder", "Student Number");
            }
            else if (select3.toUpperCase().indexOf("HOSPITAL WAIVER") >= 0) {
                jq("#modesummary").attr("readonly", false);
                jq("#modesummary").attr("name", 'person.attribute.32');
                jq("#modesummary").val("");
                jq('#universitydiv').hide();
                jq('#university option').eq(0).prop('selected', true);
                jq('#summtitle1').text('Waiver Details');
                jq('#modesummary').attr("placeholder", "Waiver Number");
            }
            else {
                jq("#modesummary").attr("readonly", false);
                jq("#modesummary").attr("name", 'modesummary');
                jq("#modesummary").val("N/A");
                jq('#universitydiv').hide();
                jq('#university option').eq(0).prop('selected', true);
                jq('#summtitle1').text('Details');
                jq('#modesummary').attr("placeholder", "Enter Value");
            }
            jq('#summ_fees').text(jq('#selectedRegFeeValue').val() + '.00');
        }
        // Paying Category Map
        var _payingCategoryMap = new Array();
         var payingCategoryMap = "${payingCategoryMap}";
        <% payingCategoryMap.each { k, v -> %>
        _payingCategoryMap[${k}] = '${v}';
        <%}%>
        // NonPaying Category Map
        var _nonPayingCategoryMap = new Array();
         var nonPayingCategoryMap = "${nonPayingCategoryMap}";
        <% nonPayingCategoryMap.each { k, v -> %>
        _nonPayingCategoryMap[${k}] = '${v}';
        <%}%>
        // Special Scheme Map
        var _specialSchemeMap = new Array();
         var specialSchemeMap = "${specialSchemeMap}";
        <% specialSchemeMap.each { k, v -> %>
        _specialSchemeMap[${k}] = '${v}';
        <%}%>
        /**
         ** MODEL FROM CONTROLLER
         **/
        MODEL = {
            TRIAGE: "${TRIAGE}",
            OPDs: "${OPDs}",
            SPECIALCLINIC: "${SPECIALCLINIC}",
            payingCategory: "${payingCategory}",
            nonPayingCategory: "${nonPayingCategory}",
            specialScheme: "${specialScheme}",
            payingCategoryMap: _payingCategoryMap,
            nonPayingCategoryMap: _nonPayingCategoryMap,
            specialSchemeMap: _specialSchemeMap,
            universities: "${universities}"
        }
        jq("#modesummary").blur(function () {
            var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
            if (select1 === 2 && select2 === 1) {
                jq('input[name="person.attribute.34"]').val(jq("#modesummary").val());
            } else if (select1 === 3 && select2 === 1) {
                jq('input[name="person.attribute.42"]').val(jq("#modesummary").val());
            } else if (select1 === 3 && select2 === 2) {
                jq('input[name="person.attribute.32"]').val(jq("#modesummary").val());
            }
        });
        jq('input:text[id]').focus(function (event) {
            var checkboxID = jq(event.target).attr('id');
            jq('#' + checkboxID).removeClass("red-border");
        });
        jq('select').focus(function (event) {
            var checkboxID = jq(event.target).attr('id');
            jq('#' + checkboxID).removeClass("red-border");
        });
        jq('input:text[id]').focusout(function (event) {
            var arr = ["surName", "firstName", "birthdate", "patientRelativeName", "patientPostalAddress", "otherNationalityId", ""];
            var idd = jq(event.target).attr('id');
            if (jq.inArray(idd, arr) !== -1) {
                if (jq('#' + idd).val().trim() === "") {
                    jq('#' + idd).addClass("red-border");
                }
                else {
                    jq('#' + idd).removeClass("red-border");
                }
            }
        });
        jq('input:text[id]').focusout(function (event) {
            var arr = ["firstName", "", "", "", "", ""];
            var idd = jq(event.target).attr('id');
            if (jq.inArray(idd, arr) !== -1) {
                if (idd === 'firstName') {
                    jq('#summ_idnt').text(jq('#patientIdnts').val());
                    jq('#summ_name').text(jq('#surName').val() + ', ' + jq('#firstName').val());
                }
            }
        });
        jq('select').focusout(function (event) {
            var arr = ["patientGender", "paymode1", "legal1", "refer1", "rooms1", "relationshipType", "modetype1", "value4"];
            var idd = jq(event.target).attr('id');
            if (jq.inArray(idd, arr) != -1) {
                if (jq('#' + idd).val() == 0 || jq('#' + idd).val().trim() == "") {
                    jq('#' + idd).addClass("red-border");
                }
                else {
                    jq('#' + idd).removeClass("red-border");
                }
                if (idd == 'patientGender') {
                    jq('#summ_gend').text(jq('#patientGender option:selected').text());
                }
            }
        });
        jq(function () {
            jq("#tabs").tabs().addClass("ui-tabs-vertical ui-helper-clearfix");
            jq("#tabs li").removeClass("ui-corner-top").addClass("ui-corner-left");
        });
        jq('#birthdate').datepicker({
            yearRange: 'c-100:c',
            maxDate: '0',
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            constrainInput: false
        }).on("change", function (dateText) {
            jq("#birthdate").val(this.value);
            PAGE.checkBirthDate();
        });
        var county_array = String(MODEL.districts).substring(0, String(MODEL.districts).length).split(',');
        var county_strng = ",Select County|";
        for (var i = 0; i < county_array.length; i++) {
            county_strng += county_array[i] + ',' + county_array[i] + '|'
        }
        MODEL.religions = ", |"
            + MODEL.religions;
        PAGE.fillOptions("#patientReligion", {
            data: MODEL.religions,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.districts = county_strng;
        PAGE.fillOptions("#districts", {
            data: MODEL.districts,
            delimiter: ",",
            optionDelimiter: "|"
        });
        PAGE.fillOptions("#referredCounty", {
            data: MODEL.districts,
            delimiter: ",",
            optionDelimiter: "|"
        });
        jq("#districts").change();
        selectedDistrict = jq("#districts option:checked").val();
        selectedUpazila = jq("#upazilas option:checked").val();

        PAGE.fillOptions("#payingCategory", {
            data: ", |" + MODEL.payingCategory,
            delimiter: ",",
            optionDelimiter: "|"
        });
        PAGE.fillOptions("#nonPayingCategory", {
            data: ", |" + MODEL.nonPayingCategory,
            delimiter: ",",
            optionDelimiter: "|"
        });
        PAGE.fillOptions("#specialScheme", {
            data: ", |" + MODEL.specialScheme,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.universities = ", |"
            + MODEL.universities;
        PAGE.fillOptions("#university", {
            data: MODEL.universities,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.TRIAGE = ",Select Type|"
            + MODEL.TRIAGE;
        PAGE.fillOptions("#triage", {
            data: MODEL.TRIAGE,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.OPDs = ",Select Type|"
            + MODEL.OPDs;
        PAGE.fillOptions("#opdWard", {
            data: MODEL.OPDs,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.SPECIALCLINIC = ",Select Type|"
            + MODEL.SPECIALCLINIC;
        PAGE.fillOptions("#specialClinic", {
            data: MODEL.SPECIALCLINIC,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.TEMPORARYCAT = ",Select Case|"
            + MODEL.TEMPORARYCAT;
        PAGE.fillOptions("#mlc", {
            data: MODEL.TEMPORARYCAT,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.referredFrom = ",Select Facility|"
            + MODEL.referredFrom;
        PAGE.fillOptions("#referredFrom", {
            data: MODEL.referredFrom,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.referralType = ",Select Type|"
            + MODEL.referralType;
        PAGE.fillOptions("#referralType	", {
            data: MODEL.referralType,
            delimiter: ",",
            optionDelimiter: "|"
        });
        /* jq("#searchbox").showPatientSearchBox(
         {
         searchBoxView: hospitalName + "/registration",
         resultView: "/module/registration/patientsearch/"
         + hospitalName + "/findCreate",
         success: function (data) {
         PAGE.searchPatientSuccess(data);
         },
         beforeNewSearch: PAGE.searchPatientBefore
         });*/
        jq('#payingCategory option').eq(0).prop('selected', true);
        jq('#university option').eq(0).prop('selected', true);
        jq("#nhifNumberRow").hide();
        jq("#universityRow").hide();
        jq("#studentIdRow").hide();
        jq("#waiverNumberRow").hide();
        //LoadLegalCases();
        //LoadReferralCases();
        //showOtherNationality();
        LoadPayCatg();
        LoadRoomsTypes();
        //stans
        jq("#otherNationality").hide();
        jq("#referredFromColumn").hide();
        jq("#referralTypeRow").hide();
        jq("#referralDescriptionRow").hide();
        jq("#triageField").hide();
        jq("#opdWardField").hide();
        jq("#specialClinicField").hide();
        jq("#fileNumberField").hide();
        // binding
        jq("#paying").click(function () {
            VALIDATORS.payingCheck();
        });
        jq("#nonPaying").click(function () {
            VALIDATORS.nonPayingCheck();
        });
        jq("#specialSchemes").click(function () {
            VALIDATORS.specialSchemeCheck();
        });
        jq("#mlcCaseYes").click(function () {
            VALIDATORS.mlcYesCheck();
        });
        jq("#mlcCaseNo").click(function () {
            VALIDATORS.mlcNoCheck();
        });
        jq("#referredYes").click(function () {
            VALIDATORS.referredYesCheck();
        });
        jq("#referredNo").click(function () {
            VALIDATORS.referredNoCheck();
        });
        jq("#triageRoom").click(function () {
            VALIDATORS.triageRoomCheck();
        });
        jq("#opdRoom").click(function () {
            VALIDATORS.opdRoomCheck();
        });
        jq("#specialClinicRoom").click(function () {
            VALIDATORS.specialClinicRoomCheck();
        });
        jq("#sameAddress").click(function () {
            VALIDATORS.copyaddress();
        });
        jq('input[name=paym_1][value="1"]').attr('checked', 'checked').change();
        jq('input[name=paym_1][value="1"]').attr('checked', false);
        jq('input[name=paym_2][value="1"]').attr('checked', false);
        jq('#university option').eq(0).prop('selected', true);
        jq("#addNextOfKin").on("click", function () {
            var c = Math.floor(1000 + Math.random() * 9000);
            //add input for new
            var row = '<div class="onerow"><div class="col4"><field><input type="text" ' +
                ' name="person.attribute.8" class="required form-textbox1 focused" id="patientRelativeName_' + c + '"/></field></div><div class="col4"> ' +
                '<span class="select-arrow" style="width: 100%"> <field> <select name="person.attribute.15" id="relationshipType_' + c + '"' +
                'class="required form-combo1 focused"> <option value=""></option> ' +
                '<option value="Father">Father</option> ' +
                '<option value="Mother">Mother</option> ' +
                '<option value="Spouse">Spouse</option> ' +
                '<option value="Guardian">Guardian</option> ' +
                '<option value="Friend">Friend</option> ' +
                '<option value="Other">Other</option> ' +
                '</select> </field> </span> </div> ' +
                '<div class="col4 last"> <field> ' +
                '<input type="text" id="patientTelephone" name="person.attribute.29" id="patientTelephone_' + c + '"' +
                'class="form-textbox1"/> </field> ' +
                '</div> </div>';
            jq("#nextOfKinDiv").append(row);
        });
    }); //end of doc ready
    /**
     ** FORM
     **/
    PAGE = {
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
        /** SUBMIT */
        submit: function () {
            // Validate and submit
            if (this.validateRegisterForm()) {
                print();
                jq("#patientRegistrationForm").submit();
            }
        },
        checkNationalID: function () {
            nationalId = jq("#patientNationalId").val();
            jq.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "main") }',
                dataType: "json",
                data: ({
                    nationalId: nationalId
                }),
                success: function (data) {
//                    jq("#divForNationalId").html(data);
                    validateNationalID(data);
                }
            });
        },
        checkPassportNumber: function () {
            passportNumber = jq("#passportNumber").val();
            jq.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "main") }',
                dataType: "json",
                data: ({
                    passportNumber: passportNumber
                }),
                success: function (data) {
//                    jq("#divForpassportNumber").html(data);
                    validatePassportNumber(data);
                }
            });
        },
        /** VALIDATE BIRTHDATE */
        checkBirthDate: function () {
            var submitted = jq("#birthdate").val();
            jq.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "processPatientBirthDate") }',
                dataType: "json",
                data: ({
                    birthdate: submitted
                }),
                success: function (data) {
                    if (data.datemodel.error == undefined) {
                        if (data.datemodel.estimated) {
                            jq("#estimatedAge").html(data.datemodel.age + '<span> (Estimated)</span>');
                            jq("#birthdateEstimated").val("true")
                        } else {
                            jq("#estimatedAge").html(data.datemodel.age);
                            jq("#birthdateEstimated").val("false");
                        }
                        jq("#summ_ages").html(data.datemodel.age);
                        jq("#estimatedAgeInYear").val(data.datemodel.ageInYear);
                        jq("#birthdate").val(data.datemodel.birthdate);
                        jq("#calendar").val(data.datemodel.birthdate);
                    } else {
                        jq().toastmessage('showErrorToast', 'Age in wrong format');
                        jq("#birthdate").val("");
                        goto_previous_tab(5);
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(thrownError);
                }
            });
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
            jq(divId).empty();
            if (option.delimiter == undefined) {
                if (option.index == undefined) {
                    jq.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jq(divId).append(
                                "<option value='" + value + "'>" + value
                                + "</option>");
                        }
                    });
                } else {
                    jq.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jq(divId).append(
                                "<option value='" + option.index[index] + "'>"
                                + value + "</option>");
                        }
                    });
                }
            } else {
                options = option.data.split(option.optionDelimiter);
                jq.each(options, function (index, value) {
                    values = value.split(option.delimiter);
                    optionValue = values[0];
                    optionLabel = values[1];
                    if (optionLabel != undefined) {
                        if (optionLabel.length > 0) {
                            jq(divId).append(
                                "<option value='" + optionValue + "'>"
                                + optionLabel + "</option>");
                        }
                    }
                });
            }
        },
        /** CHANGE DISTRICT */
        changeDistrict: function () {
            // get the list of upazilas
            upazilaList = "";
            selectedDistrict = jq("#districts option:checked").val();
            if (selectedDistrict === "") {
                jq('#upazilas').empty().append(jq("<option></option>").attr("value", '').text('Select Sub-County'));
                jq('#locations').empty().append(jq("<option></option>").attr("value", '').text('Select Ward'));
                return false
            }
            jq.each(MODEL.counties, function (index, value) {
                if (value == selectedDistrict) {
                    upazilaList = MODEL.upazilas[index];
                }
            });
        },

        /** SHOW OR HIDE REFERRAL INFO */
        toogleReferralInfo: function (obj) {
            checkbox = jq(obj);
            if (checkbox.is(":checked")) {
                jq("#referralDiv").show();
            } else {
                jq("#referralDiv").hide();
            }
        },
        /** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
        searchPatientSuccess: function (data) {
            jq("#numberOfFoundPatients")
                .html(
                    "Similar Patients: "
                    + data.totalRow
                    + "(<a href='javascript:PAGE.togglePatientResult();'>Show/Hide</a>)");
        },
        /** CALLBACK WHEN BEFORE SEARCHING PATIENT */
        searchPatientBefore: function (data) {
            jq("#numberOfFoundPatients")
                .html(
                    "<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
            jq("#patientSearchResult").hide();
        },
        /** TOGGLE PATIENT RESULT */
        togglePatientResult: function () {
            jq("#patientSearchResult").toggle();
        },
        /** VALIDATE FORM */
        validateRegisterForm: function () {
            var i = 0;
            var tab1 = 0;
            var tab2 = 0;
            var tab3 = 0;
            var tab4 = 0;
            var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
            var str1 = '';

            //TAB3
            if (!jq("input[name='paym_1']:checked").val() || !jq("input[name='paym_2']:checked").val()) {
                str1 = str1 + "Kindly ensure the Payment Categories are properly filled. ";
                i++;
                tab3++;
            }

            if (jq("#rooms1").val() === "") {
                jq('#rooms1').addClass("red-border");
                i++;
                tab3++;
            }
            else {
                jq('#rooms1').removeClass("red-border");
            }
            if (jq("#rooms2").val() === 0 || jq("#rooms2").val() === "" || jq("#rooms2").val() == null) {
                jq('#rooms2').addClass("red-border");
                i++;
                tab3++;
            }
            else {
                jq('#rooms2').removeClass("red-border");
            }
            if (jq("#rooms1").val() === 3 && jq("#rooms3").val().trim() === "") {
                jq('#rooms3').addClass("red-border");
                i++;
                tab3++;
            }
            else {
                jq('#rooms3').removeClass("red-border");
            }

            if (i === 0) {
                return true;
            }
            else {
                var str0 = "<div id='form-verification-x' onclick='verification_close();'>&#215;</div><p>Please fill in correctly the fields marked with * and highlighted in red. Also ensure that date fields have been entered in specified format</p>"
                if (str1 != "") {
                    str0 = str0 + '<p><span style="color:#f00;"><i class="icon-quote-left" style="font-size: 18px">&nbsp;</i>Also Note: </span>' + str1 + '</p>'
                }
                jq('#form-verification-failed').html(str0);
                jq('#form-verification-failed').show();
                jq('html, body').animate({scrollTop: 100}, 'slow');
                return false;
            }
        }
    };
    /**
     ** VALIDATORS
     **/
    VALIDATORS = {
        /** CHECK WHEN PAYING CATEGORY IS SELECTED */
        payingCheck: function () {
            if (jq("#paying").is(':checked')) {
                jq("#nonPaying").removeAttr("checked");
                jq("#nonPayingCategory").val("");
                jq("#specialScheme").val("");
                jq("#specialSchemes").removeAttr("checked");
                jq("#nhifNumberRow").hide();
                jq("#universityRow").hide();
                jq("#studentIdRow").hide();
                jq("#waiverNumberRow").hide();
            }
            else {
            }
        },
        /** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
        nonPayingCheck: function () {
            if (jq("#nonPaying").is(':checked')) {
                jq("#paying").removeAttr("checked");
                jq("#specialSchemes").removeAttr("checked");
                jq("#payingCategory").val("");
                jq("#specialScheme").val("");
                //jq("#selectedRegFeeValue").val(0);
                var selectedNonPayingCategory = jq("#nonPayingCategory option:checked").val();
                if (selectedNonPayingCategory === "NHIF CIVIL SERVANT") {
                    jq("#nhifNumberRow").show();
                }
                else {
                    jq("#nhifNumberRow").hide();
                }
                jq("#universityRow").hide();
                jq("#studentIdRow").hide();
                jq("#waiverNumberRow").hide();
            }
            else {
                jq("#nhifNumberRow").hide();
            }
        },
        /** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
        specialSchemeCheck: function () {
            if (jq("#specialSchemes").is(':checked')) {
                jq("#paying").removeAttr("checked");
                jq("#payingCategory").val("");
                jq("#nonPayingCategory").val("");
                jq("#nonPaying").removeAttr("checked");
                jq("#nhifNumberRow").hide();
                var selectedSpecialScheme = jq("#specialScheme option:checked").val();
                if (selectedSpecialScheme === "STUDENT SCHEME") {
                    jq("#universityRow").show();
                    jq("#studentIdRow").show();
                }
                else {
                    jq("#universityRow").hide();
                    jq("#studentIdRow").hide();
                }
                if (selectedSpecialScheme === "WAIVER CASE") {
                    jq("#waiverNumberRow").show();
                }
                else {
                    jq("#waiverNumberRow").hide();
                }
            }
            else {
                jq("#universityRow").hide();
                jq("#studentIdRow").hide();
                jq("#waiverNumberRow").hide();
            }
        },
        triageRoomCheck: function () {
            if (jq("#triageRoom").is(':checked')) {
                jq("#opdRoom").removeAttr("checked");
                jq("#specialClinicRoom").removeAttr("checked");
                jq("#triageField").show();
                jq("#opdWard").val("");
                jq("#opdWardField").hide();
                jq("#specialClinic").val("");
                jq("#specialClinicField").hide();
                jq("#fileNumberField").hide();
            }
            else {
                jq("#triageField").hide();
            }
        },
        opdRoomCheck: function () {
            if (jq("#opdRoom").is(':checked')) {
                jq("#triageRoom").removeAttr("checked");
                jq("#specialClinicRoom").removeAttr("checked");
                jq("#triage").val("");
                jq("#triageField").hide();
                jq("#opdWardField").show();
                jq("#specialClinic").val("");
                jq("#specialClinicField").hide();
                jq("#fileNumberField").hide();
            }
            else {
                jq("#opdWardField").hide();
            }
        },
        specialClinicRoomCheck: function () {
            if (jq("#specialClinicRoom").is(':checked')) {
                jq("#triageRoom").removeAttr("checked");
                jq("#opdRoom").removeAttr("checked");
                jq("#triage").val("");
                jq("#triageField").hide();
                jq("#opdWard").val("");
                jq("#opdWardField").hide();
                jq("#specialClinicField").show();
                jq("#fileNumberField").show();
            }
            else {
                jq("#specialClinicField").hide();
                jq("#fileNumberField").hide();
            }
        }
    };

    function payingCategorySelection() {
        var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
        var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
        var select3 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').data('name');
        var selectedPayingCategory = jq("#payingCategory option:checked").val();
        var estAge = jq("#estimatedAgeInYear").val();
        if (select1 == 1 && select3 == 'CHILD UNDER 5YRS') {
            if (estAge < 6) {
                jq("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            } else {
                jq().toastmessage('showErrorToast', 'Selected Scheme should be for child at 5 years and below');
                jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                return false;
            }
        }
        else {
            if (select1 == 1 && select3 == 'EXPECTANT MOTHER') {
                if (jq("#patientGender").val() == "M") {
                    jq().toastmessage('showErrorToast', 'This category is only valid for female');
                    jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                    return false;
                }
            }
            if (select1 == 3) {
                var initialRegFee = parseInt('${initialRegFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = initialRegFee + specialClinicRegFee;
                jq("#selectedRegFeeValue").val(totalRegFee);
            }
            else {
                jq("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
        if (select1 == 1) {
            jq('#payingCategory option').eq(select2).prop('selected', true);
            jq('#nonPayingCategory option').eq(0).prop('selected', true);
            jq('#specialScheme option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Paying / ' + jq('#payingCategory option:selected').text());
        }
        else if (select1 == 2) {
            jq('#nonPayingCategory option').eq(select2).prop('selected', true);
            jq('#payingCategory option').eq(0).prop('selected', true);
            jq('#specialScheme option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Non-Paying / ' + jq('#nonPayingCategory option:selected').text());
        }
        else {
            jq('#specialScheme option').eq(select2).prop('selected', true);
            jq('#payingCategory option').eq(0).prop('selected', true);
            jq('#nonPayingCategory option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Special Scheme / ' + jq('#specialScheme option:selected').text());
        }
    }
    function nonPayingCategorySelection() {
        var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
        var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
        var select3 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').data('name');
        var estAge = jq("#estimatedAgeInYear").val();
        if (select3 == 'CHILD UNDER 5YRS') {
            if (estAge < 6) {
                jq("#selectedRegFeeValue").val(0);
            } else {
                jq().toastmessage('showErrorToast', 'Selected Scheme should be for child at 5 years and below');
                jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                return false;
            }
        }
        else {
            if (select3 == 'EXPECTANT MOTHER') {
                if (jq("#patientGender").val() == "M") {
                    jq().toastmessage('showErrorToast', 'This category is only valid for Females');
                    jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                    return false;
                }
            }
        }
        var selectedRoomToVisit = jq("#rooms1").val();
        var nonPayingCategorySelected = jq("#nonPayingCategory").val();
        var selectedNonPayingCategory = jq("#nonPayingCategory option:checked").val();
        //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
        if (selectedNonPayingCategory == "NHIF CIVIL SERVANT") {
            jq("#nhifNumberRow").show();
        }
        else {
            jq("#nhifNumberRow").hide();
        }
        if (selectedRoomToVisit === "3") {
            if (nonPayingCategorySelected === "CCC PATIENT" || nonPayingCategorySelected === "TB PATIENT") {
                jq("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
        } else if (nonPayingCategorySelected === "CCC PATIENT" || nonPayingCategorySelected === "TB PATIENT") {
            jq("#selectedRegFeeValue").val(${initialRegFee});
        } else {
            jq("#selectedRegFeeValue").val(0);
        }
    }
    function specialSchemeSelection() {
        var selectedSpecialScheme = jq("#specialScheme option:checked").val();
        var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
        var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
        var select3 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').data('name');
        var estAge = jq("#estimatedAgeInYear").val();
        if (select3 == 'CHILD UNDER 5YRS') {
            if (estAge < 6) {
                jq("#selectedRegFeeValue").val(0);
            } else {
                jq().toastmessage('showErrorToast', 'Selected Scheme should be for child at 5 years and below');
                jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                return false;
            }
        }
        else {
            if (select3 == 'EXPECTANT MOTHER') {
                if (jq("#patientGender").val() == "M") {
                    jq().toastmessage('showErrorToast', 'This category is only valid for Females');
                    jq('input[name=paym_2][value="1"]').attr('checked', 'checked').change();
                    return false;
                }
            }
        }
        if (selectedSpecialScheme == "DELIVERY CASE") {
            if (jq("#patientGender").val() == "M") {
                alert("This category is only valid for female");
            }
        }
        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
        if (selectedSpecialScheme == "STUDENT SCHEME") {
            jq("#universityRow").show();
            jq("#studentIdRow").show();
        }
        else {
            jq("#universityRow").hide();
            jq("#studentIdRow").hide();
        }
        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
        if (selectedSpecialScheme == "WAIVER CASE") {
            jq("#waiverNumberRow").show();
        }
        else {
            jq("#waiverNumberRow").hide();
        }
        jq("#selectedRegFeeValue").val(0);
    }
    function triageRoomSelectionFor() {
        if (jq("#payingCategory").val() != " ") {
            var selectedPayingCategory = jq("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jq("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                jq("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
        else if (jq("#nonPayingCategory").val() != " ") {
            jq("#selectedRegFeeValue").val(0);
        }
        else if (jq("#specialScheme").val() != " ") {
            jq("#selectedRegFeeValue").val(0);
        }
    }
    function opdRoomSelectionForReg() {
        if (jq("#payingCategory").val() != " ") {
            var selectedPayingCategory = jq("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jq("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                jq("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
        else if (jq("#nonPayingCategory").val() != " ") {
            jq("#selectedRegFeeValue").val(0);
        }
        else if (jq("#specialScheme").val() != " ") {
            jq("#selectedRegFeeValue").val(0);
        }
    }
    function specialClinicSelectionForReg() {
        if (jq("#payingCategory").val() != " ") {
            var selectedPayingCategory = jq("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jq("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                var initialRegFee = parseInt('${initialRegFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = initialRegFee + specialClinicRegFee;
                jq("#selectedRegFeeValue").val(totalRegFee);
            }
        }
        else if (jq("#nonPayingCategory").val() != " ") {
            var selectedNonPayingCategory = jq("#nonPayingCategory option:checked").val();
            if (selectedNonPayingCategory == "TB PATIENT" || selectedNonPayingCategory == "CCC PATIENT") {
                jq("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
            else {
                jq("#selectedRegFeeValue").val(0);
            }
        }
        else if (jq("#specialScheme").val() != " ") {
            jq("#selectedRegFeeValue").val(0);
        }
    }
    function LoadPayCatg() {
    }
    function LoadPayCatgMode() {
        var select1 = jq('input[name=paym_1]:checked', '#patientRegistrationForm').val();
        var select2 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').val();
        var select3 = jq('input[name=paym_2]:checked', '#patientRegistrationForm').data('name');
        if (typeof select2 == 'undefined' || typeof select3 == 'undefined'){
            return false;
        }
        if (select3.includes("NHIF") ||  select3.includes("CIVIL SERVANT")) {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("");
            jq('#universitydiv').hide();
            jq('#university option').eq(0).prop('selected', true);
            jq('#summtitle1').text('NHIF Summary');
            jq('#modesummary').attr("placeholder", "NHIF Number");
        }
        else if (select3.includes("STUDENT SCHEME")) {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("");
            jq('#universitydiv').show();
            jq('#university option').eq(1).prop('selected', true);
            jq('#summtitle1').text('Student Summary');
            jq('#modesummary').attr("placeholder", "Student Number");
        }
        else if (select3.includes("WAIVER CASE")) {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("");
            jq('#universitydiv').hide();
            jq('#university option').eq(0).prop('selected', true);
            jq('#summtitle1').text('Waiver Summary');
            jq('#modesummary').attr("placeholder", "Waiver Number");
        }
        else {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("N/A");
            jq('#universitydiv').hide();
            jq('#university option').eq(0).prop('selected', true);
            jq('#summtitle1').text('Details');
            jq('#modesummary').attr("placeholder", "Enter Value");
        }
        if (select1 == 1) {
            jq('#payingCategory option').eq(select2).prop('selected', true);
            jq('#nonPayingCategory option').eq(0).prop('selected', true);
            jq('#specialScheme option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Paying / ' + jq('#payingCategory option:selected').text());
        }
        else if (select1 == 2) {
            jq('#nonPayingCategory option').eq(select2).prop('selected', true);
            jq('#payingCategory option').eq(0).prop('selected', true);
            jq('#specialScheme option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Non-Paying / ' + jq('#nonPayingCategory option:selected').text());
        }
        else {
            jq('#specialScheme option').eq(select2).prop('selected', true);
            jq('#payingCategory option').eq(0).prop('selected', true);
            jq('#nonPayingCategory option').eq(0).prop('selected', true);
            jq('#summ_pays').text('Special Scheme / ' + jq('#specialScheme option:selected').text());
        }
        payingCategorySelection();
        jq('#summ_fees').text(jq('#selectedRegFeeValue').val() + '.00');
    }
    function LoadPaymodes() {
        jq('#modetype1').empty();
        if (jq("#paymode1").val() == 1) {
            var myOptions = {1: 'GENERAL', 2: 'CHILD UNDER 5YRS', 3: 'EXPECTANT MOTHER'};
            var mySelect = jq('#modetype1');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
        }
        else if (jq("#paymode1").val() == 2) {
            var myOptions = {4: 'PULSE', 5: 'CCC PATIENT', 6: 'TB PATIENT'};
            var mySelect = jq('#modetype1');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
        }
        else if (jq("#paymode1").val() == 3) {
            var myOptions = {7: 'BLOOD OXYGEN SATURATION', 8: 'WAIVER CASE', 9: 'DELIVERY CASE'};
            var mySelect = jq('#modetype1');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
        }
        else {
            var myOptions = {0: ''};
            var mySelect = jq('#modetype1');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
        }
        LoadModeChange();
    }
    function LoadModeChange() {
        if (jq("#modetype1").val() == 8) {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("");
            jq('#forpaymode1').text('Waiver Number');
        }
        else {
            jq("#modesummary").attr("readonly", false);
            jq("#modesummary").val("N/A");
            jq('#forpaymode1').text('Summary');
        }
    }
    function LoadLegalCases() {
        jq('#mlc').empty();
        if (jq("#legal1").val() == 1) {
            PAGE.fillOptions("#mlc", {
                data: MODEL.TEMPORARYCAT,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#mlcCaseYes").attr('checked', 'checked');
            jq("#mlcCaseNo").attr('checked', false);
            jq('#formlc span').text('*');
        }
        else if (jq("#legal1").val() == 2) {
            var myOptions = {" ": 'N/A'};
            var mySelect = jq('#mlc');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            jq("#mlcCaseYes").attr('checked', false);
            jq("#mlcCaseNo").attr('checked', 'checked');
            jq('#formlc span').text('');
        }
        else {
            var myOptions = {" ": 'N/A'};
            var mySelect = jq('#mlc');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            jq("#mlcCaseYes").attr('checked', false);
            jq("#mlcCaseNo").attr('checked', false);
            jq('#formlc span').text('');
        }
    }
    function LoadReferralCases() {
        jq('#referredFrom').empty();
        jq('#referralType').empty();
        if (jq("#refer1").val() == 1) {
            PAGE.fillOptions("#referredFrom", {
                data: MODEL.referredFrom,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#referralDescription").attr("readonly", false);
            jq("#referralDescription").val("");
            PAGE.fillOptions("#referralType", {
                data: MODEL.referralType,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#referredYes").attr('checked', 'checked');
            jq("#referredNo").attr('checked', false);
            jq(".referraldiv").show();
            jq('#forReferralType span').text('*');
            jq('#forReferredFrom span').text('*');
            jq('#referralDescription').removeClass("disabled");
        }
        else if (jq("#refer1").val() == 2) {
            var myOptions = {" ": 'N/A'};
            var mySelect = jq('#referredFrom');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            mySelect = jq('#referralType');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            jq("#referralDescription").attr("readonly", true);
            jq("#referralDescription").val("N/A");
            jq(".referraldiv").hide();
            jq('#forReferralType span').text('');
            jq('#forReferredFrom span').text('');
            jq("#referredNo").attr('checked', 'checked');
            jq("#referredYes").attr('checked', false);
            jq('#referralDescription').addClass("disabled");
        }
        else {
            var myOptions = {" ": 'N/A'};
            var mySelect = jq('#referredFrom');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            mySelect = jq('#referralType');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            jq("#referralDescription").attr("readonly", true);
            jq("#referralDescription").val("N/A");
            jq(".referraldiv").hide();
            jq("#referredNo").attr('checked', false);
            jq("#referredYes").attr('checked', false);
            jq('#referralDescription').addClass("disabled");
        }
    }
    function LoadRoomsTypes() {
        nonPayingCategorySelection();
        jq('#rooms2').empty();
        if (jq("#rooms1").val() == 1) {
            PAGE.fillOptions("#rooms2", {
                data: MODEL.TRIAGE,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#rooms3").attr("readonly", true);
            jq("#rooms3").val("N/A");
            jq('#froom2').html('Triage Rooms<span>*</span>');
            jq("#triageRoom").attr('checked', 'checked');
            jq("#opdRoom").attr('checked', false);
            jq("#specialClinicRoom").attr('checked', false);
            jq('#referralDescription').removeClass("required");
            jq('#rooms3').hide();
            jq('#froom3').hide();
        }
        else if (jq("#rooms1").val() == 2) {
            PAGE.fillOptions("#rooms2", {
                data: MODEL.OPDs,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#rooms3").attr("readonly", true);
            jq("#rooms3").val("N/A");
            jq('#froom2').html('OPD Rooms<span>*</span>');
            jq("#triageRoom").attr('checked', false);
            jq("#opdRoom").attr('checked', 'checked');
            jq("#specialClinicRoom").attr('checked', false);
            jq('#referralDescription').removeClass("required");
            jq('#rooms3').hide();
            jq('#froom3').hide();
        }
        else if (jq("#rooms1").val() == 3) {
            PAGE.fillOptions("#rooms2", {
                data: MODEL.SPECIALCLINIC,
                delimiter: ",",
                optionDelimiter: "|"
            });
            jq("#rooms3").attr("readonly", false);
            jq("#rooms3").val("");
            jq('#froom2').html('Special Clinic<span>*</span>');
            jq("#triageRoom").attr('checked', false);
            jq("#opdRoom").attr('checked', false);
            jq("#specialClinicRoom").attr('checked', 'checked');
            jq('#referralDescription').addClass("required");
            jq('#rooms3').show();
            jq('#froom3').show();
        }
        else {
            var myOptions = {0: 'N/A'};
            var mySelect = jq('#rooms2');
            jq.each(myOptions, function (val, text) {
                mySelect.append(
                    jq('<option></option>').val(val).html(text)
                );
            });
            jq("#rooms3").attr("readonly", true);
            jq("#rooms3").val("N/A");
            jq("#triageRoom").attr('checked', false);
            jq("#opdRoom").attr('checked', false);
            jq("#specialClinicRoom").attr('checked', false);
            jq('#referralDescription').removeClass("required");
            jq('#rooms3').hide();
            jq('#froom3').hide();
        }
    }
    function verification_close() {
        jq('#form-verification-failed').hide();
    }
    ;
    function goto_next_tab(current_tab) {
        if (current_tab == 1) {
            var currents = '';
            while (jq(':focus') != jq('#patientPhoneNumber')) {
                if (currents == jq(':focus').attr('id')) {
                    NavigatorController.stepForward();
                    jq("#ui-datepicker-div").hide();
                    break;
                }
                else {
                    currents = jq(':focus').attr('id');
                }
                if (jq(':focus').attr('id') == 'patientPhoneNumber') {
                    jq("#ui-datepicker-div").hide();
                    break;
                }
                else {
                    NavigatorController.stepForward();
                }
            }
            // jq(':focus')
            //NavigatorController.getFieldById('passportNumber').select();
        }
        else if (current_tab == 2) {
            var currents = '';
            while (jq(':focus') != jq('#modesummary')) {
                if (currents == jq(':focus').attr('id')) {
                    NavigatorController.stepForward();
                    break;
                }
                else {
                    currents = jq(':focus').attr('id');
                }
                if (jq(':focus').attr('id') == 'modesummary') {
                    break;
                }
                else {
                    NavigatorController.stepForward();
                }
            }
        }
    }
    function goto_previous_tab(current_tab) {
        if (current_tab == 2) {
            while (jq(':focus') != jq('#passportNumber')) {
                if (jq(':focus').attr('id') == 'passportNumber' || jq(':focus').attr('id') == 'otherNationalityId') {
                    jq("#ui-datepicker-div").hide();
                    break;
                }
                else {
                    NavigatorController.stepBackward();
                }
            }
        }
        else if (current_tab == 3) {
            while (jq(':focus') != jq('#relativePostalAddress')) {
                if (jq(':focus').attr('id') == 'relativePostalAddress') {
                    jq("#ui-datepicker-div").hide();
                    break;
                }
                else {
                    NavigatorController.stepBackward();
                }
            }
        }
        else if (current_tab == 4) {
            jq('#rooms3').focus();
        }
        else if (current_tab == 5) {
            var loops = 0;
            while (jq(':focus') != jq('#maritalStatus')) {
                if (jq(':focus').attr('id') == 'birthdate') {
                    jq("#ui-datepicker-div").hide();
                    break;
                }
                else {
                    if (loops == 10){
                        //Detect the Loop and Prevent it from Happening
                        jq('#birthdate').focus();
                        break;
                    }
                    NavigatorController.stepBackward();
                    loops++;
                }
            }
        }
    }
</script>
<style>
.ui-tabs-vertical {
    width: 55em;
}

.ui-tabs-vertical .ui-tabs-nav {
    padding: .2em .1em .2em .2em;
    float: left;
    width: 12em;
}

.ui-tabs-vertical .ui-tabs-nav li {
    clear: left;
    width: 100%;
    border-bottom-width: 1px !important;
    border-right-width: 0 !important;
    margin: 0 -1px .2em 0;
}

.ui-tabs-vertical .ui-tabs-nav li a {
    display: block;
}

.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active {
    padding-bottom: 0;
    padding-right: .1em;
    border-right-width: 1px;
}

.ui-tabs-vertical .ui-tabs-panel {
    padding: 1em;
    float: right;
    width: 45em;
}

.red-border {
    border: 1px solid #f00 !important;
}

.myh2,
.tasks-list {
    margin: 0;
    padding: 0;
    border: 0;
    font-size: 100%;
    font: inherit;
    vertical-align: baseline;
}

.tasks {
    font: 13px/20px 'Lucida Grande', Verdana, sans-serif;
    color: #404040;
    width: 100%;
    background: white;
    border: 1px solid #cdd3d7;
    border-radius: 4px;
    -webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.tasks-header {
    position: relative;
    line-height: 24px;
    padding: 7px 15px;
    color: #5d6b6c;
    text-shadow: 0 1px rgba(255, 255, 255, 0.7);
    background: #f0f1f2;
    border-bottom: 1px solid #d1d1d1;
    border-radius: 3px 3px 0 0;
    background-image: -webkit-linear-gradient(top, #f5f7fd, #e6eaec);
    background-image: -moz-linear-gradient(top, #f5f7fd, #e6eaec);
    background-image: -o-linear-gradient(top, #f5f7fd, #e6eaec);
    background-image: linear-gradient(to bottom, #f5f7fd, #e6eaec);
    -webkit-box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
    box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
}

.tasks-title {
    line-height: inherit;
    font-size: 14px;
    font-weight: bold;
    color: inherit;
}

.tasks-lists {
    position: absolute;
    top: 50%;
    right: 10px;
    margin-top: -11px;
    padding: 10px 4px;
    width: 19px;
    height: 3px;
    font: 0/0 serif;
    text-shadow: none;
    color: transparent;
}

.tasks-lists:before {
    display: block;
    height: 3px;
    background: #8c959d;
    border-radius: 1px;
    -webkit-box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
    box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
}

.tasks-list-item {
    display: block;
    line-height: 24px;
    padding: 5px 10px;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

.tasks-list-item + .tasks-list-item {
    border-top: 1px solid #f0f2f3;
}

.tasks-list-cb {
    display: none;
}

.tasks-list-mark {
    position: relative;
    display: inline-block;
    vertical-align: top;
    margin-right: 0px;
    width: 16px;
    height: 20px;
    border: 2px solid #c4cbd2;
    border-radius: 12px;
}

.tasks-list-mark:before {
    content: '';
    display: none;
    position: absolute;
    top: 50%;
    left: 50%;
    margin: -5px 0 0 -6px;
    height: 4px;
    width: 8px;
    border: solid #39ca74;
    border-width: 0 0 4px 4px;
    -webkit-transform: rotate(-45deg);
    -moz-transform: rotate(-45deg);
    -ms-transform: rotate(-45deg);
    -o-transform: rotate(-45deg);
    transform: rotate(-45deg);
}

.tasks-list-cb:checked ~ .tasks-list-mark {
    border-color: #39ca74;
}

.tasks-list-cb:checked ~ .tasks-list-mark:before {
    display: block;
}

.tasks-list-desc {
    font-weight: bold;
    color: #555;
}

.tasks-list-cb:checked ~ .tasks-list-desc {
    color: #34bf6e;
}

#form-verification-x {
    color: #f00;
    cursor: pointer;
    float: right;
    margin: -10px -22px 0;
}

.form-verifier-js {
    padding: 10px 30px;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    -ms-box-sizing: border-box;
    box-sizing: border-box;
    box-shadow: 0 11px 5px -10px rgba(0, 0, 0, 0.3);
    border: 1px solid #F00;
    margin-bottom: 15px;
    display: none;
}

.form-verifier-js p {
    padding-top: 5px;
    padding-bottom: 0px;
    margin-bottom: 5px;

}

.form-duplicate-js {
    padding: 1px 30px 1px 30px;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    -ms-box-sizing: border-box;
    box-sizing: border-box;
    box-shadow: 0 11px 5px -10px rgba(0, 0, 0, 0.3);
    border: 1px solid #F00;
    margin-bottom: 15px;
}

.form-duplicate-js p {
    padding-top: 5px;
    padding-bottom: 0px;
    margin-bottom: 5px;

}

.dashboard .info-section {
    margin: 0 5px 5px;
}

.dashboard .info-body li {
    padding-bottom: 2px;
}

.dashboard .info-body li span {
    margin-right: 10px;
}

.dashboard .info-body li small {

}

.dashboard .info-body li div {
    width: 150px;
    display: inline-block;
}

.addon {
    color: #f26522;
    display: inline-block;
    float: right;
    margin: 10px 0 0 190px;
    position: absolute;
}
a.tooltip {outline:none; }
a.tooltip strong {line-height:20px;}
a.tooltip:hover {text-decoration:none;}
a.tooltip span {
    z-index:10;
    display:none;
    padding:14px 20px!important;
    margin-left:-205px;
    width:205px;
    line-height:16px;
    position:absolute;
    color:#111;
    border:1px solid #DCA; background:#fffAF0;
}
a.tooltip span em{
    width: 20px;
    float: left;
    font-family: Times New Roman;
    font-style: italic;
}
a.tooltip:hover span{
    display:inline;
}
.callout {
    z-index:20;
    position:absolute;
    top:-12px;
    border:0;
    left:203px;
}
a.tooltip span {
    border-radius:4px;
    box-shadow: 5px 5px 8px #CCC;
}
</style>
<div id="content" class="container">
    <form class="simple-form-ui" id="patientRegistrationForm" method="post">
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
                            <div class="col4">
                                <div class="tasks">
                                    <header class="tasks-header">
                                        <span class="tasks-title">Patients Category</span>
                                        <a class="tasks-lists"></a>
                                    </header>

                                    <div class="tasks-list parent-items">
                                        <label class="tasks-list-item">
                                            <input style="display:none!important" type="radio" name="paym_1" value="1"
                                                   class="tasks-list-cb">
                                            <span class="tasks-list-mark"></span>
                                            <span class="tasks-list-desc">PAYING</span>
                                        </label>

                                        <label class="tasks-list-item">
                                            <input style="display:none!important" type="radio" name="paym_1" value="2"
                                                   class="tasks-list-cb">
                                            <span class="tasks-list-mark"></span>
                                            <span class="tasks-list-desc">NON-PAYING</span>
                                        </label>

                                        <label class="tasks-list-item">
                                            <input style="display:none!important" type="radio" name="paym_1" value="3"
                                                   class="tasks-list-cb">
                                            <span class="tasks-list-mark"></span>
                                            <span class="tasks-list-desc">SPECIAL SCHEMES</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                    </td>
                    <td>

                            <div class="col4">
                                <div class="tasks">
                                    <header class="tasks-header">
                                        <span id="tasktitle" class="tasks-title">Paying Category</span>
                                        <a class="tasks-lists"></a>
                                    </header>

                                    <div class="tasks-list" id="paycatgs">

                                    </div>
                                </div>
                            </div>
                    </td>
                    <td>
                        <div class="col4 last">
                            <div class="tasks">
                                <header class="tasks-header">
                                    <span id="summtitle1" class="tasks-title">Details</span>
                                    <input type="hidden" id="nhifNumber" name="person.attribute.34"/>
                                    <input type="hidden" id="studentId" name="person.attribute.42"/>
                                    <input type="hidden" id="waiverNumber" name="person.attribute.32"/>
                                    <a class="tasks-lists"></a>
                                </header>
                            </div>

                            <span id="universitydiv" class="select-arrow" style="width: 100%">
                                <field><select style="width: 101%;" name="person.attribute.47"
                                               id="university">&nbsp;</select></field>
                            </span>

                            <field><input type="text" id="modesummary" name="modesummary" value="N/A"
                                          placeholder="WAIVER NUMBER" readonly="" style="width: 101%!important"/>
                            </field>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><h2>Visit type</h2></td>
                <td><div>
                    <select id="visitType" name="visitType">
                        <option value="1">New patient</option>
                        <option value="2">Revisit patient</option>
                    </select>
                </div>
                </td>
                </tr>



                <tr><td colspan="2"><h2>Room to Visit</h2></td></tr>
                <tr>

                <div class="onerow" style="margin-top:10px;">
                    <td valign="top">
                        <div class="col4">
                            <label for="rooms1" id="froom1" style="margin:0px;">Room to Visit<span>*</span></label>
                        </div>
                    </td>
                    <td valign="top">
                        <div class="col4">
                            <span class="select-arrow" style="width: 100%">
                                <field>
                                    <select id="rooms1" name="rooms1" onchange="LoadRoomsTypes();"
                                            class="required form-combo1">
                                        <option value="">Select Room</option>
                                        <option value="1">TRIAGE ROOM</option>
                                        <option value="2">OPD ROOM</option>
                                        <option value="3">SPECIAL CLINIC</option>
                                    </select>
                                </field>
                            </span>
                        </div>
                    </td>
                </div>
                </tr>
                <tr>
                    <div class="onerow" style="margin-top:10px;">
                        <td valign="top">
                            <div class="col4">
                                <label for="rooms2" id="froom2" style="margin:0px;">Room Type<span>*</span></label>
                            </div>
                        </td>
                        <td valign="top">
                            <div class="col4">
                                <span class="select-arrow" style="width: 100%">
                                    <field>
                                        <select id="rooms2" name="rooms2" class="required form-combo1">
                                        </select>
                                    </field>
                                </span>
                            </div>
                        </td>
                    </div>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="col4 last">
                            <label for="rooms3" id="froom3" style="margin:0px;">File Number</label>
                        </div>
                    </td>
                    <td valign="top">
                        <div class="col4 last">
                            <field><input type="text" id="rooms3" name="rooms3" value="N/A" placeholder="FILE NUMBER"
                                          readonly=""/></field>
                        </div>
                    </td>
                </tr>
            </table>

                <div class="onerow" style="display:none!important;">
                    <div class="col4">
                        <input id="paying" type="checkbox" name="person.attribute.14" value="Paying"
                               checked/> Paying
                    </div>

                    <div class="col4">
                        <input id="nonPaying" type="checkbox" name="person.attribute.14"
                               value="Non-Paying"/> Non-Paying
                    </div>

                    <div class="col4 last">
                        <input id="specialSchemes" type="checkbox" name="person.attribute.14"
                               value="Special Schemes"/> Special Schemes
                    </div>

                    <label><input type="checkbox" name="mlcCaseYes" id="mlcCaseYes">MLC Yes</label>
                    <label><input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/>MLC No</label>

                    <label><input id="referredYes" type="checkbox" name="referredYes"/>Refer Yes</label>
                    <label><input id="referredNo" type="checkbox" name="referredNo"/>Refer No</label>

                    <input id="triageRoom" type="checkbox" name="triageRoom"/>
                    <input id="opdRoom" type="checkbox" name="opdRoom"/>
                    <input id="specialClinicRoom" type="checkbox" name="specialClinicRoom"/>
                    <input id="birthdateEstimated" type="text" name="patient.birthdateEstimate"/>
                    <input id="chiefdom" class="form-textbox1 focused" type="text" name="person.attribute.41">
                </div>

                <div class="onerow" style="display:none!important;">
                    <div class="col4">&nbsp;
                        <span id="payingCategoryField">
                            <span class="select-arrow" style="width: 100%">
                                <select id="payingCategory" name="person.attribute.44"
                                        onchange="payingCategorySelection();"
                                        class="form-combo1" style="display:block!important"></select></span>
                        </span>

                    </div>

                    <div class="col4">&nbsp;
                        <span id="nonPayingCategoryField">
                            <span class="select-arrow" style="width: 100%">
                                <select id="nonPayingCategory" name="person.attribute.45"
                                        onchange="nonPayingCategorySelection();"
                                        class="form-combo1" style="display:block!important"></select></span>
                        </span>

                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="specialSchemeCategoryField">
                            <span class="select-arrow" style="width: 100%">
                                <select id="specialScheme" name="person.attribute.46"
                                        onchange="specialSchemeSelection();"
                                        class="form-combo1" style="display:block!important"></select>
                            </span>

                        </span>
                    </div>
                </div>


                <div class="onerow" style="margin-top: 100px">

                    <a class="button confirm" onclick="PAGE.submit();"
                       style="float:right; display:inline-block; margin-left: 5px;">
                        <span>FINISH</span>
                    </a>

                    <a class="button cancel" onclick="window.location.href = window.location.href"
                       style="float:right; display:inline-block;"/>
                    <span>RESET</span>
                </a>
                </div>
    </form>
</div>
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
