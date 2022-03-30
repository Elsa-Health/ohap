import { rescaleList, getSymptomTemplate, searchForSymptom, friendlySymptomName, toggleStringList } from '../utils.ts'
import symptomsList, { getSymptomByName } from '../data/symptoms'
import { createPatient, interpret,formatPatient } from '@elsa-health/model-runtime'
import {SimpleSearchBox} from "./simple-search-box.imba"
import {softenSymptomBetas} from "../utils"

let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)


let age = 100
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

	def setField symptomName, fieldName, value
		patient.symptoms = patient.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: value }) : sy))

	def chooseOption symptomName, fieldName, value
		# console.log symptomName, fieldName, value, patient
		patient.symptoms = patient.symptoms.map((do(sy) sy.name == symptomName ? ({ ...sy, [fieldName]: toggleStringList(sy[fieldName])(value)}) : sy))


	def removeSymptom syName
		activeEditSymptom = ""
		# remove the symptom from the patient
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

		pt = createPatient(sex, age, patient.symptoms, patient.signs)

		<self>
			<div[d:grid gtc:2]>
				<div[pr:10]>
					<div>
						<label>
							"Patient Age:"
							<input.simple-input bind=age />

						<br>
						<label[mt:2]>
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
								if ast
									<div[d:flex jc:space-between]>
										<.text-xl> 
											friendlySymptomName(activeEditSymptom)
										<span[cursor:pointer] @click=(removeSymptom(activeEditSymptom))> "Close"

									<div>
										<p[mb:1]> "Duration"
										<input[p:2 w:100%] placeholder="Days ..." value=aps.duration @change=(setField activeEditSymptom, "duration", e.target.value) min=0 type="number">

									<div[mt:4]>
										<p[mb:1]> "Locations"
										<div.options-wrapper>
											for loc in ast.location
												<button .active-option=(aps.locations.includes(loc)) @click=(chooseOption activeEditSymptom, "locations", loc) type="button"> friendlySymptomName loc

									<div[mt:4]>
										<p[mb:1]> "Onset"
										<div.options-wrapper>
											for ons in ast.onset
												<button @click=(setField activeEditSymptom, "onset", ons) .active-option=(aps.onset == ons) type="button"> friendlySymptomName ons


									<div[mt:4]>
										<p[mb:1]> "Periodicity"
										<div.options-wrapper>
											for per in ast.periodicity
												<button @click=(setField activeEditSymptom, "periodicity", per) .active-option=(aps.periodicity == per) type="button"> friendlySymptomName per

									<div[mt:4]>
										<p[mb:1]> "Nature"
										<div.options-wrapper>
											for nat in ast.nature
												<button .active-option=(aps.nature.includes(nat)) @click=(chooseOption activeEditSymptom, "nature", nat) type="button"> friendlySymptomName nat

									<div[mt:4]>
										<p[mb:1]> "Aggravators"
										<div.options-wrapper>
											for agg in ast.aggravators
												<button .active-option=(aps.aggravators.includes(agg)) @click=(chooseOption activeEditSymptom, "aggravators", agg) type="button"> friendlySymptomName agg

									<div[mt:4]>
										<p[mb:1]> "Relievers"
										<div.options-wrapper>
											for rel in ast.relievers
												<button .active-option=(aps.relievers.includes(rel)) @click=(chooseOption activeEditSymptom, "relievers", rel) type="button"> friendlySymptomName rel

				<div>
					<assessment-likelihoods-visual diseaseModels=diseaseModels patient=pt>




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

			<p[mt:1 c:cool8]>
				label




tag assessment-likelihoods-visual
	prop diseaseModels
	prop patient

	def runAllAssessments
		const assessments = []
		for model in diseaseModels
			assessments.push({
				p: (runAssessment(model) || 0).toFixed(2)
				condition: friendlySymptomName model.condition
			})

		return assessments

	def runAssessment diseaseModel
		if !diseaseModel
			return 0
		try
			formattedPatient = formatPatient(patient)
			console.log diseaseModel.symptoms
			const softerModel = {...diseaseModel, symptoms: softenSymptomBetas(diseaseModel.symptoms)}
			# console.log(interpret(false)(softerModel)(formattedPatient))
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

				for likel in likelihoods
					<div[mt:6]>
						<probability-bar p=likel.p label=likel.condition>

				# <div[mt:6]>
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
