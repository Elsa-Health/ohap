import _, { random } from "lodash";
import { distributions } from "@elsa-health/model-runtime";

const { createCategorical, createCauchy, createNormal } = distributions;

const symptoms: string[] = [
  "fever",
  "cough",
  "sore throat",
  "jaundice",
  "headache",
  "chills",
  "dyspnoea",
];

export const randomSymptom = (name: string): Symptom => {
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
    duration,
    onset: {
      name: "onset",
      ns: ["gradual", "sudden"],
      ps: [rand, 1 - rand],
    },
    nature: [],
    periodicity: { name: "periodicity", ps: [], ns: [] },
    aggravators: [],
    relievers: [],
    timeToOnset: {
      location: random(duration.threshold, duration.threshold + 3),
      scale: Math.max(1, random(0, duration.threshold)),
    },
  };
};

export const getSymptomTemplate = (): Symptom => ({
  name: "",
  locations: [],
  duration: createNormal("duration", 1, 1),
  onset: createCategorical("onset", ["gradual", "sudden"], [0.5, 0.5]),
  nature: [],
  periodicity: createCategorical("periodicity", [], []),
  aggravators: [],
  relievers: [],
  timeToOnset: createCauchy("timeToOnset", 1, 1),
});

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
  return _.upperFirst(name.split("-").join(" "));
};

export const toggleCondition = (
  conditions: Condition[],
  condition: Condition
) => {
  const condIdx = conditions.findIndex((c) => c.name === condition.name);
  if (condIdx > -1) {
    return conditions.filter((c) => c.name !== condition.name);
  }
  return [...conditions, condition];
};
