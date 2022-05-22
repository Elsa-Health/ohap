const fs = require("fs/promises");
const path = require("path");
require("dotenv").config();

// Replace env variable with placeholder before commit
async function cleanRealmAccess() {
	const { REALM_APP_ID } = process.env;
	try {
		const realmPath = path.join(__dirname, "..", "app", "realm.ts");
		const data = await fs.readFile(realmPath, { encoding: "utf8" });

		const newFile = data
			.split("\n")
			.map((line) => {
				if (line.includes("const realm_app_id = ")) {
					return "const realm_app_id = process.env.REALM_APP_ID;";
				} else if (line.includes("const CLUSTER_NAME =")) {
					return "const CLUSTER_NAME = process.env.CLUSTER_NAME;";
				} else if (line.includes("const DB_NAME = ")) {
					return "const DB_NAME = process.env.DB_NAME;";
				}
				return line;
			})
			.join("\n");
		await fs.writeFile(realmPath, newFile, "utf8");
	} catch (err) {
		console.log(err);
	}
}

cleanRealmAccess();
