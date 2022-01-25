# @ts-expect-error
import { createPatient, interpret,formatPatient } from 'model-interpreter'
import symptomsList, { getSymptomByName } from '../data/symptoms'
import { searchForSymptom, friendlySymptomName } from '../utils'
# import realm from 'realm-web'
import { SimpleInput } from './simple-input'
# @ts-expect-error
import {modelsDb} from "../realm.ts"


let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)

let symptomSearchStr = ""

let patient = createPatient("male", 18, [], [])

# let diseaseModel = null

export tag TryModel
	prop diseaseModel
	css mt: 10
	
	selectedSymptomIdx = -1
	
	def selectSymptom symptom
		console.log symptom
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

	def activeEditSymptom
		console.log patient.symptoms[selectedSymptomIdx]

		return patient.symptoms[selectedSymptomIdx]

	def runAssessment
		try
			formattedPatient = formatPatient(patient)
			
			# console.log formattedPatient
			result = interpret(diseaseModel)(formattedPatient)
			# console.log result
			return result
		catch err
			console.log({err})

	def render
		activeSymptomTemplate = getSymptom(patient.symptoms[selectedSymptomIdx]?.name);
			
		const modelResult = (activeSymptomTemplate && runAssessment()) || 0
		

		<self>
			<[fs:xx-large]>
				"Try the Model" + modelResult

			<div[mt:2]>
				for symptoms, idx in patient.symptoms
					<span[mr: 1 p:2 bg:blue3 rd:md cursor:pointer] @click=(selectedSymptomIdx = idx)>
						friendlySymptomName symptoms.name

			<div[w:100 mt:4]>
				<SimpleInput bind=symptomSearchStr label="Symptom Name">
				if symptomSearchStr.length > 0
					<div[d:flex flw:wrap rg:1 cg:1 mt:1]>
						for symptom in symptomSearch(5)(symptomSearchStr)
							<div[p:2 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(selectSymptom(symptom))>
								<small> friendlySymptomName symptom.symptom


			if selectedSymptomIdx >= 0
				<div[mt:2 w:150]>
					<SimpleInput bind=activeEditSymptom().duration type="number" label="Duration">
					
					<div[mb:3]>
						<[fs:large mb:2]> 
							"Locations"
						<div>
							for option in activeSymptomTemplate.location
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].location value=option/>
									<span[pl:1]> friendlySymptomName option

					<div[mb:3]>
						<[fs:large mb:2]> 
							"Onset"
						<div>
							for option in activeSymptomTemplate.onset
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].onset value=option/>
									<span[pl:1]> friendlySymptomName option

					<div[mb:3]>
						<[fs:large mb:2]> 
							"Nature"
						<div>
							for option in activeSymptomTemplate.nature
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].nature value=option/>
									<span[pl:1]> friendlySymptomName option

					<div[mb:3]>
						<[fs:large mb:2]>
							"Periodicity"
						<div>
							for option in activeSymptomTemplate.periodicity
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].periodicity value=option/>
									<span[pl:1]> friendlySymptomName option

					<div[mb:3]>
						<[fs:large mb:2]>
							"Aggravators"
						<div>
							for option in activeSymptomTemplate.aggravators
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].aggravators value=option/>
									<span[pl:1]> friendlySymptomName option

					<div[mb:3]>
						<[fs:large mb:2]>
							"Releivers"
						<div>
							for option in activeSymptomTemplate.relievers
								<label[mr:2]>
									<input type='checkbox' bind=patient.symptoms[selectedSymptomIdx].relievers value=option/>
									<span[pl:1]> friendlySymptomName option
