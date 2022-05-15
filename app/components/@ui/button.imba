
tag ui-button
	prop fullWidth\boolean = false
	prop type\("submit" | "button") = "button"
	prop compact\boolean = false
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


	def getButtonColors variant
		switch variant
			when "filled"
				[color, color, "#fff"]
			when "subtle"
				["transparent", "transparent", color]
			else
				[color, "transparent", "cool8"]

				

	def render
		const [px, py, fs] = compact ? [0, 0, getSizes(size)[2]] : getSizes(size)
		const [borderColor, bgc, color] = getButtonColors(variant)

		<self>
			<button disabled=loading
				[bgc:{bgc} c:{color} px:{px}rem fs:{fs} w:{fullWidth ? "100%" : auto} bc:{borderColor} shadow:{compact or variant === "subtle" ? "none" : "inherit"}]
				>
				if loading
					"Loading ..."
				else 
					<slot>
