BeardLib.Items.ContextMenu = BeardLib.Items.ContextMenu or class()
local ContextMenu = BeardLib.Items.ContextMenu
function ContextMenu:init(owner, layer)
    self.owner = owner
    self.parent = owner.parent
    self.menu = owner.menu
    local control_size = owner.bigger_context_menu and owner:Panel():w() or owner.panel:w() / owner.control_slice
    local bgcolor = self.parent.background_color or Color.white
    bgcolor = bgcolor:with_alpha(math.max(bgcolor.a, 0.85))
    self.panel = self.menu._panel:panel({
        name = owner.name.."list",
        w = control_size,
        layer = layer,
        visible = false,
        halign = "left",
        align = "left"
    })
    self.panel:rect({
        name = "bg",
        color = bgcolor,
        layer = -1,
        halign = "grow",
        valign = "grow",
    })
    if owner.searchbox then
        self._textbox = BeardLib.Items.TextBoxBase:new(self, {
            text_color = bgcolor:contrast(),
            panel = self.panel,
            align = "center",
            lines = 1,
            items_size = owner.items_size,
            update_text = callback(self, self, "update_search"),
        })
    end
    self._scroll = ScrollablePanelModified:new(self.panel, "ItemsPanel", {
        layer = 4, 
        padding = 0.0001, 
        scroll_width = owner.scrollbar == false and 0 or self.parent.scroll_width or 12,
        hide_shade = true, 
        color = owner.scroll_color or owner.marker_highlight_color,
        scroll_speed = 48
    })
    self._my_items = {}
    self._item_panels = {}
    self._visible_items = {}
    self.items_panel = self._scroll:canvas()
    self:update_search()
end

function ContextMenu:alive() return alive(self.panel) end

function ContextMenu:CheckItems()
    self._visible_items = {}
    local p = self.items_panel
    for _, item in ipairs(self._item_panels) do
        item:set_visible(p:inside(p:world_x(), self.panel:world_y()) == true or p:inside(p:world_x(), self.panel:world_bottom()) == true)
        if item:visible() then
            table.insert(self._visible_items, item)
        end
    end
end

function ContextMenu:CreateItems()
    self.items_panel:clear()
    local bg = self.panel:child("bg")
    local color = bg:color():contrast()
    self._item_panels = {}
    for k, text in pairs(self._my_items) do
        if type(text) == "table" then
            text = text.text
        end
        local font_size = (self.owner.font_size or self.owner.items_size) - 2
        local panel = self.items_panel:panel({
            name = "Item-"..tostring(text),
            h = font_size,
            y = (k - 1) * font_size,
        })
        panel:text({
            name = "text",
            text = self.owner.localized_items and managers.localization:text(tostring(text)) or tostring(text),
            w = panel:w() - (self.owner.text_offset * 2),
            h = panel:h(),
            x = self.owner.text_offset,
            vertical = "center",
            layer = 1,
            color = color,
            font = self.owner.font,
            font_size = font_size - 2
        })
        panel:rect({
            name = "bg",
            color = self.owner.marker_color,
            alpha = self.owner.marker_alpha,
            h = self.type_name == "Group" and self.items_size,
            halign = self.type_name ~= "Group" and "grow",
            valign = self.type_name ~= "Group" and "grow",
            layer = 0
        })
        table.insert(self._item_panels, panel)
    end
    if self.menu._openlist == self then
        self:reposition()
    end
    self._scroll:scroll_to(0)
    self:CheckItems()
end

function ContextMenu:hide()
    if self:alive() then
        self.panel:hide()
    end
    self.menu._openlist = nil
end

