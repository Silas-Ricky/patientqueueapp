<%
    ui.decorateWith("appui", "standardEmrPage", [title: "OPD Queue"])
	
    ui.includeCss("uicommons", "datatables/dataTables_jui.css")
    ui.includeCss("coreapps", "patientsearch/patientSearchWidget.css")
	ui.includeCss("patientqueueapp", "onepcssgrid.css")
	ui.includeCss("patientqueueapp", "main.css")
	
    ui.includeJavascript("ehrcashier", "moment.js")
    ui.includeJavascript("ehrcashier", "jquery.dataTables.min.js")
    ui.includeJavascript("patientqueueapp", "queue.js")
    ui.includeJavascript("patientqueueapp", "searchInSystem.js")
    ui.includeJavascript("patientqueueapp", "jquery.session.js")
%>
<script type="text/javascript">
    function handlePatientRowSelection() {
        this.handle = function (row) {
            console.log("Row status: " + row.status);
        }
    }
	
	var handlePatientRowSelection =  new handlePatientRowSelection();
	var opdQueueLabel = "OPD PATIENT QUEUE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;";
	var patientInSystemLabel = "PATIENTS IN SYSTEM &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;"


	jq(document).ready(function () {

		toggleQueueSystemTables()

		jq('.in-system').hide();
		jq('#search-in-db').change(function() {
			toggleQueueSystemTables();
			if(this.checked) {
				jq('#advanced').addClass('advancedcolor');
			}
			else {
				jq('#advanced').removeClass('advancedcolor');
				startTimer();
				bindPatientQueueSearchEvent();
				jq("#patient-search-clear-button").click();
			}
		});
		
		jq('#search-in-db').click(function() {
			if (jq(this).is(':checked')) {
				jq('#for-patient-search').text('Find Patient');
			}
			else{
				jq('#for-patient-search').text('Filter Queue');
			}
		});
		
		jq('#queue-choice').bind('change keyup', function() {
			jq.session.set("selected-option-opd", jq('#queue-choice').val());
		});
		
		if (jq.session.get("selected-option-opd")!= ''){
			jq("#queue-choice").val(jq.session.get("selected-option-opd")).change();
		}
	});
	
	jQuery.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag == 'form')
			  return jQuery(':input',this).clearForm();
			if ((type == 'text' || type == 'hidden') && jQuery(this).attr('id') != 'searchPhrase')
			  this.value = '';
			else if (type == 'checkbox' || type == 'radio')
			  this.checked = false;
			else if (tag == 'select')
			  this.selectedIndex = -1;
		});
	};
	
	function HideDashboard() {
        jq('#dashboard').hide(500);
		jq('#dashboard').find('input:text').val('');
		jq('#dashboard').find('select option:first-child').attr("selected", "selected");
    }
    function ShowDashboard() {
		if (jq('#search-in-db').is(':checked')) {
			jq('#dashboard').toggle(500);
			jq('#dashboard').find('input:text').val('');
			jq('#dashboard').find('select option:first-child').attr("selected", "selected");
		}
		else {
			jq().toastmessage('showErrorToast', "Advanced Search can only be used when searching a patient in the System.",true);
			HideDashboard();
		}
    }
</script>

