
export tag SimpleInput < div
	css label fs:medium mb:0.4 fs:5
	css input p:2 outline-color:blue5 bw:0.1 rd:2

	prop label\string = "Label"
	prop type\string = "text"
	prop name = "sample-name"
	prop value

	<self[d:flex fld:column]>
		<label htmlFor=name> label
		if type === "number"
			<input type=type name=name step="any" id=id bind=data>
		else 
			<input type=type name=name id=id bind=data>