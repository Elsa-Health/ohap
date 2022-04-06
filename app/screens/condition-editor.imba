import { distributions } from '@elsa-health/model-runtime'
import type { Symptom } from '@elsa-health/model-runtime/dist/public-types'
import { TryModel } from '../components/try-model'
import { toggleStringList, rescaleList, friendlySymptomName, getSymptomTemplate, searchForSymptom, formatFriendlyModel, formatFriendlySymptom, softenSymptomBetas } from '../utils.ts'
import '../components/symptoms-timeline'
import '../components/condition-investigation-findings'
import { SymptomEditor } from '../components/symptom-editor'
import { NewSymptomWizardModal } from '../components/new-symptom-wizard-modal.imba'
import { SliderInput } from '../components/slider-input.imba'
import {AssessmentInteract} from "../components/assessment-interact.imba"
import {last} from "lodash"
import Realm, {modelsDb, app} from "../realm.ts"
import { commentsDb } from "../realm.ts"
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
	riskFactors: []
	symptoms: [],
	signs: [],
	investigations: [],
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

let showRiskFactorsManager = false
let showInvestigationsManager = false

let showCommentDialogue = false

# Indicates whether the model is in saving progress or not
let savingModel = false

let comments = []
let expandedComments = false

export tag ConditionEditor

	# def build
	# 	conditionId = last(window.location.pathname.split("/"))
	# 	console.log 'routed', conditionId
	
	def deleteModel
		const confirmation = window.confirm("Are you sure you want to delete this model? This operation cannot be reversed.")
		if !confirmation
			return

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
		const a = document.createElement("a")
		a.href = URL.createObjectURL(new Blob([JSON.stringify(conditionModel, null, 2)], {
			type: "text/plain"
		}))
		a.setAttribute("download", "model-data.json")
		document.body.appendChild(a)
		a.click!
		document.body.removeChild(a)

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
		console.log conditionModel.symptoms	
		const confirmation = window.confirm "Please confirm that you want to save this {conditionModel.name} model"
		if !confirmation
			return
			
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.")

		if !conditionId || conditionId.length === 0
			return window.alert("Something is wrong with the condition ID. Please contact support")

		savingModel = true
		try 
			const { evaluations, summary } = await benchmarkModel conditionModel
			conditionModel.metadata.performance = {...summary, evaluations}
			# const result = await modelsDb.insertOne({
			# 	...conditionModel
			# 	upcatedAt: new Date(),
			# })
			const result = await modelsDb.updateOne({ _id: new Realm.BSON.ObjectID(conditionId) }, {$set: { ...conditionModel }})

			savingModel = false 
			window.alert "Successfully created and saved the {condition} model"

			console.log result
		catch err
			console.log "Error:", err
			savingModel = false 
			window.alert "Error! Unable to save model!"


	def selectSymptom symptom
		symptomState = symptom
		editSymptom = symptom
		showSymptomWizard = true

	def toggleAddSymptom
		# Open the symptom adder
		view = "add-symptom"

		# Reset Symptom State
		symptomState = getSymptomTemplate()


	def submitSymptom symptom\Symptom, stages
		let cleanSymptom = {
			...symptom
			onset: {...symptom.onset, ps: symptom.onset.ps.map(Number)}
			periodicity: {...symptom.periodicity, ps: symptom.periodicity.ps.map(Number)} 
			}
	
	
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


	def saveRiskFactors factors\[]
		state.riskFactors = factors
		showRiskFactorsManager = false

	def mount
		conditionId = last(window.location.pathname.split("/"))
		if !conditionId || conditionId.length === 0
			return

		# return;
		# TODO: add try catch
		const res = await modelsDb.findOne({_id: new Realm.BSON.ObjectID(conditionId)})
		state = {...state, ...res}
		loadingConditionModel = false
		console.log("STATE: ", state)

		if res && res._id
			const comms = await commentsDb.find({ referenceId: res._id })
			console.log comms
			comments = comms

	def unmount
		loadingConditionModel = true


	def render
		<self>
			<div[d:{savingModel ? "block" : "none"}]>
				"Please wait while saving the model"

			if showRiskFactorsManager
				<manage-risk-factors
				submit=saveRiskFactors 
				close=(do showRiskFactorsManager = false)
				factors=state.riskFactors>

			if showInvestigationsManager
				<condition-investigation-findings 
				submit=console.log
				close=(do showInvestigationsManager = false)
				investigations=state.investigations>

			<div[d:{savingModel ? "none" : "block"}]>
				if showSymptomWizard
					<NewSymptomWizardModal 
						stages=(state.stages) 
						conditionName=(state.condition) 
						submitSymptom=(submitSymptom) 
						editSymptom=symptomState 
						cancel=(cancelSymptomWizard) >

				if showCommentDialogue && state && state._id
					<ModelCommentDialogue cancel=(do() showCommentDialogue=false) model=state>

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
								<button.button @click=(showSymptomWizard = true)> "Add Symptom"
								<button.button @click=(showRiskFactorsManager = true)> "Risk Factors"
								<button.button @click=(showInvestigationsManager = true)> "Investigations & Findings"
								<button.button @click=saveModel> "Save Model"
								<button.button @click=deleteModel> "Delete Model"
							if app.currentUser && app.currentUser.data
								<button @click=(showCommentDialogue = true)> "Comment"
							
							<button.button @click=downloadModel> "Download"

							if state.metadata and state.metadata.performance
								<button.button type="button" route-to="/condition/{state.condition}/{state._id.toString()}/evaluations"> "View Evaluation Results"
						<symptoms-timeline selectSymptom=selectSymptom symptoms=sortByEarliest(state.symptoms) stages=(state.stages)>
					
						<div[pt:4]>
							<div[d:flex]>
								<div[pr:4]> "Comments: " + comments.length
								<div[td:underline c:blue5 cursor:pointer] @click=(do() expandedComments = !expandedComments)> expandedComments ? "Hide" : "Show"
							if expandedComments
								<div[mt:2]>
									for comment in comments
										<div[pb:3]>
											"Author: " + comment.ownerEmail
											<br>
											"Title: " + comment.title
											<br>
											"Comment: " + comment.comment
						<div[pt:10]>
							<.text-2xl> "Try running the model here"
							<AssessmentInteract diseaseModels=[state] >

