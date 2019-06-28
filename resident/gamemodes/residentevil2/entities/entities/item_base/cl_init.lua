include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

local textSize = 20

surface.CreateFont("bombtimer", {
	size = textSize,
	font = "MenuItem",
	antialias = false,
	additive = true,
})
surface.CreateFont("bombtimer_blur", {
	size = textSize,
	font = "MenuItem",
	antialias = true,
	additive = true,
	blursize = 3,
})

function ENT:Draw()
	self.Entity:DrawModel()

	if IsValid(self:GetDTEntity(0)) && self:GetDTEntity(0):IsPlayer() then

		local origin = self.Entity:GetPos() + self.Entity:GetForward() * 3.95 + self.Entity:GetRight() * 2.20 + self.Entity:GetUp() * 9
		local correctedAngle = self.Entity:GetAngles()
		correctedAngle:RotateAroundAxis(self.Entity:GetUp(), -90)

		cam.Start3D2D(origin, correctedAngle, 0.1)

			surface.SetTextPos(0, 0)
			surface.SetTextColor(255, 20, 20, 50)

			if LocalPlayer() == self:GetDTEntity(0) then
				surface.SetTextColor(20, 255, 20, 50)
			end

			surface.SetFont("bombtimer_blur")
			surface.DrawText("Armed")

			surface.SetTextPos(0, 0)
			surface.SetTextColor(255, 150, 150, 255)

			if LocalPlayer() == self:GetDTEntity(0) then
				surface.SetTextColor(150, 225, 150, 50)
			end

			surface.SetFont("bombtimer")
			surface.DrawText("Armed")

		cam.End3D2D()
	end
end
