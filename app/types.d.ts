type Sex = "male" | "female";

type Beta = {
  name: string;
  alpha: number;
  beta: number;
  type?: "beta";
};

type Normal = {
  name: string;
  mean: number;
  variance: number;
  type?: "normal";
};

type Weibull = {
  name: string;
  threshold: number;
  shape: number;
  scale: number;
  type?: "weibull";
};

type Change<T> = {
  name: string;
  from: T;
  to: T;
  duration: number;
  type?: "change";
  category: "color" | "shape" | "size" | string;
};

type Categorical = { name: string; ps: number[]; ns: string[] };

type Onset = "gradual" | "sudden";

type CauchyTimeToOnset = {
  location: number;
  scale: number;
};

type Symptom = {
  name: string;
  locations: Beta[];
  //   duration: Weibull;
  duration: Normal;
  onset: Categorical;
  nature: (Beta | Weibull | Change)[];
  periodicity: Categorical;
  aggravators: Beta[];
  relievers: Beta[];
  timeToOnset: CauchyTimeToOnset;
};

type Condition = {
  name: string;
};
