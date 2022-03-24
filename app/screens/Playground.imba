import { CategoricalInput } from "../components/categorical-input.imba"

export tag Playground
	width = 300

	def onChangeValues newData
		data = newData

	def updateValue val\number
		# console.log "val", val
		value = val

	def render
		<self>
			<div.container>
				<.text-4xl> "Playground"


				<div[pt:10 w:70]>
					"Lorme"


