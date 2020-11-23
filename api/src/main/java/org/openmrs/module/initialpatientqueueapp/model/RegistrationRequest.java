package org.openmrs.module.initialpatientqueueapp.model;

public class RegistrationRequest {
	
	private String status, message;
	
	private int patientId, encounterId;
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public int getPatientId() {
		return patientId;
	}
	
	public void setPatientId(int patientId) {
		this.patientId = patientId;
	}
	
	public int getEncounterId() {
		return encounterId;
	}
	
	public void setEncounterId(int encounterId) {
		this.encounterId = encounterId;
	}
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	@Override
	public String toString() {
		return "RegistrationRequest{" + "status='" + status + '\'' + ", message='" + message + '\'' + ", patientId="
		        + patientId + ", encounterId=" + encounterId + '}';
	}
}
