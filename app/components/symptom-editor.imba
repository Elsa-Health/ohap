import { Histogram } from './charts/histogram'
# @ts-expect-error
import { searchForSymptom, friendlySymptomName } from '../utils.ts'
import { SimpleInput } from './simple-input'
# @ts-expect-error
import {distributions} from "@elsa-health/model-runtime"
# @ts-expect-error
import symptomsList, { getSymptomByName, periodicitiesList } from "../data/symptoms.ts"
import _ from "lodash";
# import humanSample from "../assets/human-sample.svg"


css label fs:medium mb:0.4
css input[type="text"] p:2 outline-color:blue5
css .input-wrapper d:flex fld:column

tag beta-input 
	prop data\Beta

	<self>
		<SimpleInput bind=data.name label="Name" name=type='text' id="name__"+data.name name="name__"+data.name>
		<div[d:flex cg:2 my:2]>
			<SimpleInput bind=data.alpha label="Alpha" type='number' id="alpha__"+data.name name="alpha__"+data.name>
			<SimpleInput bind=data.beta label="Beta" type='number' id="beta__"+data.name name="beta__"+data.name>


tag weibull-input
	prop data\Weibull

	<self>
		<SimpleInput bind=data.name label="Name" name=type='text' id="name__"+data.name name="name__"+data.name>
		<div[d:flex cg:2 my:2 flw:wrap fld:row]>
			<SimpleInput bind=data.threshold label="Threshold" type='number' id="threshold__"+data.name name="threshold__"+data.name>
			<SimpleInput bind=data.shape label="Shape" type='number' id="shape__"+data.name name="shape__"+data.name>
			<SimpleInput bind=data.scale label="Scale" type='number' id="scale__"+data.name name="scale__"+data.name>

tag change-input
	prop data\Change<any>

	<self>
		<SimpleInput bind=data.name label="Name" name=type='text' id="name__"+data.name name="name__"+data.name>
		<div[d:flex cg:2 my:2 flw:wrap fld:row]>
			# <SimpleInput bind=data.category label="Threshold" type='number' id="threshold__"+data.name name="threshold__"+data.name>
			<select[d:flex fld:column w:100% p:1.5 mb:1] bind=data.name>
				<option> "color"
				<option> "size"
				<option> "shape"
				<option> ""
			<SimpleInput bind=data.from label="From" type=(data.category === "color" ? "string" : 'number') id="from__"+data.name name="from__"+data.name>
			<SimpleInput bind=data.to label="To" type=(data.category === "color" ? "string" : 'number') id="to__"+data.name name="to__"+data.name>
			<SimpleInput bind=data.duration label="Over (days)" type=(data.category === "color" ? "string" : 'number') id="to__"+data.name name="to__"+data.name>


const ageGroupList = ["newborn", "infant", "toddler", "child", "adolescent", "youngAdult", "adult", "senior"]

tag categorical-input
	prop data\Categorical

	<self>
		<SimpleInput bind=data.name label="Name" name=type='text' id="name__"+data.name name="name__"+data.name>
		for cat, idx in data.ns
			<div[d:flex cg:2 my:2] key=idx>
				<SimpleInput bind=data.ns[idx] label="Category" type='text' id="cat_n__"+idx name="cat_n__"+idx>
				<SimpleInput bind=data.ps[idx] label="P("+cat+")" type='text' id="cat_p__"+cat name="cat_p__"+cat>


let symptomSearch = searchForSymptom(symptomsList)
let getSymptom = getSymptomByName(symptomsList)

let noSexDifference = false

let tmpTTO = {
		start: 0,
		end: 0
	}

