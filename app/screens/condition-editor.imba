import { distributions } from '@elsa-health/model-runtime'
import type { Symptom } from '@elsa-health/model-runtime/dist/public-types'
import { TryModel } from '../components/try-model'
import { rescaleList, friendlySymptomName, getSymptomTemplate, searchForSymptom, formatFriendlyModel, formatFriendlySymptom, softenSymptomBetas } from '../utils.ts'
import { SymptomsTimeline } from '../components/symptoms-timeline'
import { SymptomEditor } from '../components/symptom-editor'
import { NewSymptomWizardModal } from '../components/new-symptom-wizard-modal.imba'
import { SliderInput } from '../components/slider-input.imba'
import {AssessmentInteract} from "../components/assessment-interact.imba"
import {last} from "lodash"
import Realm, {modelsDb, app} from "../realm.ts"
import axios from "axios"

import {dummyModel} from "../data/dummyModel"

const defaultSummary = {
	f1: 0.0,
	precision: 0.0,
	recall: 0.0,
	specificity: 0.0,
	truePositive: 0.0,
	trueNegative: 0.0,
	falsePositive: 0.0,
	falseNegative: 0.0,
}

# let state = dummyModel
let state = {
	ownerId: "",
	ownerEmail: ""
	condition: "",
	symptoms: [],
	signs: [],
	stages: []
	# symptoms: [
	# 	randomSymptom("fever"),
	# 	randomSymptom("cough"),
	# 	randomSymptom("sore throat"),
	# 	],
}

let symptomState\Symptom = getSymptomTemplate()

let view = "view-summary"
# let view = "add-symptom"
let condition = ""
let conditionId

let loadingConditionModel = true

const sortByEarliest = do(symptoms\Symptom[]) 
	symptoms.sort(do(a, b) 
		a.timeToOnset.location - b.timeToOnset.location)

let showSymptomWizard = false
let editSymptom = undefined

# Indicates whether the model is in saving progress or not
let savingModel = false

