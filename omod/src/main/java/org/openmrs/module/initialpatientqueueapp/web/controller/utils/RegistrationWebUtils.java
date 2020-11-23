package org.openmrs.module.initialpatientqueueapp.web.controller.utils;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.XPath;
import org.dom4j.io.SAXReader;
import org.jaxen.dom4j.Dom4jXPath;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.OpdPatientQueue;
import org.openmrs.module.hospitalcore.model.TriagePatientQueue;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.initialpatientqueueapp.InitialPatientQueueConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.util.OpenmrsUtil;
import org.jaxen.JaxenException;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.MalformedURLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RegistrationWebUtils {
	
	/**
	 * Optimize the request's parameters
	 * 
	 * @param request
	 * @return
	 */
	public static Map<String, String> optimizeParameters(HttpServletRequest request) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (@SuppressWarnings("rawtypes")
		Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
			String parameterName = (String) e.nextElement();
			String[] values = request.getParameterValues(parameterName);
			String value = StringUtils.join(values, ',');
			parameters.put(parameterName, value);
		}
		return parameters;
	}
	
	/**
	 * Get the list of concepts which are answered for a concept
	 * 
	 * @param conceptName
	 * @return
	 */
	public static String getSubConcepts(String conceptName) {
		Concept opdward = Context.getConceptService().getConcept(conceptName);
		StringBuilder sb = new StringBuilder();
		for (ConceptAnswer ca : opdward.getAnswers()) {
			sb.append(ca.getAnswerConcept().getConceptId() + "," + ca.getAnswerConcept().getName().getName() + "|");
		}
		return sb.toString();
	}
	
	public static String getSubConceptsWithName(String conceptName) {
		Concept concept = Context.getConceptService().getConcept(conceptName);
		StringBuilder sb = new StringBuilder();
		for (ConceptAnswer ca : concept.getAnswers()) {
			sb.append(ca.getAnswerConcept().getName().getName() + "," + ca.getAnswerConcept().getName().getName() + "|");
		}
		return sb.toString();
	}
	
	public static String getReligionConcept() {
		Concept religion = Context.getConceptService().getConcept("RELIGION");
		StringBuilder sb = new StringBuilder();
		for (ConceptAnswer ca : religion.getAnswers()) {
			sb.append(ca.getAnswerConcept().getName().getName() + "," + ca.getAnswerConcept().getName().getName() + "|");
		}
		return sb.toString();
	}
	
	/**
	 * Send patient for OPD Queue
	 * 
	 * @param patient
	 * @param selectedOPDConcept
	 * @param revisit
	 */
	public static void sendPatientToOPDQueue(Patient patient, Concept selectedOPDConcept, boolean revisit,
	        String selectedCategory) {
		Concept visitStatus = null;
		if (!revisit) {
			visitStatus = Context.getConceptService().getConcept("NEW PATIENT");
		} else {
			visitStatus = Context.getConceptService().getConcept("REVISIT");
		}
		
		OpdPatientQueue queue = Context.getService(PatientQueueService.class).getOpdPatientQueue(
		    patient.getPatientIdentifier().getIdentifier(), selectedOPDConcept.getConceptId());
		if (queue == null) {
			queue = new OpdPatientQueue();
			queue.setUser(Context.getAuthenticatedUser());
			queue.setPatient(patient);
			queue.setCreatedOn(new Date());
			queue.setBirthDate(patient.getBirthdate());
			queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
			queue.setOpdConcept(selectedOPDConcept);
			queue.setOpdConceptName(selectedOPDConcept.getName().getName());
			if (null != patient.getMiddleName()) {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName() + " " + patient.getMiddleName());
			} else {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName());
			}
			//queue.setReferralConcept(referralConcept);
			//queue.setReferralConceptName(referralConcept.getName().getName());
			queue.setSex(patient.getGender());
			queue.setCategory(selectedCategory);
			queue.setVisitStatus(visitStatus.getName().getName());
			PatientQueueService queueService = Context.getService(PatientQueueService.class);
			queueService.saveOpdPatientQueue(queue);
			
		}
		
	}
	
	public static void sendPatientToTriageQueue(Patient patient, Concept selectedTriageConcept, boolean revisit,
	        String selectedCategory) {
		Concept visitStatus = null;
		if (!revisit) {
			visitStatus = Context.getConceptService().getConcept("NEW PATIENT");
		} else {
			visitStatus = Context.getConceptService().getConcept("REVISIT");
		}
		
		TriagePatientQueue queue = Context.getService(PatientQueueService.class).getTriagePatientQueue(
		    patient.getPatientIdentifier().getIdentifier(), selectedTriageConcept.getConceptId());
		if (queue == null) {
			queue = new TriagePatientQueue();
			queue.setUser(Context.getAuthenticatedUser());
			queue.setPatient(patient);
			queue.setCreatedOn(new Date());
			queue.setBirthDate(patient.getBirthdate());
			queue.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
			queue.setTriageConcept(selectedTriageConcept);
			queue.setTriageConceptName(selectedTriageConcept.getName().getName());
			if (null != patient.getMiddleName()) {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName() + " " + patient.getMiddleName());
			} else {
				queue.setPatientName(patient.getGivenName() + " " + patient.getFamilyName());
			}
			//queue.setReferralConcept(referralConcept);
			//queue.setReferralConceptName(referralConcept.getName().getName());
			queue.setSex(patient.getGender());
			queue.setCategory(selectedCategory);
			queue.setVisitStatus(visitStatus.getName().getName());
			PatientQueueService queueService = Context.getService(PatientQueueService.class);
			queueService.saveTriagePatientQueue(queue);
			
		}
		
	}
	
	/**
	 * Get the list of address
	 * 
	 * @param model
	 * @throws MalformedURLException
	 * @throws DocumentException
	 * @throws JaxenException
	 */
	/*
	 * Ghanshyam - Sagar : date- 15 Dec, 2012. Redmine issue's for Bangladesh :
	 * #510 and #511 and #512 Tehsil renamed as Upazila
	 */
	public static void getAddressData(PageModel model) throws MalformedURLException, DocumentException, JaxenException {
		File addressFile = new File(OpenmrsUtil.getApplicationDataDirectory() + "kenyaaddresshierarchy.xml");
		if (addressFile.exists()) {
			SAXReader reader = new SAXReader();
			Document document = reader.read(addressFile.toURI().toURL());
			XPath distSelector = (XPath) new Dom4jXPath("//country/district");
			@SuppressWarnings("rawtypes")
			List distList = distSelector.selectNodes(document);
			String[] distArr = new String[distList.size()];
			String[] upazilaArr = new String[distList.size()];
			if (distList.size() > 0) {
				for (int i = 0; i < distList.size(); i++) {
					distArr[i] = ((Element) distList.get(i)).attributeValue("name");
					@SuppressWarnings("rawtypes")
					List upazilaList = ((Element) distList.get(i)).elements("upazila");
					upazilaArr[i] = ((Element) upazilaList.get(0)).attributeValue("name") + ",";
					for (int j = 1; j < (upazilaList.size() - 1); j++) {
						upazilaArr[i] += ((Element) upazilaList.get(j)).attributeValue("name") + ",";
					}
					upazilaArr[i] += ((Element) upazilaList.get(upazilaList.size() - 1)).attributeValue("name");
				}
			}
			model.addAttribute("districts", distArr);
			model.addAttribute("upazilas", upazilaArr);
		}
	}
	
	//
	public static void getAddressDta(PageModel model) throws MalformedURLException, DocumentException, JaxenException {
		File addressFile = new File(OpenmrsUtil.getApplicationDataDirectory() + "kenyaaddresshierarchy.xml");
		if (addressFile.exists()) {
			SAXReader reader = new SAXReader();
			Document document = reader.read(addressFile.toURI().toURL());
			XPath distSelector = (XPath) new Dom4jXPath("//country/county");
			@SuppressWarnings("rawtypes")
			List countyList = distSelector.selectNodes(document);
			String[] countyArr = new String[countyList.size()];
			String[] subcountyArr = new String[countyList.size()];
			String location = "";
			
			if (countyList.size() > 0) {
				for (int i = 0; i < countyList.size(); i++) {
					
					countyArr[i] = ((Element) countyList.get(i)).attributeValue("name");
					@SuppressWarnings("rawtypes")
					List subcountyList = ((Element) countyList.get(i)).elements("subcounty");
					
					String countyName = ((Element) countyList.get(i)).attributeValue("name");
					location = location + countyName;
					
					String subcountyName = ((Element) subcountyList.get(0)).attributeValue("name");
					location = location + "/" + subcountyName;
					subcountyArr[i] = ((Element) subcountyList.get(0)).attributeValue("name") + ",";
					@SuppressWarnings("rawtypes")
					List locationList = ((Element) subcountyList.get(0)).elements("location");
					for (int k = 0; k < (locationList.size()); k++) {
						String locationName = ((Element) locationList.get(k)).attributeValue("name");
						location = location + "." + locationName;
					}
					
					for (int j = 1; j < (subcountyList.size() - 1); j++) {
						subcountyName = ((Element) subcountyList.get(j)).attributeValue("name");
						location = location + "/" + subcountyName;
						subcountyArr[i] += ((Element) subcountyList.get(j)).attributeValue("name") + ",";
						locationList = ((Element) subcountyList.get(j)).elements("location");
						for (int k = 0; k < (locationList.size()); k++) {
							String locationName = ((Element) locationList.get(k)).attributeValue("name");
							location = location + "." + locationName;
						}
					}
					
					subcountyName = ((Element) subcountyList.get((subcountyList.size() - 1))).attributeValue("name");
					location = location + "/" + subcountyName;
					subcountyArr[i] += ((Element) subcountyList.get((subcountyList.size() - 1))).attributeValue("name")
					        + ",";
					locationList = ((Element) subcountyList.get((subcountyList.size() - 1))).elements("location");
					for (int k = 0; k < (locationList.size()); k++) {
						String locationName = ((Element) locationList.get(k)).attributeValue("name");
						location = location + "." + locationName;
					}
					
					if (i < countyList.size() - 1) {
						location = location + "@";
					}
				}
			}
			model.addAttribute("districts", countyArr);
			model.addAttribute("upazilas", subcountyArr);
			model.addAttribute("location", location);
			
		}
	}
	
	/**
	 * Create a new encounter
	 * 
	 * @param patient
	 * @param revisit
	 * @return
	 */
	public static Encounter createEncounter(Patient patient, boolean revisit) {
		EncounterType encounterType = null;
		if (!revisit) {
			String encounterTypeName = GlobalPropertyUtil.getString(
			    InitialPatientQueueConstants.PROPERTY_ENCOUNTER_TYPE_REGINIT, "REGINITIAL");
			encounterType = Context.getEncounterService().getEncounterType(encounterTypeName);
		} else {
			String encounterTypeName = GlobalPropertyUtil.getString(
			    InitialPatientQueueConstants.PROPERTY_ENCOUNTER_TYPE_REVISIT, "REGREVISIT");
			encounterType = Context.getEncounterService().getEncounterType(encounterTypeName);
		}
		
		// get location
		Location location = new Location(GlobalPropertyUtil.getInteger(InitialPatientQueueConstants.PROPERTY_LOCATION, 1));
		
		// create encounter
		Encounter encounter = new Encounter();
		encounter.setEncounterType(encounterType);
		encounter.setCreator(Context.getAuthenticatedUser());
		encounter.setProvider(Context.getAuthenticatedUser().getPerson());
		encounter.setEncounterDatetime(new Date());
		encounter.setPatient(patient);
		encounter.setLocation(location);
		return encounter;
	}
}
