import "../components/modal.imba"


open = true
export tag Playground
	width = 300


	def onChangeValues newData
		data = newData

	def updateValue val\number
		value = val

	def closeModal
		open = false

	def setup
		setTimeout(&, 1000) do()
			ready = true
			tick!

	# autorender = 1s
	def render
		<self>
			<div.container>
				<.text-3xl.font-bold.underline> "Playground"


				<ui-button @click=(open = true)>
					"Open"


			<modal bind:open=(open) title="Playground" onClose=closeModal size="md">
				"Lorem ipsu is here to be done with some things!!! again!!"





