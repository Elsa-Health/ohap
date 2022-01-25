import { TryModel } from '../components/try-model'
import { friendlySymptomName, getSymptomTemplate } from '../utils.ts'
import { SymptomsTimeline } from '../components/symptoms-timeline'
import { SymptomEditor } from '../components/symptom-editor'
import {last} from "lodash"
import {modelsDb, app} from "../realm.ts"
import {dummyModel} from "../data/dummyModel"

# let state = dummyModel
let state = {
	condition: "",
	symptoms: [],
	signs: [],
	# symptoms: [
	# 	randomSymptom("fever"),
	# 	randomSymptom("cough"),
	# 	randomSymptom("sore throat"),
	# 	],
}

let symptomState\Symptom = getSymptomTemplate()

let view = "view-summary"
let condition = ""
let conditionId

const sortByEarliest = do(symptoms\Symptom[]) 
	symptoms.sort(do(a, b) 
		a.timeToOnset.location - b.timeToOnset.location)

export tag ConditionEditor

	# def build
	# 	conditionId = last(window.location.pathname.split("/"))
	# 	console.log 'routed', conditionId

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
		const confirmation = window.confirm "Please confirm that you want to save this model";
		if !confirmation
			return;
			
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.");

		if !conditionId || conditionId.length === 0
			return window.alert("Something is wrong with the condition ID. Please contact support");

		try 
			const conditionModel = {...state, condition, updatedAt: new Date()}
			# const result = await modelsDb.insertOne({
			# 	...conditionModel
			# 	upcatedAt: new Date(),
			# })
			const result = await modelsDb.updateOne({ _id: new Realm.BSON.ObjectID(conditionId) }, {$set: { ...conditionModel }})

			window.alert(`Successfully created and saved the ${condition} model`);

			console.log(result)
		catch err
			console.log "Error:", err
			window.alert "Error! Unable to save model!"


	def selectSymptom symptom
		view = "add-symptom"
		symptomState = symptom

	def toggleAddSymptom
		# Open the symptom adder
		view = "add-symptom"

		# Reset Symptom State
		symptomState = getSymptomTemplate()


	def submitSymptom symptom\Symptom
		let idx = state.symptoms.findIndex((do(sy) sy.name === symptom.name))
		if idx === -1
			state.symptoms.push(symptom)
		else
			console.log "updating"
			state.symptoms[idx] = symptom

		# Open the view summary
		view = "view-summary"
		# Reset Symptom State
		symptomState = getSymptomTemplate()

	def mount
		conditionId = last(window.location.pathname.split("/"))
		if !conditionId || conditionId.length === 0
			return

		# TODO: add try catch
		const res = await modelsDb.findOne({_id: new Realm.BSON.ObjectID(conditionId)});
		# console.log("STATE: ", res)
		state = res


	<self>
		<[fs:xx-large mb:4]> 
			friendlySymptomName condition
		if view === "add-symptom"
			<button @click=(view = "view-summary")> "View Summary"
			<div[mt:2]>
				<SymptomEditor bind=symptomState  submitSymptom=submitSymptom>
		else if view === "view-summary"
			<div[d:flex cg:2 mb:3]>
				<button @click=(toggleAddSymptom)> "Add Symptom"
				<button> "Add Sign"
				<button @click=downloadModel> "Download"
				<button @click=saveModel> "Save Model"
			<SymptomsTimeline selectSymptom=selectSymptom symptoms=sortByEarliest(state.symptoms)>
			<TryModel diseaseModel=state>

