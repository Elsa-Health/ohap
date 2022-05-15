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

type DatasetType = "vignette" | "tabular" | "images" | "video";

type DateTimeString = string;

type Dataset = {
	ownerId: string;
	name: string;
	description: string;
	homepage: string;
	repository: string;
	paper: string;
	contact: {
		email: string;
		name: string;
		organization: string;
	};
	datasetType: DatasetType;
	language: string;
	collectionPeriod: {
		start: DateTimeString;
		end: DateTimeString;
	};
	countries: string[];
	license: string;
	tags: string[];
	owner: {
		name: string;
		email: string;
		address: string;
		website: string;
	};

	// Descriptions
	annotationProcess: string;
	sensitiveInformation: string;
	socialImpact: string;
	biases: string;
	knownLimitations: string;
	citation: string;

	// Actual data
	data: {
		url: "";
		vignettes: [];
	};

	// Timestamps
	createdAt: Date;
	updatedAt: Date;
};

// The type of resource
type resourceType = "model" | "dataset";

type invitationStatus = "accepted" | "pending";

type invitationRole = "owner" | "contributor";

// Inviting a collaborator to a model/dataset/resource
type Invitation = {
	// Mongodb id
	_id: string;

	// About the invitee
	email: string;

	// Aboout the sender of the invite
	senderId: string;
	senderEmail: string;

	// About the invitation
	status: invitationStatus;
	role: invitationRole;

	// About the resource
	resourceId: string;
	resourceName: string;
	resourceType: "model" | "dataset";

	// Timestamps
	createdAt: Date;
	updatedAt: Date;
};

type Contributor = {
	email: string;
	id: string;
	status: invitationStatus;
	role: invitationRole;
	createdAt: Date;
	updatedAt: Date;
};
