# import Plotly from 'plotly.js-dist-min'

export tag Histogram
	prop data = []

	def awaken
		let x = [];
		for i in [1...100]
			x[i] = Math.random()

		let trace = {
			x: x,
			type: "histogram"
		}

		# Plotly.newPlot("histogramRoot", [trace])
		console.log "awaken"

	<self>
		<div#histogramRoot>