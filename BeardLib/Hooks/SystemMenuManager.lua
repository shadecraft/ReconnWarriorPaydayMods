core:module("SystemMenuManager")
require("lib/managers/dialogs/keyboardinputdialog")

GenericSystemMenuManager = GenericSystemMenuManager or SystemMenuManager.GenericSystemMenuManager

function GenericSystemMenuManager:show_keyboard_input(data)
    self.KEYBOARD_INPUT_DIALOG = self.KEYBOARD_INPUT_DIALOG or KeyboardInputDialog
	self:_show_class(data, self.GENERIC_KEYBOARD_INPUT_DIALOG, self.KEYBOARD_INPUT_DIALOG, false)
end

function GenericSystemMenuManager:show_custom(data)
	if _G.setup and _G.setup:has_queued_exec() then
		return
	end
	local success = self:_show_class(data, BeardLibGenericDialog, BeardLibGenericDialog, data.force)
	self:_show_result(success, data)
end

BeardLibGenericDialog = BeardLibGenericDialog or class(GenericDialog)
function BeardLibGenericDialog:init(manager, data, is_title_outside)
    Dialog.init(self, manager, data)
    if not self._data.focus_button then
        if #self._button_text_list > 0 then
            self._data.focus_button = #self._button_text_list
        else
            self._data.focus_button = 1
        end
    end
    self._ws = self._data.ws or manager:_get_ws()
    self._panel_script = _G[self.PANEL_SCRIPT_CLASS]:new(self._ws, self._data.title or "", self._data.text or "", self._data, {
        type = self._data.type or "system_menu",
        no_close_legend = true,
        use_indicator = data.indicator or data.no_buttons,
        is_title_outside = is_title_outside
    })
    self._panel_script:set_layer(_G.tweak_data.gui.DIALOG_LAYER)
    self._panel_script:set_centered()
    if data.position_func then
        data.position_func(self._panel_script._panel, self._panel_script._ws:panel())
    end
    if not data.no_background then
        self._panel_script:add_background()
    end
    self._panel_script:set_fade(0)
    self._controller = self._data.controller or manager:_get_controller()
    self._confirm_func = callback(self, self, "button_pressed_callback")
    self._cancel_func = callback(self, self, "dialog_cancel_callback")
    self._resolution_changed_callback = callback(self, self, "resolution_changed_callback")
    managers.viewport:add_resolution_changed_func(self._resolution_changed_callback)
    if data.counter then
        self._counter = data.counter
        self._counter_time = self._counter[1]
    end
end