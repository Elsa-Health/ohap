export type investigation2 = {
	label?: string;
	value?: string;
	name: string;
	type: "boolean" | "number" | "range" | "normality";
	result: {
		value: string;
		description: string;
	};
};

type investigation =
	| {
			name: string;
			withDescription?: boolean;
			type: "boolean" | "range" | "normality";
			units?: string;
	  }
	| {
			name: string;
			withDescription?: boolean;
			type: "number";
			units: string;
	  };

export const investigations: Array<investigation> = [
	{ name: "Rapid Test (MRDT)", type: "boolean" },
	{ name: "Blood Slide", type: "boolean" },
	{ name: "CD4 Count", type: "number", units: "cells/mm3" },
	{ name: "Viral load", type: "number", units: "cells/mm3" },
	{ name: "HIV Rapid Test", type: "boolean" },
	{ name: "CrAg", type: "boolean" },
	{ name: "Hepatitis B surface antigen (HBsAg)", type: "boolean" },
	{ name: "Hepatitis B e-Antigen (HbeAg)", type: "boolean" },

	// Imaging
	{ name: "X-Ray", type: "normality", withDescription: true },
	{ name: "MRI", type: "normality", withDescription: true },
	{ name: "CT Scan", type: "normality", withDescription: true },

	// TB
	{ name: "Xpert MTB/ RIF", type: "boolean" },
	{ name: "Mantoux / PPD (Skin Test)", type: "boolean" },

	// Bacterial / Viral Infections
	{ name: "Sputum Culture", type: "boolean" },
	{ name: "Sputum Smear", type: "boolean" },
	{ name: "Sputum PCR", type: "boolean" },
	{ name: "CSF Culture", type: "boolean" },
	{ name: "Microscopy of CSF - India Ink Staining", type: "boolean" },
	{ name: "Blood Culture", type: "boolean" },

	// fungal infection
	{ name: "1-2-Beta-D-glucan", type: "boolean" },

	// Urinalysis
	{ name: "Albumin", type: "range" },
	{ name: "Albumin-creatitine ratio", type: "range" },
	{ name: "Calcium", type: "range" },
	{ name: "Creatinine", type: "range" },
	{ name: "Protein-creatinine ratio", type: "range" },
	{ name: "Uric acid", type: "range" },

	// clinical chemistry
	{ name: "Potassium (K+)", type: "range" },
	{ name: "Sodium (Na+)", type: "range" },
	{ name: "Magnesium (Mg+)", type: "range" },
	{ name: "Chloride (Cl-)", type: "range" },
	{ name: "Bicarbonate (HcO3)", type: "range" },
	{ name: "Phosphorus", type: "range" },

	// Cerebrospinal Fluid Test (Lumbar Puncture)
	{ name: "CSF - Pressure", type: "range" },
	{ name: "CSF - Cell Count", type: "range" },
	{ name: "CSF - Glucose", type: "range" },
	{ name: "CSF - Protein", type: "range" },

	// Liver function tests
	{ name: "Aminotransferase, alanine (ALT)", type: "range" },
	{ name: "Aminotransferase, aspartate (AST)", type: "range" },
	{ name: "Total Bilirubin", type: "range" },
	{ name: "Direct Bilirubin", type: "range" },
	{ name: "Creatinine", type: "range" },

	// Hematology / Blood Tests
	{ name: "Haemoglobin (HB)", type: "range", units: "g/L" },
	{ name: "White Cell Count (WBC)", type: "range", units: "x10^9/L" },
	{ name: "Platelet Count (PLT)", type: "range", units: "x10^9/L" },
	{ name: "Red Blood Count (RBC)", type: "range", units: "x10^12/L" },
	{ name: "Mean Cell Volume (MCV)", type: "range", units: "fl" },
	{
		name: "Packed Cell Volume (PCV)/Haematocrit (HCT)",
		type: "range",
		units: "L/L",
	},
	{ name: "Mean Cell Haemoglobin (MCH)", type: "range", units: "fmol/cell" },
	{
		name: "Mean Cell Haemoglobin Concentration (MCHC)",
		type: "range",
		units: "g/L",
	},
	{ name: "Neutrophil Count", type: "range", units: "x10^9/L" },
	{ name: "Lymphocyte Count", type: "range", units: "x10^9/L" },
	{ name: "Monocyte Count", type: "range", units: "x10^9/L" },
	{ name: "Eosinophil Count", type: "range", units: "x10^9/L" },
	{ name: "Basophil Count", type: "range", units: "x10^9/L" },
	{
		name: "Erythrocyte Sedimentation Rate (ESR)",
		type: "range",
		units: "mm/hr",
	},
	{ name: "Reticulocytes", type: "range", units: "%" },
	{ name: "PT", type: "range", units: "Secs" },
	{ name: "INR", type: "range" },
	{ name: "APTT", type: "range" },
	{ name: "Fibrinogen", type: "range" },
	{ name: "Antithrombin Activity", type: "range" },
	{ name: "Protein S Free Antigen", type: "range" },
	{ name: "Protein C Activity", type: "range" },
	{ name: "Activated Protein C Resistance (APCR)", type: "range" },
	{ name: "Lupus Anticoagulant", type: "range" },
	{ name: "FDPs", type: "range" },
	{ name: "Factor VIII", type: "range" },
	{ name: "Factor IX", type: "range" },
	{ name: "C-Reactive protein, blood", type: "range", units: "mg/dL" },
	{ name: "Glucose, plasma—fasting", type: "range" },
	{ name: "Iron, serum", type: "range", units: "mcg/dL" },

	// other
	{ name: "HPV Test", type: "boolean" },
	{ name: "Chlamydia Rapid Test", type: "boolean" },
	{ name: "H-Pylori Stool Test", type: "normality", withDescription: true },
	{ name: "Systolic Blood Pressure", type: "range", units: "mmHG" },
	{ name: "Diastolic Blood Pressure", type: "range", units: "mmHG" },
	{ name: "Lactate dehydrogenase (LDH) test", type: "range" },
	{ name: "Pregnancy Test", type: "boolean" },
	{ name: "Oxygen Saturation", type: "normality", withDescription: true },
	{ name: "High Vaginal Swab (HVS)", type: "normality", withDescription: true },

	//
	{ name: "Stool Analysis", type: "normality", withDescription: true },
	{ name: "Urinalysis - Acidity", type: "range" },
	{ name: "Urinalysis - Concentration", type: "range" },
	{ name: "Urinalysis - Protein", type: "range" },
	{ name: "Urinalysis - Sugar", type: "range" },
	{ name: "Urinalysis - Ketones", type: "range" },
	{ name: "Urinalysis - Bilirubin", type: "range" },
	{ name: "Urinalysis - Leukocytes", type: "range" },
	{ name: "Urinalysis - Blood", type: "boolean" },
	{ name: "Urine Culture", type: "boolean" },
];

// FIXME: There is a duplicate of creatinine
// FIXME: The investigations need to be updated to support panel/battery tests
// FIXME: Blood pressure needs systolic and diastolic

export const normalityRangeItems = ["high", "normal", "low"];

export const inputInvestigations = investigations.map((value: unknown, _) => {
	const v = value as investigation;
	return {
		...v,
		result: {
			value: "",
			description: "",
		},
	};
});
