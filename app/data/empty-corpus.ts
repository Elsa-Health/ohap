import { Dataset } from "../types";

const CORPUS_TEMPLATE: Dataset = {
	ownerId: "",
	name: "",
	description: "",
	homepage: "",
	datasetType: "tabular", // "vignette" or "tabular" or "images" or "video",
	repository: "",
	paper: "",

	collectionPeriod: {
		start: new Date().toDateString(),
		end: new Date().toDateString(),
	},
	language: "english",
	countries: [],
	license: "",
	tags: [],
	contact: {
		email: "",
		name: "",
		organization: "",
	},
	owner: {
		name: "",
		email: "",
		address: "",
		website: "",
	},

	// Descriptions
	annotationProcess: "",
	sensitiveInformation: "",
	socialImpact: "",
	biases: "",
	knownLimitations: "",
	citation: "",

	data: {
		url: "",
		vignettes: [],
	},

	createdAt: new Date(),
	updatedAt: new Date(),
};

const getCorpusTemplate = (): Dataset => {
	return {
		...CORPUS_TEMPLATE,
		collectionPeriod: {
			start: new Date().toDateString(),
			end: new Date().toDateString(),
		},
		createdAt: new Date(),
		updatedAt: new Date(),
	};
};

export { CORPUS_TEMPLATE, getCorpusTemplate };
