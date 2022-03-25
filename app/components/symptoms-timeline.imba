import {upperFirst, min} from "lodash"
import { adjust, friendlySymptomName } from "../utils.ts"


let pallete = ["#4665af", "#a85fb4", "#f05793", "#ff7059", "#ffa600"]
let defaultColor = "#ccc"


let dayWidth = 10

tag symptom-item < div
	prop symptom\Symptom
	prop stageIdx\number


	def render
		let bgc = typeof stageIdx === 'number'  ? pallete[stageIdx] : defaultColor
		<self[d:flex fls:100]>
			<div[ai:center pos:relative]>
				<div>
					<div[h:0.5 bgc:{adjust(bgc, 70)} w:{symptom.timeToOnset.scale * 2 * dayWidth} ml:{(symptom.timeToOnset.location - symptom.timeToOnset.scale) * dayWidth} pos:absolute t:8 bgc@hover:blue5 cursor:pointer]>
						<div[h:3 w:0.75 bgc:inherit pos:absolute t:-1.2 l:0]>
						<div[h:3 w:0.75 bgc:inherit pos:absolute t:-1.2 r:0]>
					<div[ml:{symptom.timeToOnset.location * dayWidth}]>
						upperFirst(symptom.name)
						<div[w:{dayWidth * symptom.duration.mean} bg:{bgc} h:8 bg@hover:{adjust(bgc, -20)} cursor:pointer shadow:lg shadow@hover:xl rd:lg]> 

tag time-line
	prop maxDate
	css h:20px d:flex

	<self>
		for day in [0...maxDate]
			<div[w:{dayWidth} fls:0]> 
				<div[d:flex fld:column ai:flex-start]> 
					<span[fs:8px pl:1]> "|"
					<span> day


export tag SymptomsTimeline < div
	prop symptoms
	prop selectSymptom
	prop stages
	
	css pt:3
	

	def getSymptomStage symptom
		if !stages
			return 0 
		if stages.length === 0
			return 0 
		else
			const syStages = stages.filter do(stage)
				stage.symptoms.includes(symptom.name)

			const stageIds = syStages.map do(stage) 
				stage.id

			return min(stageIds)

	def getMaxDate symptoms\Symptom[]
		if (symptoms.length === 0)
			return 0
		let sortedSymptoms = symptoms.sort((do(a, b) (b.timeToOnset.location + b.duration.mean) - (a.timeToOnset.location + a.duration.mean)))
		let lastSymptom = sortedSymptoms[0]
		return lastSymptom.timeToOnset.location + lastSymptom.timeToOnset.scale + lastSymptom.duration.mean + 5

	def handleDragScroll event
		// BROKEN: This does some very funky type of scrolling :)
		let { dx } = event
		# let scrollLeft = self.scrollLeft - dx
		# self.scrollLeft = scrollLeft

	def render
		<self @touch=(handleDragScroll)>
			<div[py:0]>
				if stages && stages.length > 0
					<.text-xl> "Stages"
					<div[py:1 d:flex]>
						for stage, idx in stages
							<div[d:flex pr:4 jc:center ai:center]>
								<div[h:4 w:4 rd:md bgc:{pallete[idx]}]>
								<div[pl:1]> friendlySymptomName stage.name
			<div[bgc:gray1 ofx:scroll d:flex fld:column rg:1 py:3 pb:6 cursor@active:grabbing]>
				for symptom in symptoms
					<symptom-item @click=(selectSymptom symptom) symptom=symptom stageIdx=(getSymptomStage symptom)>
				<br />
				<time-line maxDate=(getMaxDate symptoms)>
