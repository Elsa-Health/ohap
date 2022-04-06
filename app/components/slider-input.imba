
export tag SliderInput
	prop width = 300
	prop value
	prop updateValue
	prop stepSize=0.01
	prop label = ""
	prop gradient=false
	prop min = 0
	prop max = 100
	prop type = "range" # range | scale
	prop startLabel = "Start"
	prop endLabel = "End"

	def render
		isRange = type == "range"
		<self[py:2]>
			<div[fs:1.1rem]>
				label
			<div[d:flex ai:center]>
				<div[pt:6]>
					<slider width=width value=value stepSize=stepSize updateValue=updateValue gradient=gradient min=min max=max tooltip=isRange>
					if !isRange
						<div[d:flex fld:row jc:space-between w:{width}px pt:2]>
							<span> 
								`{startLabel}: {(100 - value).toFixed(2)}%`
							<span> 
								`{endLabel}: {value.toFixed(2)}%`
					else
						<div[d:flex fld:row jc:space-between w:{width}px pt:2]>
							<span> startLabel
							<span> endLabel

				if isRange
					<div[pl:4 d:flex ai:center]>
						<input.simple-input[w:20] type="number" min=min max=max value=value @change=(do(e) updateValue +e.target.value)>
						<[fs:x-large pl:2]> "%"



tag slider
	prop width = 300
	prop value = 0
	prop stepSize=0.01
	prop updateValue
	prop gradient=false
	prop min = 0
	prop max = 100
	prop tooltip = true


	active = false

	css $track-size:10px $thumb-size:calc(100% + 10px)
	css .track h:$track-size w:100% rd:6 d:flex ai:center bg:cool3
	css	.thumb h:$thumb-size w:10px bgc:$blue rd:full cursor:pointer ml:-5px
		h@hover:$track-size + 16px w@touch:$track-size + 16px tween:sizes transition-duration:0.2s
		.value fs:sm c:white bgc:blue5 w:34px pos:absolute t:-26px d:flex jc:center l:-10px


	def build
		# x = value
		y = 0


	def render
		thumbPosition = width * (value / 100)
		<self[w:{width}px] @mouseenter=(active = true) @mouseleave=(active=false) @touch.fit(self, min, max, stepSize)=(updateValue e.x)>
			<div.track [bg:linear-gradient(to right, cool3 0%, pink3  51%, $pink  100%)]=gradient>
				<div.thumb [x:{thumbPosition}px]>
					<div.value [d:none tween:all transition-duration:0.2s]=!active [d:none]=!tooltip> value.toFixed(0)



# ###########################################################
# ####################### EXAMPLES #########################
# ###########################################################
# <SliderInput 
# 					label="The label here" 
# 					value=value 
# 					width=width
# 					stepSize=0.01
# 					updateValue=updateValue>


# 				<SliderInput 
# 					label="Another Input" 
# 					value=value 
# 					width=width
# 					stepSize=10
# 					min=0
# 					max=100
# 					updateValue=updateValue>


# 				<SliderInput 
# 					label="How does the onset present?"
# 					value=value 
# 					width=width
# 					stepSize=10
# 					min=0
# 					max=100
# 					gradient
# 					type="scale"
# 					startLabel="Gradual"
# 					endLabel="Sudden"
# 					updateValue=updateValue>