export tag ConditionEditor

	# def build
	# 	conditionId = last(window.location.pathname.split("/"))
	# 	console.log 'routed', conditionId
	
	def deleteModel
		const confirmation = window.confirm("Are you sure you want to delete this model? This operation cannot be reversed.")
		if !confirmation
			return;

		if !app.currentUser.id
			return window.alert("You must have an account to delete this model")

		if app.currentUser.id != state.ownerId
			return window.alert("You can only delete the models that you own")

		try 
			const res = await modelsDb.deleteOne({ _id: state._id })
			window.alert("Model delete successfully!!")


			window.location.replace("{document.location.origin}/explore-models")
		catch error
			console.error "Error: ", error
			window.alert("There was an error deleting the model! Please try again.") 

	def benchmarkModel model
		const URL = "https://model-evaluation-server-d3pcdcobha-uc.a.run.app/vignette-evaluation"
		# const URL = "http://localhost:3001/vignette-evaluation"
		try
			const result = await axios.post(URL, {
				model
			})
			console.log result
			return result.data
		catch error
			console.error({error})
			return { evaluations: [], summary: defaultSummary }

	def downloadModel
		const conditionModel = {...state, condition}
		const a = document.createElement("a");
		a.href = URL.createObjectURL(new Blob([JSON.stringify(conditionModel, null, 2)], {
			type: "text/plain"
		}));
		a.setAttribute("download", "model-data.json");
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);

	def saveModel
		console.log conditionId
		const conditionModel = {
			...state, 
			updatedAt: new Date(), 
			symptoms: softenSymptomBetas(state.symptoms), 
			metadata: { 
				performance: defaultSummary, 
				activity: { likes: 0, downloads: 0 } 
			}
		}
		
		const confirmation = window.confirm "Please confirm that you want to save this {conditionModel.name} model";
		if !confirmation
			return;
			
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.");

		if !conditionId || conditionId.length === 0
			return window.alert("Something is wrong with the condition ID. Please contact support");

		savingModel = true
		try 
			const { evaluations, summary } = await benchmarkModel conditionModel
			conditionModel.metadata.performance = summary
			# const result = await modelsDb.insertOne({
			# 	...conditionModel
			# 	upcatedAt: new Date(),
			# })
			const result = await modelsDb.updateOne({ _id: new Realm.BSON.ObjectID(conditionId) }, {$set: { ...conditionModel }})

			savingModel = false 
			window.alert(`Successfully created and saved the ${condition} model`);

			console.log(result)
		catch err
			console.log "Error:", err
			savingModel = false 
			window.alert "Error! Unable to save model!"


	def selectSymptom symptom
		# view = "add-symptom"
		symptomState = symptom
		console.log("HERE", symptom)
		editSymptom = symptom
		showSymptomWizard = true

	def toggleAddSymptom
		# Open the symptom adder
		view = "add-symptom"

		# Reset Symptom State
		symptomState = getSymptomTemplate()


	def submitSymptom symptom\Symptom, stages
		let cleanSymptom = { ...symptom, onset: {...symptom.onset, ps: symptom.onset.ps.map(Number)}, periodicity: {...symptom.periodicity, ps: symptom.periodicity.ps.map(Number)} }
	
		# If condition has stages, update the stages
		if state.multiStage && state.stages.length > 0 && stages
			state.stages = stages
		
		let idx = state.symptoms.findIndex((do(sy) sy.name === symptom.name))
		if idx === -1
			state.symptoms.push(cleanSymptom)
		else
			console.log "updating"
			state.symptoms[idx] = cleanSymptom

		# Open the view summary
		view = "view-summary"
		# Reset Symptom State
		symptomState = getSymptomTemplate()
		showSymptomWizard = false
		editSymptom = undefined

	def cancelSymptomWizard
		symptomState = getSymptomTemplate()
		showSymptomWizard = false
		editSymptom = undefined

	def mount
		conditionId = last(window.location.pathname.split("/"))
		if !conditionId || conditionId.length === 0
			return

		# return;
		# TODO: add try catch
		const res = await modelsDb.findOne({_id: new Realm.BSON.ObjectID(conditionId)});
		console.log("STATE: ", res)
		state = res
		loadingConditionModel = false

	def unmount
		loadingConditionModel = true


	def render
		<self>
			<div[d:{savingModel ? "block" : "none"}]>
				"Please wait while saving the model"
			<div[d:{savingModel ? "none" : "block"}]>
				if showSymptomWizard
					<NewSymptomWizardModal stages=(state.stages) conditionName=(state.condition) submitSymptom=(submitSymptom) editSymptom=symptomState cancel=(cancelSymptomWizard)>
				<div[mb:4]>
					<[fs:xx-large mb:0]> 
						friendlySymptomName state.condition
					if !loadingConditionModel
						<[c:blue6 fs:small]> "Created By: " + state.ownerEmail
				
				if loadingConditionModel
					<[fs:large]> "Loading the condition model ...."
				else
					if view === "add-symptom"
						<button @click=(view = "view-summary")> "View Summary"
						<div[mt:2]>
							<SymptomEditor bind=symptomState  submitSymptom=submitSymptom>
					else if view === "view-summary"
						<div[d:flex cg:2 mb:3]>
							# <button @click=(toggleAddSymptom)> "Add Symptom"
							if app.currentUser.id == state.ownerId
								<button @click=(showSymptomWizard = true)> "Add Symptom"
								<button> "Add Sign"
								<button @click=saveModel> "Save Model"
								<button @click=deleteModel> "Delete Model"
							else
								<button @click=(do() window.alert("Feature is coming soon"))> "Comment"
							<button @click=downloadModel> "Download"
						<SymptomsTimeline selectSymptom=selectSymptom symptoms=sortByEarliest(state.symptoms) stages=(state.stages)>
						
						
						<div[pt:16]>
							<.text-2xl> "Try running the model here"
							<AssessmentInteract diseaseModels=[state]>


