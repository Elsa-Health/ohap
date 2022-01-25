import { SimpleInput } from '../components/simple-input'
import { friendlySymptomName, randomSymptom, toggleCondition } from '../utils.ts'
import { conditionsDb, modelsDb, app} from "../realm.ts"
import {last} from "lodash"

# let conditions = [{ _id: "0eincds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0eicwe0iqds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0eg45wccds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }, { _id: "0e34wfeccds", name: "tinea-nigra", createdAt: new Date(), updatedAt: new Date() }]
let conditions = []
let loadingConditions = true
let showNewConditionForm = false
let condition

tag create-condition-form
	prop conditionName
	
	modelName = ""

	def submit event
		event.preventDefault()
		const cond = {
			name: modelName,
			condition: conditionName,
			ownerId: app.currentUser.id,
			ownerEmail: app.currentUser.profile.email,
			symptoms: [],
			signs: [],
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

			<button[mt:2]> "Submit"

tag condition-list-item
	css shadow:md p:4 my:2 shadow@hover:lg cursor:pointer rd:4
	<self route-to=`/condition/${data.condition}/${data._id}`>
		<[fs:large mb:2]> friendlySymptomName data.condition
		<div> `Id: {data._id.toString()}`
		<div> `Last Update: {data.updatedAt.toLocaleString() if data.updatedAt}`

export tag ConditionModels
	def routed params, state
		console.log "routed here", params, state
		# const res = await conditionsDb.find({});
		# conditions = res

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


	<self>
		if loadingConditions
			"Loading condition models ..."
			
		<div[my:1]>
			if showNewConditionForm
				<create-condition-form conditionName=condition>
			else
				<button @click=(showNewConditionForm=true)> "+ Create new condition model"

		for condition in conditions
			<condition-list-item key=condition._id bind=condition>