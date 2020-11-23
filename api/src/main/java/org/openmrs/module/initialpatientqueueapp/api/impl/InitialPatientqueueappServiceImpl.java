/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.initialpatientqueueapp.api.impl;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.initialpatientqueueapp.api.InitialPatientqueueappService;
import org.openmrs.module.initialpatientqueueapp.api.dao.InitialPatientqueueappDao;
import org.openmrs.module.initialpatientqueueapp.model.RegistrationFee;

import java.text.ParseException;
import java.util.List;

public class InitialPatientqueueappServiceImpl extends BaseOpenmrsService implements InitialPatientqueueappService {
	
	InitialPatientqueueappDao dao;
	
	/**
	 * Injected in moduleApplicationContext.xml
	 */
	public void setDao(InitialPatientqueueappDao dao) {
		this.dao = dao;
	}
	
	/*
	 * REGISTRATION FEE
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee) {
		return dao.saveRegistrationFee(fee);
	}
	
	public RegistrationFee getRegistrationFee(Integer id) {
		return dao.getRegistrationFee(id);
	}
	
	public List<RegistrationFee> getRegistrationFees(Patient patient, Integer numberOfLastDate) throws ParseException {
		return dao.getRegistrationFees(patient, numberOfLastDate);
	}
	
	public void deleteRegistrationFee(RegistrationFee fee) {
		dao.deleteRegistrationFee(fee);
	}
	
	/*
	 * PERSON ATTRIBUTE
	 */
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type, String value) {
		return dao.getPersonAttribute(type, value);
	}
	
	public Encounter getLastEncounter(Patient patient) {
		return dao.getLastEncounter(patient);
	}
	
	/*public int getNationalId(String nationalId) {
		return dao.getNationalId(nationalId);
	}*/
	
	public int getNationalId(Integer patientId, String nationalId) {
		return dao.getNationalId(patientId, nationalId);
	}
	
	/*//public int getHealthId(String healthId) {
		return dao.getHealthId(healthId);
	}*/
	
	public int getHealthId(Integer patientId, String healthId) {
		return dao.getHealthId(patientId, healthId);
	}
	
	/*public int getPassportNumber(String passportNumber) {
		return dao.getPassportNumber(passportNumber);
	}*/
	
	public int getPassportNumber(Integer patientId, String passportNumber) {
		return dao.getPassportNumber(patientId, passportNumber);
	}
	
}
