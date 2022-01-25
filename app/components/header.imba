# @ts-expect-error
import {app} from "../realm.ts"


export tag Header

	def mount
		console.log app.currentUser

	<self>
		<header>
			<.container[d:flex jc:space-between]>
				<h1[fs:32 fw:400]> "Elsa Model Builder"

				<div>
					if (app && app.currentUser && app.currentUser.isLoggedIn)
						"Authenticated"
					else
						<a href="/sign-in">
							"Sign In"