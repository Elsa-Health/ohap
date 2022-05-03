# @ts-expect-error
import { createPatient, interpret,formatPatient } from '@elsa-health/model-runtime'
import symptomsList, { getSymptomByName } from '../data/symptoms'
import { softenSymptomBetas, searchForSymptom, friendlySymptomName } from '../utils'
# import realm from 'realm-web'
import { SimpleInput } from './simple-input'
# @ts-expect-error
import {modelsDb} from "../realm.ts"


let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)

let symptomSearchStr = ""

let patient = createPatient("male", 18, [], [])

let selectedSymptomName = undefined
# let diseaseModel = null

export tag TryModel
	prop diseaseModel
	css mt: 10
	
	selectedSymptomIdx = -1
	
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
			symptomSearchStr = ""

	def openAmplify symptom
		if selectedSymptomName === symptom.name
			selectedSymptomName = undefined
		else
			selectedSymptomName = symptom.name

	def activeEditSymptom
		let activeSymptom = patient.symptoms.find((do(sy) sy.name === selectedSymptomName))
		return activeSymptom

	def runAssessment
		try
			formattedPatient = formatPatient(patient)
			const softerModel = {...diseaseModel, symptoms: softenSymptomBetas(diseaseModel.symptoms)}
			return interpret(false)(softerModel)(formattedPatient)
		catch err
			console.error({err})
			return 0

	def isActive activeSymptom, symptomName
		return activeSymptom && activeSymptom.name === symptomName

	def unmount
		selectedSymptomIdx = -1
		patient = createPatient("male", 18, [], [])
		symptomSearchStr = ""

	def render
		let activeSymptom = patient.symptoms.find((do(sy) sy.name === selectedSymptomName))
		const activeSymptomTemplate = activeSymptom && getSymptom(activeSymptom.name);
		const modelResult = runAssessment() || 0

		<self>
			<[fs:xx-large]>
				"Try the Model"

			<div[mt:2]>
				for symptom, idx in patient.symptoms
					<span[mr: 1 p:2 rd:md cursor:pointer bg:blue2] [bg:blue5 c:white]=isActive(activeSymptom, symptom.name) @click=(openAmplify(symptom))>
						friendlySymptomName symptom.name

			<div[w:100 mt:4]>
				<form autocomplete="off">
					<SimpleInput bind=symptomSearchStr label="Symptom Name">
				if symptomSearchStr.length > 0
					<div[d:flex flw:wrap rg:1 cg:1 mt:1]>
						for symptom in symptomSearch(5)(symptomSearchStr)
							<div[p:2 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(selectSymptom(symptom))>
								<small> friendlySymptomName symptom.symptom


			<div[d:grid gtc:2]>
				<div>
					if selectedSymptomName && activeSymptomTemplate
						<div[mt:2]>
							<SimpleInput bind=activeEditSymptom().duration type="number" label="Duration">
							
							<div[mb:3]>
								<[fs:large mb:2]> 
									"Locations"
								<div>
									for option in activeSymptomTemplate.locations
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.location value=option/>
											<span[pl:1]> friendlySymptomName option

							<div[mb:3]>
								<[fs:large mb:2]> 
									"Onset"
								<div>
									for option in activeSymptomTemplate.onset
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.onset value=option/>
											<span[pl:1]> friendlySymptomName option

							<div[mb:3]>
								<[fs:large mb:2]> 
									"Nature"
								<div>
									for option in activeSymptomTemplate.nature
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.nature value=option/>
											<span[pl:1]> friendlySymptomName option

							<div[mb:3]>
								<[fs:large mb:2]>
									"Periodicity"
								<div>
									for option in activeSymptomTemplate.periodicity
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.periodicity value=option/>
											<span[pl:1]> friendlySymptomName option

							<div[mb:3 d:{activeSymptomTemplate.aggravators.length > 0 ? "inherit" : "none"}]>
								<[fs:large mb:2]>
									"Aggravators"
								<div>
									for option in activeSymptomTemplate.aggravators
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.aggravators value=option/>
											<span[pl:1]> friendlySymptomName option

							<div[mb:3 d:{activeSymptomTemplate.relievers.length > 0 ? "inherit" : "none"}]>
								<[fs:large mb:2]>
									"Releivers"
								<div>
									for option in activeSymptomTemplate.relievers
										<label[mr:2]>
											<input type='checkbox' bind=activeSymptom.relievers value=option/>
											<span[pl:1]> friendlySymptomName option

				<div[mt:2]>
					<[fs:x-large]> 
						# <pre>
						# JSON.stringify(softenSymptomBetas(diseaseModel.symptoms), null, 2)
						modelResult
