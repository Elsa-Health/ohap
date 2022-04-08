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

type investigation = {
	name: string;
	withDescription?: boolean;
	type: "boolean" | "number" | "range" | "normality";
};

export const investigations: Array<investigation> = [
	{ name: "Rapid Test (MRDT)", type: "boolean" },
	{ name: "Blood Slide", type: "boolean" },
	{ name: "CD4 Count", type: "number" },
	{ name: "Viral load", type: "number" },
	{ name: "HIV Rapid Test", type: "boolean" },
	{ name: "CrAg", type: "boolean" },
	{ name: "Hepatitis B surface antigen (HBsAg)", type: "boolean" },
	{ name: "Hepatitis B e-Antigen (HbeAg)", type: "boolean" },

	// Imaging
	{ name: "X-Ray", type: "normality" },
	{ name: "MRI", type: "normality" },
	{ name: "CT Scan", type: "normality" },

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
	{ name: "Haemoglobin (HB)", type: "range" },
	{ name: "White Cell Count (WBC)", type: "range" },
	{ name: "Platelet Count (PLT)", type: "range" },
	{ name: "Red Blood Count (RBC)", type: "range" },
	{ name: "Mean Cell Volume (MCV)", type: "range" },
	{ name: "Packed Cell Volume (PCV)/Haematocrit (HCT)", type: "range" },
	{ name: "Mean Cell Haemoglobin (MCH)", type: "range" },
	{ name: "Mean Cell Haemoglobin Concentration (MCHC)", type: "range" },
	{ name: "Neutrophil Count", type: "range" },
	{ name: "Lymphocyte Count", type: "range" },
	{ name: "Monocyte Count", type: "range" },
	{ name: "Eosinophil Count", type: "range" },
	{ name: "Basophil Count", type: "range" },
	{ name: "Erythrocyte Sedimentation Rate (ESR)", type: "range" },
	{ name: "Reticulocytes", type: "range" },
	{ name: "PT", type: "range" },
	{ name: "INR", type: "range" },
	{ name: "APTT", type: "range" },
	{ name: "Fibrinogen", type: "range" },
	{ name: "Antithrombin Activity", type: "range" },
	{ name: "Protein S Free Antigen", type: "range" },
	{ name: "Protein C Activity", type: "range" },
	{ name: "Lupus Anticoagulant", type: "range" },
	{ name: "Activated Protein C Resistance (APCR)", type: "range" },
	{ name: "Lupus Anticoagulant", type: "range" },
	{ name: "FDPs", type: "range" },
	{ name: "Factor VIII", type: "range" },
	{ name: "Factor IX", type: "range" },
	{ name: "C-Reactive protein, blood", type: "range" },
	{ name: "Iron, serum", type: "range" },
	{ name: "Glucose, plasma—fasting", type: "range" },
	{ name: "Iron, serum", type: "range" },

	// other
	{ name: "HPV Test", type: "boolean" },
	{ name: "Chlamydia Rapid Test", type: "boolean" },
	{ name: "H-Pylori Stool Test", type: "normality" },
	{ name: "Blood Pressure", type: "range" },
	{ name: "Lactate dehydrogenase (LDH) test", type: "range" },
	{ name: "Pregnancy Test", type: "boolean" },
	{ name: "Oxygen Saturation", type: "normality" },
	{ name: "High Vaginal Swab (HVS)", type: "normality" },

	//
	{ name: "Stool Analysis", type: "normality" },
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
