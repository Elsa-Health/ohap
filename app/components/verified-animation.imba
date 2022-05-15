import lottie from "lottie-web"
import animationData from "../assets/verified.json"

export tag Verified
	def mount
		lottie.loadAnimation({
			container: document.getElementById('animation'), # the dom element that will contain the animation
			renderer: 'svg',
			loop: true,
			autoplay: true,
			animationData,
			# path: '../assets/under-construction.json' # the path to the animation json
		});

		tick!

	def render()
		<self>
			<div#animation>