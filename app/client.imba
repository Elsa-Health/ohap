import { CreateCondition } from './screens/create-condition'
import { ConditionModels } from './screens/condition-models'
import { ConditionEditor } from './screens/condition-editor'
import { Header } from './components/header'
import { SimpleInput } from './components/simple-input'
import {SignIn} from "./sign-in.imba"
import conditions from './data/conditions.ts'
import { SymptomEditor } from './components/symptom-editor'
import { friendlySymptomName, randomSymptom, toggleCondition } from './utils.ts'
import { SymptomsTimeline } from './components/symptoms-timeline'
import {conditionsDb, app} from "./realm.ts"

global css html
	ff:'Roboto', sans

global css .container width:85% margin:auto

global css .text-3xl fs:1.87em lh:2.0 fw:"100"
global css .text-2xl fs:1.5em lh:1.7 fw:"100"
global css .text-xl fs:1.25em lh:1.5 fw:"100"



let conditionSearchString = ""
let selectedConditions\Condition[] = [] # [{name: "laryngitis"}]
let conditionsList = []

tag app

	css button p:2 bgc:blue2 bw:0 rd:3 bgc@hover:blue3 cursor:pointer


	def selectCondition condition
		# console.log toggleCondition(selectedConditions, condition)
		selectedConditions = toggleCondition(selectedConditions, condition)

	def isActiveCondition condition
		selectedConditions.find((do(cond) cond.name === condition.name)) ? true : false

	def mount
		try 
			const results = await conditionsDb.find({}, {limit: 15})

			conditionsList = results
		catch error
			console.log({error})

	<self>
		<Header>


		<div.container route="/sign-in$">
			<SignIn>

		<div.container route="/$">
			<div[mt:2]>
				<SimpleInput[mb:3] bind=conditionSearchString type="text" label="Condition Search">
				<div[d:flex fld:row cg:2 rg:2  flw:wrap mb:6]>
					for condition in conditionsList.filter((do(x) x.name.includes(conditionSearchString))).slice(0, 20)
						<div[shadow:md bg:blue1 px:4 py:4 rd:lg shadow@hover:lg cursor:pointer] [bg:blue5 c:white]=(isActiveCondition condition) route-to=`/condition/${condition.name}$`>
							friendlySymptomName condition.name

				<a href="/create-condition"> "+ Create new condition"

				# <div[mt:6]>
				# 	<button disabled=(selectedConditions.length < 1) route-to="/$"> "Continue"

		<div.container route="/create-condition">
			<CreateCondition>

		<div.container route="/condition/:condition$">
			<ConditionModels>

		<div.container route="/condition/:condition/:id$">
			<ConditionEditor>


imba.mount <app>