<style>
	.results {
		margin-top: 5px;
	}
	#patients-in-system tbody tr:hover,
	#patient-queue tbody tr:hover {
		background: #007fff;
		cursor: pointer;
		color: white;
	}
	#patient-queue tbody tr td.dataTables_empty:hover {
		background: white;
		cursor: default;
		color: #363463;
	}
	#patient-search-clear-button {
		margin-left: -25px;
		position: relative;
		right: 5px;
	}
	#patient-search-form input {
		display: inline;
		margin-top: 5px;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.new-patient-header .identifiers {
		margin-top: 1px;
	}
	#queue-choice-form{
		display: inline-block;
		width: 300px;
	}
	#patient-search-form {
		display: inline-block;
		width: 630px;
		float: right;
	}
	select:focus,
	input:focus {
		outline: 2px none #000!important;
	}
	form p, .form p {
		margin-bottom: 5px;
	}
	form label, .form label {
		color: #009384;
		display: inline-block;
		padding-left: 5px;
	}
	#patient-search-clear-button {
		cursor: pointer;
	}
	.name {
		color: #f26522;
	}
	#for-search-in-db{
		padding-right: 10px;
		cursor: pointer;
		float: right;
		color: #363463;
	}
	#for-search-in-db input{
		cursor: pointer;
	}
	form .advanced {
		background: #888 none repeat scroll 0 0;
		border-color: #dddddd;
		border-style: solid;
		border-width: 1px;
		color: #fff;
		cursor: pointer;
		float: right;
		padding: 5px 0;
		text-align: center;
		width: 35%;
	}
	.advancedcolor{
		background: #363463 none repeat scroll 0 0!important;
	}
	
	form .advanced i {
		font-size: 22px;
	}
	.from-lab{
		background: #fff799 none repeat scroll 0 0!important;
		color: #000 !important;
	}
	.recent-lozenge {
		border: 1px solid #f00;
		border-radius: 4px;
		color: #f00;
		display: inline-block;
		font-size: 0.7em;
		padding: 1px 2px;
		vertical-align: text-bottom;
	}
	.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
		color: #555;
		text-align: left;
	}
	input, select{
		margin: 0px;
		display: inline-block;
		padding: 2px 10px;
		background-color: #fff;
		border: 1px solid #ddd;
		color: #363463;
	}
	.info-header span{
		cursor: pointer;
		display: inline-block;
		float: right;
		margin-top: -2px;
		padding-right: 5px;
	}
	.dashboard .info-section {
		margin: 2px 5px 5px;
	}
	.toast-item{
		background-color: #222;
	}
	.col4 label {
		width: 110px;
		display: inline-block;
	}
	.col4 input[type=text] {
		display: inline-block;
		padding: 2px 10px;
	}
	.col4 select {
		padding: 2px 10px;
	}
	.last {
		width: 32%!important;
	}
	form select {
		min-width: 50px;
		display: inline-block;
	}
	.addon{
		display: inline-block;
		float: right;
		margin: 5px 0 0 145px;
		position: absolute;
	}
	#lastDayOfVisit label{
		display:none;
	}
	#lastDayOfVisit input{
		width:167px !important;
	}
	.add-on {
		float: right;
		left: auto;
		margin-left: -29px;
		margin-top: 3px;
		position: absolute;
	}
	.ui-widget-content a {
		color: #007fff;
	}
	.toast-item-image {
		top: 25px;
	}
	form select, .form select {
		min-width: 99% !important;
	}
	
	
</style>

