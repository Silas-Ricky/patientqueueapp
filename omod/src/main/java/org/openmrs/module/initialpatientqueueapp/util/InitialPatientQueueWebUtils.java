package org.openmrs.module.initialpatientqueueapp.util;

import java.io.File;
import java.net.MalformedURLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.jaxen.JaxenException;
import org.jaxen.XPath;
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
import org.openmrs.module.initialpatientqueueapp.InitialPatientQueueConstants;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.util.OpenmrsUtil;
import org.springframework.ui.Model;

public class InitialPatientQueueWebUtils {
	
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
	 * Get String value from a specific global property. Unless the global property is found, the
	 * defaultValue will be returned.
	 * 
	 * @param globalPropertyName
	 * @param defaultValue
	 * @return
	 */
	public static String getString(String globalPropertyName, String defaultValue) {
		String value = Context.getAdministrationService().getGlobalProperty(globalPropertyName);
		
		String result = defaultValue;
		
		if (!StringUtils.isBlank(value)) {
			result = value;
		}
		return result;
	}
	
}
