tag modal
	prop centered\boolean = true
	prop size\("sm" | "md" | "lg") = "md"
	prop title\string = ""
	prop onClose
	prop open\boolean = false

	css .view pos:fixed t:0 l:0 bgc:cool8/40 w:100% h:100% zi:10 of:hidden
		.modal-container bgc:white rd:md p:6 shadow:lg


	def getSizes size
		switch size
			when "sm"
				[25]
			when "md"
				[50]
			when "lg"
				[75]


	def render
		const [width] = getSizes(size)
		<self>
			if open
				<.view>
					<.modal-container[w@lg:{width}% w:80% my:5rem] [mx:auto]=centered @hotkey('esc')=onClose>
						<div[d:flex ai:center jc:space-between]>
							<[fs:xx-large]> title
							<span.material-icons[cursor:pointer] @click=onClose> "close"

						<[pt:2]>
							<slot>
