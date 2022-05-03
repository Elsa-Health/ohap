import { SimpleInput } from '../components/simple-input'
# @ts-expect-error
import {conditionsDb, app} from "../realm.ts"
import { lowerCase, kebabCase } from "lodash"



let condition = {
	name: "",
}

export tag CreateCondition
	def submit event
		event.preventDefault()
		if condition.name.length === 0
			alert "Condition names cannot be empty."
			return;

		const confirmation = window.confirm "Please confirm that you want to save this model";
		if !confirmation
			return;
			
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.");

		try 
			const result = await conditionsDb.insertOne({
				...condition
				name: kebabCase(lowerCase(condition.name)),
				ownerId: app.currentUser.id,
				ownerEmail: app.currentUser.profile.email,
				ownerName: app.currentUser.customData.username || ""
				createdAt: new Date(),
				upcatedAt: new Date(),
			})

			window.alert(`Successfully created and saved the ${condition.name} model`);

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


			<button[mt:2 px:12 py:2 mr:3]> "Create"
			<button[mt:2 px:12 py:2 c:red6] @click=(window.history.back()) type="button"> "Cancel"
