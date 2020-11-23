package org.openmrs.module.initialpatientqueueapp.model;

import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.initialpatientqueueapp.EhrRegistrationUtils;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

public class PatientModel {
	
	private String patientId;
	
	private String identifier;
	
	private String fullname;
	
	private String surName;
	
	private String firstName;
	
	private String otherName;
	
	private String age;
	
	private String gender;
	
	private String category;
	
	private String address;
	
	private String birthdate;
	
	private Boolean birthdateEstimated;
	
	private String physicalAddress, county, subCounty, location;
	
	private Map<Integer, String> attributes = new HashMap<Integer, String>();
	
	public PatientModel(Patient patient) throws ParseException {
		setPatientId(patient.getPatientId().toString());
		setIdentifier(patient.getPatientIdentifier().getIdentifier());
		setFullname(PatientUtils.getFullName(patient));
		setSurName(patient.getFamilyName());
		setFirstName(patient.getGivenName());
		if (patient.getMiddleName() != null) {
			setOtherName(patient.getMiddleName());
		} else {
			setOtherName("");
		}
		
		setAge(String.format("%s, %s", PatientUtils.estimateAge(patient.getBirthdate()),
		    PatientUtils.getAgeCategory(patient)));
		
		if (patient.getGender().equalsIgnoreCase("M")) {
			setGender("Male");
		} else if (patient.getGender().equalsIgnoreCase("F")) {
			setGender("Female");
		} else if (patient.getGender().equalsIgnoreCase("O")) {
			setGender("Others");
		}
		
		if (patient.getPersonAddress() != null) {
			setAddress(patient.getPersonAddress().getAddress1() + ", " + patient.getPersonAddress().getCityVillage() + ", "
			        + patient.getPersonAddress().getCountyDistrict() + ", " + patient.getPersonAddress().getAddress2());
			setPhysicalAddress(patient.getPersonAddress().getAddress1());
			setCounty(patient.getPersonAddress().getCityVillage());
			setSubCounty(patient.getPersonAddress().getCountyDistrict());
			setLocation(patient.getPersonAddress().getAddress2());
		}
		
		setBirthdate(EhrRegistrationUtils.formatDate(patient.getBirthdate()));
		setBirthdateEstimated(patient.getBirthdateEstimated());
		
		Map<String, PersonAttribute> attributes = patient.getAttributeMap();
		for (String key : attributes.keySet()) {
			getAttributes().put(attributes.get(key).getAttributeType().getId(), attributes.get(key).getValue());
		}
	}
	
	public String getFullname() {
		return fullname;
	}
	
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	
	public String getSurName() {
		return surName;
	}
	
	public void setSurName(String surName) {
		this.surName = surName;
	}
	
	public String getFirstName() {
		return firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getOtherName() {
		return otherName;
	}
	
	public void setOtherName(String otherName) {
		this.otherName = otherName;
	}
	
	public String getAge() {
		return age;
	}
	
	public void setAge(String age) {
		this.age = age;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getCategory() {
		return category;
	}
	
	public void setCategory(String category) {
		this.category = category;
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public Map<Integer, String> getAttributes() {
		return attributes;
	}
	
	public void setAttributes(Map<Integer, String> attributes) {
		this.attributes = attributes;
	}
	
	public String getIdentifier() {
		return identifier;
	}
	
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}
	
	public String getPatientId() {
		return patientId;
	}
	
	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}
	
	public String getBirthdate() {
		return birthdate;
	}
	
	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}
	
	public Boolean getBirthdateEstimated() {
		return birthdateEstimated;
	}
	
	public void setBirthdateEstimated(Boolean birthdateEstimated) {
		this.birthdateEstimated = birthdateEstimated;
	}
	
	public String getPhysicalAddress() {
		return physicalAddress;
	}
	
	public void setPhysicalAddress(String physicalAddress) {
		this.physicalAddress = physicalAddress;
	}
	
	public String getCounty() {
		return county;
	}
	
	public void setCounty(String county) {
		this.county = county;
	}
	
	public String getSubCounty() {
		return subCounty;
	}
	
	public void setSubCounty(String subCounty) {
		this.subCounty = subCounty;
	}
	
	public String getLocation() {
		return location;
	}
	
	public void setLocation(String location) {
		this.location = location;
	}
}
