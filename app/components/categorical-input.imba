import _ from "lodash"
import {friendlySymptomName} from "../utils.ts"

export tag CategoricalInput < div
	prop data\{name:string;value:number}[]
	prop onChangeValues
	prop label = ""

	def removeItem name
		onChangeValues data.filter((do(d) d.name != name))

	def updateValue name, value
		const newData = data.map do(d) d.name == name ? ({ ...d, value: value / 100 }) : d
		onChangeValues newData

	def render
		console.log data
		sum = _.sum(data.map((do(d) d.value * 100)))
		<self>
			label


			for row in data
				<div[d:grid gtc:repeat(2, 1fr) ai:center pt:2]>
					<div>
						friendlySymptomName row.name

					<div[d:flex ai:center]>
						<input.simple-input min=0 max=100 value=(row.value * 100) @change=(do(e) updateValue(row.name, +e.target.value)) type="number">
						<span.material-icons[cursor:pointer c@hover:red5] @click=(removeItem row.name)> "close"


			<hr[my:4]>

			<div[ta:end pr:10%]>
				<[c:red7 fw:bold]=(sum > 100) [c:$blue fw:bold]=(sum == 100)> sum + " %"
