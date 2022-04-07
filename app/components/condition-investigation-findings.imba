import { friendlySymptomName } from "../utils.ts"
import { distributions } from "@elsa-health/model-runtime"
import { investigations as invsList, normalityRangeItems } from "../data/investigations.ts"
import { SliderInput } from "./slider-input.imba"
import { CategoricalInput } from "./categorical-input.imba"

let investigationList = invsList.map do(inv)
	let result
	if inv.type === "boolean" or inv.type === "normality"
		result = distributions.createBeta(inv.name, 50, 50)
	elif inv.type === "number" or inv.type === "range"
		result = distributions.createCategorical(inv.name, ["high", "normal", "low"], [0,0,0])

	return {
		...inv,
		results: result
	}

tag condition-investigation-findings
	prop investigations = []
	prop close
	prop submit

	searchStr = ""

	def activeInv name
		(investigations.filter do(i) i.name === name).length > 0

	def searchFilter str, list
		if searchStr.length < 1
			return []

		const res = list.filter do(i)
			i.name.toLowerCase().includes searchStr.toLowerCase()

		res.slice 0, 6 


	def toggleInv name
		const exists? = activeInv name
		if exists?
			searchStr = ""
			investigations = investigations.filter do(i) i.name !== name
		else
			searchStr = ""
			inv = investigationList.find do(inv) inv.name === name
			investigations = [ ...investigations, inv ]

	def saveInvs
		submit investigations

	def updateBiInv name, value
		investigations = investigations.map do(inv)
			if inv.name === name
				let result = inv.results
				result.alpha = Math.max(0.0001, +value)
				result.beta === Math.max(0.0001, 100 - +value)
				{...inv, results: result }
			else
				inv

	def updateCategoricalInv investigation
		def update data\{name: string; value:number}[]
			investigations = investigations.map do(inv)
				if inv.name === investigation.name
					for n, idx in inv.results.ns
						inv.results.ps[idx] = (data.find do(dt) dt.name === n).value

				return inv


	def updateComplexInv name, key, value
		# TODO: Update
		investigations = investigations.map do(inv)
			if inv.name === name
				let result = inv.results[key]
				result.alpha = Math.max(0.0001, +value)
				result.beta = Math.min(0.0001, 100 - +value)
				{...inv, result: { ...inv.results, [key]: result }}
			else
				inv

	def removeInv name
		investigations = investigations.filter do(f)
			f.name !== name


	def render
		<self.modal.is-active>
			<div.modal-background>
			<div.modal-content.has-background-white.p-4[rd:md]>
				<h1.subtitle.is-3> "Investigation Findings"


				<label>
					"Search"
					<input.input 
					bind=searchStr 
					type="text" 
					placeholder="Search Investigations, mrdt, cd4, ...">

					<div.tags.pt-2>
						for inv in searchFilter(searchStr, investigationList)
							<span.tag.is-medium[cursor:pointer]
								.is-primary=activeInv(inv.name)
								@click=(toggleInv inv.name)> 
									friendlySymptomName inv.name


				for inv in investigations
					<div>
						<label>
							<collapsible title=inv.name onRemove=(do removeInv inv.name)>
								<div>
									if inv.type === "boolean"
										<SliderInput
											label=""
											value=inv.results.alpha
											min=0.0001
											max=100
											width=300
											type="scale"
											gradient
											stepSize=0.001
											endLabel="Positive"
											startLabel="Negative"
											updateValue=(do(val) updateBiInv inv.name, val)
											>
									elif inv.type === ""
										<input.input bind=inv.result.value />
									elif inv.type === "range" or inv.type === "number"
										<CategoricalInput 
										data=(inv.results.ns.map do(item, idx) ({ name: item, value: inv.results.ps[idx] })) 
										onChangeValues=(updateCategoricalInv(inv)) label=("") >
									elif inv.type === "normality"
										<SliderInput
											label=""
											value=inv.results.alpha
											min=0.0001
											max=100
											width=300
											type="scale"
											gradient
											stepSize=0.001
											startLabel="Normal"
											endLabel="Abnormal"
											updateValue=(do(val) updateBiInv inv.name, val)
											>


				<div.is-flex.is-justify-content-flex-end>
					<button.button.mr-3 @click=close> "Cancel"
					<button.button.is-primary @click=saveInvs > "Save"






tag collapsible
	prop title = ""
	prop onRemove

	css pt:2 pb:2

	open = false

	def toggleOpen
		open = !open

	def remove
		onRemove!


	<self>
		<div[d:flex fld:row c:$blue cursor:pointer ai:center] @click=toggleOpen>
			<span.material-icons> if !open then "expand_more" else "expand_less"
			<h4.mb-0[fs:1.3rem]> title

			<div[ml:10 fg:1 c:black flex:1 text-align:right]>
				<span[cursor:pointer c@hover:red] @click=remove > "Remove"

		if open
			<div[mt:-3 pl:10]>
				<slot>
