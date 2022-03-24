import {SimpleInput} from "../components/simple-input.imba"
import { friendlySymptomName, randomSymptom, toggleCondition } from '../utils.ts'
# @ts-expect-error
import { conditionsDb, modelsDb, app} from "../realm.ts"
import {last} from "lodash"

let conditions = []
let multiStage = false
let stages = []
let stageTemplate = {
	name: "",
	id: 1,
	symptoms: [],
	signs: [],
}


export tag CreateConditionModel

	modelName = ""
	conditionName = ""

	def addNewStage
		stages = [ ...stages, { ...stageTemplate, id: Math.random() } ]

	def removeStage idx
		stages = stages.filter do(stage)
			stage.id !== idx

	def submit event
		event.preventDefault()
		if modelName.length <= 3
			return window.alert("Model name length must be greater than 3")
		if conditionName.length < 2
			return window.alert("Please choose a condition from the drop down")
		if !window.confirm("Please confirm the creation of the {conditionName} model")
			return
		# Over-write the id with the index of the item in the stages array. This is assuming that there is an ordering to the items
		const formattedStages = stages.map do(stage, idx)
			{ ...stage, id: idx, name: stage.name.trim!.toLowerCase! }
		const cond = {
			name: modelName,
			condition: conditionName,
			ownerId: app.currentUser.id,
			ownerEmail: app.currentUser.profile.email,
			symptoms: [],
			signs: [],
			multiStage: multiStage, 
			stages: formattedStages,
			createdAt: new Date(),
			updatedAt: new Date()
		}

		try 
			const result = await modelsDb.insertOne(cond)
			window.alert "Condition Model created!"
			console.log("{result.insertedId}")

			window.document.location.href = "{document.location.origin}/condition/{conditionName}/{result.insertedId}"
		catch error
			console.log({error})
			window.alert "Error creating model. Contact Support."

		modelName = ""
		conditionName = ""

	def mount
		try 
			const conditionItems = await conditionsDb.find({})
			console.log conditionItems
			conditions = conditionItems
			loadingConditions = false
		catch
			loadingConditions = false
			conditions = []

	def render
		<self>
			<[fs:x-large]>
				"Create a new Model for a condition"

			<form[w:100 mt:3] @submit=submit autocomplete="off">
				# <SimpleInput label="Condition Name" bind=condition.name type="text">
				<label> "Choose a condition"
					<br />
					<select bind=conditionName>
						<option value=""> ""
						for cond in conditions.sort((do(a, b) b.name < a.name ))
							<option value=cond.name> friendlySymptomName cond.name

				<SimpleInput bind=modelName type="text" label="Model Nickname">
				
				
				<div[mt:2]>
					<input type="checkbox" id="multiStage" bind=multiStage />
					<label for="multiStage"> "This condition has multiple stages"

				if multiStage
					<div>
						<.text-lg[py:2]> "Please describe the stages of this condition"
						for stage in stages
							<div[py:1 d:flex]>
								<input.simple-input[mr:1] bind=stage.name />
								<button @click=(removeStage stage.id) type="button"> "Remove"


						<button[mt:4] @click=addNewStage type="button"> "Add Stage"

				<button[mt:2 mr:3]> "Submit"
				<button[mt:2 c:red6] @click=(showNewConditionForm = false) type="button"> "Cancel"
