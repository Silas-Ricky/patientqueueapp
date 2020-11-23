package org.openmrs.module.initialpatientqueueapp.includable.validator.attribute;

import java.util.Map;

public interface PatientAttributeValidator {
	
	public abstract String validate(Map<String, Object> parameters);
	
}
