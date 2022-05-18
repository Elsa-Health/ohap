import { isResourceContributor, friendlySymptomName, getVignetteAgeString } from '../utils.ts'
import Realm, { datasetsDb, app } from '../realm.ts'
import { last, upperFirst } from "lodash"

let corpus = {
	name: ""
}
let corpusId = ""
let loadedCorpus = false
let showAddContributor = false;


export tag DatasetSummary
	def mount
		corpusId = last(window.location.pathname.split("/"))
		console.log corpusId
		try 
			const res = await datasetsDb.findOne({ _id: Realm.BSON.ObjectID(corpusId) })
			# console.log res
			corpus = res
			loadedCorpus = true

		catch error
			console.log {error}
			window.alert "There was an error loading the dataset. Please try again."

	def render
		const isContributor = isResourceContributor(corpus)(app.currentUser && app.currentUser.id)

		<self[pt:5 mb:10rem]>
			<loading-progress-bar ready=loadedCorpus>

			<modal size="sm" title="Add Contributor" onClose=(do() showAddContributor = false) open=showAddContributor>
				<add-contributor-form resourceType="dataset" resourceId=corpusId resourceName=corpus.name onClose=(do() showAddContributor = false)>


			if loadedCorpus
				<.text-3xl> corpus.name
				<div>
					corpus.description

				if isContributor
					<ui-button @click=(showAddContributor = true)> "Add Contributors"


				if corpus.datasetType === "vignette"
					<div[pt:2rem]>
						<div[py:3 d:flex jc:space-between]>
							<.text-xl> "Vignettes list ({corpus.data.vignettes.length})"
							if isContributor
								<ui-button variant="filled" route-to="/datasets/view/{corpusId}/create-vignette"> "+ Add Vignette"

						css thead bgc:cooler4 bw:0
						css th ta:left
						css td bd: 1px solid cool2 padding: 0.5rem;
						css tr bgc@even:cool2/50;

						<table-ui headers=["Condition", "Presentation", "Age", "Sex", "Actions"]>
							for vign, idx in corpus.data.vignettes
								<tr[py:2rem]>
									<td> friendlySymptomName vign.condition
									<td> vign.presentation
									<td> getVignetteAgeString vign.age
									<td> upperFirst vign.sex
									<td[d:flex]> 
										<ui-button variant="subtle"> "Delete"
										<ui-button route-to="{idx}" variant="subtle"> "Open"







let copus = {
	"ownerId": "",
	"name": "Tanzania Test",
	"description": "This is a test description",
	"homepage": "https://elsa.health",
	"datasetType": "vignette",
	"repository": "https://elsa.health",
	"paper": "https://elsa.health",
	"collectionPeriod": {
		"start": "2019-06-13",
		"end": "2022-05-02"
	},
	"language": "english",
	"countries": [
		{
			"name": "Tanzania, United Republic of",
			"code": "TZ",
			"capital": "Dodoma",
			"region": "AF",
			"currency": {
				"code": "TZS",
				"name": "Tanzanian shilling",
				"symbol": "Sh"
			},
			"language": {
				"code": "en",
				"name": "English"
			},
			"flag": "https://restcountries.eu/data/tza.svg"
		},
		{
			"name": "Kenya",
			"code": "KE",
			"capital": "Nairobi",
			"region": "AF",
			"currency": {
				"code": "KES",
				"name": "Kenyan shilling",
				"symbol": "Sh"
			},
			"language": {
				"code": "en",
				"name": "English"
			},
			"flag": "https://restcountries.eu/data/ken.svg"
		}
	],
	"license": "Open Data Commons Attribution License",
	"tags": [
		"test",
		"one",
		"two"
	],
	"contact": {
		"email": "Contact email",
		"name": "Contact p",
		"organization": "Test Org"
	},
	"owner": {
		"name": "Onwer name",
		"email": "Owner email",
		"address": "",
		"website": "Owner website"
	},
	"annotationProcess": "Annotation.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"sensitiveInformation": "Sensitive Info.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"socialImpact": "Social Impact.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"biases": "Biases.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"knownLimitations": "Limitations.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"citation": "Citation.\nDedicate your dataset to the public domain: This isn’t technically a license since you are relinquishing all your rights in your dataset by choosing to dedicate your dataset to the public domain. To donate your work to the public domain, you can select “public domain” from the license menu when creating your dataset.",
	"createdAt": "2022-05-05T00:19:41.901Z",
	"updatedAt": "2022-05-05T00:19:41.901Z",


	data: {
		vignettes: [
			{
				condition: "Malaria"
				presentation: "typical"
				age: {
					years: 20
					months: 4
					days: 1
				},
				sex: "female"
			}
			{
				condition: "Pneumonia"
				presentation: "typical"
				age: {
					years: 20
					months: 4
					days: 1
				},
				sex: "female"
			}
			{
				condition: "Dysentry"
				presentation: "typical"
				age: {
					years: 20
					months: 4
					days: 1
				},
				sex: "female"
			}
		]
	}
}
