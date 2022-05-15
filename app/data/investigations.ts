export type investigation2 = {
	label?: string;
	value?: string;
	name: string;
	type: "boolean" | "number" | "range" | "normality" | "options";
	result: {
		value: string;
		description: string;
	};
};

type metadata =
	| {
			isPanel: false;
	  }
	| {
			isPanel: true;
			panel: string;
			panelAlias: string;
	  };

type investigation =
	| {
			name: string;
			withDescription?: boolean;
			type: "boolean" | "range" | "normality";
			units?: string;
			_: metadata;
	  }
	| {
			name: string;
			withDescription?: boolean;
			options: string[];
			type: "options";
			units?: string;
			_: metadata;
	  }
	| {
			name: string;
			withDescription?: boolean;
			type: "number";
			units: string;
			_: metadata;
	  };

export const investigations: Array<investigation> = [
	{ name: "Rapid Test (MRDT)", type: "boolean", _: { isPanel: false } },
	{ name: "Blood Slide", type: "boolean", _: { isPanel: false } },
	{
		name: "CD4 Count",
		type: "number",
		units: "cells/mm3",
		_: { isPanel: false },
	},
	{
		name: "Viral load",
		type: "number",
		units: "cells/mm3",
		_: { isPanel: false },
	},
	{ name: "HIV Rapid Test", type: "boolean", _: { isPanel: false } },
	{ name: "CrAg", type: "boolean", _: { isPanel: false } },
	{
		name: "Hepatitis B surface antigen (HBsAg)",
		type: "boolean",
		_: { isPanel: false },
	},
	{
		name: "Hepatitis B e-Antigen (HbeAg)",
		type: "boolean",
		_: { isPanel: false },
	},

	// Imaging
	{
		name: "X-Ray",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},
	{
		name: "MRI",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},
	{
		name: "CT Scan",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},

	// TB
	{ name: "Xpert MTB/ RIF", type: "boolean", _: { isPanel: false } },
	{ name: "Mantoux / PPD (Skin Test)", type: "boolean", _: { isPanel: false } },

	// Bacterial / Viral Infections
	{ name: "Sputum Culture", type: "boolean", _: { isPanel: false } },
	{ name: "Sputum Smear", type: "boolean", _: { isPanel: false } },
	{ name: "Sputum PCR", type: "boolean", _: { isPanel: false } },
	{ name: "CSF Culture", type: "boolean", _: { isPanel: false } },
	{
		name: "Microscopy of CSF - India Ink Staining",
		type: "boolean",
		_: { isPanel: false },
	},
	{ name: "Blood Culture", type: "boolean", _: { isPanel: false } },

	// fungal infection
	{ name: "1-2-Beta-D-glucan", type: "boolean", _: { isPanel: false } },

	// Urinalysis
	{
		name: "Color",
		type: "options",
		options: ["yellow", "amber", "red", "blue", "clear", "straw"],
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Appearance",
		type: "options",
		options: ["clear", "cloudy", "slightly cloudy", "turbid"],
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Specific Gravity",
		type: "number",
		units: "",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "pH",
		type: "number",
		units: "pH",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Glucose",
		type: "number",
		units: "pH",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Bilirubin",
		type: "number",
		units: "pH",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Ketones",
		type: "number",
		units: "mg/dL",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Occult Blood",
		type: "number",
		units: "mg/dL",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Protein",
		type: "range",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Nitrate",
		type: "number",
		units: "mg/dL",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Leukocyte Esterase",
		type: "boolean",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "White blood cell count",
		type: "number",
		units: "/HPF",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Red blood cell count",
		type: "number",
		units: "/HPF",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Urine Squamous Epithelial Cells",
		type: "number",

		units: "/HPF",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},
	{
		name: "Ascorbic Acid",
		type: "number",
		units: "mg/dL",
		_: { isPanel: true, panel: "Urinalysis", panelAlias: "Urinalysis" },
	},

	// clinical chemistry
	{ name: "Potassium (K+)", type: "range", _: { isPanel: false } },
	{ name: "Sodium (Na+)", type: "range", _: { isPanel: false } },
	{ name: "Magnesium (Mg+)", type: "range", _: { isPanel: false } },
	{ name: "Chloride (Cl-)", type: "range", _: { isPanel: false } },
	{ name: "Bicarbonate (HcO3)", type: "range", _: { isPanel: false } },
	{ name: "Phosphorus", type: "range", _: { isPanel: false } },

	// Cerebrospinal Fluid Test (Lumbar Puncture)
	{
		name: "Pressure",
		type: "range",
		_: {
			isPanel: true,
			panel: "Cerebrospinal Fluid Test (CSF)",
			panelAlias: "CSF",
		},
	},
	{
		name: "Cell Count",
		type: "range",
		_: {
			isPanel: true,
			panel: "Cerebrospinal Fluid Test (CSF)",
			panelAlias: "CSF",
		},
	},
	{
		name: "Glucose",
		type: "range",
		_: {
			isPanel: true,
			panel: "Cerebrospinal Fluid Test (CSF)",
			panelAlias: "CSF",
		},
	},
	{
		name: "Protein",
		type: "range",
		_: {
			isPanel: true,
			panel: "Cerebrospinal Fluid Test (CSF)",
			panelAlias: "CSF",
		},
	},

	// Liver function tests
	{
		name: "Aminotransferase, alanine (ALT)",
		type: "range",
		_: {
			isPanel: true,
			panel: "Liver Function Test (LFT)",
			panelAlias: "LFT",
		},
	},
	{
		name: "Aminotransferase, aspartate (AST)",
		type: "range",
		_: {
			isPanel: true,
			panel: "Liver Function Test (LFT)",
			panelAlias: "LFT",
		},
	},
	{
		name: "Total Bilirubin",
		type: "range",
		_: {
			isPanel: true,
			panel: "Liver Function Test (LFT)",
			panelAlias: "LFT",
		},
	},
	{
		name: "Direct Bilirubin",
		type: "range",
		_: {
			isPanel: true,
			panel: "Liver Function Test (LFT)",
			panelAlias: "LFT",
		},
	},
	{
		name: "Creatinine",
		type: "range",
		_: {
			isPanel: true,
			panel: "Liver Function Test (LFT)",
			panelAlias: "LFT",
		},
	},

	// Hematology / Blood Tests
	{
		name: "Haemoglobin (HB)",
		type: "range",
		units: "g/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "White Cell Count (WBC)",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Platelet Count (PLT)",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Red Blood Count (RBC)",
		type: "range",
		units: "x10^12/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Mean Cell Volume (MCV)",
		type: "range",
		units: "fl",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Packed Cell Volume (PCV)/Haematocrit (HCT)",
		type: "range",
		units: "L/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Mean Cell Haemoglobin (MCH)",
		type: "range",
		units: "fmol/cell",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Mean Cell Haemoglobin Concentration (MCHC)",
		type: "range",
		units: "g/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Neutrophil Count",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Lymphocyte Count",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Monocyte Count",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Eosinophil Count",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Basophil Count",
		type: "range",
		units: "x10^9/L",
		_: { isPanel: true, panel: "Complete Blood Count", panelAlias: "CBC" },
	},
	{
		name: "Erythrocyte Sedimentation Rate (ESR)",
		type: "range",
		_: { isPanel: false },
		units: "mm/hr",
	},
	{ name: "Reticulocytes", type: "range", _: { isPanel: false }, units: "%" },
	{ name: "PT", type: "range", _: { isPanel: false }, units: "Secs" },
	{ name: "INR", type: "range", _: { isPanel: false } },
	{ name: "APTT", type: "range", _: { isPanel: false } },
	{ name: "Fibrinogen", type: "range", _: { isPanel: false } },
	{ name: "Antithrombin Activity", type: "range", _: { isPanel: false } },
	{ name: "Protein S Free Antigen", type: "range", _: { isPanel: false } },
	{ name: "Protein C Activity", type: "range", _: { isPanel: false } },
	{
		name: "Activated Protein C Resistance (APCR)",
		type: "range",
		_: { isPanel: false },
	},
	{ name: "Lupus Anticoagulant", type: "range", _: { isPanel: false } },
	{ name: "FDPs", type: "range", _: { isPanel: false } },
	{ name: "Factor VIII", type: "range", _: { isPanel: false } },
	{ name: "Factor IX", type: "range", _: { isPanel: false } },
	{
		name: "C-Reactive protein, blood",
		type: "range",
		_: { isPanel: false },
		units: "mg/dL",
	},
	{ name: "Glucose, plasma—fasting", type: "range", _: { isPanel: false } },
	{
		name: "Iron, serum",
		type: "range",
		_: { isPanel: false },
		units: "mcg/dL",
	},

	// Lipid panel / Lipid profile test
	{
		name: "Total Cholesterol",
		type: "range",
		units: "mg/dL",
		_: { isPanel: true, panel: "Lipid Panel", panelAlias: "Lipid Panel" },
	},
	{
		name: "High-density lipoprotein cholesterol (HDL)",
		type: "range",
		units: "mg/dL",
		_: { isPanel: true, panel: "Lipid Panel", panelAlias: "Lipid Panel" },
	},
	{
		name: "Low-density lipoprotein cholesterol (LDL)",
		type: "range",
		units: "mg/dL",
		_: { isPanel: true, panel: "Lipid Panel", panelAlias: "Lipid Panel" },
	},
	{
		name: "Very low-density lipoprotein choesterol (VLDL)",
		type: "range",
		units: "mg/dL",
		_: { isPanel: true, panel: "Lipid Panel", panelAlias: "Lipid Panel" },
	},
	{
		name: "Triglycerides",
		type: "range",
		units: "mg/dL",
		_: { isPanel: true, panel: "Lipid Panel", panelAlias: "Lipid Panel" },
	},

	// other
	{ name: "HPV Test", type: "boolean", _: { isPanel: false } },
	{ name: "Chlamydia Rapid Test", type: "boolean", _: { isPanel: false } },
	{
		name: "H-Pylori Stool Test",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},
	{
		name: "Systolic Blood Pressure",
		type: "range",
		units: "mmHG",
		_: { isPanel: false },
	},
	{
		name: "Diastolic Blood Pressure",
		type: "range",
		units: "mmHG",
		_: { isPanel: false },
	},
	{
		name: "Lactate dehydrogenase (LDH) test",
		type: "range",
		_: { isPanel: false },
	},
	{ name: "Pregnancy Test", type: "boolean", _: { isPanel: false } },
	{
		name: "Oxygen Saturation",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},
	{
		name: "High Vaginal Swab (HVS)",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},

	//
	{
		name: "Stool Analysis",
		type: "normality",
		withDescription: true,
		_: { isPanel: false },
	},
	{
		name: "Calcium",
		type: "range",
		_: { isPanel: false },
	},
	{
		name: "Creatinine",
		type: "range",
		_: { isPanel: false },
	},
	{
		name: "Protein-creatinine ratio",
		type: "range",
		_: { isPanel: false },
	},
	{
		name: "Uric acid",
		type: "number",
		units: "mg/24 h",
		_: { isPanel: false },
	},
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
