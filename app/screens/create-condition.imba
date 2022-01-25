import { SimpleInput } from '../components/simple-input'
import {conditionsDb, app} from "../realm.ts"


let condition = {
	name: ""
}

export tag CreateCondition
	def submit event
		event.preventDefault()
		const confirmation = window.confirm "Please confirm that you want to save this model";
		if !confirmation
			return;
			
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.");

		try 
			const result = await conditionsDb.insertOne({
				...condition
				ownerId: app.currentUser.id,
				ownerEmail: app.currentUser.profile.email,
				createdAt: new Date(),
				upcatedAt: new Date(),
			})

			window.alert(`Successfully created and saved the ${condition.name} model`);

			console.log(result)
			condition = { name: "" };
			# TODO: Go to the model definition/editor page??
		catch err
			console.log "Error:", err
			window.alert "Error! Unable to save model!"



	<self>
		<[fs:x-large]>
			"Create a new condition"

		<form[w:100 mt:3] @submit=submit autocomplete="off">
			<SimpleInput label="Condition Name" bind=condition.name type="text">

			<button[mt:2 px:12 py:2]> "Create"