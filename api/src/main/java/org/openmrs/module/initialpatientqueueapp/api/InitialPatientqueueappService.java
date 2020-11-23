/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.initialpatientqueueapp.api;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.OpenmrsService;
import org.openmrs.module.initialpatientqueueapp.model.RegistrationFee;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.util.List;

/**
 * The main service of this module, which is exposed for other modules. See
 * moduleApplicationContext.xml on how it is wired up.
 */
@Transactional
public interface InitialPatientqueueappService extends OpenmrsService {
	
	// REGISTRATION FEE
	/**
	 * Save registration fee
	 * 
	 * @param fee
	 * @return
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee);
	
	/**
	 * Get registration fee by id
	 * 
	 * @param id
	 * @return
	 */
	public RegistrationFee getRegistrationFee(Integer id);
	
	/**
	 * Get list of registration fee
	 * 
	 * @param patient
	 * @param numberOfLastDate <b>null</b> to search all time
	 * @return
	 * @throws ParseException
	 */
	public List<RegistrationFee> getRegistrationFees(Patient patient, Integer numberOfLastDate) throws ParseException;
	
	/**
	 * Delete a registration fee
	 * 
	 * @param fee
	 */
	public void deleteRegistrationFee(RegistrationFee fee);
	
	// PERSON ATTRIBUTE
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type, String value);
	
	/*
	 * ENCOUNTER
	 */
	
	/**
	 * Get last encounter
	 * 
	 * @param patient
	 * @return
	 */
	public Encounter getLastEncounter(Patient patient);
	
	// ghanshya,3-july-2013 #1962 Create validation for length of Health ID and
	// National ID
	//public int getNationalId(String nationalId);
	
	public int getNationalId(Integer patientId, String nationalId);
	
	//public int getHealthId(String healthId);
	
	public int getHealthId(Integer patientId, String healthId);
	
	//public int getPassportNumber(String passportNumber);
	
	public int getPassportNumber(Integer patientId, String passportNumber);
	
}
