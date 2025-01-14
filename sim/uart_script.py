import os
Path = "/remote/usrhome/otusbimp20/ALI/UVM/UART"
# Define your project files
project_files = [
    f"{Path}/verif/Interface.sv",
    #f"{Path}/rtl/des_uart.sv",
    f"-y {Path}/rtl",
    f"{Path}/rtl/des_uart.sv",
    f"{Path}/verif/pkg.sv",
    f"{Path}/verif/top.sv"
]

# Combine project files into a single string
project_files_str = " ".join(project_files)

# VCS compile command
vcs_command = f"vcs -full64 -sverilog +incdir+{Path}/verif -ntb_opts uvm-1.2 {project_files_str} +libext+.sv -l log +ntb_random_seed_automatic"

os.system(vcs_command)

# Run command
run_command = "./simv"

os.system(run_command)
