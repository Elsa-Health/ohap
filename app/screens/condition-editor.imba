import { distributions } from '@elsa-health/model-runtime'
import type { Symptom } from '@elsa-health/model-runtime/dist/public-types'
import { clone, merge, omit,last} from "lodash"
import axios from "axios"
import riskFactors from "../data/riskFactors"
import { TryModel } from '../components/try-model'
import { isResourceContributor, toggleStringList, rescaleList, friendlySymptomName, getSymptomTemplate, searchForSymptom, formatFriendlyModel, formatFriendlySymptom, softenSymptomBetas } from '../utils.ts'
import '../components/symptoms-timeline'
import '../components/condition-investigation-findings'
import { SymptomEditor } from '../components/symptom-editor'
import { NewSymptomWizardModal } from '../components/new-symptom-wizard-modal.imba'
import { SliderInput } from '../components/slider-input.imba'
import {AssessmentInteract} from "../components/assessment-interact.imba"
import "../components/modal.imba"
import "../components/loading-progress-bar.imba"
import "../components/add-contributor-form.imba"
import Realm, {modelsDb, app} from "../realm.ts"
import { commentsDb } from "../realm.ts"

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

const defaultMetadata = { 
	performance: defaultSummary, 
	activity: { likes: 0, downloads: 0 }
	contributors: []
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
	stages: [],
	metadata: defaultMetadata
	# symptoms: [
	# 	randomSymptom("fever"),
	# 	randomSymptom("cough"),
	# 	randomSymptom("sore throat"),
	# 	],
}



let resetState = do
	state = {
		ownerId: "",
		ownerEmail: ""
		condition: "",
		riskFactors: []
		symptoms: [],
		signs: [],
		investigations: [],
		stages: [],
		metadata: defaultMetadata
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

let showAddContributor = false

# Indicates whether the model is in saving progress or not
let savingModel = false

let comments = []
let expandedComments = false


def isModelContributor userId\string, state
	if userId == state.ownerId
		return true
	elif state.metadata && state.metadata.contributors
		const idx = state.metadata.contributors.findIndex do(cont)
			cont.id === userId
		return idx > -1
	else
		return false

export tag ConditionEditor
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
		# TODO: Check that the user is allowed to contribute to the model
		const conditionModel = omit({
			...state, 
			updatedAt: new Date(), 
			symptoms: softenSymptomBetas(state.symptoms), 
			metadata: defaultMetadata
		}, ["_id"])

		const incorrectDurations = state.symptoms.filter do(sy)
			sy.duration.sd <= 0 || sy.duration.mean <= 0

		if (incorrectDurations.length > 0)
			const n = incorrectDurations[0].name
			window.alert "Durations must be longer than 0 days +/- 1 or more days. Please verify the symptom of {n}"
			return;

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


	def saveInvestigations investigations\[]
		state.investigations = investigations
		showInvestigationsManager = false

	def mount
		conditionId = last(window.location.pathname.split("/"))
		if !conditionId || conditionId.length === 0
			return

		# return;
		# TODO: add try catch
		# const res = await modelsDb.findOne({_id: new Realm.BSON.ObjectID(conditionId)})
		const res = await axios.get("https://eu-central-1.aws.data.mongodb-api.com/app/elsa-models-lqpbx/endpoint/model?id={conditionId}")
		resetState!
		const metadata = merge(clone(defaultMetadata), clone(res.data.metadata))
		state = {...state, ...res.data, metadata}
		loadingConditionModel = false

		if res && res._id
			const comms = await commentsDb.find({ referenceId: res._id })
			comments = comms

		tick!

	def unmount
		loadingConditionModel = true


	def render
		console.log state
		<self>
			<div[d:{savingModel ? "block" : "none"}]>
				"Please wait while saving the model"


			<modal size="sm" title="Add Contributor" onClose=(do() showAddContributor = false) open=showAddContributor>
				<add-contributor-form resourceType="model" resourceId=conditionId resourceName=state.name onClose=(do() showAddContributor = false)>

			<modal title="Risk Factors" onClose=(do() showRiskFactorsManager = false) open=showRiskFactorsManager>
				<manage-risk-factors
					submit=saveRiskFactors 
					close=(do showRiskFactorsManager = false)
					factors=state.riskFactors>

			<modal title="Tests & Investigations" onClose=(do() showInvestigationsManager = false) open=showInvestigationsManager>
				<condition-investigation-findings 
					submit=saveInvestigations
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
					<loading-progress-bar [w@md:100% w@lg:40% mx:auto my:20] ready=!loadingConditionModel>
				else
					if view === "add-symptom"
						<button @click=(view = "view-summary")> "View Summary"
						<div[mt:2]>
							<SymptomEditor bind=symptomState  submitSymptom=submitSymptom>
					else if view === "view-summary"
						<div[d:flex flw:wrap rg:1.5 cg:2 mb:3]>
							# <button @click=(toggleAddSymptom)> "Add Symptom"
							if isResourceContributor(state)(app.currentUser && app.currentUser.id)
								<button.button @click=(showSymptomWizard = true)> "Add Symptom"
								<button.button @click=(showRiskFactorsManager = true)> "Risk Factors"
								<button.button @click=(showInvestigationsManager = true)> "Investigations & Findings"
								<button.button @click=saveModel> "Save Model"
								<button.button @click=deleteModel> "Delete Model"
								<button.button @click=(showAddContributor = true)> "Add Contributors"
							if app.currentUser && app.currentUser.id
								<button @click=(showCommentDialogue = true)> "Comment"
							
							<button.button @click=downloadModel> "Download"

							if state.metadata and state.metadata.performance
								<button type="button" route-to="/condition/{state.condition}/{state._id.toString()}/evaluations"> "View Evaluation Results"


						<symptoms-timeline selectSymptom=selectSymptom symptoms=sortByEarliest(state.symptoms) stages=(state.stages)>

						<div[pt:4]>
							<[fs:large fw:600 mb:1]> "Contributors {state.metadata.contributors.length}"
							for person in state.metadata.contributors
								<div[pb:3]>
									"Contributor: {person.email.split('@')[0]}"
									<br>
									"Role: {person.role}"
					
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


const riskFactorOptions = riskFactors.map do(factor)
	distributions.createBeta factor.name, 50, 50

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
		<self>
			<div[rd:md]>
				<label>
					# <input.input bind=searchStr type="text" placeholder="obese, immunocompromised, ...">
					# <text-input label="Search" bind=searchStr placeholder="obese, immunocompromised, ...">
					<multi-select-input label="Search" bind=factors options=riskFactorOptions labelKey="name" valueKey="name">

				# <div>
				# 	for res in searchFilter(searchStr, riskFactors)
				# 		<span.tag.is-medium[cursor:pointer] .is-primary=activeFactor(res.name) @click=(toggleFactor res.name)> friendlySymptomName res.name



				<div[p:1]>
					for pFactor in factors
						<div[d:flex py:4 ai:center jc:space-between fld:row bdb:1px #ccc/20 solid]>
							<SliderInput 
								label=(friendlySymptomName pFactor.name)
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

				<div[d:flex pt:8]>
					<ui-button @click=close> "Cancel"
					<div[w:5]>
					<ui-button variant="filled" @click=saveFactors> "Save"

