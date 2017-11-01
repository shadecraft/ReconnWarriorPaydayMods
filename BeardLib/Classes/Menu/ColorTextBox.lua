BeardLib.Items.ColorTextBox = BeardLib.Items.ColorTextBox or class(BeardLib.Items.TextBox)
local ColorTextBox = BeardLib.Items.ColorTextBox
function ColorTextBox:Init(...)
    ColorTextBox.super.Init(self, ...)
    local panel = self:Panel()
    panel:rect({name = "color_preview", w = self.items_size, h = self.items_size})
    self:UpdateColor()
end

function ColorTextBox:UpdateColor()
    local preview = self:Panel():child("color_preview")
    if preview then
        preview:set_color(self:Value())
        preview:set_right(self._textbox.panel:right())
    end
end

function ColorTextBox:Value()
    return Color:from_hex(self.value)
end

function ColorTextBox:SetValue(value, ...)
    if type_name(value) == "Color" then
        value = value:to_hex()
    end
    ColorTextBox.super.SetValue(self, value, ...)
end

function ColorTextBox:_SetValue(...)
    ColorTextBox.super._SetValue(self, ...)
    self:UpdateColor()
end

function ColorTextBox:MousePressed(button, x, y)
    local result = ColorTextBox.super.MousePressed(self, button, x, y)
    if not result and self.show_color_dialog and self.enabled then
        if button == Idstring("0") and self:Panel():inside(x,y) then
            self:RunCallback(self.show_color_dialog)
            return true
        end
    end
    return result
end

function BeardLib.Items.Menu:ColorTextBox(params)
    return self:NewItem(BeardLib.Items.ColorTextBox:new(self:ConfigureItem(params)))
end