const fs = require("fs/promises");
const path = require("path");
require("dotenv").config();

// Replace placeholder with environment variable
async function setRealmID() {
	const { REALM_APP_ID, CLUSTER_NAME, DB_NAME } = process.env;
	console.log(REALM_APP_ID, CLUSTER_NAME, DB_NAME);
	try {
		const realmPath = path.join(__dirname, "..", "app", "realm.ts");
		const data = await fs.readFile(realmPath, { encoding: "utf8" });
		const newFile = data
			.replace(
				/process.env.REALM_APP_ID/g,
				REALM_APP_ID ? `"${REALM_APP_ID}"` : '"process.env.REALM_APP_ID"'
			)
			.replace(
				/process.env.CLUSTER_NAME/g,
				CLUSTER_NAME ? `"${CLUSTER_NAME}"` : '"process.env.CLUSTER_NAME"'
			)
			.replace(
				/process.env.DB_NAME/g,
				DB_NAME ? `"${DB_NAME}"` : '"process.env.DB_NAME"'
			);
		await fs.writeFile(realmPath, newFile, "utf8");
	} catch (err) {
		console.log(err);
	}
}

setRealmID();
