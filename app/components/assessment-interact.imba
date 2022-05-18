import { searchForSymptom, friendlySymptomName, toggleStringList } from '../utils.ts'
import symptomsList, { getSymptomByName } from '../data/symptoms'
import { createPatient, interpret,formatPatient } from '@elsa-health/model-runtime'
import {SimpleSearchBox} from "./simple-search-box.imba"
import {softenSymptomBetas} from "../utils"
import { sortBy } from "lodash"
import toastr from "toastr"

let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)


let age = 18
let sex = "female"

# HACK!
let symptomsOrder = []

export tag AssessmentInteract
	css .options-wrapper > button mr:2 py:1 px:6 fs:sm bgc:white bd:1px solid cool4 rd:2 cursor:pointer bgc@hover:$blue c@hover:white mb:1
	css .options-wrapper > button.active-option bgc:$blue c:white

	prop diseaseModels

	patient = createPatient(sex, age, [], [])
	symptomSearchStr = ""
	activeEditSymptom = ""

	def selectSymptom symptom
		const exists = patient.symptoms.some((do(sy) sy.name === symptom.symptom));
		if (!exists)
			patient.symptoms.push({
				name: symptom.symptom,
				locations: [],
				duration: 1,
				onset: 'gradual',
				nature: [],
				periodicity: 'intermittent',
				aggravators: [],
				relievers: [],
			})
			symptomsOrder.push symptom.symptom
			symptomSearchStr = ""

	# def setField symptomName, fieldName, value
	# 	patient.symptoms = patient.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: value }) : sy))

	# def chooseOption symptomName, fieldName, value
	# 	patient.symptoms = patient.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: toggleStringList(sy[fieldName])(value)}) : sy))


	def removeSymptom syName
		activeEditSymptom = ""
		# remove the symptom from the patient
		console.log syName, patient
		patient.symptoms = patient.symptoms.filter((do(sy) sy.name != syName))

		# remove the symptom from the symptomsOrder
		symptomsOrder = symptomsOrder.filter((do(sy) sy != syName))


	def mount
		symptomsOrder = []
		activeEditSymptom = ""
		# sex = "female"
		# age = 12
		patient = createPatient(sex, age, [], [])
		tick!

	def render
		const activeSymptomTemplate = getSymptom(activeEditSymptom)
		const ast = activeSymptomTemplate

		const activePatientSymptom = ast ? patient.symptoms.find((do(sy) sy.name === ast.symptom)) : null
		const aps = activePatientSymptom

		const activeSymptomIdx = patient.symptoms.findIndex((do(sy) sy.name === activeEditSymptom))

		pt = createPatient(sex, age, patient.symptoms, patient.signs)

		<self>
			<div[d:grid gtc:2]>
				<div[pr:10]>
					<div>
						<label>
							"Patient Age:"
							<input.simple-input bind=age />

						<div[mt:2]>
							<label>
								"Patient Sex:"
								<br>
								<select[mt:1 h:8 w:60] bind=sex>
									<option value="male"> "Male"
									<option value="female"> "Female"
					<div[pt:4]>
						<.text-lg> "Add new symptom"

					<SimpleSearchBox bind=symptomSearchStr>

					if symptomSearchStr.length > 2
						<div[d:flex flw:wrap rg:1 cg:1 mt:1]>
							for symptom in symptomSearch(5)(symptomSearchStr)
								<div[p:2 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(selectSymptom(symptom))>
									<small> friendlySymptomName symptom.symptom

					<div[pt:3]>
						<div[bd:1px solid cool4 rd:md min-height:100 d:flex]>
							<div[fl:1]>
								for ptSymptom in symptomsOrder
									<toggle-button[bdb:1px solid cool3] key=ptSymptom label=(friendlySymptomName ptSymptom) active=activeEditSymptom==ptSymptom @click=(activeEditSymptom = ptSymptom)>
								# for ptSymptom in patient.symptoms
								# 	<toggle-button[bdb:1px solid cool3] key=ptSymptom.name label=(friendlySymptomName ptSymptom.name) active=activeEditSymptom==ptSymptom.name @click=(activeEditSymptom = ptSymptom.name)>


							<div[fl:3 bdl:1px solid cool4 p:3 pb:10]>
								<SymptomInputForm symptom=activeSymptomTemplate remove=removeSymptom bind=patient.symptoms[activeSymptomIdx] >
				<div>
					<assessment-likelihoods-visual
						diseaseModels=diseaseModels 
						patient=pt>



export tag SymptomInputForm
	prop symptom\SymptomItem
	prop remove
	prop data
	prop isChiefComplaint\boolean = false

	css .options-wrapper > button mr:2 py:1 px:6 fs:sm bgc:white bd:1px solid cool4 rd:2 cursor:pointer bgc@hover:$blue c@hover:white mb:1
	css .options-wrapper > button.active-option bgc:$blue c:white


	def setField symptomName, fieldName, value
		# console.log symptomName, fieldName, value, data["field"]
		data[fieldName] = value
		# data.symptoms = data.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: value }) : sy))

	def chooseOption symptomName, fieldName, value
		data[fieldName] = toggleStringList(data[fieldName])(value)
		# data.symptoms = data.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: toggleStringList(sy[fieldName])(value)}) : sy))
	
	def render
		<self>
			if symptom
				<div[d:flex jc:space-between]>
					<.text-xl> 
						friendlySymptomName(symptom.symptom)
					<span[cursor:pointer] @click=(remove(symptom.symptom))> "Close"

				<div[pt:2]>
					<chekbox-input bind=isChiefComplaint value=symptom.symptom label="This is a chief complaint">

				<div>
					<p[mb:1]> "Duration"
					<input[p:2 w:100%] placeholder="Days ..." value=data.duration @change=(setField symptom.symptom, "duration", e.target.value) min=0 type="number">

				if symptom.location && symptom.location.length > 0
					<div[mt:4]>
						<p[mb:1]> "Locations"
						<div.options-wrapper>
							for loc in symptom.location
								<button .active-option=(data.locations.includes(loc)) @click=(chooseOption symptom.symptom, "locations", loc) type="button"> friendlySymptomName loc

				if symptom.onset && symptom.onset.length > 0
					<div[mt:4]>
						<p[mb:1]> "Onset"
						<div.options-wrapper>
							for ons in symptom.onset
								<button @click=(setField symptom.symptom, "onset", ons) .active-option=(data.onset == ons) type="button"> friendlySymptomName ons


				if symptom.periodicity && symptom.periodicity.length > 0
					<div[mt:4]>
						<p[mb:1]> "Periodicity"
						<div.options-wrapper>
							for per in symptom.periodicity
								<button @click=(setField symptom.symptom, "periodicity", per) .active-option=(data.periodicity == per) type="button"> friendlySymptomName per

				if symptom.nature && symptom.nature.length > 0
					<div[mt:4]>
						<p[mb:1]> "Nature"
						<div.options-wrapper>
							for nat in symptom.nature
								<button .active-option=(data.nature.includes(nat)) @click=(chooseOption symptom.symptom, "nature", nat) type="button"> friendlySymptomName nat

				if symptom.aggravators && symptom.aggravators.length > 0
					<div[mt:4]>
						<p[mb:1]> "Aggravators"
						<div.options-wrapper>
							for agg in symptom.aggravators
								<button .active-option=(data.aggravators.includes(agg)) @click=(chooseOption symptom.symptom, "aggravators", agg) type="button"> friendlySymptomName agg

				if symptom.relievers && symptom.relievers.length > 0
					<div[mt:4]>
						<p[mb:1]> "Relievers"
						<div.options-wrapper>
							for rel in symptom.relievers
								<button .active-option=(data.relievers.includes(rel)) @click=(chooseOption symptom.symptom, "relievers", rel) type="button"> friendlySymptomName rel


				if symptom.radiation && symptom.radiation.length > 0
					<div[mt:4]>
						<p[mb:1]> "Radiation"
						<div.options-wrapper>
							for rad in symptom.radiation
								<button .active-option=(data.radiation.includes(rad)) @click=(chooseOption symptom.symptom, "radiation", rad) type="button"> friendlySymptomName rad


				if symptom.severity && symptom.severity.length > 0
					<div[mt:4]>
						<p[mb:1]> "Severity"
						<div.options-wrapper>
							for sev in symptom.severity
								<button .active-option=(data.severity == sev)  @click=(setField symptom.symptom, "severity", sev) type="button"> friendlySymptomName sev




tag probability-bar
	css .likely-area bgi:linear-gradient(to right, $pink 0%, #F6A2BE  51%, $pink  100%)

	prop p\number
	prop label\string

	def render
		let pWidth = (p < 0 || p > 1 ? 0.5 : p / 1) * 100

		<self>
			<div[d:flex h:2]>
				<div[flex:{pWidth} rd:sm tween:all transition-duration:0.3s].likely-area>
				<div[flex:{100 - pWidth} bgc:cool1]>

				<div[pl:2]>
					p

			# TODO: Add model author information
			<p[mt:1 mb:0 c:cool8]>
				label




tag assessment-likelihoods-visual
	prop diseaseModels
	prop patient

	def runAllAssessments
		const assessments = []
		for model in diseaseModels
			assessments.push({
				p: (runAssessment(model) || 0).toFixed(2)
				conditionName: friendlySymptomName model.condition
				condition: model.condition
				modelId: model._id.toString()
				modelName: model.name
			})

		return assessments

	def runAssessment diseaseModel
		if !diseaseModel
			return 0
		try
			formattedPatient = formatPatient(patient)
			const softerModel = {
				...diseaseModel,
				symptoms: softenSymptomBetas(diseaseModel.symptoms)
			}

			return interpret(false)(softerModel)(formattedPatient)
		catch err
			console.error({err})
			return 0


	def render
		const modelResult = runAssessment() || 0

		const likelihoods = runAllAssessments!

		<self>
			<div>
				<.text-xl> "Asssessments"

				for likel in sortBy(likelihoods, ['p']).reverse!
					<div[mt:2 p:2 pt:2 rd:sm]>
						<probability-bar 
						p=likel.p 
						label=likel.conditionName>

						<div[p:2 d:flex c:$blue jc:flex-end fs:sm]>
							<a[c:$blue tdl:none cursor:pointer] 
								target="_blank" 
								href="/condition/{likel.condition}/{likel.modelId}"> "Open Editor"
							<div[c:$blue cursor:pointer pl:4] 
							@click=toastr.info("Coming Soon")>
								"View Reasoning"

				# 	<probability-bar p=0.52 label="Syphillis">

				# <div[mt:6]>
				# 	<probability-bar p=0.41 label="Dysentry">

				# <div[mt:6]>
				# 	<probability-bar p=0.24 label="Tuberculosis">


				# <div[mt:8]>
				# 	"Given the symptoms indicated, the most likely condition is Complicated Malaria"


tag toggle-button
	prop label\string
	prop active\boolean

	css py:3 pl:3 ta:left cursor:pointer

	<self [bgc:$blue c:white]=active> label
