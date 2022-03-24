export tag SimpleSearchBox
	css $rad:0.5rem $dur:.3s $color-dark:#2f2f2f $color-light:#fff $height:3.5rem $btn-width:6rem $bez:cubic-bezier(0, 0, 0.43, 1.49)
	css form pos:relative w:100% bgc:$blue rd:$rad
	css input, button h:$height bd:0 c:$color-dark fs:1.2rem
	# css input[type="search"] bgc:$color-light w:100% p:0 1.6rem rd:$rad appearence:none pos:relative zi:1 tween:all transition-property: all transition-duration:$dur transition-timing-function:ease
	css button d:none pos:absolute t:0 r:0 w:$btn-width fw:bold bgc:$blue rd: 0 $rad $rad 0 c:white
	# css input::not(::placeholder-shown) rd: $rad 0 0 $rad w:calc(100% - $btn-width) tween:all transition-property:all transition-duration:0.5s
	# css input::not(::placeholder-shown) + button d:block tween:all transition-property:all transition-duration:0.5s
	css label pos:absolute clip:rect(1px 1px 1px 1px) p:0 bd:0 h:1px w:1px of:hidden tween:all transition-property:all transition-duration:0.5s

	prop data

	searching = false

	def onSubmit evt
		evt.preventDefault!

	<self>
		<form onsubmit=onSubmit role="search">
			<label for="search"> "Search for stuff"
			<input[w:100% p:0 .6rem rd:$rad appearence:none pos:relative zi:1 bgc:cool1 bd:1px solid #ccc rd:$rad outline:none] [rd: $rad 0 0 $rad w:calc(100% - $btn-width) tween:all transition-property:all transition-duration:$dur]=(data.length > 0) autocomplete="off" id="search" type="search" bind=data placeholder="Search..." autofocus required >
			<button[d:block tween:all transition-property:all transition-duration:$dur]=(data.length>0) type="submit"> "Go"

