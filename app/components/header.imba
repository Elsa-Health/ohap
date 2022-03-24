# @ts-expect-error
import {app} from "../realm.ts"


export tag Header < header
	css bdb:1px solid #dcdcdc mb:3

	def signOut	
		const confirm = window.confirm "Please confirm that you are trying to signout."

		if !confirm
			return

		app.currentUser.logOut()
		# tick!

	def getUserName
		if app.currentUser && app.currentUser.customData.username
			return app.currentUser.customData.username + " "
		else
			return ""

	<self>
		<.container[d:flex jc:space-between ai:center]>
			<h1[fs:24 fw:400]> 
				<span[cursor:pointer] route-to="/"> "Elsa Model Platform"

			<div[d:flex]>
				if (app && app.currentUser && app.currentUser.isLoggedIn && app.currentUser.providerType !== "anon-user")
					# <p> "Authenticated"
					<p[cursor:pointer c@hover:blue4 td@hover:underline] @click=signOut> getUserName! + "Sign Out"
				else
					<a href="/sign-in">
						"Sign In (Preview)"