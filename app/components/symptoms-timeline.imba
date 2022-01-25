import {upperFirst} from "lodash"


let dayWidth = 30

tag symptom-item < div
	prop symptom\Symptom
	
	<self[d:flex fls:100]>
		<div[ai:center pos:relative]>
			<div>
				<div[h:1 bgc:blue4 w:{symptom.timeToOnset.scale * 2 * dayWidth} ml:{(symptom.timeToOnset.location - symptom.timeToOnset.scale) * dayWidth} pos:absolute t:8 bgc@hover:blue5 cursor:pointer]>
					<div[h:5 w:1 bgc:inherit pos:absolute t:-2.2 l:0]>
					<div[h:5 w:1 bgc:inherit pos:absolute t:-2.2 r:0]>
				<div[ml:{symptom.timeToOnset.location * dayWidth}]>
					upperFirst symptom.name
					<div[w:{dayWidth * symptom.duration.mean} bg:gray3 h:8 bg@hover:gray4 cursor:pointer]> 

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
	css bgc:gray1 ofx:scroll d:flex fld:column rg:3 py:3 pb:6 cursor@active:grabbing


	prop symptoms
	prop selectSymptom

	def getMaxDate symptoms\Symptom[]
		if (symptoms.length === 0)
			return 0
		# let sortedSymptoms = symptoms.sort((do(a, b) (b.timeToOnset.location + b.duration.scale) - (a.timeToOnset.location + a.duration.scale)))
		let sortedSymptoms = symptoms.sort((do(a, b) (b.timeToOnset.location + b.duration.mean) - (a.timeToOnset.location + a.duration.mean)))
		let lastSymptom = sortedSymptoms[0]
		# console.log lastSymptom
		return lastSymptom.timeToOnset.location + lastSymptom.timeToOnset.scale + lastSymptom.duration.mean + 5

	def handleDragScroll event
		// BROKEN: This does some very funky type of scrolling :)
		let { dx } = event
		# let scrollLeft = self.scrollLeft - dx
		# self.scrollLeft = scrollLeft

	<self @touch=(handleDragScroll)>
		for symptom in symptoms
			<symptom-item @click=(selectSymptom symptom) symptom=symptom>
		<br />
		<time-line maxDate=(getMaxDate symptoms)>