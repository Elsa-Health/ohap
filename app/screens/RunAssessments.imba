import { AssessmentInteract } from "../components/assessment-interact.imba"
import {modelsDb} from "../realm.ts"


let diseaseModels = []
let modelsList = []
let loadingModels = true
let loadingConditions = true

export tag RunAssessments
	def mount
		try 
			const results = [] # await conditionsDb.find({}, {limit: 100})
			conditionsList = results

			const models = await modelsDb.find(
				{}, 
				{limit: 250, sort: { updatedAt: -1 } }
			)
			modelsList = models
		catch error
			console.log({error})
		finally
			loadingModels = false
		
		loadingConditions = false


	def render
		<self>
			<h1>
				"This is the Assessments Page"

			if loadingModels
				<h1> "Loading ..."

			<div>
				<AssessmentInteract 
					diseaseModels=modelsList />	
