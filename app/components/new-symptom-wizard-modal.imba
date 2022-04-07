import { distributions } from '@elsa-health/model-runtime'
import { rescaleList, friendlySymptomName, getSymptomTemplate, searchForSymptom, formatFriendlyModel, formatFriendlySymptom, toggleStringList } from '../utils.ts'
import { SliderInput } from './slider-input.imba'
import {CategoricalInput} from "./categorical-input.imba"
import symptomsList, { getSymptomByName, periodicitiesList } from "../data/symptoms.ts"
import {kebabCase, difference, keys, values, mean, upperFirst} from "lodash"

const ageGroupList = ["newborn", "infant", "toddler", "child", "adolescent", "youngAdult", "adult", "senior"]

let symptomSearch = searchForSymptom(symptomsList)
let viewTransitions = {
	0: "name",
	1: "sex",
	2: "ageGroup",
	3: "location",
	4: "duration",
	5: "onset",
	6: "nature",
	7: "periodicity",
	8: "aggravators",
	9: "relievers",
	10: "timeToOnset",
	11: "summary"
}

let activeStage = null

let addingCombination = false
let combinationsList\string[] = []
let tmpTTO = {
		start: 0,
		end: 0
	}

export tag NewSymptomWizardModal
	css h:100vh pos:fixed bg:rgba(10,10,10,0.4) l:0 t:0 w:100vw zi:9999 transition-duration:0.5s tween:ease-in ofy:scroll

	# TODO: Support taking in symptom as starter, then work to edit the symptom
	prop editSymptom\Symptom
	prop conditionName
	prop cancel
	prop stages = []
	prop submitSymptom


	syState = symptomState || undefined
	syTemplate = undefined
	symptomSearchStr = ""
	currentTransition = 0

	def toggleSymptomStage stageId
		stages = stages.map do(stage)
			if stage.id == stageId
				updatedSymptoms = toggleStringList(stage.symptoms)(syState.name)
				return {...stage, symptoms: updatedSymptoms} 
			else
				return stage


	def transition
		screensCount = keys(viewTransitions).length
		let nextScreenIndex = currentTransition + 1
		let lastScreenIdx = Object.keys(viewTransitions).length - 2

		for idx in [nextScreenIndex ... lastScreenIdx]
			const screen = viewTransitions[idx]
			if syTemplate && Array.isArray(syTemplate[screen])
				if syTemplate[screen].length > 0
					nextScreenIndex = idx
					break
				else
					if idx === lastScreenIdx
						# we are on the last screen. jump to summary
						nextScreenIndex = lastScreenIdx + 1
						break
					continue
			else
				break

		currentTransition = nextScreenIndex


	def transitionBack
		currentTransition -= 1

	def finish
		# save the symptom state
		submitSymptom formatFriendlySymptom(syState), stages 

		return

	def setSymptom symptom
		let sy = getSymptomTemplate()
		sy.name = symptom.symptom
		syState = sy
		syTemplate = symptom

	def updateSex sex, event
		const value = typeof event == 'number' ? event : Number(event.target.value)
		
		syState.sex[sex].alpha = Math.max(0.0001, value)
		syState.sex[sex].beta = Math.max(0.0001, 100 - value)

	def updateAge key, event
		const value = typeof event == 'number' ? event : Number(event.target.value)

		syState.age[key].alpha = Math.max(0.0001, value)
		syState.age[key].beta = Math.max(0.0001, 100 - value)

	def addLocation location
		syState.locations.push(distributions.createBeta(location, 100, 1))

	def addOnset onset
		# syState.onset.ps.push(0)
		# syState.onset.ns.push(onset || "")
		return

	def startAddMultipleNatures
		addingCombination = true
		combinationsList = []

	def stopAddMultipleNatures
		const natures = distributions.createBeta(combinationsList, 100, 1, { dist: "beta", combination: true })

		syState.nature.push(natures)
		addingCombination = false

		combinationsList = []

	def addNature nature
		if !addingCombination
			syState.nature.push(distributions.createBeta(nature, 100, 1))
		else 
			combinationsList.push(nature)
			# syState.nature.push(distributions.createBeta(nature, 100, 1))

	def updateNature name, event
		const value = Number(event.target.value)

		let natIdx = syState.nature.findIndex((do(nat) nat.name === name))
		if (natIdx <= -1)
			return

		syState.nature[natIdx].alpha = Math.max(0.0001, value)
		syState.nature[natIdx].beta = Math.max(0.0001, 100 - value)


	def updateAggravator name, event
		const value = Number(event.target.value)

		let natIdx = syState.aggravators.findIndex((do(nat) nat.name === name))
		if (natIdx <= -1)
			return

		syState.aggravators[natIdx].alpha = Math.max(0.0001, value)
		syState.aggravators[natIdx].beta = Math.max(0.0001, 100 - value)
	
	def updateReliever name, event
		const value = Number(event.target.value)

		let natIdx = syState.relievers.findIndex((do(nat) nat.name === name))
		if (natIdx <= -1)
			return

		syState.relievers[natIdx].alpha = Math.max(0.0001, value)
		syState.relievers[natIdx].beta = Math.max(0.0001, 100 - value)


	def addPeriodicity period
		syState.periodicity.ps.push(0)
		syState.periodicity.ns.push(period || "")
		# syState.periodicity.push(distributions.createBeta(period, 100, 1))

	def addAggravator aggravator
		syState.aggravators.push(distributions.createBeta(aggravator, 100, 1))

	def addReliever reliever
		syState.relievers.push(distributions.createBeta(reliever, 100, 1))

	def updatePeriodicity period, event
		# FIXME: This functions produces wrong periodicity categorical values in the ps list
		const periodIdx = syState.periodicity.ns.indexOf(period)
		if periodIdx < 0
			return
		
		const totalProbabilities = syState.periodicity.ps
		totalProbabilities[periodIdx] = Number(event.target.value)
		# const rescaled = rescaleList(totalProbabilities)

		# syState.periodicity.ps = rescaled
		syState.periodicity.ps = totalProbabilities

	def updateCategoricalPeriodicity syState
		def update data\{name:string;value:number}[]
			const per = syState.periodicity

			per.ns.map do(name, idx)
				const item = data.find do(item) item.name == name
				if item
					per.ps[idx] = item.value
				else 
					per.ps = per.ps.slice(idx, 1)
					per.ns = per.ns.filter do(item) item != name


			syState.periodicity = per

	def removePeriodicity idx
		syState.periodicity.ns.splice(idx, 1)
		syState.periodicity.ps.splice(idx, 1)

	def updateSuddenOnset event
		const value = event.target.value

		suddenVal = value / 100
		syState.onset.ps[1] = suddenVal
		syState.onset.ps[0] = +((1 - suddenVal).toFixed(5))


	def updateOnset syState
		return def update val
			value = val / 100
			syState.onset.ps[1] = value
			syState.onset.ps[0] = 1 - value

	def updateLocation key, event
		const value = Number(event.target.value)

		syState.locations[key].alpha = Math.max(0.0001, value)
		syState.locations[key].beta = Math.max(0.0001, 100 - value)

	def markSymptomAsForever
		syState.duration.mean=1825
		syState.duration.sd = 90

	def updateTTO event
		# If you update the TTO process, you must update the mount function that updates the tmpTTO variable
		const {start, end} = tmpTTO
		let mu = mean([start, end])
		let scale = Math.abs(mu - end)

		syState.timeToOnset.location = mu
		syState.timeToOnset.scale = scale

	def mount
		if editSymptom !== undefined
			syState = editSymptom
			syTemplate = getSymptomByName(symptomsList)(editSymptom.name) || undefined

			const { location, scale } = editSymptom.timeToOnset
			tmpTTO.start = location - scale
			tmpTTO.end = location + scale

			currentTransition = syTemplate ? 1 : 0

			tick!


	def unmount
		currentTransition = 0
		symptomSearchStr = ""

		syState = undefined
		syTemplate = undefined

	def render
		updateOnsetWitState = updateOnset syState

		<self @hotkey("right")=transition @hotkey("left")=transitionBack @hotkey("esc")=cancel>
			<div[bgc:white w@md:50vw m:auto mt@md:10vh p:4 rd:md shadow:lg min-height@md:30vh]>

				<div[d:flex jc:space-between]>
					<[fs:xx-large fw:300 mb:1]>
						editSymptom && editSymptom.name ? "Edit Symptom: " + friendlySymptomName(editSymptom.name) : "Add New Symptom"
					<[rd:full bc:black bw:1 fs:x-large cursor:pointer] @click=cancel> "x"

				if currentTransition === 0
					<div>
						"We are about to add a new symptom to the " + conditionName + " algorithm."

						<div[mt:4]>
							<label> "Enter the symptom name"
							<input.simple-input[mt:1] bind=symptomSearchStr>

							<div[d:flex cg:1 mt:2 flw:wrap]>
								for symptom in symptomSearch(10)(kebabCase(symptomSearchStr))
									<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=setSymptom(symptom)>
										<small> friendlySymptomName symptom.symptom

							<div[mt:3]>
								if syState && syState.name.length > 0 
									"Selected: " + friendlySymptomName syState.name

							if stages && stages.length > 0 && syState && syState.name.length > 0 
								<div[mt:3]>
									"For which stage are you modeling this symptom currently?"
									<br>
									for stage in stages
										<div[pr:3]>
										<input type="checkbox" checked=(stage.symptoms.includes(syState.name)) @change=(toggleSymptomStage stage.id) id=(stage.name)>
										<label for=(stage.name)> upperFirst stage.name


						<div[mt:4 d:flex jc:flex-end]>
							<button[px:8 py:2 bg:white bw:1 rd:md fs:md bc:cool3 cursor:pointer shadow@hover:lg] [bg:blue3 tween:all transition-duration:0.3s]=(syState !== undefined) disabled=(syState === undefined) @click=(transition)> "Continue"

				elif currentTransition === 1
					<div>
						"Lets discuss the sex and age prevalence of the "
						<span[td:underline]> friendlySymptomName syState.name
						" symptom."


						<div[mt:4]>
							<p>
								"In percentages, how often does this symptom happen for Males and Females"

							<div>
								<label[fw:500]> "Males (as a percentage %): "
								# <input.simple-input[mt:1] type="number" bind=syState.sex.male.alpha placeholder="0" @change=(updateSex("male", e))>
								<SliderInput 
									label="" 
									value=syState.sex.male.alpha
									width=500
									min=0.001
									max=100
									stepSize=0.001
									gradient
									type="range"
									startLabel="Doesn't Happen"
									endLabel="Always Happens"
									updateValue=(do(val) updateSex("male", val))>

							<hr>

							<div[pt:4]>
								<label[fw:500]> "Females (as a percentage %): "
								# <input.simple-input[mt:1] type="number" bind=syState.sex.female.alpha placeholder="0" @change=(updateSex("female", e))>
								<SliderInput 
									label="" 
									value=syState.sex.female.alpha
									width=500
									min=0.001
									max=100
									stepSize=0.001
									gradient
									type="range"
									startLabel="Doesn't Happen"
									endLabel="Always Happens"
									updateValue=(do(val) updateSex("female", val))>


						

						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"

				elif currentTransition === 2
					<div>
						"In percentages, how often does this symptom happen for each age group"

						<div[mt:4]>
							for group in ageGroupList
								<div[mb:2]>
									<label[fw:500]> friendlySymptomName group
									<SliderInput 
										label="" 
										value=syState.age[group].alpha
										width=500
										min=0.001
										max=100
										stepSize=0.001
										gradient
										type="range"
										startLabel="Doesn't Happen"
										endLabel="Always Happens"
										updateValue=(do(val) updateAge(group, val))>

									<hr>

						# <div[mt:4]>
						# 	for group in ageGroupList
						# 		<div[mb:2]>
						# 			<label[fw:500]> friendlySymptomName group
						# 			# <span[c:purple9 td:underline]> friendlySymptomName group
						# 			<input.simple-input[mt:1] bind=syState.age[group].alpha @change=(updateAge(group, e)) min=0 max=100 type="number"> 


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"

				elif currentTransition === 3
					<div>
						"How often does this specific symptom of "
						<span[td:underline]> friendlySymptomName syState.name
						" happen in different locations of the body?"


						<div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
							for loc, idx in syTemplate.location
								<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=addLocation(loc)>
										<small> friendlySymptomName loc

						for loc, idx in syState.locations
							<[w:100 mb:1]>
								# <SimpleInput label="Name" type="text" bind=loc.name>
								<input.simple-input disabled type="text" bind=loc.name>
								"Which happens " 
								<input[w:14 mt:2] defaultValue=loc.alpha @change=(updateLocation(idx, e)) min=0 max=100 type="number"> 
								"% of the time."
								<div[ta:right]>
									<button type="button" @click=(syState.locations.splice(idx, 1))>
										<small[cursor:pointer c:red8]> "Remove Location"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"


				elif currentTransition === 4
					<div>
						"How long does the symptom of "
						<span[td:underline]> friendlySymptomName syState.name
						" last?"


						<div[mt:4]>
							<[w:100 mb:1]>
								"On average, this symptom lasts "
								<input[w:13] bind=syState.duration.mean min=0 type="number">
								" +/- "
								<input[w:12] bind=syState.duration.sd min=0 type="number">
								" days."

							<button type="button" @click=(markSymptomAsForever)> "This symptom lasts forever"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"


				elif currentTransition === 5
					<div>
						"Does this symptom show up suddenly or gradually?"

						# <div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
						# 	for ons, idx in syTemplate.onset
						# 		<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=(addOnset(ons))>
						# 				<small> friendlySymptomName ons


						# <div[mt:4 w:100]>
						# 	"Sudden Value:"
						# 	<input[w:14 mt:2] defaultValue=(syState.onset.ps[1] * 100) @change=(updateSuddenOnset(e)) min=0 max=100 type="number">

						<div>
							<SliderInput 
								label="" 
								value=(syState.onset.ps[1] * 100 )
								width=500
								min=0
								max=100
								stepSize=0.01
								gradient
								type="scale"
								startLabel="Gradual Onset"
								endLabel="Sudden Onset"
								updateValue=(updateOnsetWitState)>


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"



				elif currentTransition === 6
					<div>
						"What is the nature of presentation for this symptom?"

						<div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
							for nat, idx in addingCombination ? syTemplate.nature : difference(syTemplate.nature, syState.nature.map((do(nat) nat.name)))
								<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=addNature(nat)>
										<small> friendlySymptomName nat


						<div[my:2]>
							if addingCombination
								<p[fs:sm]> combinationsList.map((do(item) friendlySymptomName item)).join(" + ")
								<div[cursor:pointer c:blue4 td@hover:underline] @click=stopAddMultipleNatures> "Done Adding & Combination of symptoms"
							else
								<div[cursor:pointer c:blue4 td@hover:underline] @click=startAddMultipleNatures> "Add & Combination of symptoms"

						for nat, idx in syState.nature
							<[w:100 mb:1]>
								# <SimpleInput label="Name" type="text" bind=nat.name>
								<input.simple-input type="text" disabled bind=nat.name>
								"Which happens " 
								<input[w:14 mt:2] defaultValue=nat.alpha @change=(updateNature(nat.name, e)) min=0 max=100 type="number"> 
								"% of the time."
								<div[ta:right]>
									<button type="button" @click=(syState.nature.splice(idx, 1))>
										<small[cursor:pointer c:red8]> "Remove Nature"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"

				elif currentTransition === 7
					<div>
						"What is the periodicity of this symptom?"

						<div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
							for period, idx in difference(syTemplate.periodicity, syState.periodicity.ns)
								<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=(addPeriodicity(period))>
										<small> friendlySymptomName period



						<[w:100 my:2]>
							<CategoricalInput 
								label="A breakdown of your periodicitities - Periodicities must add up to 100%"
								data=(syState.periodicity.ns.map do(item, idx) ({ name: item, value: syState.periodicity.ps[idx] })) 
								onChangeValues=(updateCategoricalPeriodicity(syState))>


						# for period, idx in syState.periodicity.ns
						# 	<[w:100 mb:1]>
						# 		# <SimpleInput label="Name" type="text" bind=period.name>
						# 		<input.simple-input type="text" bind=period disabled>
						# 		"Which happens " 
						# 		<input[w:14 mt:2] defaultValue=syState.periodicity.ps[idx] @change=(updatePeriodicity(period, e)) min=0 max=100 type="number"> 
						# 		"% of the time."
						# 		<div[ta:right]>
						# 			# FIXME: Button does not work
						# 			<button type="button" @click=(removePeriodicity(idx))>
						# 				<small[cursor:pointer c:red8]> "Remove periodicity"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"


				elif currentTransition === 8
					<div>
						"What are the aggravators of this symptom?"

						<div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
							for agg, idx in difference(syTemplate.aggravators, syState.aggravators.map((do(agg) agg.name)))
								<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=addAggravator(agg)>
										<small> friendlySymptomName agg

						for agg, idx in syState.aggravators
							<[w:100 mb:1]>
								# <SimpleInput label="Name" type="text" bind=loc.name>
								<input.simple-input type="text" disabled bind=agg.name>
								"Which happens " 
								<input[w:14 mt:2] defaultValue=agg.alpha @change=(updateAggravator(idx, e)) min=0 max=100 type="number"> 
								"% of the time."
								<div[ta:right]>
									<button type="button" @click=(syState.aggravators.splice(idx, 1))>
										<small[cursor:pointer c:red8]> "Remove Aggravator"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"

				elif currentTransition === 9
					<div>
						"What are the relievers of this symptom?"

						<div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
							for rel, idx in difference(syTemplate.relievers, syState.relievers.map((do(rel) rel.name)))
								<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=addReliever(rel)>
										<small> friendlySymptomName rel

						for rel, idx in syState.relievers
							<[w:100 mb:1]>
								# <SimpleInput label="Name" type="text" bind=loc.name>
								<input.simple-input disabled type="text" bind=rel.name>
								"Which happens " 
								<input[w:14 mt:2] defaultValue=rel.alpha @change=(updateReliever(idx, e)) min=0 max=100 type="number"> 
								"% of the time."
								<div[ta:right]>
									<button type="button" @click=(syState.relievers.splice(idx, 1))>
										<small[cursor:pointer c:red8]> "Remove Relievers"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"


				elif currentTransition === 10
					<div>
						"What is the incubation period of this symptoms. How long until this symptom show up?"

						# <div[mt:4 d:flex cg:1 mt:2 flw:wrap]>
						# 	for rel, idx in difference(syTemplate.relievers, syState.relievers.map((do(rel) rel.name)))
						# 		<div[py:2 px:4 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:lg fs:lg] @click=addReliever(rel)>
						# 				<small> friendlySymptomName rel

						<div[pl:0 mt:2]>
							"On average, It take between "
							<input[w:12] bind=tmpTTO.start @change=updateTTO min=0 type="number">
							" and "
							<input[w:12] bind=tmpTTO.end @change=updateTTO min=tmpTTO.start type="number">
							" days to start presenting"


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transition)> "Continue"


				elif currentTransition === 11
					<div>
						"Summary of the symptom"

						<div[mt:4]>
							<pre>
								JSON.stringify(formatFriendlySymptom(syState), null, 2)


						<div[mt:4 d:flex jc:space-between]>
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(transitionBack)> "Back"
							<button[px:8 py:2 bg:blue3 bw:1 rd:md fs:md bc:blue3 cursor:pointer shadow@hover:lg] @click=(finish)> "Finish"

			<br>
			<br>
			<br>
