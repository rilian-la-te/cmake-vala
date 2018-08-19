macro(use_vcm VCM_DIR)
	list (APPEND CMAKE_MODULE_PATH ${VCM_DIR}/GitVersion ${VCM_DIR}/Find ${VCM_DIR}/Vala ${VCM_DIR}/Utility ${VCM_DIR}/GLib)
endmacro()
