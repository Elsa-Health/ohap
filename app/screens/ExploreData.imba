import { datasetsDb, app } from '../realm.ts'
import { friendlySymptomName, adjustColor } from '../utils.ts'
import { upperFirst } from "lodash"
import axios from "axios"

import { format, formatDistance, formatRelative, subDays } from 'date-fns'


let datasets = []
let loadingDatasets = true

export tag ExploreData
	css .row d:flex fld: row
	css .search-container d:flex fld: column


	def handleOpenCorpus id
		window.document.location.href = "{document.location.origin}/datasets/view/{id}"


	def mount
		try 
			datasets = [] # await conditionsDb.find({}, {limit: 100})
			# const res = await datasetsDb.find({}, {limit: 250, sort: { updatedAt: -1 }, project: { annotationProcess: 0 } })
			# const res = await datasetsDb.aggregate([{$limit: 250}, { $sort: { updatedAt: -1 } }, { $project: { vignettes: 0 } }])
			const res = await axios.get("https://eu-central-1.aws.data.mongodb-api.com/app/elsa-models-lqpbx/endpoint/recentDatasets?count=20")
			datasets = res.data
			
		catch error
			console.log({error})
		
		loadingDatasets = false

	def render
		<self[pt:5 mb:10rem]>
			<div.search-container>
				<.text-3xl> "Datasets"
				<div[d:flex fld@lt-md:column jc:space-between ]>
					<div[flg:1]>
						<text-input [w:100% w@md:55%] placeholder="Search datasets">
						<chekbox-input label="My datasets only" [mt:2]>

					<ui-button variant="filled" route-to="/datasets/create-dataset">
						"+ Create Dataset"



			<hr[bc:cool3 my:1.4rem]>

			<div[pt:2]>
				<div[d:grid gcg:2em grg:2em gtc@lt-sm:1fr gtc:1fr 1fr pt:3]>
					for set in datasets
						<DataItemCard corpus=set onOpenCorpus=handleOpenCorpus>



tag badge
	prop color\string = "#4665AF"
	prop size\("sm" | "md" | "lg") = "md"
	prop variant\("outline" | "filled" | "light" | "dot") = "dot"


	def getColors variant
		switch variant
			when "outline"
				[color, "transparent", color]
			when "filled"
				[color, color, "#fff"]
			when "light"
				[adjustColor(color, 140), adjustColor(color, 140), color]
			when "dot"
				[color, "transparent", color]

	def getSizes size
		switch size
			when "xs"
				[0.5, 0.1, 0.6]
			when "sm"
				[0.6, 0.2, 0.7]
			when "md"
				[0.7, 0.3, 0.8]
			when "lg"
				[0.8, 0.4, 1.0]

	def render
		const [px, py, fs] = getSizes size
		const [outlineColor, backgroundColor, fontColor] = getColors variant
		
		<self[px:{px}rem py:{py}rem fs:{fs}rem bgc:{backgroundColor} border:1px solid {outlineColor} rd:full c:{fontColor} d:flex ai:center cg:2]>
			<div[size:1 bgc:{color} rd:full]> if variant === "dot"
			<slot>


tag DataItemCard
	css d:block
	css .model-name fs:xl fw:normal margin:0
	css .row d:flex fld:row
	css .ai-center align-items:center
	css p margin: 0

	prop corpus
	prop onOpenCorpus

	descriptionChars = 150

	def render
		<self>
			<div[shadow:md shadow@hover:lg p:4 rd:md outline: 1px solid #ccc cursor:pointer bgc@hover:#f4f4f4] @click=(onOpenCorpus corpus._id)>
				<div[d:flex jc:space-between ai:center]>
					<h2.model-name> corpus.name

					<div[d:flex c:gray5]>
						<div[d:flex ai:center px:1.2]> 
							<span.material-icons[c:green4 fs:18px mr:1]> "south"
							"0"
						<div[d:flex ai:center px:1.2]> 
							<span.material-icons[c:red4 fs:18px mr:1]> "favorite"
							"0"

				<div.row[c:gray5 d:flex cg:2 flw:wrap rg:1]>
					for tg in corpus.tags
						<badge size="sm"> friendlySymptomName tg
				<div.row[c:gray5 pb:1 pt:1.6]>
					corpus.description.slice(0, descriptionChars) + "{corpus.description.length > descriptionChars ? "...": ""}"

				<div[d:grid gtc:repeat(1, auto) gtc@lg:repeat(2, auto) gtc@xl:repeat(4, auto) c:gray5 pb:1 pt:1.6 cg:1 rg:1]>
					<div.row.ai-center>
						<span.material-icons[cursor:pointer c@hover:gray6]> "assignment"
						<p[pl:2]> "Type: " + upperFirst corpus.type 
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px ml:3 d@lt-md:none]> "circle"

					<div.row.ai-center>
						<span.material-icons[cursor:pointer c@hover:gray6]> "assignment"
						<p[pl:2]> "License: " + upperFirst corpus.license 
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px ml:3 d@lt-md:none]> "circle"
						
						
					<div.row.ai-center>
						<span.material-icons[cursor:pointer c@hover:gray6]> "person"
						<p[pl:2 c:blue5 tdl:underline]> corpus.owner.name
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px ml:3 d@lt-md:none]> "circle"
						
					<div.row.ai-center>
						# <span.material-icons[cursor:pointer c@hover:gray6]> "assignment"
						<p> "Updated {formatDistance(new Date(corpus.updatedAt), new Date(), { addSuffix: true })}"	
