#try to get a correct python command to run all python scripts for me is python3 -B
ifeq ($(shell python -c "import sys; print(sys.version_info.major)"), 3)
	PY_CMD := python -B
else
	PY_CMD := python3 -B
endif

all: AUTOHEADERS 

AUTOHEADERS:
	@echo $(PY_CMD)
	@mkdir -p autogen
	@$(PY_CMD) tools/odrive/version.py --output autogen/version.c
	@$(PY_CMD) Firmware/interface_generator_stub.py --verbose --definitions odrive-interface.yaml --template fibre-cpp/interfaces_template.j2 --output autogen/interfaces.hpp
	@$(PY_CMD) Firmware/interface_generator_stub.py --definitions odrive-interface.yaml --template fibre-cpp/function_stubs_template.j2 --output autogen/function_stubs.hpp
	@$(PY_CMD) Firmware/interface_generator_stub.py --definitions odrive-interface.yaml --generate-endpoints 'ODrive3' --template fibre-cpp/endpoints_template.j2 --output autogen/endpoints.hpp
	@$(PY_CMD) Firmware/interface_generator_stub.py --definitions odrive-interface.yaml --template fibre-cpp/type_info_template.j2 --output autogen/type_info.hpp
