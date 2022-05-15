import {licenses, contentRefernceURL} from '../data/licences.ts'
import { countriesList } from '../data/countries.ts'
import { upperFirst } from 'lodash'
import { getCorpusTemplate } from '../data/empty-corpus.ts'
import {languages} from "../data/languages.ts"
import {datasetsDb, app} from "../realm.ts"



const c = {
	name: "",
	description: "",
	homepage: "",
	datasetType: "", # "vignette" or "tabular" or "images" or "video",
	repository: "",
	paper: "",

	collectionPeriod: {
		start: new Date().toDateString(),
		end: new Date().toDateString(),
	},
	language: "english",
	countries: [],
	license: "",
	tags: [],
	contact: {
		email: "",
		name: "",
		organization: "",
	},
	owner: {
		name: "",
		email: "",
		address: "",
		website: "",
	},

	// Descriptions
	annotationProcess: "",
	sensitiveInformation: "",
	socialImpact: "",
	biases: "",
	knownLimitations: "",
	citation: "",

	createdAt: new Date(),
	updatedAt: new Date(),
};
let corpus = getCorpusTemplate()


const datasetTypeOptions = ["tabular", "image", "vignette", "video", "audio"].map do(dt)
	{
		label: upperFirst dt
		value: dt
	}

const languageOptions = languages.map do(dt)
	{
		label: dt
		value: dt
	}

const licenseOptions = licenses.map do(lt)
	{
		...lt,
		value: lt.name
	}

export tag CreateDataset
	css .fluid-grid d:grid gtc:repeat(1, auto) gtc@md:repeat(4, auto) g:1.5em py:0.8rem


	def submit
		if (corpus.name.length === 0)
			return window.alert("Please ensure that your dataset has a title/name.")

		const conf = window.confirm "Please confirm that you are creating a new dataset with the correct details."
		if (!conf) 
			return
		
		if !app.currentUser.id
			return window.alert("You do not have a user account. Please sign in.");

		try 
			const result = await datasetsDb.insertOne({
				...corpus
				ownerId: app.currentUser.id,
				ownerEmail: app.currentUser.profile.email,
				ownerName: app.currentUser.customData.username || ""
				createdAt: new Date(),
				upcatedAt: new Date(),
			})

			window.alert(`Successfully created the {corpus.name} dataset`);

			corpus = getCorpusTemplate()
			# TODO: Go to the corpus definition/editor page??
		catch err
			console.log "Error:", err
			window.alert "Error! Unable to create corpus!"


		


	def updateTags val\string
		const tags = val.split(",").map do(t)
			t.trim()
		corpus.tags = tags

	def render
		console.log corpus
		<self[pt:5 mb:10rem]>
			<.text-3xl> "Create a new dataset"

			<div>
				<div.fluid-grid>
					<text-input label="Dataset Name" required bind=corpus.name>

				<div.fluid-grid>
					<text-input label="Homepage" placeholder="https://..." required bind=corpus.homepage>
					<select-input options=datasetTypeOptions searchable=false label="Dataset Type" labelKey="label" required bind=corpus.datasetType>
					<text-input label="Repository" placeholder="https://github.com/elsa-Health" bind=corpus.repository>
					<text-input label="Paper" placeholder="https://arxiv.com/1032/380ss093" bind=corpus.paper>

				<div[py:0.8rem]>
					<text-area-input label="Description" bind=corpus.description rows=4>

				<hr[bc:cool1/20 my:8]>

				<div.fluid-grid>
					<select-input options=languageOptions searchable=true label="Dataset Language" labelKey="label" required bind=corpus.language>
					<multi-select-input bind=corpus.countries options=countriesList label="Countries Collected" labelKey="name" valueKey="name">
					<select-input options=licenseOptions searchable=false label="Dataset License" labelKey="name" required bind=corpus.license>
					<text-input label="Tags (optional, comma separated)" onChange=updateTags>


				<div.fluid-grid>
					<date-input label="Dataset Collection Start" bind=corpus.collectionPeriod.start>
					<date-input label="Dataset Collection End" bind=corpus.collectionPeriod.end>
					<text-input label="Person of contact - Name" bind=corpus.contact.name>
					<text-input label="Person of contact - Email" bind=corpus.contact.email>
					<text-input label="Person of contact - Organization" bind=corpus.contact.organization>
					<text-input label="Data owner - Name" bind=corpus.owner.name>
					<text-input label="Data owner - Email" bind=corpus.owner.email>
					<text-input label="Data owner - Website" bind=corpus.owner.website>



				<hr[bc:cool1/20 my:8]>

				<div[d:flex fld:column g:1rem]>
					<text-area-input label="Annotation Process" required bind=corpus.annotationProcess>
					<text-area-input label="Sensitive Information" required bind=corpus.sensitiveInformation>
					<text-area-input label="Social Impact of Dataset" required bind=corpus.socialImpact>
					<text-area-input label="Biases in Dataset" required bind=corpus.biases>
					<text-area-input label="Known Limitations" required bind=corpus.knownLimitations>
					<text-area-input label="Citation Details" required bind=corpus.citation>



				<div[my:8]>
					<ui-button variant="filled" @click=submit type="button">
						"Submit"

				