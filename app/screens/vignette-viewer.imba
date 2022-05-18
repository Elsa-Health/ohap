import { getMedicationByName } from '../data/medications.ts'
import riskFactors, {getFactorByName} from '../data/riskFactors.ts'
import allergies, {getAllergyByName} from '../data/allergies.ts'
import { VignetteCreator } from './vignette-creator'
import Realm, { datasetsDb, app } from '../realm.ts'
import { friendlySymptomName, toggleStringList, searchForSymptom } from '../utils.ts'

import {last} from "lodash"

let corpusId = ""
let vignette;
let loading = true
let vignetteIdx = ""

export tag VignetteViewer
	loading = true
	
	def mount
		loading = true
		corpusId = ""
		vignetteIdx = ""

		const pathname = window.location.pathname.split("/")
		corpusId = last(pathname.slice(0, pathname.length - 1))
		vignetteIdx = last(pathname)
		try 
			const res = await datasetsDb.findOne({ _id: Realm.BSON.ObjectID(corpusId) })
			vig = res.data.vignettes[parseInt(vignetteIdx)]
			vignette = {
				...vig,
				investigations: vig.investigations.map do(inv)
					{
						...inv
						value: inv.name
						label: inv._.isPanel ? "{inv._.panelAlias} - {inv.name}" : inv.name,
						result: {
							value: inv.type === "boolean" ? false : "",
							description: ""
						}
					}
				differentials: vig.differentials.map((do(dif) { value: dif, label: friendlySymptomName dif }))
				"allergies": vig["allergies"].map((do(alergy) { ...getAllergyByName(alergy), value: alergy, label: friendlySymptomName alergy }))
				"risk-factors": vig["risk-factors"].map((do(rf) { ...getFactorByName(rf), value: rf, label: friendlySymptomName rf }))
				"recent-medications": vig["recent-medications"].map((do(med) { ...getMedicationByName(med), value: med, label: friendlySymptomName med }))
				"recent-infected-person-contact": vig["recent-infected-person-contact"].map((do(med) { value: med, label: friendlySymptomName med }))
			}
			loading = false
			console.log vig

			tick!

		catch error
			console.log {error}
			window.alert "There was an error loading the dataset. Please try again."

	def unmount
		loading = true


	<self>
		if loading
			<loading-progress-bar ready=!loading>
		
		if vignette && !loading
			<VignetteCreator defaultState=vignette isLocked=true>
