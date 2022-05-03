import { SimpleInput } from './components/simple-input'
import {countriesList} from "./data/countries.ts"
# @ts-expect-error
import Realm, {app} from "./realm.ts"

let loading = false;

let username = ""
let email = ""
let profession = ""
let country = ""
let password = ""

export tag SignIn
	def signUp
		loading = true

		const confirmation = window.confirm "Please confirm your email, password and other details"

		if (!confirmation)
			loading = false
			return

		try 
			const auth = await app.emailPasswordAuth.registerUser({email, password});
			# 	const emailPasswordUserCredentials = Realm.Credentials.emailPassword(
			# 		email,
			# 		password
			# 	);
			# 	console.log(app.currentUser.linkCredentials)
			# 	auth = await app.currentUser.linkCredentials(emailPasswordUserCredentials);
			
			# window.location.replace("/update-proile")
		catch error
			window.alert("Failed to sign up!")
			console.log error

			loading = false

	def submit e
		e.preventDefault();
		
		loading = true
		
		try 
			const credentials = Realm.Credentials.emailPassword(email, password)
			const auth = await app.logIn(credentials)

			if auth.isLoggedIn
				window.location.replace("/")
		catch error
			window.alert("Sign in failed")
			console.log error

			loading = false

	def render
		<self>
			<form[w:100 m:auto mt:10%] @submit=submit autocomplete="off">
				<[fs:32 ta:center mb:2]> "Sign In"
				<SimpleInput label="Email" name="email" id="email" bind=email type="text">
				<SimpleInput[mt:2] label="Password" name="password" id="password" bind=password type="text">


				<button[p:2 w:100% mt:6] disabled=loading> 
					loading ? "Loading ...":"Sign In"

				<button[p:2 w:100% mt:6] type="button" @click=signUp disabled=true> 
					loading ? "Loading ...":"Create Account"