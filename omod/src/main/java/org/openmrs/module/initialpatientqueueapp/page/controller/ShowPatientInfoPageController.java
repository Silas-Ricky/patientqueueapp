package org.openmrs.module.initialpatientqueueapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.matcher.RegistrationUtils;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.hospitalcore.util.ObsUtils;
import org.openmrs.module.initialpatientqueueapp.EhrRegistrationUtils;
import org.openmrs.module.initialpatientqueueapp.InitialPatientQueueConstants;
import org.openmrs.module.initialpatientqueueapp.api.InitialPatientqueueappService;
import org.openmrs.module.initialpatientqueueapp.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.initialpatientqueueapp.model.PatientModel;
import org.openmrs.module.initialpatientqueueapp.model.RegistrationFee;
import org.openmrs.module.initialpatientqueueapp.web.controller.utils.RegistrationWebUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShowPatientInfoPageController {
	
	private static Log logger = LogFactory.getLog(ShowPatientInfoPageController.class);
	
	public void controller() {
		
	}
	
	public void get(@RequestParam("patientId") Integer patientId,
	        @RequestParam(value = "encounterId", required = false) Integer encounterId,
	        @RequestParam(value = "revisit", required = false) Boolean revisit,
	        @RequestParam(value = "reprint", required = false) Boolean reprint, PageModel model) throws IOException,
	        ParseException {
		
		//set place holder values
		model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
		model.addAttribute("selectedOPD", "");
		model.addAttribute("selectedTRIAGE", "");
		model.addAttribute("selectedSPECIALCLINIC", "");
		model.addAttribute("selectedMLC", "");
		model.addAttribute("dueDate", "");
		model.addAttribute("daysLeft", "");
		model.addAttribute("specialSchemeName", "");
		model.addAttribute("create", "");
		model.addAttribute("creates", "");
		model.addAttribute("observations", "");
		model.addAttribute("encounterId", encounterId);
		model.addAttribute("registrationFee", "");
		model.addAttribute("revisit", false);
		model.addAttribute("reprint", false);
		model.addAttribute("selectedPaymentCategory", "");
		model.addAttribute("firstTimeVisit", true);
		model.addAttribute("outcomes", "");
		
		SimpleDateFormat simpleDate = new SimpleDateFormat("dd/MM/yyyy kk:mm");
		model.addAttribute("receiptDate", simpleDate.format(new Date()));
		
		Patient patient = Context.getPatientService().getPatient(patientId);
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		PatientModel patientModel = new PatientModel(patient);
		
		List<Obs> obst = Context.getObsService().getObservationsByPerson(patient);
		for (Obs obs : obst) {
			if (obs.getConcept().getDisplayString().equalsIgnoreCase("VISIT OUTCOME")) {
				String outcome = obs.getValueText();
				model.addAttribute("outcomes", outcome);
				break;
			}
		}
		
		PatientQueueService pqs = Context.getService(PatientQueueService.class);
		Encounter lastEncounter = pqs.getLastOPDEncounter(patient);
		
		Date lastVisitDate = new Date();
		if (lastEncounter != null) {
			lastVisitDate = lastEncounter.getEncounterDatetime();
		}
		
		model.addAttribute("lastVisit", lastVisitDate);
		model.addAttribute("patient", patientModel);
		model.addAttribute("patientAge", patient.getAge());
		model.addAttribute("patientGender", patient.getGender());
		
		SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
		
		String previousVisitTime = sdf.format(hcs.getLastVisitTime(patient));
		
		model.addAttribute("currentDateTime", previousVisitTime);
		
		// Get patient registration fee
		if (GlobalPropertyUtil.getInteger(InitialPatientQueueConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0) > 0) {
			List<RegistrationFee> fees = Context.getService(InitialPatientqueueappService.class).getRegistrationFees(
			    patient, GlobalPropertyUtil.getInteger(InitialPatientQueueConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0));
			if (!CollectionUtils.isEmpty(fees)) {
				RegistrationFee fee = fees.get(0);
				Calendar dueDate = Calendar.getInstance();
				dueDate.setTime(fee.getCreatedOn());
				dueDate.add(Calendar.DATE, 30);
				model.addAttribute("dueDate", EhrRegistrationUtils.formatDate(dueDate.getTime()));
				model.addAttribute("daysLeft", dateDiff(dueDate.getTime(), new Date()));
			}
		}
		
		// Get selected OPD room if this is the first time of visit
		if (encounterId != null) {
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			for (PersonAttribute pa : pas) {
				PersonAttributeType attributeType = pa.getAttributeType();
				PersonAttributeType personAttributePaymentCategory = hcs.getPersonAttributeTypeByName("Payment Category");
				if (attributeType.getPersonAttributeTypeId().equals(
				    personAttributePaymentCategory.getPersonAttributeTypeId())) {
					model.addAttribute("selectedPaymentCategory", pa.getValue());
				}
			}
			
			Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
			for (Obs obs : encounter.getObs()) {
				if (obs.getConcept().getName().getName().equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_TRIAGE)) {
					model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
				}
				if (obs.getConcept().getName().getName()
				        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_OPD_WARD)) {
					model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
				}
				if (obs.getConcept().getName().getName()
				        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
					model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
				}
				
				if (obs.getConcept().getName().getName()
				        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
					model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
				}
				
				if (obs.getConcept().getDisplayString()
				        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
					double regFee = obs.getValueNumeric();
					int regFeeToInt = (int) regFee;
					model.addAttribute("registrationFee", regFeeToInt);
				}
				
				if (obs.getConcept().getDisplayString().equalsIgnoreCase("VISIT OUTCOME")) {
					String outcome = obs.getValueText();
					model.addAttribute("outcomes", outcome);
				}
				
			}
			Boolean firstTimeVisit = true;
			model.addAttribute("firstTimeVisit", firstTimeVisit);
			model.addAttribute("typeOfSlip", "Registration Receipt");
			model.addAttribute("reprint", false);
		}
		
		if ((revisit != null) && revisit) {
			model.addAttribute("typeOfSlip", "Registration Receipt");
			model.addAttribute("revisit", revisit);
			model.addAttribute("reprint", reprint);
			
			Date lastVisitTime = hcs.getLastVisitTime(patient);
			Date currentVisitTime = new Date();
			long visitTimeDifference = this.dateDiffInHours(lastVisitTime, currentVisitTime);
			model.addAttribute("visitTimeDifference", visitTimeDifference);
			
			SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
			String sef = spf.format(hcs.getLastVisitTime(patient));
			System.out.println("patient created day visit" + hcs.getLastVisitTime(patient));
			System.out.println("patient created day " + sef);
			String stf = spf.format(new Date());
			System.out.println("patient previous day visit" + spf.format(new Date()));
			System.out.println("previous day visit" + stf);
			int value = stf.compareTo(sef);
			model.addAttribute("create", value);
			model.addAttribute("firstTimeVisit", false);
		}
		
		// If reprint, get the latest registration encounter
		if ((reprint != null) && reprint) {
			model.addAttribute("firstTimeVisit", false);
			model.addAttribute("revisit", false);
			model.addAttribute("reprint", reprint);
			model.addAttribute("typeOfSlip", "Duplicate Slip");
			SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
			String sef = spf.format(hcs.getLastVisitTime(patient));
			String srf = spf.format(patient.getDateCreated());
			System.out.println("patient created day visit" + hcs.getLastVisitTime(patient));
			System.out.println("patient created day " + patient.getDateCreated());
			System.out.println("patient created day " + sef);
			String stf = spf.format(new Date());
			System.out.println("patient previous day visit" + spf.format(new Date()));
			System.out.println("previous day visit" + stf);
			//model.addAttribute("currentDateTime",stf );
			int value = stf.compareTo(sef);
			int values = stf.compareTo(srf);
			System.out.println("****" + value);
			System.out.println("****" + values);
			model.addAttribute("create", value);
			model.addAttribute("creates", values);
			model.addAttribute("currentDateTime", sdf.format(hcs.getLastVisitTime(patient)));
			
			Encounter encounter = Context.getService(InitialPatientqueueappService.class).getLastEncounter(patient);
			if (encounter != null) {
				Map<Integer, String> observations = new HashMap<Integer, String>();
				
				for (Obs obs : encounter.getAllObs()) {
					if (obs.getConcept().getName().getName()
					        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_TRIAGE)) {
						model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getName().getName()
					        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_OPD_WARD)) {
						model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getName().getName()
					        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
						model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
					}
					
					if (obs.getConcept().getName().getName()
					        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
						model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getDisplayString()
					        .equalsIgnoreCase(InitialPatientQueueConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
						double regFee = obs.getValueNumeric();
						int regFeeToInt = (int) regFee;
						
						model.addAttribute("registrationFee", regFeeToInt);
					}
					observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
				}
				model.addAttribute("observations", observations);
				List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
				for (PersonAttribute pa : pas) {
					PersonAttributeType attributeType = pa.getAttributeType();
					PersonAttributeType personAttributePaymentCategory = hcs
					        .getPersonAttributeTypeByName("Payment Category");
					if (attributeType.getPersonAttributeTypeId().equals(
					    personAttributePaymentCategory.getPersonAttributeTypeId())) {
						model.addAttribute("selectedPaymentCategory", pa.getValue());
					}
				}
			}
		}
		
		User user = Context.getAuthenticatedUser();
		model.addAttribute("reVisitFee",
		    GlobalPropertyUtil.getString(InitialPatientQueueConstants.PROPERTY_REVISIT_REGISTRATION_FEE, ""));
		model.addAttribute("childLessThanFiveYearRegistrationFee",
		    GlobalPropertyUtil.getString(InitialPatientQueueConstants.PROPERTY_CHILDLESSTHANFIVEYEAR_REGISTRATION_FEE, ""));
		model.addAttribute("specialClinicRegFee",
		    GlobalPropertyUtil.getString(InitialPatientQueueConstants.PROPERTY_SPECIALCLINIC_REGISTRATION_FEE, ""));
		model.addAttribute("TRIAGE", RegistrationWebUtils.getSubConcepts(InitialPatientQueueConstants.CONCEPT_NAME_TRIAGE));
		model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(InitialPatientQueueConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute("SPECIALCLINIC",
		    RegistrationWebUtils.getSubConcepts(InitialPatientQueueConstants.CONCEPT_NAME_SPECIAL_CLINIC));
		model.addAttribute("user", user);
	}
	
	public void post(@RequestParam("patientId") Integer patientId,
	        @RequestParam(value = "encounterId", required = false) Integer encounterId,
	        // @RequestParam(value = "regFeeValue", required = false) Double selectedRegFeeValue,
	        HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {
		
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		// get patient
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		/*
		 * SAVE ENCOUNTER
		 */
		Encounter encounter = null;
		if (encounterId != null) {
			encounter = Context.getEncounterService().getEncounter(encounterId);
			
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			Obs obs = hcs.getObs(Context.getPersonService().getPerson(patient), encounter);
			//obs.setValueNumeric(selectedRegFeeValue);
		} else {
			encounter = RegistrationWebUtils.createEncounter(patient, true);
			
			if (!StringUtils.isBlank(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_TRIAGE))) {
				Concept triageConcept = Context.getConceptService().getConcept(
				    InitialPatientQueueConstants.CONCEPT_NAME_TRIAGE);
				Concept selectedTRIAGEConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_TRIAGE)));
				String selectedCategory = parameters.get(InitialPatientQueueConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs triage = new Obs();
				triage.setConcept(triageConcept);
				triage.setValueCoded(selectedTRIAGEConcept);
				encounter.addObs(triage);
				
				// send patient to triage room
				RegistrationWebUtils.sendPatientToTriageQueue(patient, selectedTRIAGEConcept, true, selectedCategory);
			} else if (!StringUtils.isBlank(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_OPD_WARD))) {
				Concept opdConcept = Context.getConceptService().getConcept(
				    InitialPatientQueueConstants.CONCEPT_NAME_OPD_WARD);
				Concept selectedOPDConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_OPD_WARD)));
				String selectedCategory = parameters.get(InitialPatientQueueConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(opdConcept);
				opd.setValueCoded(selectedOPDConcept);
				encounter.addObs(opd);
				
				// send patient to opd room
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, true, selectedCategory);
			} else {
				Concept specialClinicConcept = Context.getConceptService().getConcept(
				    InitialPatientQueueConstants.CONCEPT_NAME_SPECIAL_CLINIC);
				Concept selectedSpecialClinicConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_SPECIAL_CLINIC)));
				String selectedCategory = parameters.get(InitialPatientQueueConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(specialClinicConcept);
				opd.setValueCoded(selectedSpecialClinicConcept);
				encounter.addObs(opd);
				
				// send patient to special clinic
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedSpecialClinicConcept, true, selectedCategory);
			}
			
			Concept mlcConcept = Context.getConceptService().getConcept(
			    InitialPatientQueueConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);
			
			Obs mlc = new Obs();
			if (!StringUtils.isBlank(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_MLC))) {
				Concept selectedMlcConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(InitialPatientQueueConstants.FORM_FIELD_PATIENT_MLC)));
				
				mlc.setConcept(mlcConcept);
				mlc.setValueCoded(selectedMlcConcept);
				encounter.addObs(mlc);
			}
			
			Concept cnrffr = Context.getConceptService().getConcept(
			    InitialPatientQueueConstants.CONCEPT_NAME_REGISTRATION_FEE);
			Concept cr = Context.getConceptService().getConcept(InitialPatientQueueConstants.CONCEPT_REVISIT);
			Double doubleVal = Double.parseDouble(parameters.get(InitialPatientQueueConstants.FORM_FIELD_REGISTRATION_FEE));
			Obs obsr = new Obs();
			obsr.setConcept(cnrffr);
			obsr.setValueCoded(cr);
			obsr.setValueNumeric(doubleVal);
			obsr.setValueText(parameters.get(InitialPatientQueueConstants.FORM_FIELD_SELECTED_PAYMENT_CATEGORY));
			obsr.setComment(parameters.get(InitialPatientQueueConstants.FORM_FIELD_SELECTED_PAYMENT_SUBCATEGORY));
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			for (PersonAttribute pa : pas) {
				PersonAttributeType attributeType = pa.getAttributeType();
				PersonAttributeType personAttributePaymentCategory = hcs
				        .getPersonAttributeTypeByName("Paying Category Type");
				if (attributeType.getPersonAttributeTypeId().equals(
				    personAttributePaymentCategory.getPersonAttributeTypeId())) {
					obsr.setComment(pa.getValue());
				}
			}
			encounter.addObs(obsr);
			
		}
		
		try {
			// update patient
			Patient updatedPatient = generatePatient(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			
			// update patient attribute
			updatedPatient = setAttributes(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			EhrRegistrationUtils.savePatientSearch(patient);
		}
		catch (Exception e) {}
		
		// save encounter
		Context.getEncounterService().saveEncounter(encounter);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print("success");
	}
	
	/**
	 * Get date diff betwwen 2 dates
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	private long dateDiff(Date d1, Date d2) {
		long diff = Math.abs(d1.getTime() - d2.getTime());
		return (diff / (1000 * 60 * 60 * 24));
	}
	
	private long dateDiffInHours(Date d1, Date d2) {
		long diff = Math.abs(d1.getTime() - d2.getTime());
		return (diff / (1000 * 60 * 60));
	}
	
	private Patient generatePatient(Patient patient, Map<String, String> parameters) throws ParseException {
		return patient;
	}
	
	private Patient setAttributes(Patient patient, Map<String, String> attributes) throws Exception {
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> parameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes", attributes);
		String validateResult = validator.validate(parameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : attributes.keySet()) {
				if ((name.contains(".attribute.")) && (!StringUtils.isBlank(attributes.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = EhrRegistrationUtils.getPersonAttribute(id, attributes.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}
		
		return patient;
	}
	
}
