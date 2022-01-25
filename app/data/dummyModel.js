export const dummyModel = {
  condition: "tinea-nigra",
  symptoms: [
    {
      name: "cough",
      locations: [],
      duration: {
        name: "duration",
        mean: 1825,
        sd: 1,
        _: {
          dist: "normal",
        },
        variance: 4,
      },
      onset: {
        name: "onset",
        ps: [0.5, 0.5],
        ns: ["gradual", "sudden"],
        _: {
          dist: "categorical",
        },
      },
      nature: [
        {
          name: "dry",
          alpha: 80,
          beta: 20,
          _: {
            dist: "beta",
          },
        },
        {
          name: "jelly-like-sputum",
          alpha: 1,
          beta: 1,
          _: {
            dist: "beta",
          },
        },
      ],
      periodicity: {
        name: "periodicity",
        ps: [null, 0.25, 0.25, 0.5],
        ns: ["morning", "night", "intermittent", "non-specific"],
        _: {
          dist: "categorical",
        },
      },
      aggravators: [
        {
          name: "dust",
          alpha: 1,
          beta: 1,
          _: {
            dist: "beta",
          },
        },
        {
          name: "pollen",
          alpha: 1,
          beta: 1,
          _: {
            dist: "beta",
          },
        },
        {
          name: "smoke",
          alpha: 1,
          beta: 1,
          _: {
            dist: "beta",
          },
        },
        {
          name: "laying-down",
          alpha: 1,
          beta: 1,
          _: {
            dist: "beta",
          },
        },
      ],
      relievers: [
        {
          name: "antihistamines",
          alpha: 1100,
          beta: 10,
          _: {
            dist: "beta",
          },
        },
      ],
      timeToOnset: {
        name: "timeToOnset",
        location: 2.5,
        scale: 1.5,
        _: {
          dist: "cauchy",
        },
      },
    },
    {
      name: "fever",
      locations: [],
      duration: {
        name: "duration",
        mean: 17,
        sd: 1,
        _: {
          dist: "normal",
        },
        variance: 3,
      },
      onset: {
        name: "onset",
        ps: [0.85, 0.15],
        ns: ["gradual", "sudden"],
        _: {
          dist: "categorical",
        },
      },
      nature: [
        {
          name: "low-grade",
          alpha: 10,
          beta: 90,
          _: {
            dist: "beta",
          },
        },
        {
          name: "high-grade",
          alpha: 90,
          beta: 10,
          _: {
            dist: "beta",
          },
        },
      ],
      periodicity: {
        name: "periodicity",
        ps: [0.1, 0, 0.8, 0, 0, 0.1, 0],
        ns: [
          "persistent",
          "intermittent",
          "relapsing",
          "step-ladder",
          "remittent",
          "non-specific",
          "night",
        ],
        _: {
          dist: "categorical",
        },
      },
      aggravators: [
        {
          name: "pollen",
          alpha: 10,
          beta: 90,
          _: {
            dist: "beta",
          },
        },
        {
          name: "crying",
          alpha: 10,
          beta: 90,
          _: {
            dist: "beta",
          },
        },
        {
          name: "light-activity",
          alpha: 1,
          beta: 99,
          _: {
            dist: "beta",
          },
        },
        {
          name: "cold-weather",
          alpha: 2,
          beta: 98,
          _: {
            dist: "beta",
          },
        },
      ],
      relievers: [
        {
          name: "antipyretics",
          alpha: 1000,
          beta: 10,
          _: {
            dist: "beta",
          },
        },
      ],
      timeToOnset: {
        name: "timeToOnset",
        location: 7,
        scale: 3,
        _: {
          dist: "cauchy",
        },
      },
    },
  ],
  signs: [],
};
