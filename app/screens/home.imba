

tag Hero
	css my@md:26vh my@lt-md:16vh px@lt-md:2

		button bd:1px solid #ccc bg:white mx:4 rd:lg px:10 py:5 cursor@hover:pointer shadow@hover:md fs:large fs:x-large
		
		# .cta background-size:200% auto; bgi:linear-gradient(to right, $light-blue 0%, #98dcd5  51%, $light-blue  100%) 
		.cta 
			background-size:200% auto; 
			bgi:linear-gradient(91.03deg, $blue 14.64%, rgba(75, 184, 233, 0.5) 99.45%), linear-gradient(91.03deg, $blue 14.64%, rgba(75, 184, 233, 0.5) 99.45%) 
			color:white
			# linear-gradient(88.16deg, rgba(75, 134, 233, 0.5) 8.29%, #4665AF 84.06%); # t(to right, $light-blue 0%, #98dcd5  51%, $light-blue  100%) 
			background-position@hover:right center
			tween:all transition-property:all transition-duration:0.5s
			w@lt-md:100% my@lt-md:2
			

	<self>
		<[fs:64 fw:300 fs@lt-md:40 ta:center lh:1.5]>
			"Creating the future of healthcare,"
			<br> 
			"with the power of community & technology."


		<div[d:flex jc:center mt:10 fld@lt-md:column]>
			<button.explore-models.cta route-to="/explore-models"> "Explore Disease Models"
			<button.explore-data.cta route-to="/datasets"> "Data & Vignettes"
			# <button.learn-more> "Learn More"
			# <input[w:100 fs:x-large p:2]>

		<div[d:flex jc:center mt:14 ai:center]>
			<div[bd:#ccc 1px solid d:flex ai:center rd:full pr:4 cursor:pointer]>
				<div[bg:$blue c:white py:2 px:4 rd:full fs:sm mr:2]>
					"Unstable (v 0.0.24)"
				<div[fs:xs]>
					"Things are changing often, so expect many suprises until v 0.1."

export tag Home
	def render
		<self>
			<Hero>

			# <div.container>
			# 	<div[ta:center]>
			# 		<.text-4xl> "About"

				# "Lorem ipsum dolor sit amet consectetur adipisicing elit. Nihil, enim, ex tempora rem iure quos natus omnis possimus sit dolore accusantium eius odio temporibus quas. Numquam eaque quaerat dolorum blanditiis."
