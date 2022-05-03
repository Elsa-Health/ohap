import riskFactors from '../data/riskFactors.ts'
import {SymptomInputForm} from "../components/assessment-interact"
import "../components/@ui/input"
import "../components/@ui/button"
import conditions from '../data/conditions.ts'
import { friendlySymptomName, toggleStringList, searchForSymptom } from '../utils.ts'
import { investigations as invsList } from "../data/investigations.ts"

import symptomsList, { getSymptomByName } from '../data/symptoms'


let investigationItem = {
	label: "Rapid Malaria Test",
	value: "rapid-malaria-test",
	result: {
		value: "",
		description: ""
	}
}

let vignette = {
	condition: ""
	presentation: "typical"
	age: {
		years: 0
		months: 0
		days: 0
	},
	sex: "male"
	country: ""
	weight: {
		units: "kg"
		value: 0
	},
	height: {
		units: "cm"
		value: 0
	},
	vitals: {
		temperature: {
			units: "celcius",
			value: 0
		}
		"respiratory-rate": 0,
		"heart-rate": 0,
		"oxygen-saturation": 0
		"blood-pressure": {
			systolic: 0,
			diastolic: 0
		}
	},
	symptoms: []
	investigations: []
	riskFactors: []
	differentials: []
}


const casePresentationOptions  = [
	{
		value: "typical",
		label: "Typical",
		description: "This is typically how these patients should present"
	}
	{
		value: "atypical",
		label: "Atypical",
		description: "This is a non-typical presentation"
	}
]

const sexOptions = [
	{
		value: "male"
		label: "Male"
	}
	{
		value: "female"
		label: "Female"
	}
]

const investigationOptions = invsList.map do(inv)
	{
		...inv
		value: inv.name
		label: inv.name,
		result: {
			value: inv.type === "boolean" ? false : "",
			description: ""
		}
	}

const symptomOptions = symptomsList.map do(sym)
	{
		...sym,
		value: sym.symptom,
		label: friendlySymptomName(sym.symptom)
	}

const conditionOptions = conditions.map do(cond)
	{
		label: friendlySymptomName cond.name
		value: cond.name
	}

const booleanTestOptions = [
	{
		label: "Positive",
		value: 'true',
	}
	{
		label: "Negative",
		value: 'false'
	}
]


const normalityTestOptions = [
	{
		label: "Normal",
		value: 'normal',
	}
	{
		label: "Abnormal",
		value: 'abnormal'
	}
]



let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)

let evidenceSearchStr = ""