export tag SymptomEditor
	
	tmpDuration = {
		mean: 0,
		variance: 0,
	}

	css self@lg
		d:grid 
		gtc:5
		gcg:3
		.form-container gc: 1 / 3
		.visualizer-container gc: 3 / 6

	css self@lt-lg
		d:grid 
		gtc:2
		.form-container gc: 1 / 2
		.visualizer-container gc: 2 / 3

	prop data\Symptom
	prop submitSymptom

	def createLocation
		data.locations.push(distributions.createBeta("", 1, 1))

	def createAggravator
		data.aggravators.push(distributions.createBeta("", 1, 1))

	def createReliever
		data.relievers.push(distributions.createBeta("", 1, 1))

	def createNature type
		if type === "weibull"
			data.nature.push(distributions.createWeibull("", 1, 1, 1))
		else if type === "beta"
			data.nature.push(distributions.createBeta("", 1, 1))

		else if type === "change"
			data.nature.push({ name: "", from: 0, to: 1, type: "change", duration: 1, category: "size" }) # category could be either number, color, size, shape

	def createPeriodicity name
		# data.periodicity.ns.some(&) 
		let emptyExists = data.periodicity.ns.some((do(value)
			value.length === 0
		))
		if !emptyExists
			data.periodicity.ps.push(0)
			data.periodicity.ns.push(name || "")
		else
			console.log "Please fill in all the periodicity names"


	def setSymptomTemplate selectedSymptom
		const {symptom, location, periodicity, aggravators, relievers } = selectedSymptom
		data.name = symptom

		
		data.locations = location.map((do(value) distributions.createBeta(value, 1, 1)))
		data.nature = []
		data.periodicity = distributions.createCategorical("periodicity", periodicity, new Array(periodicity.length).fill(1/periodicity.length))
		data.aggravators = aggravators.map((do(value) distributions.createBeta(value, 1, 1)))
		data.relievers = relievers.map((do(value) distributions.createBeta(value, 1, 1)))

	def updateTTO event
		# If you update the TTO process, you must update the mount function that updates the tmpTTO variable
		const {start, end} = tmpTTO
		let mean = _.mean([start, end])
		let scale = Math.abs(mean - end)

		data.timeToOnset.location = mean;
		data.timeToOnset.scale = scale

	def updateLocation key, event
		const value = Number(event.target.value)
		data.locations[key].alpha = value
		data.locations[key].beta = 100 - value

	def updateAge key, event
		const value = Number(event.target.value)
		data.age[key].alpha = value
		data.age[key].beta = 100 - value

	def updateSex sex, event
		const value = Number(event.target.value)
		
		data.sex[sex].alpha = value
		data.sex[sex].beta = 100 - value

	def setEqualSexes evt
		const equal = evt.target.checked
		if equal
			data.sex.male.alpha = 100
			data.sex.male.beta = 1

			data.sex.female.alpha = 100
			data.sex.female.beta = 1
		else 
			data.sex.male.alpha = 50
			data.sex.male.beta = 50

			data.sex.female.alpha = 50
			data.sex.female.beta = 50


	def updateBetaNature key, event
		# Possibly just use the `betaListItem` method below
		const value = +event.target.value
		data.nature[key].alpha = value
		data.nature[key].beta = 100 - value

	def betaListItem field, key, event
		const value = event.target.value

		data[field][key].alpha = +value
		data[field][key].beta = 100 - value

	def mount
		const { location, scale } = data.timeToOnset
		tmpTTO.start = location - scale;
		tmpTTO.end = location + scale
		tick!
	# def updateDuration key event
	# 	const value = event.target.value
	# 	data.duration.mean = value
	
	def addNature symptom
		data.nature.push(distributions.createBeta(symptom, 1, 1))
		# return 0

	def submit e
		e.preventDefault();
		# console.log data
		submitSymptom data


	# def mount
	# 	tmpTTO.start = data.timeToOnset.location - data.timeToOnset.scale
	# 	tmpTTO.end = data.timeToOnset.location + data.timeToOnset.scale
		
	<self>
		<form.form-container @submit=submit autocomplete="off">
			<.text-2xl[ta:center mb:3]>
					"Symptom Editor Form"
			<div[d:flex fld:column]>
				<label htmlFor="symptom-name"> "Symptom Name"
				<input[max-width:100] bind=data.name type='text' id="symptom-name" name="symptom-name">

				if data.name.length > 0
					<div[d:flex cg:1 mt:1 flw:wrap]>
						for symptom in symptomSearch(5)(data.name)
							<div[p:2 mb:1 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(setSymptomTemplate(symptom))>
								<small> friendlySymptomName symptom.symptom

			# SEX
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Sex Presentation"
				
				<div[pl:2]>
					<div[mb:2]>
						<input type="checkbox" bind=noSexDifference @change=(setEqualSexes)> 
						"There is no difference between the sexes"
					<div[mb:2]>
						"Males experience this symptom "
						<input[w:14 mt:2] bind=data.sex.male.alpha @change=(updateSex("male", e)) min=0 max=100 type="number"> 
						"% of the time"
					<div>
						"Females experience this symptom "
						<input[w:14 mt:2] bind=data.sex.female.alpha @change=(updateSex("female", e)) min=0 max=100 type="number"> 
						"% of the time"


			# AGE
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Age Presentation"

				<div[pl:2]>
					for group in ageGroupList
						<div[mb:2]>
							<span[c:purple9 td:underline]> friendlySymptomName group
							" experience this symptom "
							<input[w:14 mt:2] bind=data.age[group].alpha @change=(updateAge(group, e)) min=0 max=100 type="number"> 
							"% of the time"
			
			# TIME TO ONSET
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Time to Onset"

				<div[pl:2]>
					"On average, It take between "
					<input[w:12] bind=tmpTTO.start @change=updateTTO min=0 type="number">
					" and "
					<input[w:12] bind=tmpTTO.end @change=updateTTO min=tmpTTO.start type="number">
					" days to start presenting"


				# <div[d:flex w:100 cg:2]>
				# 	<SimpleInput label="Location" bind=data.timeToOnset.location min=0 type="number">
				# 	<SimpleInput label="Scale" bind=data.timeToOnset.scale min=0 type="number">
			
			# LOCATIONS
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Locations"
					<small[cursor:pointer c:blue9] @click=(createLocation)> "+ Add Location"

				for loc, idx in data.locations
					<[w:100]>
						<SimpleInput label="Name" type="text" bind=loc.name>
						"Which happens " 
						<input[w:14 mt:2] defaultValue=loc.alpha @change=(updateLocation(idx, e)) min=0 max=100 type="number"> 
						"% of the time."
						<div[ta:right]>
							<button type="button" @click=(data.locations.splice(idx, 1))>
								<small[cursor:pointer c:red8]> "Remove Location"

						
						
						# <SimpleInput label="Name" type="text" bind=loc.name>
						# <beta-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=loc key=loc>

			# DURATION
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Duration"
					
				<[w:100]>
					"On average, this symptom lasts "
					<input[w:13] bind=data.duration.mean min=0 type="number">
					" +/- "
					<input[w:12] bind=data.duration.variance min=0 type="number">
					" days."

					<button type="button" @click=(data.duration.mean=1825)> "This symptom lasts forever"

					# TODO: Replace the weibull with a Normal Distribution
					# <weibull-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=data.duration>


			# ONSET
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Onset"
				<[w:100]>
					<categorical-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=data.onset>


			# NATURE
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Nature"
					<div[d:flex cg:4]>
						<small[cursor:pointer c:blue9] @click=(createNature("beta"))> "+ Add Beta Nature"
						# <small[cursor:pointer c:blue9] @click=(createNature("weibull"))> "+ Add Weibull Nature"
						# <small[cursor:pointer c:blue9] @click=(createNature("change"))> "+ Add Changing Nature"

				<div[d:flex flw:wrap cg:1 rg:1]>
					for sampleNature in (getSymptom(data.name)?.nature || []).filter((do(nat) !data.nature.map((do(n) n.name)).includes(nat)))
						<div[p:2 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(addNature(sampleNature))>
							<small> friendlySymptomName sampleNature
				
				for nat, idx in data.nature
					<[w:100]>
						# "On average, this symptom has the periodicity "
						# <input[w:12] bind=data.duration.mean min=0 type="number">
						# " +/- "
						# <input[w:12] bind=data.duration.variance min=0 type="number">
						# " days."
						# @ts-expect-error
						if nat._.dist === "weibull"
							<weibull-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=nat key=nat>
						else if nat._.dist === "beta"
							"On average, the nature "
							<div[mb:1]>
								<SimpleInput bind=nat.name type="text" label="Name">
								# <input bind=nat.name type="text">
							" presents in "
							<input[w:12] @change=(updateBetaNature(idx, e)) min=0 type="number">
							" % of cases"
							# <beta-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=nat key=nat>
						else if nat._.dist === "change"
							<change-input [mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=nat key=nat>
						
						<div[ta:right]>
							<button type="button" @click=(data.nature.splice(idx, 1))>
								<small[cursor:pointer c:red8]> "Remove Nature"


			# PERIODICITY
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Periodicity"
					<small[cursor:pointer c:blue9] @click=(createPeriodicity)> "+ Add Periodicity"

				<div[d:flex fld:row flw:wrap rg:1 cg:1 mt:1]>
					for periodicity in periodicitiesList
						<div[p:2 bg:blue2 rd:4 cursor:pointer shadow@hover:0 6px 6px 0 rgba(0,0,0,0.2)] @click=(createPeriodicity(periodicity))>
								<small> friendlySymptomName periodicity
				
				<[w:100]>
					<categorical-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=data.periodicity>

			# AGGRAVATORS
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Aggravators"
					<small[cursor:pointer c:blue9] @click=(createAggravator)> "+ Add Aggravator"

				for agg, idx in data.aggravators
					<[w:100]>
						# <beta-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=agg key=agg>
						<SimpleInput label="Name" type="text" bind=agg.name>
						"Which happens " 
						<input[w:14 mt:2] defaultValue=agg.alpha @change=(betaListItem("aggravators", idx, e)) type="number"> 
						"% of the time."

						<div[ta:right]>
							<button type="button" @click=(data.aggravators.splice(idx, 1))>
								<small[cursor:pointer c:red8]> "Remove Aggravator"



			# RELIEVERS
			<section[mt:4]>
				<div[d:flex cg:10 ai:center]>
					<.text-xl> 
						"Relievers"
					<small[cursor:pointer c:blue9] @click=(createReliever)> "+ Add Reliever"

				for rel, idx in data.relievers
					<[w:100]>
						# <beta-input[mb:3 bdb:{"1px solid #ccc"} pb:2 ml:6] bind=rel key=rel>
						<SimpleInput label="Name" type="text" bind=rel.name>
						"Which happens " 
						<input[w:14 mt:2] defaultValue=rel.alpha @change=(betaListItem("relievers", idx, e)) type="number"> 
						"% of the time."
						<div[ta:right]>
							<button type="button" @click=(data.relievers.splice(idx, 1))>
								<small[cursor:pointer c:red8]> "Remove Reliever"


			<button[py:2.5 px:8 w:100% bgc:blue8 c:white bw:0 rd:3 mt:6 cursor:pointer] type="submit"> "Submit"


		<div.visualizer-container[bg:gray0 ml:2]>
			<.text-2xl[ta:center mb:3]>
				"Simulations"

			# <div>
			# 	"<Histogram>"


			# <svg[c:blue8 h:10 w:10] src='../assets/human-sample.svg' >

