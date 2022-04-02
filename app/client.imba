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
import {conditionsDb} from "./realm.ts"

global css html
	ff:'Roboto', sans

global css .container w:85% margin:auto px:10 w@1670:1580px margin:auto

global css @root --blue:#4665AF $purple:#8456A3 $pink:#F1709B $light-blue:#4BB8E9 $color-light:#fff


global css .text-4xl fs:2.01em lh:2.1 fw:"100"
global css .text-3xl fs:1.87em lh:2.0 fw:"100"
global css .text-2xl fs:1.5em lh:1.7 fw:"100"
global css .text-xl fs:1.25em lh:1.5 fw:"100"

global css .simple-input w:100% fs:md p:1.5 rd:md bw:0.1 outline-color:blue2 bc:cool3

global css .overflow-hidden of:hidden



tag app
	css button p:2 bgc:blue2 bw:0 rd:3 bgc@hover:blue3 cursor:pointer

	<self>
		<Header>


		<div.container route="/sign-in$">
			<SignIn>

		<div.container route="/update-profile$">
			<UpdateProfile>

		<div route="/$">
			<Home>

		<div.container route="/explore-models">
			<ExploreModels>

		<div.container route="/explore-data">
			<ExploreData>

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
