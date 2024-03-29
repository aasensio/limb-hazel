pro inv_event, event
   widget_control, event.id, GET_UVALUE=Action
	widget_control, event.top, GET_UVALUE=info
	
	handler = event.top
	
	;handler = widget_info(Event.Handler, /CHILD)
	;widget_control, handler, GET_UVALUE=info
	
   case Action of
		'TABS': begin			
		end
		'RUN_INV': begin
			generate_conf_files, info, 1
			run_code, info, /inversion
			plot_observation_result, info.obs_file, info.output_file, info.plotWidget
		end
		'RUN_SYNTH': begin			
			generate_conf_files, info, 0
			run_code, info			
			plot_observation_result, info.obs_file, info.output_file, info.plotWidget
		end
		'VERBOSE': begin
			;widget_control, Event.id, GET_VALUE=value			
			info.verbose = 1
			widget_control, handler, SET_UVALUE=info
		end
		'NOVERBOSE': begin
			;widget_control, Event.id, GET_VALUE=value			
			info.verbose = 0
			widget_control, handler, SET_UVALUE=info
		end
		'LU_SOLVER': begin
			;widget_control, Event.id, GET_VALUE=value			
			info.linear_solver = 0
			widget_control, handler, SET_UVALUE=info
		end
		'CG_SOLVER': begin
			;widget_control, Event.id, GET_VALUE=value			
			info.linear_solver = 1
			widget_control, handler, SET_UVALUE=info
		end
		'OUTPUT_FILE': begin
			widget_control, Event.id, GET_VALUE=value			
			info.output_file = value
			widget_control, handler, SET_UVALUE=info
		end
		'OUTPUT_FILE_DIALOG': begin
			;widget_control, Event.id, GET_VALUE=value
			value = dialog_pickfile(/read)
			info.output_file = value
			widget_control, handler, SET_UVALUE=info
			widget_control, info.output_file_widget, SET_VALUE=value
		end
		'OBS_FILE': begin
			widget_control, Event.id, GET_VALUE=value			
			info.obs_file = value			
			widget_control, handler, SET_UVALUE=info
		end
		'OBS_FILE_DIALOG': begin
			;widget_control, Event.id, GET_VALUE=value
			value = dialog_pickfile(PATH=info.path_obs, GET_PATH=path_obs, /read)
			if (value ne '') then begin
				info.path_obs = path_obs
				info.obs_file = value			
				widget_control, handler, SET_UVALUE=info
				widget_control, info.obs_file_widget, SET_VALUE=value
			endif
		end
		'PLOT_OBSERVATION': begin			
			plot_observation, info.obs_file, info.obsplotWidget
		end
		'ATOM': begin						
			widget_control, Event.id, GET_VALUE=value
			info.atom = value
			widget_control, handler, SET_UVALUE=info
			case (info.atom) of
				0: begin
					nmax = 4
					sens = 1
				end
				1: begin
					nmax = 1
					sens = 0
				end
			endcase
			
			widget_control, info.MultipletWidget, SET_SLIDER_MAX=nmax
			widget_control, info.MultipletWidget, SET_VALUE=1
			widget_control, info.MultipletWidget, sensitive=sens			
		end
		'MULTIPLET': begin						
			widget_control, Event.id, GET_VALUE=value
			info.multiplet = value
			wav = wavelength_component(info.atom,info.multiplet-1)
			widget_control, handler, SET_UVALUE=info
			widget_control, info.label_multiplet, SET_VALUE='lambda: '+strtrim(string(wav),2)
			i0 = i0_allen(wavelength_component(info.atom,info.multiplet-1),cos(info.theta_obs*!DPI/180.d0))
			widget_control, info.i0_allen, SET_VALUE='Allen: '+strtrim(string(i0),2)
		end
		'PASCHEN': begin
			;widget_control, Event.id, GET_VALUE=value
			info.zeeman_pb = 1
			widget_control, handler, SET_UVALUE=info
		end
		'LINEAR': begin
			;widget_control, Event.id, GET_VALUE=value
			info.zeeman_pb = 0
			widget_control, handler, SET_UVALUE=info
		end
		'ATOMPOL': begin
			;widget_control, Event.id, GET_VALUE=value
			info.atom_pol = 1
			widget_control, handler, SET_UVALUE=info
		end
		'NOATOMPOL': begin
			;widget_control, Event.id, GET_VALUE=value
			info.atom_pol = 0
			widget_control, handler, SET_UVALUE=info
		end
		'STIM': begin
			;widget_control, Event.id, GET_VALUE=value
			info.stimulated = 1
			widget_control, handler, SET_UVALUE=info
		end
		'NOSTIM': begin
			;widget_control, Event.id, GET_VALUE=value
			info.stimulated = 0
			widget_control, handler, SET_UVALUE=info
		end
		'MAGOPT': begin
			;widget_control, Event.id, GET_VALUE=value
			info.mag_opt = 1
			widget_control, handler, SET_UVALUE=info
		end
		'NOMAGOPT': begin
			;widget_control, Event.id, GET_VALUE=value
			info.mag_opt = 0
			widget_control, handler, SET_UVALUE=info
		end
		'EMISSION': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 0
			widget_control, handler, SET_UVALUE=info
		end
		'FORMAL': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 1
			widget_control, handler, SET_UVALUE=info
		end
		'DELOPAR': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 3
			widget_control, handler, SET_UVALUE=info
		end
		'MILNE': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 2
			widget_control, handler, SET_UVALUE=info
		end
		'SIMPLE_SLAB': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 4
			widget_control, handler, SET_UVALUE=info
		end
		'EXACT_SLAB': begin
			;widget_control, Event.id, GET_VALUE=value
			info.rt_mode = 5
			widget_control, handler, SET_UVALUE=info
		end
		'I0': begin
			widget_control, Event.id, GET_VALUE=value
			info.boundary(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'Q0': begin
			widget_control, Event.id, GET_VALUE=value
			info.boundary(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'U0': begin
			widget_control, Event.id, GET_VALUE=value
			info.boundary(2) = value
			widget_control, handler, SET_UVALUE=info
		end
		'V0': begin
			widget_control, Event.id, GET_VALUE=value
			info.boundary(3) = value
			widget_control, handler, SET_UVALUE=info
		end
		'NCYCLES': begin
			widget_control, Event.id, GET_VALUE=value
			info.ncycles = value+1			
			widget_control, handler, SET_UVALUE=info
		end
		'BVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.Bfield = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_BVALUE': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_Bfield = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_Bfield eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Btext, sensitive=0
			endif else begin
				widget_control, info.Btext, sensitive=1
			endelse
		end
		'BVALUE2': begin
			widget_control, Event.id, GET_VALUE=value
			info.Bfield2 = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_BVALUE2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_Bfield2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_Bfield2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Btext2, sensitive=0
			endif else begin
				widget_control, info.Btext2, sensitive=1
			endelse
		end
		'THETAVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.thetaB = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_THETAB': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_thetaB = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_thetaB eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.thetaBtext, sensitive=0
			endif else begin
				widget_control, info.thetaBtext, sensitive=1
			endelse			
		end
		'THETAVALUE2': begin
			widget_control, Event.id, GET_VALUE=value
			info.thetaB2 = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_THETAB2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_thetaB2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_thetaB2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.thetaBtext2, sensitive=0
			endif else begin
				widget_control, info.thetaBtext2, sensitive=1
			endelse			
		end
		'CHIVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.chiB = value			
			widget_control, handler, SET_UVALUE=info			
		end
		'CYC_CHIB': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_chiB = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_chiB eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.chiBtext, sensitive=0
			endif else begin
				widget_control, info.chiBtext, sensitive=1
			endelse
		end
		'CHIVALUE2': begin
			widget_control, Event.id, GET_VALUE=value
			info.chiB2 = value			
			widget_control, handler, SET_UVALUE=info			
		end
		'CYC_CHIB2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_chiB2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_chiB2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.chiBtext2, sensitive=0
			endif else begin
				widget_control, info.chiBtext2, sensitive=1
			endelse
		end
		'DOPPLERVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.vdopp = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_VDOPP': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_vdopp = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_vdopp eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Dopplertext, sensitive=0
			endif else begin
				widget_control, info.Dopplertext, sensitive=1
			endelse
		end
		'DOPPLERVALUE2': begin
			widget_control, Event.id, GET_VALUE=value
			info.vdopp2 = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_VDOPP2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_vdopp2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_vdopp2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Dopplertext2, sensitive=0
			endif else begin
				widget_control, info.Dopplertext2, sensitive=1
			endelse
		end
		'DTAUVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.tau = value			
			widget_control, handler, SET_UVALUE=info
		end
		'DTAU2VALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.tau2 = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_TAU': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_tau = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_tau eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Tautext, sensitive=0
			endif else begin
				widget_control, info.Tautext, sensitive=1
			endelse
		end
		'CYC_TAU2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_tau2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_tau2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Tautext2, sensitive=0
			endif else begin
				widget_control, info.Tautext2, sensitive=1
			endelse
		end
		'DEPOLVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.depol = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_DEPOL': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_depol = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_depol eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Depoltext, sensitive=0
			endif else begin
				widget_control, info.Depoltext, sensitive=1
			endelse
		end
		'VMACVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.vmacro = value			
			widget_control, handler, SET_UVALUE=info
		end
		'VMAC2VALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.vmacro2 = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_VMACRO': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_vmacro = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_vmacro eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Macrotext, sensitive=0
			endif else begin
				widget_control, info.Macrotext, sensitive=1
			endelse
		end
		'CYC_VMACRO2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_vmacro2 = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_vmacro2 eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Macrotext2, sensitive=0
			endif else begin
				widget_control, info.Macrotext2, sensitive=1
			endelse
		end
		'DAMPVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.damping = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_DAMP': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_damping = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_damping eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Dampingtext, sensitive=0
			endif else begin
				widget_control, info.Dampingtext, sensitive=1
			endelse
		end
		'BETAVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.source = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_BETA': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_source = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_source eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Betatext, sensitive=0
			endif else begin
				widget_control, info.Betatext, sensitive=1
			endelse
		end
		'HEIGHTVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.height = value
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_HEIGHT': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_height = value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_height eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.Heighttext, sensitive=0
			endif else begin
				widget_control, info.Heighttext, sensitive=1
			endelse
		end
		'FFVALUE': begin
			widget_control, Event.id, GET_VALUE=value
			info.ff = value			
			widget_control, handler, SET_UVALUE=info
		end
		'CYC_FF': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inv_ff= value			
			widget_control, handler, SET_UVALUE=info
			ind = where(info.inv_ff eq 0)
			if (n_elements(ind) eq 4) then begin
				widget_control, info.fftext, sensitive=0
			endif else begin
				widget_control, info.fftext, sensitive=1
			endelse
		end
		'INVMODE_CYC1': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inversion_mode(0) = value+1
			widget_control, handler, SET_UVALUE=info
		end
		'INVMODE_CYC2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inversion_mode(1) = value+1
			widget_control, handler, SET_UVALUE=info
		end
		'INVMODE_CYC3': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inversion_mode(2) = value+1
			widget_control, handler, SET_UVALUE=info
		end
		'INVMODE_CYC4': begin
			widget_control, Event.id, GET_VALUE=value			
			info.inversion_mode(3) = value+1
			widget_control, handler, SET_UVALUE=info
		end
		'WI1': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stI_weight(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WI2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stI_weight(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WI3': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stI_weight(2) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WI4': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stI_weight(3) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WQ1': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stQ_weight(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WQ2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stQ_weight(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WQ3': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stQ_weight(2) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WQ4': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stQ_weight(3) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WU1': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stU_weight(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WU2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stU_weight(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WU3': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stU_weight(2) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WU4': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stU_weight(3) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WV1': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stV_weight(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WV2': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stV_weight(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WV3': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stV_weight(2) = value
			widget_control, handler, SET_UVALUE=info
		end
		'WV4': begin
			widget_control, Event.id, GET_VALUE=value			
			info.stV_weight(3) = value
			widget_control, handler, SET_UVALUE=info
		end
		'OBS_THETA': begin
			widget_control, Event.id, GET_VALUE=value			
			info.theta_obs = value
			i0 = i0_allen(wavelength_component(info.atom,info.multiplet-1),cos(info.theta_obs*!DPI/180.d0))
			widget_control, info.i0_allen, SET_VALUE='Allen: '+strtrim(string(i0),2)
			widget_control, handler, SET_UVALUE=info
		end
		'OBS_CHI': begin
			widget_control, Event.id, GET_VALUE=value			
			info.chi_obs = value
			widget_control, handler, SET_UVALUE=info
		end
		'OBS_GAMMA': begin
			widget_control, Event.id, GET_VALUE=value			
			info.gamm_obs = value
			widget_control, handler, SET_UVALUE=info
		end
		'MAX_ITER': begin
			widget_control, Event.id, GET_VALUE=value			
			info.itermax = value
			widget_control, handler, SET_UVALUE=info
		end
		'DIR_OUTPUTFILE': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_output_file = value
			widget_control, handler, SET_UVALUE=info
		end
		'DIR_FUNCEVAL': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_feval = value
			widget_control, handler, SET_UVALUE=info
		end
		'DIR_REDVOL': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_redvol = value
			widget_control, handler, SET_UVALUE=info
		end
		'B_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_bfield(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'B_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_bfield(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'B2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_bfield2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'B2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_bfield2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'THETAB_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_thetaB(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'THETAB_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_thetaB(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'THETAB2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_thetaB2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'THETAB2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_thetaB2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'CHIB_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_chiB(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'CHIB_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_chiB(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'CHIB2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_chiB2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'CHIB2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_chiB2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VDOPP_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vdopp(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VDOPP_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vdopp(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VDOPP2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vdopp2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VDOPP2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vdopp2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DTAU_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_tau(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DTAU_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_tau(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DTAU2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_tau2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DTAU2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_tau2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'D2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_depol(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'D2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_depol(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VMAC_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vmacro(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VMAC_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vmacro(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VMAC2_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vmacro2(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'VMAC2_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_vmacro2(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DAMP_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_damping(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'DAMP_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_damping(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'BETA_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_beta(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'BETA_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_beta(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'H_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_height(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'H_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_height(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'FF_DIR_MIN': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_ff(0) = value
			widget_control, handler, SET_UVALUE=info
		end
		'FF_DIR_MAX': begin
			widget_control, Event.id, GET_VALUE=value			
			info.dir_range_ff(1) = value
			widget_control, handler, SET_UVALUE=info
		end
		'ONE_SLAB' : begin
		 	info.number_slabs = 1
		   widget_control, handler, SET_UVALUE=info
		   widget_control, info.Btext2, sensitive=0
		   widget_control, info.thetaBtext2, sensitive=0
		   widget_control, info.chiBtext2, sensitive=0
		   widget_control, info.Dopplertext2, sensitive=0
		   widget_control, info.Tautext2, sensitive=0
		   widget_control, info.Macrotext2, sensitive=0
		   widget_control, info.buttonsB2, sensitive=0
		   widget_control, info.buttonsthetaB2, sensitive=0
		   widget_control, info.buttonschiB2, sensitive=0
		   widget_control, info.buttonsDoppler2, sensitive=0
		   widget_control, info.buttonsMacro2, sensitive=0
		   widget_control, info.buttonstau2, sensitive=0
		   widget_control, info.buttonsff, sensitive=0
		   info.inv_vmacro2 = [0,0,0,0]
		   info.inv_Bfield2 = [0,0,0,0]
		   info.inv_thetaB2 = [0,0,0,0]
		   info.inv_chiB2 = [0,0,0,0]
		   info.inv_vdopp2 = [0,0,0,0]
		   info.inv_tau2 = [0,0,0,0]
			info.inv_ff = [0,0,0,0]
			widget_control, info.buttonsB2, SET_VALUE = info.inv_Bfield2
			widget_control, info.buttonsthetaB2, SET_VALUE = info.inv_thetaB2
			widget_control, info.buttonschiB2, SET_VALUE = info.inv_chiB2
			widget_control, info.buttonsDoppler2, SET_VALUE = info.inv_vdopp2
			widget_control, info.buttonsMacro2, SET_VALUE = info.inv_vmacro2
			widget_control, info.buttonstau2, SET_VALUE = info.inv_tau2
			widget_control, info.buttonsff, SET_VALUE = info.inv_ff
		 end
		 'TWO_SLABS' : begin
		 	info.number_slabs = 2
		   widget_control, handler, SET_UVALUE=info
		   widget_control, info.Btext2, sensitive=0
		   widget_control, info.thetaBtext2, sensitive=0
		   widget_control, info.chiBtext2, sensitive=0
		   widget_control, info.Dopplertext2, sensitive=0
		   widget_control, info.Tautext2, sensitive=1
		   widget_control, info.Macrotext2, sensitive=1
		   widget_control, info.buttonsB2, sensitive=0
		   widget_control, info.buttonsthetaB2, sensitive=0
		   widget_control, info.buttonschiB2, sensitive=0
		   widget_control, info.buttonsDoppler2, sensitive=0
		   widget_control, info.buttonsMacro2, sensitive=1
		   widget_control, info.buttonstau2, sensitive=1
		   widget_control, info.buttonsff, sensitive=0
		   info.inv_Bfield2 = [0,0,0,0]
		   info.inv_thetaB2 = [0,0,0,0]
		   info.inv_chiB2 = [0,0,0,0]
		   info.inv_vdopp2 = [0,0,0,0]
			info.inv_ff = [0,0,0,0]
			widget_control, info.buttonsB2, SET_VALUE = info.inv_Bfield2
			widget_control, info.buttonsthetaB2, SET_VALUE = info.inv_thetaB2
			widget_control, info.buttonschiB2, SET_VALUE = info.inv_chiB2
			widget_control, info.buttonsDoppler2, SET_VALUE = info.inv_vdopp2
			widget_control, info.buttonsff, SET_VALUE = info.inv_ff
		  end
		 'TWO_SLABS_DIFFIELD' : begin
		 	info.number_slabs = 3
		   widget_control, handler, SET_UVALUE=info
		   widget_control, info.Btext2, sensitive=1
		   widget_control, info.thetaBtext2, sensitive=1
		   widget_control, info.chiBtext2, sensitive=1
		   widget_control, info.Dopplertext2, sensitive=1
		   widget_control, info.Tautext2, sensitive=1
		   widget_control, info.Macrotext2, sensitive=1
		   widget_control, info.buttonsB2, sensitive=1
		   widget_control, info.buttonsthetaB2, sensitive=1
		   widget_control, info.buttonschiB2, sensitive=1
		   widget_control, info.buttonsDoppler2, sensitive=1
		   widget_control, info.buttonsMacro2, sensitive=1
		   widget_control, info.buttonstau2, sensitive=1
		   widget_control, info.buttonsff, sensitive=0
			info.inv_ff = [0,0,0,0]
			widget_control, info.buttonsff, SET_VALUE = info.inv_ff
		  end
		  'TWO_SLABS_COMPO' : begin
		 	info.number_slabs = -2
		   widget_control, handler, SET_UVALUE=info
		   widget_control, info.Btext2, sensitive=1
		   widget_control, info.thetaBtext2, sensitive=1
		   widget_control, info.chiBtext2, sensitive=1
		   widget_control, info.Dopplertext2, sensitive=1
		   widget_control, info.Tautext2, sensitive=1
		   widget_control, info.Macrotext2, sensitive=1
		   widget_control, info.buttonsB2, sensitive=1
		   widget_control, info.buttonsthetaB2, sensitive=1
		   widget_control, info.buttonschiB2, sensitive=1
		   widget_control, info.buttonsDoppler2, sensitive=1
		   widget_control, info.buttonsMacro2, sensitive=1
		   widget_control, info.buttonstau2, sensitive=1
		   widget_control, info.buttonsff, sensitive=1
		  end
		  'J10_VALUE' : begin
				widget_control, Event.id, GET_VALUE=value
				info.j10 = value
				widget_control, handler, SET_UVALUE=info
		  end
			
   endcase	
		
	widget_control, handler, SET_UVALUE=info
	save,info,filename='state.idl'
   
end