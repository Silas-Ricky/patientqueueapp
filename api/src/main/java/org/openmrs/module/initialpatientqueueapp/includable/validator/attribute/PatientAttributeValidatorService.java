package org.openmrs.module.initialpatientqueueapp.includable.validator.attribute;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;

import java.util.Map;

public class PatientAttributeValidatorService implements PatientAttributeValidator {
	
	private Log logger = LogFactory.getLog(getClass());
	
	private PatientAttributeValidator validator = null;
	
	/**
	 * Get the validator relying on the hospital name. If can't find one, a warning will be thrown
	 * and the default validator will be used.
	 */
	public PatientAttributeValidatorService() {
		String hospitalName = GlobalPropertyUtil.getString(HospitalCoreConstants.PROPERTY_HOSPITAL_NAME, "");
		
		if (StringUtils.isBlank(hospitalName)) {
			hospitalName = "common";
			logger.warn("CAN'T FIND THE HOSPITAL NAME. USE THE DEFAULT VALIDATOR.");
		}
		
		hospitalName = hospitalName.toLowerCase();
		String qualifiedName = "org.openmrs.module.registration.includable.validator.attribute." + hospitalName
		        + ".PatientAttributeValidatorImpl";
		try {
			validator = (PatientAttributeValidator) Class.forName(qualifiedName).newInstance();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String validate(Map<String, Object> parameters) {
		if (validator != null) {
			return validator.validate(parameters);
		} else {
			logger.warn("NO VALIDATOR FOUND!");
		}
		return null;
	}
}
