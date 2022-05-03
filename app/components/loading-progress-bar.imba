

tag loading-progress-bar
	prop value\number = 0
	prop optimistic\boolean = true
	prop ready\boolean = false
	prop optimisticValue = 0
	prop autoHide\boolean = false
	prop hidden\boolean = false

	optimisticTimerRef = undefined
	
	css h:2 bgc:cool4 rd:sm
		.bar bgc:$primary h:2 rd:sm
		.text fs:sm ta:center

	def runTimer interval
		optimisticTimerRef = setInterval(&, interval) do()
			optimisticValue = optimisticValue + 0.5

	def setup
		if optimistic
			self.autorender = 100
			runTimer 100

	def rendered
		if ready 
			optimisticTimerRef && clearInterval optimisticTimerRef
			setTimeout(&, 1000) do()
				hidden = true
		if optimistic
			if optimisticValue === 33
				clearInterval(optimisticTimerRef)
				runTimer 200
				optimisticValue = 34
			elif optimisticValue === 78
				clearInterval(optimisticTimerRef)
				runTimer 400
				optimisticValue = 79
			elif optimisticValue === 99
				clearInterval(optimisticTimerRef)
		if optimisticValue >= 100 or value >= 100
			optimisticTimerRef && clearInterval optimisticTimerRef
			value = 100
			optimisticValue = 100

	def render
		v = ready ? 100 : optimistic ? optimisticValue : Math.min(100, value)
		<self [d:none tween:all 350ms ease animation-duration:1s transition-delay:1s]=hidden>
			<div.bar[w:{v + "%"} tween:all transition-duration:0.2s] [tween:all w:100% transition-duration:0.5s]=ready>
			<div.text> "Loading {Math.round(v)}%"