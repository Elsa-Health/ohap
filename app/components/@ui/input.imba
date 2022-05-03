import Fuse from 'fuse.js'

# TODO: Implement full list of props as per mantine.dev
# 1. searchable
# 2. SelectItem objects collection as data property
# 3. creatable
# 4. clearable
# 5. defaultValue


tag select-input
	prop options\{label: string; value: string}[]
	prop label
	prop value\string
	prop onChange
	prop required = false
	prop data = ""

	focused = false
	# searchStr = value || ""

	css pos:relative
	css .wrapper d:flex fld:column fl:1 w:100%
	css .options-wrapper pos:absolute shadow:md w:100% bg:white max-height:50vh ofy:scroll
		.option-item py:3 px:4 bgc@hover:cool1 cursor:pointer

	def selectItem item\{label: string; value: string}
		searchStr = item.label
		data = item.value
		onChange(item.value) if onChange

	def search list, searchStr
		const options = {
			includeScore: false,
			shouldSort: true,
			keys: ['label', 'value', 'description'],
		}

		const fuse = new Fuse(list, options)
		fuse.search(searchStr).map do(itm) itm.item

	def render
		<self>
			<.wrapper>
				<label[c:cool8]> 
					"{label}"
					<span[c:red5]> " *" if required
				<input.simple-input bind=data @focusin=(focused = true) @keydown=(focused = true) @focusout.wait(200)=(focused = false)>

			<.options-wrapper[d:{!focused ? "none" : "block"}]>
				for item in search(options, data)
					<div.option-item @click=(selectItem item)>
						item.label



tag multi-select-input
	prop options\{label: string; value: string}[]
	prop label
	prop labelKey\string = "label"
	prop value\string
	prop valueKey\string = "value"
	prop onChange
	prop required = false
	prop data\{label: string; value: string}[] = []
	prop maxLength\number = Infinity

	searchStr = ""
	focused = false

	css pos:relative
	css .wrapper d:flex fld:column fl:1 w:100%
	css .input-wrapper w:100% outline:0.1px solid #ccc p:1.5 rd:sm d:flex rg:1.5
		.active-item p:1 fs:small bd:1px solid #ccc rd:sm d:flex ai:center mr:1.5 cursor:pointer bgc@hover:cool2
		input bd:transparent outline:transparent rd:0
	css .options-wrapper pos:absolute shadow:md w:100% bg:white max-height:50vh ofy:scroll zi:3
		.option-item py:3 px:4 bgc@hoTever:cool1 cursor:pointer bgc:white


	def selectItem item\{label: string; value: string}
		searchStr = ""
		const exists = data.findIndex((do(itm) itm[labelKey] === item[labelKey])) > -1

		if exists
			data = data.filter do(itm) itm[labelKey] !== item[labelKey]
		else 
			data = [...data, item]
		onChange && onChange(data)

	def search list, searchStr
		const options = {
			includeScore: false,
			shouldSort: true,
			keys: [labelKey, valueKey, 'description'],
		}

		const fuse = new Fuse(list, options)
		fuse.search(searchStr).map do(itm) itm.item

	def notSelected item, data
		data.findIndex(do(itm) itm[labelKey] === item[labelKey]) === -1


	def render
		<self>
			<.wrapper>
				<label[c:cool8]> 
					"{label}"
					<span[c:red5]> " *" if required
					<div.input-wrapper[mt:0.2rem]>
						for item in data
							<div.active-item @click=(selectItem item)>
								<span> item[labelKey]
								<span.material-icons[cursor: pointer fs:x-small ml:1]> "close"
						<input disabled=(isFinite(maxLength) ? data.length >= maxLength : false) bind=searchStr @focusin=(focused = true) @keydown=(focused = true) @focusout.wait(200)=(focused = false)>

			<.options-wrapper[d:{!focused ? "none" : "block"} bgc:white]>
				for item in search(options, searchStr).filter((do(itm) notSelected(itm, data)))
					<div.option-item @click=(selectItem item)>
						item[labelKey]


tag chekbox-input
	prop color
	prop id
	prop label
	prop onChange
	
	bool = no

	def onchange
		onChange bool

	<self>
		<input[mr:1] type='checkbox' bind=bool @change=onchange />



tag radio-input-group
	prop color
	prop id = Math.random!.toString!
	prop label
	prop options\{label: string, value: string, description?: string}[] = []
	prop orientation\("vertical" | "horizontal") = "horizontal"
	prop onChange
	prop data

	css .wrapper d:flex fld:column
	css .options-wrapper mt:1
	
	# value = ""

	def onchange value
		onChange(value) if onChange


	<self>
		<.wrapper>
			<label[c:cool8]>
				"{label}"
				<span[c:red5]> " *" if required
		
		<div.options-wrapper [d:flex fld:column]=(orientation === "vertical")> for option in options
			<label[mr:2 mb:2]>
				<input type='radio' @change=(onchange option.value) bind=data value=option.value/>
				<div[d:inline-flex fld:column pl:1]>
					<span> option.label
					<span[fs:small c:cool7]> option.description



tag text-input
	prop label\string
	prop placeholder\string = ""
	prop data\string
	prop required\boolean = no
	prop onChange

	<self>
		<label[c:cool8]> 
			label
			<span[c:red5]> " *" if required
			<input.simple-input type="text" placeholder=placeholder bind=data>


tag number-input
	prop label\string
	prop data\number
	prop required\boolean = no
	prop onChange

	<self>
		<label[c:cool8]>
			label
			<span[c:red5]> " *" if required
			<input.simple-input type="number" bind=data>

