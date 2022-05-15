import { app } from '../realm.ts'
import "../components/loading-progress-bar.imba"

let loading = true
let verified = true

let errorMessage = "There was an error confirming your account."
let allowResendConfirmation = true

# TODO: Account for verification of an already verified account!
# TODO: Account for expired verification codes
export tag ConfirmAccount
	def mount
		let params = (new URL(document.location)).searchParams;
		const [token, tokenId] = [params.get("token"), params.get("tokenId")]
		console.log token, tokenId
		
		try
			const res = await app.emailPasswordAuth.confirmUser({token, tokenId})

			# TODO: support resending confirmation email
			loading = false;
			verified = true
			console.log res
		catch error
			if error.errorCode === "UserpassTokenInvalid"
				errorMessage = "The user token has already been used or has expired. Please resend a confirmation link"
			console.warn({ error })
			loading = false
			verified = false
			# window.alert "There was an error confirming your account."


	def resendConfirmationEmail
		const confirmed = window.confirm "Please confirm that you are sending another confirmation code to your email address."
		if confirmed
			try
				await app.emailPasswordAuth.resendConfirmationEmail({ email });

				window.alert "Please check you email for the next confirmation code"
			catch error
				console.error {error}
				window.alert "There was a problem resending your confimraion link. Please contact commnity@elsa.health"
		
	<self>
		
		<loading-progress-bar [w@md:100% w@lg:40% mx:auto my:20] ready=!loading>

		if !loading		
			if verified === true
				<div[d:flex jc:center]>
					<div[ta:center pt:8]>
						<span.material-icons[fs:10rem fs@lg:18rem c:green6]> "task_alt"
						<[fs:2.4rem fs@lg:3.2rem ta:center c:$blue ]> "Thank you for confirming your account!"
						<p[fs:1.4rem]>
							"Welcome to the Elsa clinical community. We cannot wait to see how much impact and reach your clinical support can make!"
						<p[fs:1rem]>
							"If you need support with anything please do not hesitate to contact us at " 
							<a href="mailto:community@elsa.health"> "community@elsa.health"

						<ui-button[mx:auto mt:2rem] variant="filled" size="xl" route-to="/sign-in">
							"Sign in to your account"
			else
				<div[d:flex jc:center]>
					<div[ta:center pt:8]>
						<span.material-icons[fs:10rem fs@lg:18rem c:red6]> "report"
						<[fs:2.4rem fs@lg:3.2rem ta:center c:yellow7 ]> errorMessage
						<p[fs:1.4rem]>
							"Please contact support at community@elsa.health for more help"


						if allowResendConfirmation
							<ui-button[mx:auto mt:2rem] @click=resendConfirmationEmail variant="filled" size="xl">
								"Resend Confirmation Email"