/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.initialpatientqueueapp.api.dao;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.module.initialpatientqueueapp.model.RegistrationFee;

import java.text.ParseException;
import java.util.List;

public interface InitialPatientqueueappDao {
	
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
	 * Delete registration fee
	 * 
	 * @param fee
	 */
	public void deleteRegistrationFee(RegistrationFee fee);
	
	// PERSON ATTRIBUTE
	
	/**
	 * Get Person Attributes
	 * 
	 * @param type
	 * @param value
	 * @return
	 */
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type, String value);
	
	/**
	 * Get last encounter
	 * 
	 * @param patient
	 * @return
	 */
	public Encounter getLastEncounter(Patient patient);
	
	//public int getNationalId(String nationalId);
	
	public int getNationalId(Integer patientId, String nationalId);
	
	//public int getHealthId(String healthId);
	
	public int getHealthId(Integer patientId, String healthId);
	
	//public int getPassportNumber(String passportNumber);
	
	public int getPassportNumber(Integer patientId, String passportNumber);
	
}
