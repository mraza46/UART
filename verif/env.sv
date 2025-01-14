class uart_env extends uvm_env;
  //This is my environment class
  uart_agent agt;
  uart_scoreboard scbd;
  `uvm_component_utils (uart_env)
  function new(string name = "uart_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    agt = uart_agent::type_id::create("agt", this);
    //build scoreboard
    scbd =uart_scoreboard::type_id::create("scbd", this);
  endfunction
  function void connect_phase (uvm_phase phase);
    //connect analysis port to scoreboard
    super.connect_phase(phase);
    agt.mon.uart_mon_port.connect(scbd.uart_imp);
  endfunction
endclass
