//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package org.openmrs.module.initialpatientqueueapp.util;

import org.openmrs.ConceptAnswer;

import java.util.Comparator;

public class ConceptAnswerComparator implements Comparator<ConceptAnswer> {
	
	public ConceptAnswerComparator() {
	}
	
	public int compare(ConceptAnswer o1, ConceptAnswer o2) {
		return o1.getAnswerConcept().getName().getName().compareTo(o2.getAnswerConcept().getName().getName());
	}
}
