import Realm, { datasetsDb, app } from '../realm.ts'
import toastr from "toastr"

let roleOptions = [
	{
		label: "Owner",
		value: "owner"
	}
	{
		label: "Contributor",
		value: "contributor"
	}
]

tag add-contributor-form
	prop resourceType\("model" | "dataset")
	prop resourceId\string
	prop resourceName\string
	prop onClose

	css d:flex fld:column rg:4

	email = ""
	role = "contributor"

	loading = false

	def addContributor
		console.log email, role

		const invitation\Invitation = {
			role,
			email: email,
			status: "pending",
			ownerId: ""
			senderId: app.currentUser.id
			senderEmail: app.currentUser.profile.email
			resourceId: resourceId
			resourceName: resourceName
			resourceType: resourceType,
			createdAt: new Date()
			updatedAt: new Date(),
		}

		const confirmed = window.confirm "Please confirm that you are adding {invitation.email} as a {invitation.role}"
		if !confirmed
			return;

		loading = true;
		try
			const result = await app.currentUser.callFunction("inviteCollaborator", { ...invitation })

			console.log "result", result
			onClose && onClose!
			loading = false;

			toastr.info "Invitation Sent to: {email}"

		catch error
			console.error error


	<self>
		<text-input label="Contributor Email" bind=email placeholder="example@email.com">
		<select-input bind=role label="Contributore Role" options=(roleOptions) searchable=no>

		<ui-button[mx:auto] variant="filled" @click=(addContributor) loading=loading> "Add Contributor"
