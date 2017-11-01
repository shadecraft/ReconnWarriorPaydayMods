local old_init = WeaponFactoryTweakData.init
function WeaponFactoryTweakData:init(tweak_data)
    old_init(self, tweak_data)
    
	self.wpn_fps_bow_hunter.override = {
		wpn_fps_upg_o_specter = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_aimpoint = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_docter = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_eotech = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_t1micro = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_aimpoint_2 = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_eotech_xps = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_reflex = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_rx01 = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_rx30 = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_cmore = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_cs = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_eotech = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_acog = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_spot = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 16, 0.5)}}
		},
		wpn_fps_upg_o_xpsg33_magnifier = {
			stance_mod = {wpn_fps_bow_hunter = {translation = Vector3(0, 23, 0.5)}}
		},
		wpn_fps_upg_o_rmr = {
			parent = "lower_reciever"       
		}
    }
    self.wpn_fps_bow_hunter.adds = { 
		wpn_fps_upg_fl_pis_laser = { "wpn_fps_pis_2006m_fl_adapter" },
		wpn_fps_upg_fl_pis_tlr1 = { "wpn_fps_pis_2006m_fl_adapter" },
		wpn_fps_upg_fl_pis_crimson = { "wpn_fps_pis_2006m_fl_adapter" },
		wpn_fps_upg_fl_pis_x400v = { "wpn_fps_pis_2006m_fl_adapter" },
		wpn_fps_upg_fl_pis_m3x = { "wpn_fps_pis_2006m_fl_adapter" },
    }
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_fl_pis_laser")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_fl_pis_tlr1")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_fl_pis_x400v")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_fl_pis_crimson")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_fl_pis_m3x")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_aimpoint")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_cs")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_aimpoint_2")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_docter")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_eotech")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_t1micro")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_cmore")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_acog")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_specter")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_eotech_xps")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_reflex")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_rx01")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_rx30")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_spot")
table.insert(self.wpn_fps_bow_hunter.uses_parts, "wpn_fps_upg_o_xpsg33_magnifier")
end