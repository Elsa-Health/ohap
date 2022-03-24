import type {
	Beta,
	Sex,
	Normal,
	Cauchy,
	Change,
	Categorical,
	Weibull,
	Onset,
	BetaCombinationRule,
	Symptom,
} from "@elsa-health/model-runtime";

type CauchyTimeToOnset = {
	location: number;
	scale: number;
};

type Condition = {
	name: string;
};
