import { ConditionListItem } from './condition-models'
import { friendlySymptomName } from '../utils.ts'
import { SimpleInput } from '../components/simple-input'
import { conditionsDb, modelsDb } from '../realm.ts'
import { format, formatDistance, formatRelative, subDays } from 'date-fns'

let models = [
	{ _id: "deuwiodxqas", symptoms: [], signs: [], condition: "pneumonia", nickname: "pneumonia-tanzania-children" },
	{ _id: "deuwi34xqas", symptoms: [], signs: [], condition: "tinea-nigra", nickname: "Tinea Nigra" },
	{ _id: "deuwirfsqas", symptoms: [], signs: [], condition: "brochitis", nickname: "brochitis - ally" },
	{ _id: "de65iodxqas", symptoms: [], signs: [], condition: "vaginal-candidiasis", nickname: "blue - vaginal candidiasis" },
]

let metadata = { performance: { sensitivity: 0.5, specificity: 0.2, f1: 0.99, kl: null }, activity: { downloads: 30, likes: 1 } }

let likes  

let conditionSearchString = ""

let item = { _id: "0eincds", name: "Test Condition (Ally)", condition: "test-condition", createdAt: new Date(), updatedAt: new Date(), authorName: "ally" }
let modelsList = []

tag ConditionItemCard
	css shadow:md bg:blue1 px:3 py:3 rd:lg shadow@hover:lg cursor:pointer bg@hover:blue4 c@hover:white tween:all transition-duration:0.3s
	<self>
		data


export tag ExploreModels
	css .search w:100% fs:md p:3 rd:md bw:0.1 outline-color:blue5 bc:blue3

	conditionsList = []
	loadingConditions = true

	def handleOpenModel conditionName, modelId
		window.document.location.href = "{document.location.origin}/condition/{conditionName}/{modelId}"

	def filterBySearchStr model, searchStr
		if model.condition.toLowerCase().includes(searchStr.toLowerCase()) || model.name.toLowerCase().includes(searchStr.toLowerCase())
			return true
		else
			return false
	def mount
		try 
			const results = [] # await conditionsDb.find({}, {limit: 100})
			conditionsList = results

			const models = await modelsDb.find({}, {limit: 250, sort: { updatedAt: -1 } })
			modelsList = models
		catch error
			console.log({error})
		
		loadingConditions = false

	<self>
		<div[mt:2]>
			# <SimpleInput[mb:3] bind=conditionSearchString type="text" label="Explore disease models">
			<label[fs:lg c:cool8] htmlFor="modelSearch"> "Explore disease models"
			<div[mt:1]>
				<input.search type="text" bind=conditionSearchString placeholder="Search for conditions. ie: Malaria, Tinea Pedis, Gastritis, ...">

			<div[d:flex fld:row cg:2 rg:2  flw:wrap mb:6 pt:4]>
				if loadingConditions
					<[fs:large]> "Loading ..."
				for condition in conditionsList.filter((do(x) x.name.toLowerCase().includes(conditionSearchString.toLowerCase()))).slice(0, 50)
					<ConditionItemCard data=friendlySymptomName(condition.name) route-to=`/condition/${condition.name}$`>
					# <div[shadow:md bg:blue1 px:4 py:4 rd:lg shadow@hover:lg cursor:pointer] route-to=`/condition/${condition.name}$`>
						

			<a href="/create-condition"> "+ Create new Condition / Disease"
			<br>
			<br>
			<span[p:2 outline:1px solid #ccc rd:md shadow@hover:md cursor:pointer] route-to="/create-condition-model"> "Create New Model/Algorithm"


		<div[py:4]>
			<[fs:large]> "Recently Updated"

			<div[d:grid gcg:2em grg:2em gtc@lt-sm:1fr gtc:1fr 1fr pt:3]>
				for model in modelsList.filter(do(mod) filterBySearchStr mod, conditionSearchString)
					<div route-to="/condition/{model.condition}/{model._id}" >
						<ModelItemCard model=model onOpenModel=(console.log)>




tag ModelItemCard
	css d:block
	css .model-name fs:xl fw:normal margin:0
	css .row d:flex fld:row
	css .ai-center align-items:center
	css p margin: 0

	prop model
	prop onOpenModel

	def render
		const hasPerf = model.metadata && model.metadata.performance
		const sensitivity = hasPerf ? model.metadata.performance.recall || 0 : 0
		const specificity = hasPerf ? model.metadata.performance.specificity || 0 : 0
		const f1 = hasPerf ? model.metadata.performance.f1 || 0 : 0

		<self>
			<div[shadow:md shadow@hover:lg p:4 rd:md outline: 1px solid #ccc cursor:pointer bgc@hover:#f4f4f4] @click=(onOpenModel model.condition, model._id)>
				<div[d:flex jc:space-between ai:center]>
					<h2.model-name> model.name

					<div[d:flex c:gray5]>
						<div[d:flex ai:center px:1.2]> 
							<span.material-icons[c:green4 fs:18px mr:1]> "south"
							"0"
						<div[d:flex ai:center px:1.2]> 
							<span.material-icons[c:red4 fs:18px mr:1]> "favorite"
							"0"

				<div.row[c:gray5 pb:1 pt:1.6]>
					<div.row.ai-center>
						<span.material-icons[cursor:pointer c@hover:gray6]> "assignment"
						<p[pl:2 mr:3]> friendlySymptomName model.condition 
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px]> "circle"
						
						
					<div.row.ai-center[pl:2]>
						<span.material-icons[cursor:pointer c@hover:gray6]> "person"
						<p[pl:2 c:blue5 tdl:underline mr:3]> model.ownerEmail.split("@")[0]
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px]> "circle"
						
					<div.row.ai-center[pl:2]>
						# <span.material-icons[cursor:pointer c@hover:gray6]> "assignment"
						<p[pl:2]> "Updated {formatDistance(new Date(model.updatedAt), new Date(), { addSuffix: true })}"	

				<div.row[c:gray5 py:1.2]>
					<div.row.ai-center>
						<span.material-icons[cursor:pointer c@hover:gray6]> "poll"
						<p[pl:2 mr:3]> "Sensitivity: {sensitivity.toFixed(3)}"
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px]> "circle"
						
						
					<div.row.ai-center[pl:2]>
						<p[pl:2 mr:3]> "Specificity: {specificity.toFixed(3)}"
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px]> "circle"
						
					<div.row.ai-center[pl:2]>
						<p[pl:2 mr:3]> "F1: {f1.toFixed(3)}"
						<span.material-icons[cursor:pointer c@hover:gray6 fs:6px]> "circle"
					
					<div.row.ai-center[pl:2]>
						<p[pl:2]> "KL: N/A"