tag ModelCommentDialogue
	css h:100vh pos:fixed bg:rgba(10,10,10,0.4) l:0 t:0 w:100vw zi:9999 transition-duration:0.5s tween:ease-in ofy:scroll
	prop model
	prop cancel
	conditionName = "Tinea Nigra"

	title = ""
	referenceType = "model" # model | vignette | dataset
	referenceId = model && model._id
	isBug = false
	isFeatureRequest = false
	status = "open"
	comment = ""
	createdAt = new Date()
	updatedAt = new Date()

	def submit evt
		evt.preventDefault!
		const user = app.currentUser

		const comment = {
			title,
			referenceType,
			referenceId: model._id,
			isBug,
			ownerId: user.id,
			ownerEmail: user.profile.email || ""
			isFeatureRequest,
			status,
			comment,
			createdAt : new Date(),
			updatedAt : new Date(),
		}

		try
			await commentsDb.insertOne({ ...comment })
			window.alert "Comment successfully added"
			cancel!
		catch error
			console.error({error})

	def render
		console.log title, isBug, isFeatureRequest, referenceId, model._id, comment
		<self>
			<div[bgc:white w@md:50vw m:auto mt@md:10vh p:4 rd:md shadow:lg min-height@md:30vh]>
				<[fs:2xl]> "Leave a Comment" 

				<form[pt:2] @submit=submit>
					<label>
						"Title"
						<input.simple-input bind=title>


					<div[my:3]>
						<label for="isBug">
							<input id="isBug" type="checkbox" checked=isBug @change=(isBug = !isBug)>
							<span> "Found something wrong"


					<div[my:3]>
						<label>
							<input type="checkbox" bind=isFeatureRequest>
							<span> "Suggesting an improvment"	


					<div[my:3]>
						<textarea[w:100%] placeholder="Your comment goes here" name="comment" rows="4" bind=comment>


					<button[mr:4] type="button" @click=cancel> "Cancel"
					<button> "Submit"