export tag VignetteCreator

	css pb:30
	css .fluid-grid d:grid gtc@lg:repeat(4, 1fr) gtc:repeat(1, 1fr) gcg:1.2rem grg:1.2rem


	def selectEvidence evidence
		console.log evidence

	def updateSymptoms symptoms
		# create new symptom
		let res = symptoms.map do(sy)
			let name = sy.symptom || sy.name
			console.warn "name", sy.name
			let symptomExists = vignette.symptoms.findIndex((do(sy) sy.name === name)) > -1;
			if symptomExists
				return sy
			let existingSymptom = vignette.symptoms.find((do(sy) sy.name === name)) || {};
			{
				name: name,
				locations: [],
				duration: 1,
				onset: 'gradual',
				nature: [],
				periodicity: 'intermittent',
				aggravators: [],
				relievers: [],
				...existingSymptom
			}
		vignette.symptoms = res

	def updateInvestigations investigations
		# vignette.investigations = investigations
		console.log "updates", investigations

	def updateDifferentials diff
		console.log diff

	def removeSymptom symptomName
		vignette.symptoms = vignette.symptoms.filter do(sy)
			sy.name !== symptomName


	def submitVignette
		const confirmed = window.confirm "Please confirm that you are submitting the vignette?"

		console.log vignette, confirmed

	def render
		# const testNames = vignette.investigations.map((do(itm) itm.label))
		# console.log vignette.investigations
		<self>
			<.text-3xl[lh:normal]> "Condition Vignette Creator"
			<[c:cool6]> "Use this form to create clinical case vignettes for any of the conditions supported by the platform."

			<div[mt:8]>
				<select-input[my:2] required label="Condition" options=conditionOptions bind=vignette.condition onChange=(do(val) vignette.condition = val)>


				<radio-input-group[mt:4] bind=vignette.presentation orientation="vertical" label="Case Presentation Type" options=casePresentationOptions required>


			
			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Patient Demographics"
				<span[fs:xs c:cool5]> "Describe the patients demographics."


				<div.fluid-grid[pt:2]>
					<number-input required=yes bind=vignette.age.years label="Years">
					<number-input required=yes bind=vignette.age.months label="Months">
					<number-input required=yes bind=vignette.age.days label="Days">
					<select-input required options=sexOptions bind=vignette.sex label="Sex">
					<text-input required label="Country" bind=vignette.country>
					<number-input required=yes bind=vignette.height.value label="Height (cm)">
					<number-input required=yes bind=vignette.weight.value label="Weight (kg)">


			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Patient Vitals"
				<span[fs:xs c:cool5]> "Patient vital information you expect to see."


				<div.fluid-grid[pt:2]>
					<number-input required=yes bind=vignette.vitals.temperature.value label="Temperature (Celcius)">
					<number-input required=yes bind=vignette.vitals["respiratory-rate"] label="Respiratory Rate (bpm)">
					<number-input required=yes bind=vignette.vitals["heart-rate"] label="Heart Rate">
					<number-input required=yes bind=vignette.vitals["oxygen-saturation"] label="Oxygen Saturation (O2 Sat, %)">
					<number-input required=yes bind=vignette.vitals["blood-pressure"].systolic label="Blood pressure (Systolic)">
					<number-input required=yes bind=vignette.vitals["blood-pressure"].diastolic label="Blood pressure (Diastolic)">


			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Patient Presentation"
				<span[fs:xs c:cool5]> "Information about the patient you can observe as well as their complaints - this is the evidence presented."


				<div[pt:2]>
					<multi-select-input[my:2] 
						required
						label="Search symptoms & signs"
						labelKey="name"
						options=symptomOptions 
						onChange=updateSymptoms
						data=vignette.symptoms>


				<div[d:grid gtc:repeat(2, 1fr) gtc@lt-sm:1 pt:2 gcg:2rem grg:2rem pl@md:4rem]>
					for sym in vignette.symptoms
						<div[bgc:cool1 p:2rem rd:md]>
							<SymptomInputForm remove=removeSymptom symptom=getSymptom(sym.name) remove=removeSymptom bind=sym >

			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Risk Factors"
				<span[fs:xs c:cool5]> "Are there risk factors associated with this particular vignette?"


				<div[pt:2]>
					<multi-select-input[my:2] 
						required
						label="Search factors"
						# labelKey="value"
						options=riskFactors.map((do(rf) { ...rf, value: rf.name, label: friendlySymptomName rf.name })) 
						onChange=console.log
						bind=vignette.riskFactors>

			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Tests & Investigations"
				<span[fs:xs c:cool5]> "What were the tests done and the results of those tests"


				<div[pt:2]>
					<multi-select-input[my:2] 
						required
						label="Search tests" 
						options=investigationOptions 
						bind=vignette.investigations 
						onChange=updateInvestigations>


				<div[d:grid gtc:repeat(2, 1fr) gtc@lt-sm:1 pt:2 gcg:2rem grg:2rem pl@md:4rem]>
					for inv in vignette.investigations
						<div[bgc:cool1 p:2rem rd:md]>
							if inv.type === "range" or inv.type === "number"
								<number-input label="{inv.name}{inv.units ? "( "+inv.units+")" : ""}" required=true bind=inv.result.value >
							elif inv.type === "boolean"
								<radio-input-group label="{inv.name}{inv.units ? " "+inv.units : ""}" required=true options=booleanTestOptions bind=inv.result.value>
							elif inv.type === "normality"
								<radio-input-group label="{inv.name}{inv.units ? " "+inv.units : ""}" required=true options=normalityTestOptions bind=inv.result.value>
							
							if inv.withDescription === true
								<text-input[pt:3] label="Description (Optional)" bind=inv.result.description>

			<hr[bc:cool1/20 my:8]>

			<div>
				<.text-lg> "Similar / Acceptable Differentials (max 3)"
				<span[fs:xs c:cool5]> "What are the 3 conditions that are most similar to this vignette that they are acceptable differntials?"


				<div[pt:2]>
					<multi-select-input[my:2] 
						required
						label="Search conditions" 
						options=conditionOptions 
						bind=vignette.differentials
						maxLength=3
						onChange=updateDifferentials>


			<div[mt:8]>
				<ui-button @click=submitVignette variant="outline">
					"Submit"
