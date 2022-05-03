# @ts-expect-error
import {app} from "../realm.ts"

# TODO: Match the design of the header
# 1. Add navigation options
# 2. Support mobile collapsible header
# 3. Add logo icon to top left
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
				<span[cursor:pointer c:$blue] route-to="/"> "Open Health Platform"

			<div[d:flex]>
				if (app && app.currentUser && app.currentUser.isLoggedIn && app.currentUser.providerType !== "anon-user")
					# <p> "Authenticated"
					<p[cursor:pointer c@hover:blue4 td@hover:underline ml:2] route-to="/profile/{app.currentUser.id}"> getUserName!
					<p[cursor:pointer c@hover:blue4 td@hover:underline ml:2] @click=signOut> "Sign Out"
				else
					<a href="/sign-in">
						"Sign In (Preview)"