let riskFactors = [
	{ name: "smoking", tags: ["cigarretes"] }
	{ name: "alcohol-consumption", tags: ["drinking", "alcohol", "drunk"] }
	{name: "immunocompromised", tags: ["hiv", "immunity"] }
	{name: "men-who-have-sex-with-men", tags: ["homosexual"] }
	{name: "diabetic", tags: ["diabetes", "sugar"]}
	{name: "hypertensive", tags: ["hypertension", "blood", "pressure"]}
	{name: "infected-person-contact", tags: ["exposure"]}
	{name: "high-colesterol", tags: ["colesterol", "obesity"] }
	{name: "unhygenic-living-conditions", tags: ["environment"]}
	{name: "obesity", tags: ["overweight", "weight", "cholesterol"]}
	{name: "family-history", tags: ["genetic", "family", "inherit"]}
	{name: "substance-abuse", tags: ["drugs"]}
	{name: "organ-transplant", tags: ["transplant", "surgery"]}
	{name: "sedentary-lifestyle", tags: ["sitting"]}
]

tag manage-risk-factors
	prop submit
	prop factors = []
	prop close

	searchStr = ""

	def activeFactor name
		(factors.filter do(f) f.name === name).length > 0

	def searchFilter searchStr, factors
		if searchStr.length < 1
			return []
		factors.filter do(rf)
			let a = rf.name.toLowerCase().includes searchStr.toLowerCase!
			let b = rf.tags.join(" ").includes searchStr.toLowerCase!
			return a or b

	def toggleFactor name
		const exists? = activeFactor name
		if exists?
			searchStr = ""
			factors = factors.filter do(f) f.name !== name
		else
			searchStr = ""
			fact = distributions.createBeta name, 50, 50
			factors = [...factors, { name, ...fact }]


	def updateFactor name, value
		console.log name, value
		factors = factors.map do(f)
			if f.name === name
				f.alpha = value
				f.beta = Math.max(0.001, 100 - value)
				f
			else
				f

	def saveFactors
		submit factors


	def removeFactor name
		factors = factors.filter do(f)
			f.name !== name


	def render
		console.log factors
		<self.modal.is-active>
			<div.modal-background>
			<div.modal-content.has-background-white.p-4[rd:md]>
				<h1.subtitle.is-3> "Risk Factors"

				<label>
					"Search"
					<input.input bind=searchStr type="text" placeholder="obese, immunocompromised, ...">

				<div.tags.pt-2>
					for res in searchFilter(searchStr, riskFactors)
						<span.tag.is-medium[cursor:pointer] .is-primary=activeFactor(res.name) @click=(toggleFactor res.name)> friendlySymptomName res.name



				<div.p-1>
					for pFactor in factors
						<div.pb-3.is-flex.is-align-items-center.is-justify-content-space-between[fld:row]>
							<SliderInput 
								label=(friendlySymptomName pFactor.name )
								value=pFactor.alpha
								width=300
								min=0.001
								max=100
								stepSize=0.001
								gradient
								type="range"
								startLabel="Never Causes"
								endLabel="Always Causes"
								updateValue=(do(val) updateFactor(pFactor.name, val)) >

							<span[cursor:pointer c@hover:red] @click=(do removeFactor(pFactor.name))> "Remove"

				<div.is-flex.is-justify-content-flex-end>
					<button.button.mr-3 @click=close> "Cancel"
					<button.button.is-primary @click=saveFactors> "Save"