function ContextMenu:reposition()
    local size = (self.owner.font_size or self.owner.items_size) - 2
    local bottom_h = (self.menu._panel:world_bottom() - self.owner.panel:world_bottom()) 
    local top_h = (self.owner.panel:world_y() - self.menu._panel:world_y()) 
    local items_h = (#self._my_items * size) + (self.owner.searchbox and self.owner.items_size or 0)
    local normal_pos = items_h <= bottom_h or bottom_h >= top_h
    if (normal_pos and items_h > bottom_h) or (not normal_pos and items_h > top_h) then
        self.panel:set_h(math.min(bottom_h, top_h))
    else
        self.panel:set_h(items_h)
    end
    self.panel:set_world_right(self.owner.panel:world_right())
    if normal_pos then
        self.panel:set_world_y(self.owner.panel:world_bottom())
    else
        self.panel:set_world_bottom(self.owner.panel:world_y())
    end
    self._scroll:panel():set_y(self.owner.searchbox and self.owner.items_size or 0) 
    self._scroll:panel():set_y(self.owner.searchbox and self.owner.items_size or 0) 
    self._scroll:set_size(self.panel:w(), self.panel:h() - (self.owner.searchbox and self.owner.items_size or 0))

    self._scroll:panel():child("scroll_up_indicator_arrow"):set_top(6 - self._scroll:y_padding())
    self._scroll:panel():child("scroll_down_indicator_arrow"):set_bottom(self._scroll:panel():h() - 6 - self._scroll:y_padding())

    self._scroll:update_canvas_size()
end

function ContextMenu:showing()
    return self.panel:visible()
end

function ContextMenu:show()   
    if self.menu._openlist == self then
        self:hide()
        return
    end
    self:reposition()
    self.panel:show()
    self:CheckItems()
    self.menu._openlist = self
end

function ContextMenu:MousePressed(button, x, y)        
    if self:textbox() then
        if self:textbox():MousePressed(button, x, y) then
            return true
        end
    end
    if self.panel:inside(x,y) then
        if button == Idstring("mouse wheel down") or button == Idstring("mouse wheel up") then
            if self._scroll:scroll(x, y, button == Idstring("mouse wheel up") and 1 or -1) then
                self:CheckItems()
                self:MouseMoved(x, y)
                return true
            end
        end
        if button == Idstring("0") then
            if self._scroll:mouse_pressed(button, x, y) then
                self:CheckItems()
                return true
            end
            for k, item in pairs(self.owner.items) do
                local item_p = self.items_panel:child("Item-"..tostring(item))
                if alive(item_p) and item_p:inside(x,y) then
                    if self.owner.ContextMenuCallback then
                        self.owner:ContextMenuCallback(item)
                    else
                        if item.callback then self.owner:RunCallback(item.callback, item) end            
                    end        
                    self:hide()
                    return true
                end
            end
        end
        return true
    elseif button == Idstring("0") or button == Idstring("1") then
        self:hide()
        return true
    end
end

function ContextMenu:KeyPressed(o, k)
    if self:textbox() then
        self:textbox():KeyPressed(o, k)
    end
    if not self:alive() then
        return
    end
    if self.menu._openlist and k == Idstring("esc") then
        self.menu._openlist:hide()
    end
end

function ContextMenu:textbox()
    return self.owner._textbox or self._textbox
end

function ContextMenu:update_search(force_show)
    if force_show == true and not self:showing() then
        self:show()
    end
    local text = self:textbox() and self:textbox():Value() or ""
    self._my_items = {}
    for _, v in pairs(self.owner.items) do
        if type(v) == "table" then
            v = v.text
        end
        local match = tostring(v):lower():match(tostring(text))
        if text == "" then
            table.insert(self._my_items, v)
        else
            if match then
                table.insert(self._my_items, 1, v)
            else
                table.insert(self._my_items, v)
            end
        end
    end
    self:CreateItems()
end

function ContextMenu:HightlightItem(item, highlight)
    if self._highlighting and self._highlighting ~= item and highlight then
        self:HightlightItem(self._highlighting, false)
        self._highlighting = item
    end
    item:child("bg"):set_color(highlight and self.owner.marker_highlight_color or self.owner.marker_color or Color.white)
end

function ContextMenu:MouseMoved(x, y)
    if self:textbox() then
        self:textbox():MouseMoved(x, y)
    end
    local _, pointer = self._scroll:mouse_moved(nil, x, y) 
    if pointer then
        managers.mouse_pointer:set_pointer_image(pointer)
        return true
    else
        managers.mouse_pointer:set_pointer_image("arrow")
    end
    for k, item in pairs(self._visible_items) do
        if alive(item)  then
            self:HightlightItem(item, item:inside(x,y))
        end
    end
end

function ContextMenu:MouseReleased(button, x, y)
    if self:textbox() then
        self:textbox():MouseReleased(button, x, y)
    end
    self._scroll:mouse_released(button, x, y)
    self:CheckItems()
end