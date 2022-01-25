import { SimpleInput } from './components/simple-input'
import {app} from "./realm.ts"

let loading = false;

let email = ""
let password = ""

export tag SignIn
	def signUp
		console.log "clicked"
		loading = true

		const confirmation = window.confirm "Please confirm you email and password."

		if (!confirmation)
			loading = false
			return

		try 
			const auth = await app.emailPasswordAuth.registerUser(email, password)

			console.log(auth)
			# window.location.replace("/")
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

	<self>
		<form[w:100 m:auto mt:10%] @submit=submit autocomplete="off">
			<[fs:32 ta:center mb:2]> "Sign In"
			<SimpleInput label="Email" name="email" id="email" bind=email type="text">
			<SimpleInput[mt:2] label="Password" name="password" id="password" bind=password type="text">

			<button[p:2 w:100% mt:6] disabled=loading> 
				loading ? "Loading ...":"Sign In"

			<button[p:2 w:100% mt:6] type="button" @click=signUp disabled=loading> 
				loading ? "Loading ...":"Create Account"