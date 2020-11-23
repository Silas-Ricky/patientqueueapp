package org.openmrs.module.initialpatientqueueapp.api.dao.hibernate;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.initialpatientqueueapp.InitialPatientQueueConstants;
import org.openmrs.module.initialpatientqueueapp.api.dao.InitialPatientqueueappDao;
import org.openmrs.module.initialpatientqueueapp.model.RegistrationFee;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.Order;
import org.hibernate.Session;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class HibernateInitialPatientqueueappDao implements InitialPatientqueueappDao {
	
	protected final Log logger = LogFactory.getLog(this.getClass());
	
	private SimpleDateFormat mysqlDateTimeFormatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	
	private SimpleDateFormat mysqlDateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	
	private SessionFactory sessionFactory;
	
	/**
	 * @param sessionFactory the sessionFactory to set
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	/**
	 * @return the sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	/*
	 * REGISTRATION FEE
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee) {
		return (RegistrationFee) sessionFactory.getCurrentSession().merge(fee);
	}
	
	public RegistrationFee getRegistrationFee(Integer id) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(RegistrationFee.class);
		criteria.add(Restrictions.eq("id", id));
		return (RegistrationFee) criteria.uniqueResult();
	}
	
	@SuppressWarnings("unchecked")
	public List<RegistrationFee> getRegistrationFees(Patient patient, Integer numberOfLastDate) throws ParseException {
		
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(RegistrationFee.class);
		criteria.add(Restrictions.eq("patient", patient));
		Calendar afterDate = Calendar.getInstance();
		afterDate.add(Calendar.DATE, -numberOfLastDate);
		String afterDateFormat = mysqlDateFormatter.format(afterDate.getTime()) + " 00:00:00";
		logger.info(String.format("getRegistrationFees(patientId=%s, afterDate=%s)", patient.getId(), afterDateFormat));
		criteria.add(Restrictions.ge("createdOn", mysqlDateTimeFormatter.parse(afterDateFormat)));
		criteria.addOrder(Order.desc("createdOn"));
		
		return criteria.list();
	}
	
	public void deleteRegistrationFee(RegistrationFee fee) {
		sessionFactory.getCurrentSession().delete(fee);
	}
	
	/*
	 * PERSON ATTRIBUTE
	 */
	
	@SuppressWarnings("unchecked")
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type, String value) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PersonAttribute.class);
		criteria.add(Restrictions.eq("attributeType", type));
		criteria.add(Restrictions.eq("value", value));
		criteria.add(Restrictions.eq("voided", false));
		Criteria personCriteria = criteria.createCriteria("person");
		personCriteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		return criteria.list();
	}
	
	/*
	 * ENCOUNTER
	 */
	public Encounter getLastEncounter(Patient patient) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(Encounter.class);
		criteria.add(Restrictions.eq("patient", patient));
		
		// Get encountertypes
		Set<EncounterType> encounterTypes = new HashSet<EncounterType>();
		encounterTypes.add(Context.getEncounterService().getEncounterType(
		    GlobalPropertyUtil.getString(InitialPatientQueueConstants.PROPERTY_ENCOUNTER_TYPE_REGINIT, "REGINITIAL")));
		encounterTypes.add(Context.getEncounterService().getEncounterType(
		    GlobalPropertyUtil.getString(InitialPatientQueueConstants.PROPERTY_ENCOUNTER_TYPE_REVISIT, "REGREVISIT")));
		criteria.add(Restrictions.in("encounterType", encounterTypes));
		criteria.addOrder(Order.desc("dateCreated"));
		criteria.setMaxResults(1);
		return (Encounter) criteria.uniqueResult();
	}
	
	// ghanshya,3-july-2013 #1962 Create validation for length of Health ID and
	// National ID
	/*
	 * Validate NationalId
	 */
	/* public int getNationalId(String nationalId) {
	     String hql = "from PersonAttribute pa where pa.attributeType=20 AND pa.value like '" + nationalId + "' ";
	     Session session = sessionFactory.getCurrentSession();
	     Query q = session.createQuery(hql);
	     List<PersonAttribute> list = q.list();
	     if (list.size() > 0) {
	         return 1;
	     } else {
	         return 0;
	     }
	 }*/
	
	public int getNationalId(Integer patientId, String nationalId) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PersonAttribute.class);
		criteria.add(Restrictions.eq("attributeType.id", 20));
		criteria.add(Restrictions.eq("value", nationalId));
		criteria.add(Restrictions.eq("voided", false));
		criteria.add(Restrictions.not(Restrictions.eq("person.id", patientId)));
		List<PersonAttribute> list = criteria.list();
		if (list.size() > 0) {
			return 1;
		} else {
			return 0;
		}
		
	}
	
	/*
	 * Validate HealthId
	 */
	/*public int getHealthId(String healthId) {
	    String hql = "from PersonAttribute pa where pa.attributeType=24 AND pa.value like '" + healthId + "' ";
	    Session session = sessionFactory.getCurrentSession();
	    Query q = session.createQuery(hql);
	    List<PersonAttribute> list = q.list();
	    if (list.size() > 0) {
	        return 1;
	    } else {
	        return 0;
	    }
	}*/
	
	public int getHealthId(Integer patientId, String healthId) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PersonAttribute.class);
		criteria.add(Restrictions.eq("attributeType.id", 24));
		criteria.add(Restrictions.eq("value", healthId));
		criteria.add(Restrictions.eq("voided", false));
		criteria.add(Restrictions.not(Restrictions.eq("person.id", patientId)));
		List<PersonAttribute> list = criteria.list();
		if (list.size() > 0) {
			return 1;
		} else {
			return 0;
		}
		
	}
	
	/*
	 * Validate PassportNumber
	 */
	/*public int getPassportNumber(String passportNumber) {
	    String hql = "from PersonAttribute pa where pa.attributeType=38 AND pa.value like '" + passportNumber + "' ";
	    Session session = sessionFactory.getCurrentSession();
	    Query q = session.createQuery(hql);
	    List<PersonAttribute> list = q.list();
	    if (list.size() > 0) {
	        return 1;
	    } else {
	        return 0;
	    }
	}*/
	
	public int getPassportNumber(Integer patientId, String passportNumber) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(PersonAttribute.class);
		criteria.add(Restrictions.eq("attributeType.id", 38));
		criteria.add(Restrictions.eq("value", passportNumber));
		criteria.add(Restrictions.eq("voided", false));
		criteria.add(Restrictions.not(Restrictions.eq("person.id", patientId)));
		List<PersonAttribute> list = criteria.list();
		if (list.size() > 0) {
			return 1;
		} else {
			return 0;
		}
		
	}
}
