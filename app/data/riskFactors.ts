const riskFactors = [
	{ name: "smoking", tags: ["cigarretes"] },
	{ name: "alcohol-consumption", tags: ["drinking", "alcohol", "drunk"] },
	{ name: "immunocompromised", tags: ["hiv", "immunity"] },
	{ name: "men-who-have-sex-with-men", tags: ["homosexual"] },
	{ name: "diabetic", tags: ["diabetes", "sugar"] },
	{ name: "hypertensive", tags: ["hypertension", "blood", "pressure"] },
	{ name: "infected-person-contact", tags: ["exposure"] },
	{ name: "high-colesterol", tags: ["colesterol", "obesity"] },
	{ name: "unhygenic-living-conditions", tags: ["environment"] },
	{ name: "obesity", tags: ["overweight", "weight", "cholesterol"] },
	{ name: "family-history", tags: ["genetic", "family", "inherit"] },
	{ name: "substance-abuse", tags: ["drugs"] },
	{ name: "organ-transplant", tags: ["transplant", "surgery"] },
	{ name: "sedentary-lifestyle", tags: ["sitting"] },
	{ name: "crowded-living conditions", tags: ["overcrowding", "crowds"] },
	{ name: "livestock-proximity", tags: ["cattle", "farm", "livestock"] },
	{ name: "no-mosquito-net", tags: ["mosquito", "malaria", "net"] },
	{ name: "pregnancy", tags: ["pregnant"] },
	{ name: "extended-antibiotic-use", tags: ["antibiotics", "medication"] },
	{ name: "aids", tags: ["hiv", "immunocompromised", "immunity"] },
];

export function getFactorByName(name: string) {
	return riskFactors.find((r) => r.name === name) || {};
}

export default riskFactors;
