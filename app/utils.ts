import _, { random } from "lodash";
import { distributions } from "@elsa-health/model-runtime";
import * as T from "@elsa-health/model-runtime";

const { createCategorical, createCauchy, createNormal, createBeta } =
	distributions;

const symptoms: string[] = [
	"fever",
	"cough",
	"sore throat",
	"jaundice",
	"headache",
	"chills",
	"dyspnoea",
];

export const randomSymptom = (name: string): T.Symptom => {
	const rand = Math.random();
	const duration = {
		name: "duration",
		threshold: random(1, 8),
		shape: random(8, 15),
		scale: random(8, 14),
	};
	return {
		name,
		locations: [],
		sex: {
			male: createBeta("male", 10, 90),
			female: createBeta("female", 10, 90),
		},
		duration,
		onset: createCategorical("onset", ["gradual", "sudden"], [rand, 1 - rand]),
		nature: [],
		periodicity: createCategorical("periodicity", [], []),
		aggravators: [],
		relievers: [],
		timeToOnset: createCauchy(
			"timeToOnset",
			random(duration.threshold, duration.threshold + 3),
			Math.max(1, random(0, duration.threshold))
		),
		// {
		// 	location: random(duration.threshold, duration.threshold + 3),
		// 	scale: Math.max(1, random(0, duration.threshold)),
		// },
	};
};

export const getSymptomTemplate = (): T.Symptom => ({
	name: "",
	locations: [],
	sex: {
		male: createBeta("male", 100, 1),
		female: createBeta("female", 100, 1),
	},
	age: {
		newborn: createBeta("newborn", 100, 1),
		adolescent: createBeta("adolescent", 100, 1),
		infant: createBeta("infant", 100, 1),
		toddler: createBeta("toddler", 100, 1),
		child: createBeta("child", 100, 1),
		youngAdult: createBeta("youngAdult", 100, 1),
		adult: createBeta("adult", 100, 1),
		senior: createBeta("senior", 100, 1),
	},
	duration: createNormal("duration", 1, 1),
	onset: createCategorical("onset", ["gradual", "sudden"], [0.5, 0.5]),
	nature: [],
	periodicity: createCategorical("periodicity", [], []),
	aggravators: [],
	relievers: [],
	timeToOnset: createCauchy("timeToOnset", 1, 1),
});

export const humanFriendlyModel = (
	model: T.ConditionModel
): T.ConditionModel => {
	const symptoms: T.Symptom[] = model.symptoms.map((s) => softenSingleBeta(s));

	symptoms.map((sy) => {
		return {
			...sy,
		};
	});
	return {
		...model,
	};
};

export const formatFriendlyModel = (
	model: T.ConditionModel
): T.ConditionModel => {
	return { ...model };
};

export const formatFriendlySymptom = (symptom: T.Symptom): T.Symptom => {
	return {
		...symptom,
		periodicity: {
			...symptom.periodicity,
			ps: rescaleList(symptom.periodicity.ps),
		},
	};
};

export const searchForSymptom =
	(symptomsList: Record<string, any>[]) =>
	(resultsCount = 4) =>
	(name: string) => {
		return symptomsList
			.filter(
				(sy) =>
					sy.symptom.includes(name.toLowerCase()) ||
					sy.tags.filter((t) => t.includes(name.toLowerCase())).length > 0
			)
			.slice(0, resultsCount);
	};

export const friendlySymptomName = (name: string) => {
	return camelToText(_.upperFirst(name.split("-").join(" ")));
};

export const toggleCondition = (
	conditions: T.Condition[],
	condition: T.Condition
) => {
	const condIdx = conditions.findIndex((c) => c.name === condition.name);
	if (condIdx > -1) {
		return conditions.filter((c) => c.name !== condition.name);
	}
	return [...conditions, condition];
};

function softenSingleBeta(rv: T.Beta | any) {
	if (rv?._.dist === "beta" && (rv?.alpha <= 0 || rv.beta <= 0)) {
		return { ...rv, alpha: rv.alpha + 0.01, beta: rv.beta + 0.01 };
	}

	return rv;
}

export function softenSymptomBetas(symptoms: T.Symptom[]): T.Symptom[] {
	return symptoms.map((sy) => ({
		...sy,
		sex: _.fromPairs(
			Object.keys(sy.sex).map((sx) => [sx, softenSingleBeta(sy.sex[sx])])
		),
		age: _.fromPairs(
			Object.keys(sy.age).map((ag) => [ag, softenSingleBeta(sy.age[ag])])
		),
		aggravators: sy.aggravators.map(softenSingleBeta),
		relievers: sy.relievers.map(softenSingleBeta),
		nature: sy.nature.map(softenSingleBeta),
	}));
}

// function to convert came case to normal text using the camelEdges
const camelEdges =
	/([A-Z](?=[A-Z][a-z])|[^A-Z](?=[A-Z])|[a-zA-Z](?=[^a-zA-Z]))/g;
export function camelToText(camel: string) {
	let text = camel.replace(camelEdges, "$1 ");
	return text.charAt(0).toUpperCase() + text.slice(1);
}

export function normalizeList(min: number, max: number, list: number[]) {
	const largest = Math.max(...list);
	const smallest = Math.min(...list);
	const range = max - min;

	return list.map((v) => ((v - smallest) / (largest - smallest)) * range + min);
}

// Rescale a list of value given a min and a max
export function rescaleList(list: number[]) {
	const sum = list.reduce((a, b) => a + b, 0);
	return list.map((v) => v / sum);
}

// Return a list with the new
export const toggleStringList =
	(list: string[]) =>
	(value: string): string[] => {
		if (list.includes(value)) {
			return list.filter((li) => li !== value);
		}
		return [...list, value];
	};

export function adjust(color: string, amount: number): string {
	return (
		"#" +
		color
			.replace(/^#/, "")
			.replace(/../g, (color) =>
				(
					"0" +
					Math.min(255, Math.max(0, parseInt(color, 16) + amount)).toString(16)
				).substr(-2)
			)
	);
}
