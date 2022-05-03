import Realm, {modelsDb, app} from "../realm.ts"
import {format} from "date-fns"
import {last} from "lodash"


# TODO: Fix such that when user loads the page 
let profile = {
	name: {
		first: "",
		middle: "",
		last: ""
	},
	email: "",
	createdAt: new Date()
}

let myModels = []
let modelSearchStr = ""

let myVignettes = []
let myDatasets = []

let activeTabIndex = 0
let tabs = [
	{ title: "My models", count: myModels.length},
	{title: "My vignettes", count: 0}, 
	{title: "My datasets", count: 0}, 
	{title: "My profile"}
]

export tag Profile
	css td bd: 1px solid cool2 padding: 8px;
	css tr bgc@even:cool2/50;
	css pt:10


	def mount
		userId = last(window.location.pathname.split("/"))
		if !userId || userId.length === 0
			return

		try
			const modelRes = await modelsDb.find({ ownerId: userId })
			myModels = modelRes
			updateTabChipCount "My models", myModels.length

			# const vignettesRes = []
			myVignettes = []
			myDatasets = []


			console.log modelRes
		catch error
			console.error({error})


	def handleChangeTab tabName
		activeTabIndex = tabs.findIndex do(t)
			t.title === tabName

	def updateTabChipCount name, count
		tabs = tabs.map do(t)
			if t.title === name
				return { ...t, count }
			return t


	def render
		activeTab = tabs[activeTabIndex]
		<self>
			<.text-4xl> "Welcome, {profile.name.first} {profile.name.last}"


			<tab-view 
				activeTab=activeTab.title
				onChangeTab=handleChangeTab
				tabs=tabs>

			
			if activeTabIndex === 0
				<div[d:flex jc:space-between my:5]>
					<input.simple-input[w:80] bind=modelSearchStr placeholder="Search">
					<button.primary> "+ Create New Model"
				<table-ui headers=["Model", "Condition", "Performance", "Last update", "Actions"]>
					for model in myModels.filter((do(m) 
						m.condition.includes(modelSearchStr.toLowerCase!) or m.name.toLowerCase().includes(modelSearchStr.toLowerCase!)))
						<tr>
							<td> model.name
							<td> model.condition
							<td> if model.metadata && model.metadata.performance then "F1: {model.metadata.performance.f1}"
							<td> format(model.updatedAt,'dd MMM yyyy')
							<td>
								<a href="{document.location.origin}/condition/{model.condition}/{model._id.toString()}"> "Edit / Update"



tag table-ui
	css th fw:500 ta:left bgc:cool2/70
	css th, td bd: 1px solid cool2 padding: 8px;

	prop headers\[] = ["Disease Name", "Created By", "Presentation", "Actions"]
	prop data = {
		headers,
		data: [
			["Malaria", "@Ally", "Typical"]
		]
	}
	<self>
		<table[w:100% border-collapse:collapse rd:md shadow:xs]>
			<thead[w:100% rd:md]>
				<tr[rd:md]>
					for header in headers
						<th[w:{100 / headers.length}%]> header
			<tbody>
				<slot>


tag tab-view
	css .tab-nav-container d:flex fld:row bdb:1px solid cool2 transition-property:all transition-duration:5s tween:all
		.tab-nav-item px:2rem py:0.4rem c@hover:$primary cursor:pointer

	prop activeTab = "My Models"
	prop onChangeTab
	prop tabs = []

	def setActiveTab tab
		onChangeTab tab

	<self>
		<div.tab-nav-container>
			for tab in tabs
				<div.tab-nav-item [c:$blue bdb:medium solid $primary]=(activeTab===tab.title) @click=(setActiveTab tab.title)>
					tab.title
					if tab.count !== undefined
						<span[bgc:gray2 fs:sm py:0.5 px:1.5 rd:full ml:1]> tab.count
