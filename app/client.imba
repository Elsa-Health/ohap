import { DatasetSummary } from './screens/DatasetSummary'
import { CreateDataset } from './screens/create-dataset'
import { ConfirmAccount } from './screens/confirm-account'
import { VignetteCreator } from './screens/vignette-creator'
import { VignetteViewer } from "./screens/vignette-viewer"
import { Profile } from './screens/Profile'
import { UpdateProfile } from './screens/UpdateProfile'
import { ExploreData } from './screens/ExploreData'
import { ExploreModels } from './screens/ExploreModels'
import { Playground } from './screens/Playground'
import { Home } from './screens/home'
import { CreateCondition } from './screens/create-condition'
import { CreateConditionModel } from './screens/CreateConditionModel'
import { ConditionModels } from './screens/condition-models'
import { ConditionEditor } from './screens/condition-editor'
import { RunAssessments } from './screens/RunAssessments'
import { ModelEvaluations } from './screens/ModelEvaluations'
import { Header } from './components/header'
import { SimpleInput } from './components/simple-input'
import {SignIn} from "./sign-in.imba"
import conditions from './data/conditions.ts'
import { SymptomEditor } from './components/symptom-editor'
import { ensureLoggedIn, conditionsDb, loginAnonymous, app} from "./realm.ts"

global css html
	ff:'Roboto', sans

global css .container w:85% margin:auto px:10 w@1670:1580px margin:auto

global css @root --blue:#4665AF $purple:#8456A3 $pink:#F1709B $light-blue:#4BB8E9 $color-light:#fff


global css .text-4xl fs:2.01em lh:2.1 fw:"100"
global css .text-3xl fs:1.87em lh:2.0 fw:"100"
global css .text-2xl fs:1.5em lh:1.7 fw:"100"
global css .text-xl fs:1.25em lh:1.5 fw:"100"
global css .text-lg fs:1.15em lh:1.2 fw:"100"

global css .simple-input w:100% fs:md p:1.5 rd:md bw:0.1 outline-color:blue2 bc:cool3

global css .overflow-hidden of:hidden

global css
	input shadow: inset 0 0.0625em 0.125em rgb(10 10 10 / 5%) bgc:white border:1px solid transparent bc:#dbdbdb
	
	
# box-shadow: inset 0 0.0625em 0.125em rgb(10 10 10 / 5%);
# max-width: 100%;
# width: 100%;

global css 
	button px:1.2em py:calc(.6em - 1px) bgc:white c:#363636 bd:1px solid transparent bc:cool3 rd:0.3rem cursor:pointer bc@hover:cool4 shadow@hover:sm
	button.primary bgc:$primary c:white


tag app
	css button p:2 bgc:blue2 bw:0 rd:3 bgc@hover:blue3 cursor:pointer

	def render
		<self>
			<Header>


			<div.container route="/sign-in$">
				<SignIn>

			<div.container route="/update-profile$">
				<UpdateProfile>

			<div.container route="/profile/:id$">
				<Profile>

			<div route="/$">
				<Home>

			<div.container route="/explore-models">
				<ExploreModels>

			<div.container route="/confirm-account">
				<ConfirmAccount>

			<div.container route="/datasets$">
				<ExploreData>
			
			<div.container route="/datasets/view/:id$">
				<DatasetSummary>

			<div.container route="/datasets/view/:id/create-vignette$">
				<VignetteCreator isLocked=false>

			<div.container route="/datasets/view/:cid/:vid">
				<VignetteViewer>


			<div.container route="/datasets/create-dataset$">
				<CreateDataset>

			<div.container route="/create-condition">
				<CreateCondition>

			<div.container route="/create-condition-model">
				<CreateConditionModel>

			<div.container route="/condition/:condition$">
				<ConditionModels>

			<div.container route="/condition/:condition/:id$">
				<ConditionEditor>

			<div.container route="/condition/:condition/:id/evaluations$">
				<ModelEvaluations>

			<div.container route="/run-assessments">
				<RunAssessments>


			<div route="/playground$">
				<Playground>


imba.mount <app>
