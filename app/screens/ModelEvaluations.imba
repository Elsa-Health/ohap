import Realm, { conditionsDb, modelsDb } from '../realm.ts'
import {friendlySymptomName} from "../utils.ts"
import { sortBy } from "lodash"
import axios from "axios"


let dE = [ {
	conditionName: "jciweods",
	p: 0.4,
	typical: true,
	variance: 0.001,
	vignetteId: "cwnjs"
	# vignette: []
} ]

let vignetteEvaluations = []
let diseaseName = ""

let loading = true

export tag ModelEvaluations
	def mount
		const pathnameItems = window.location.pathname.split("/")
		const conditionId = pathnameItems[pathnameItems.length - 2]
		diseaseName = pathnameItems[pathnameItems.length - 3]
		try
			const res = await modelsDb.findOne({_id: new Realm.BSON.ObjectID(conditionId)})
			state = res
			loadingConditionModel = false

			if res && res._id
				const URL = "https://model-evaluation-server-d3pcdcobha-uc.a.run.app/vignettes/getByIds"
				# const URL = "http://localhost:3001/vignettes/getByIds" 
				const result = await axios.post(URL, {
					ids: res.metadata.performance.evaluations.map do(e) e.vignetteId
				})
				const vignetteItems = result.data.map do(vign)
					const v = res.metadata.performance.evaluations.find do(e) e.vignetteId == vign.uid
					v.vignette = vign
					return v

				vignetteEvaluations = vignetteItems
				loading = false
				tick!
				return result.data
		catch error
			console.error({ error })

	
	def render
		<self>
			<.text-2xl> "Evaluation Results: {diseaseName}"

				<loading-progress-bar [w@md:100% w@lg:40% mx:auto my:20] ready=!loading>

			if !loading
				for item in sortBy(vignetteEvaluations, ["p"]).reverse()
					<VignetteEvaluationItem vEvaluation=item />






tag VignetteEvaluationItem
	showVignette = false
	prop vEvaluation
	css p:4 outline:1px solid #ccc mb:2 rd:sm
	css .title fs:18 color:blue6


	def render
		vi = vEvaluation.vignette
		<self>
			<div[d:flex jc:space-between]>
				<div>
					<.title>
						"{vEvaluation.typical ? "Typical" : "Atypical"} {friendlySymptomName vEvaluation.conditionName}"
					<[fs:1]> "ID: {vEvaluation.vignetteId}"
				<div>
					<button type="button" @click=(showVignette = !showVignette)> !showVignette ? "Show Vignette" : "Hide Vignette"

			<div>
				<> 
					"Prediction: {(vEvaluation.p * 100).toFixed(2)}% +/- {(vEvaluation.variance || 0).toFixed(2)}"


			if showVignette
				<div[pt:4]>
					<p> "Age: {vi.years} yrs, {vi.months} months and {vi.days || 0} days"

					<p> "Patient Presentation"

					<div[d:grid gcg:2em grg:2em gtc@lt-sm:1fr gtc:1fr 1fr pt:3]>
						for p in vi.presentingSymptoms
							<div[pb:4]>
								friendlySymptomName p.value
								<br>
								"Location: {p.location}"
								<br>
								"Duration: {p.duration} days"
								<br>
								"Onset: {p.onset}"
								<br>
								"Natures: {p.nature && p.nature.join ""}"
								<br>
								"Periodicity: {p.periodicity}"
								<br>
								"Aggravators: {p.aggravators && p.aggravators.join ""}"
								<br>
								"Relievers: {p.reducers && p.reducers.join ""}"



