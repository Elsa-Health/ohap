import * as Realm from "realm-web";

const id = "xxxx";
const DB = "xxxx";
const DB_NAME = "xxxx";

export const app = new Realm.App({ id });
export default Realm;

// Authenticate all users as anonymous by default
export const ensureLoggedIn = async (app) => {
	console.log("called", app.currentUser);
	if (app.currentUser === null) {
		const res = await loginAnonymous();
		return res;
	}
	return app.currentUser;
};

// IFFE to await login for everyone
(async function () {
	await ensureLoggedIn(app);
})();

// console.log("REALM: ", Realm, app);

const mongodb = app.currentUser?.mongoClient(DB);
export const modelsDb = mongodb?.db(DB_NAME)?.collection("models");
export const conditionsDb = mongodb?.db(DB_NAME)?.collection("conditions");

export const commentsDb = mongodb?.db(DB_NAME)?.collection("comments");
export const datasetsDb = mongodb?.db(DB_NAME)?.collection("datasets");

export const userDataDb = mongodb?.db(DB_NAME)?.collection("user-data");

export const invitationsDb = mongodb?.db(DB_NAME)?.collection("invitations");

export async function loginAnonymous() {
	if (app.currentUser !== null) {
		return;
	}
	console.log("Creating anon user");
	// Create an anonymous credential
	const credentials = Realm.Credentials.anonymous();
	try {
		// Authenticate the user
		const user = await app.logIn(credentials);
		return user;
	} catch (err) {
		console.error("Failed to log in", err);
	}
}

// app.currennottUser.isLoggedIn
// app.currentUser.profile
// app.currentUser.isLoggedIn
// app.currentUser.id
// app.currentUser.profile.email

// modelsDb.findOne({_id: "61ee74703dcfba9bb366f494"})

// modelsDb.updateOne({ _id: "" }, {$set: { ...conditionModel }})