<header>
</header>
<body>
	<div class="clear"></div>
	<div class="container">
		
		<div class="patient-header new-patient-header">
			<div class="demographics">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span class="page-label">OPD PATIENT QUEUE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>
			</div>
			<div class="identifiers">
				<em>Current Time:</em>
				<span>${date}</span>
			</div>
			
			<div class="onerow" style="margin-top: 40px">
				<form id="queue-choice-form">
					
						<label for="queue-choice">Select Queue</label>
						<select id="queue-choice" style="margin-top: 10px; width: 100px;">
							<option value="0">-- Please select --</option>
							<% listOPD.each { it -> %>
							<option value="${it.answerConcept.id}"> ${it.answerConcept.name} </option>
							<% } %>
						</select>
					
				</form>
				
				<form method="get" id="patient-search-form" onsubmit="return false">
					
						<label for="patient-search" id="for-patient-search">Filter Queue</label>
						<div onclick="ShowDashboard();" class="advanced" id="advanced">
							<i class="icon-filter"></i>ADVANCED SEARCH
						</div>
						
						<label for="search-in-db" id="for-search-in-db">
							<input type="checkbox" name="search-in-db" id="search-in-db">Search In System
						</label>
						
						<input type="text" id="patient-search" placeholder="${ ui.message("coreapps.findPatient.search.placeholder") }" style="width: 96.4%;" /><i id="patient-search-clear-button" class="small icon-remove-sign"></i>
					
				</form>
			</div>
			
			<div id="dashboard" class="dashboard advanced-search" style="display:none;">
				<div class="info-section">
					<div class="info-header">
						<i class="icon-diagnosis"></i>

						<h3>ADVANCED SEARCH</h3>
						<span id="as_close" onclick="HideDashboard();">
							<div class="identifiers">
								<span style="background:#00463f; padding-bottom: 5px;">x</span>
							</div>
						</span>
					</div>

					<div class="info-body" style="min-height: 140px;">
						<ul>
							<li>
								<div class="onerow">
									<div class="col4">
										<label for="gender">Gender</label>
										<select style="width: 167px" id="gender" name="gender">
											<option value="Any">Any</option>
											<option value="M">Male</option>
											<option value="F">Female</option>
										</select>
									</div>

									<div class="col4">
										<label for="lastDayOfVisit">Last Visit</label>
										${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'lastDayOfVisit', id: 'lastDayOfVisit', label: '', useTime: false, defaultToday: false, class: ['newdtp'], endDate: new Date()])}
									</div>

									<div class="col4 last">
										<label for="relativeName">Relative Name</label>
										<input id="relativeName" name="relativeName" style="width: 182px"
											   placeholder="Relative Name">
									</div>
								</div>

								<div class="onerow" style="padding-top: 2px;">
									<div class="col4">
										<label for="age">Age</label>
										<input id="age" name="age" style="width: 167px" placeholder="Patient Age">
									</div>

									<div class="col4">
										<label for="gender">Previous Visit</label>
										<select style="width: 167px" id="lastVisit">
											<option value="Any">Anytime</option>
											<option value="31">Last month</option>
											<option value="183">Last 6 months</option>
											<option value="366">Last year</option>
										</select>
									</div>

									<div class="col4 last">
										<label for="nationalId">National ID</label>
										<input id="nationalId" name="nationalId" style="width: 182px" placeholder="National ID">
									</div>
								</div>

								<div class="onerow" style="padding-top: 1px;">
									<div class="col4">
										<label for="ageRange">Range &plusmn;</label>
										<select id="ageRange" name="ageRange" style="width: 167px">
											<option value="0">Exact</option>
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
										</select>
									</div>

									<div class="col4">
										<label for="phoneNumber">Phone No.</label>
										<input id="phoneNumber" name="phoneNumber" style="width: 167px" placeholder="Phone No.">
									</div>

									<div class="col4 last">
										<label for="fileNumber">File Number</label>
										<input id="fileNumber" name="fileNumber" style="width: 182px" placeholder="File Number">
									</div>
								</div>

								<div class="onerow" style="padding-top: 2px;">
									<div class="col4">
										<label for="patientMaritalStatus">Marital Status</label>
										<select id="patientMaritalStatus" style="width: 167px">
											<option value="">Any</option>
											<option value="Single">Single</option>
											<option value="Married">Married</option>
											<option value="Divorced">Divorced</option>
											<option value="Widow">Widow</option>
											<option value="Widower">Widower</option>
											<option value="Separated">Separated</option>
										</select>
									</div>

									<div class="col4">
										&nbsp;
									</div>

									<div class="col4 last">&nbsp;</div>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="results">
		<div class="queue">
			<table id="patient-queue" class="dataTable">
				<thead>
				<tr role="row">
					<th class="ui-state-default" style="width: 160px;">
						<div class="DataTables_sort_wrapper">Identifier<span class="DataTables_sort_icon"></span></div>
					</th>
	
					<th class="ui-state-default">
						<div class="DataTables_sort_wrapper">Name<span class="DataTables_sort_icon"></span></div>
					</th>
	
					<th class="ui-state-default" style="width: 80px;">
						<div class="DataTables_sort_wrapper">Age<span class="DataTables_sort_icon"></span></div>
					</th>
	
					<th class="ui-state-default" style="width: 65px;">
						<div class="DataTables_sort_wrapper">Gender<span class="DataTables_sort_icon"></span></div>
					</th>
	
					<th class="ui-state-default" style="width:95px;">
						<div class="DataTables_sort_wrapper">Visit Status<span class="DataTables_sort_icon"></span></div>
					</th>
	
					<th class="user-processing ui-state-default" style="width: 150px;">
						<div class="DataTables_sort_wrapper">Processing<span class="DataTables_sort_icon"></span></div>
					</th>
				</tr>
				</thead>
	
				<tbody>
				</tbody>
			</table>
		</div>
		
		<div class="in-system">
			<table id="patients-in-system" class="dataTable">
				<thead>
					<tr role="row">
						<th class="ui-state-default" style="width: 160px;">
							<div class="DataTables_sort_wrapper">Identifier<span class="DataTables_sort_icon"></span></div>
						</th>
		
						<th class="ui-state-default">
							<div class="DataTables_sort_wrapper">Name<span class="DataTables_sort_icon"></span></div>
						</th>
		
						<th class="ui-state-default" style="width: 80px;">
							<div class="DataTables_sort_wrapper">Age<span class="DataTables_sort_icon"></span></div>
						</th>
		
						<th class="ui-state-default" style="width: 75px;">
							<div class="DataTables_sort_wrapper">Gender<span class="DataTables_sort_icon"></span></div>
						</th>
						
						<th class="ui-state-default" style="width: 200px;">
							<div class="DataTables_sort_wrapper">Last Visit<span class="DataTables_sort_icon"></span></div>
						</th>
					</tr>
				</thead>
	
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</body>




