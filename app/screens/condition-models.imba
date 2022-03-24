import { SimpleInput } from '../components/simple-input'
# @ts-expect-error
import { friendlySymptomName, randomSymptom, toggleCondition } from '../utils.ts'
# @ts-expect-error
import { conditionsDb, modelsDb, app} from "../realm.ts"
import {last} from "lodash"

# let conditions = [{ _id: "0eincds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0eicwe0iqds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0eg45wccds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0e34wfeccds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }]
let conditions = []
let loadingConditions = true
let showNewConditionForm = false
let multiStage = false
let stages = []
let condition

let stageTemplate = {
	name: "",
	id: 1,
	symptoms: [],
	signs: [],
}

tag create-condition-form
	prop conditionName
	
	modelName = ""

	def addNewStage
		stages = [ ...stages, { ...stageTemplate, id: Math.random() } ]

	def removeStage idx
		stages = stages.filter do(stage)
			stage.id !== idx

	def submit event
		event.preventDefault()
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
		catch error
			console.log({error})
			window.alert "Error creating model. Contact Support."

		modelName = ""
		showNewConditionForm = false
	
	<self>
		<form[w:100] autocomplete="off" @submit=submit>
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

export tag ConditionListItem
	css shadow:md p:4 my:2 shadow@hover:lg cursor:pointer rd:4

	<self route-to=`/condition/${data.condition}/${data._id}`>
		<[fs:large mb:2]> data.name
		<[fs:small mb:2]> 
			"Condition: "+ friendlySymptomName data.condition
			<div> `Id: {data._id.toString()}`
			<div> `Last Update: {data.updatedAt.toLocaleString() if data.updatedAt}`

export tag ConditionModels
	def routed params, state
		console.log "routed here", params, state
		# const res = await conditionsDb.find({});
		# conditions = res

	def reset
		conditions = []
		loadingConditions = true
		showNewConditionForm = false
		condition = undefined

	def mount
		condition = last(window.location.pathname.split("/"))
		if condition.length === 0
			# TODO: handle error
			return 0

		try
			const res = await modelsDb.find({condition: condition});
			conditions = res;
			loadingConditions = false
		catch error
			window.alert "Error loading models. Please contact support."
			console.log({error})
			loadingConditions = false

	def unmount
		reset()


	<self>
		if loadingConditions
			"Loading condition models ..."
			
		<div[my:1]>
			if showNewConditionForm
				<create-condition-form conditionName=condition>
			else
				<button @click=(showNewConditionForm=true)> "+ Create new condition model"

		for condition in conditions
			<ConditionListItem key=condition._id bind=condition>
