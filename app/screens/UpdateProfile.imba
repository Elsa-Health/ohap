import { SimpleInput } from '../components/simple-input'
import {countriesList} from "../data/countries.ts"
# @ts-expect-error
import Realm, {app, userDataDb} from "../realm.ts"

let loading = false;

let username = ""
let profession = ""
let country = ""

export tag UpdateProfile
	def mount
		if app.currentUser === null
			return window.location.href = "/"

		# consoleapp.currentUser.customData
		app.currentUser.refreshCustomData()
		const cd = app.currentUser.customData
		
		username = cd.username || ""
		proession = cd.proession || ""
		country = cd.country || ""

		tick!


	def submit e
		e.preventDefault();

		if app.currentUser === null
			return alert("You are not authenticated.")
		
		loading = true

		const confirmation = window.confirm "Please confirm your username, profession and country."

		if (!confirmation)
			loading = false
			return

		try 
			// Update the user's custom data document
			await userDataDb.updateOne(
				{ userId: app.currentUser.id },
				{ $set: { favoriteColor: "purple", username, country, profession } },
				{ upsert: true }
			);

			// Refresh the user's local customData property
			await app.currentUser.refreshCustomData();

			window.location.replace("/")
		catch error
			window.alert("Failed to sign up!")
			console.log error

			loading = false

	def render
		<self>
			<form[w:100 m:auto mt:10%] @submit=submit autocomplete="off">
				<[fs:32 ta:center mb:2]> "Sign In"
				<SimpleInput label="Username" name="username" id="username" bind=username type="text">

				<div[mt:3]>
					<label[fs:sm] htmlFor="profession"> "Profession"
					<br />
					<select[w:100% h:8 p:1 outline-color:blue5] bind=profession name="profession">
						<option value=""> "Choose your profession/qualification"
						<option value="physician"> "General Physician"
						<option value="specialist"> "Specialist"
						<option value="medica-doctor"> "Medical Doctor"
						<option value="pharmacist"> "Pharmacist"
						<option value="health-researcher"> "Health Researcher"
						<option value="medical-student"> "Medical Student"
						<option value="software-engineer"> "Software Engineer"
						<option value="ai-engineer"> "Machine Learning/AI Engineer"
						<option value="other"> "Other"

				<div[mt:3]>
					<label[fs:sm] htmlFor="profession"> "Country"
					<br />
					<select[w:100% h:8 p:1 outline-color:blue5] bind=country name="profession">
						<option value=""> "Choose your country"
						for country in countriesList
							<option> country.name

				<button[p:2 w:100% mt:6] type="button" @click=submit disabled=loading> 
					loading ? "Loading ...":"Update Profile"