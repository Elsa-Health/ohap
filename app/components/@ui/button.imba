
tag ui-button
	prop fullWidth\boolean = false
	prop type\("submit" | "button") = "button"
	prop loading\boolean = false
	prop color\string = "#4665b7"
	prop variant\("filled" | "light" | "outline" | "default" | "subtle") = "default"
	prop size\("xs" | "sm" | "md" | "lg" | "xl") = "md"

	css w:fit-content


	def getSizes size
		switch size
			when "xs"
				[1, 1, 10]
			when "sm"
				[1.5, 1, 12]
			when "md"
				[2, 1, 14]
			when "lg"
				[2.5, 1.2, 16]
			when "xl"
				[3, 1.4, 18]
				

	def render
		const [px, py, fs] = getSizes(size)
		<self>
			<button disabled=loading
				[bgc:{variant === "filled" ? color : "transparent"} c:{variant === "filled" ? "white" : cool8} px:{px}rem fs:{fs} w:{fullWidth ? "100%" : auto}]
				>
				if loading
					"Loading ..."
				else 
					<slot>