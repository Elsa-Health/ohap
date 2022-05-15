import { test, expect } from "@playwright/test";

test("test", async ({ page }) => {
	// Go to http://localhost:3000/
	await page.coverage.startJSCoverage();
	await page.goto("http://localhost:3000/");

	// Click text=Explore Disease Models
	await page.locator("text=Explore Disease Models").click();
	await expect(page).toHaveURL("http://localhost:3000/explore-models");

	// Click div.model-item
	await page.locator(":nth-match(div.model-item, 1)").click();
	// await expect(page).toHaveURL("http://localhost:3000/condition/**/*");

	// Click text=Download
	const [download] = await Promise.all([
		page.waitForEvent("download"),
		page.locator("text=Download").click(),
	]);
});
