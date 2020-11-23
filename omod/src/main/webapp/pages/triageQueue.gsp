<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Triage Queue"])
    ui.includeCss("uicommons", "datatables/dataTables_jui.css")
    ui.includeJavascript("patientqueueapp", "jquery.dataTables.min.js")
    ui.includeJavascript("patientqueueapp", "queue.js")
    ui.includeJavascript("patientqueueapp", "jquery.session.js")
%>
<script type="text/javascript">
    function handlePatientRowSelection() {
        this.handle = function (row) {
            console.log("Row status: " + row.status);
            location.href = '/' + OPENMRS_CONTEXT_PATH + emr.applyContextModel('${ ui.escapeJs(afterSelectedUrl) }', { patientId: row.patient.id, queueId: row.id, opdId: jq('#queue-choice').val()});
        }
    }

    var handlePatientRowSelection =  new handlePatientRowSelection();
	
	jq(document).ready(function () {
		jq('#queue-choice').bind('change keyup', function() {
			jq.session.set("selected-option-triage", jq('#queue-choice').val());
		});
		
		if (jq.session.get("selected-option-triage")!= ''){
			jq("#queue-choice").val(jq.session.get("selected-option-triage"));
			
			if (jq("#queue-choice").val() != 0){
				startRefresh();
			}
		}
	});
</script>

<style>
	.results {
		margin-top: 1em;
	}
	#patient-queue tbody tr:hover {
		background-color: #f26522;
		cursor: pointer;
	}
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
		margin-top: 5px;
	}
	#queue-choice-form{
		display: inline-block;
		width: 300px;
	}
	#patient-search-form {
		display: inline-block;
		width: 650px;
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
		padding-left: 5px;
	}
	#patient-search-clear-button {
		cursor: pointer;
	}
	.name{
		color: #f26522;
	}
	form select, .form select {
		min-width: 97%!important;
	}
</style>

<header>
</header>
<body>
	<div class="clear"></div>
		
		<div class="patient-header new-patient-header">
			<div class="demographics">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span>TRIAGE PATIENT QUEUE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>
			</div>

			<div class="identifiers">
				<em>Current Time:</em>
				<span>${date}</span>
			</div>
			
			<div class="onerow" style="margin-top: 40px">
				<form id="queue-choice-form">
					<p>
						<label for="queue-choice">Select Queue</label>
						<select id="queue-choice">
							<option value="0">-- Please select --</option>
							<% listOPD.each { it -> %>
								<% if (it.answerConcept.id != 5123) { %>								
									<option value="${it.answerConcept.id}"> ${it.answerConcept.name} </option>
								<% } %>
							<% } %>
						</select>
					</p>
				</form>
				
				<form method="get" id="patient-search-form" onsubmit="return false">
					<p>
						<label for="patient-search">Filter Patient</label>
						<input type="text" id="patient-search" placeholder="${ ui.message("coreapps.findPatient.search.placeholder") }" style="width: 96.6%;" /><i id="patient-search-clear-button" class="small icon-remove-sign"></i>
					</p>
				</form>
			</div>
		</div>
	</div>
	
	<div class="results">
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
</body>




