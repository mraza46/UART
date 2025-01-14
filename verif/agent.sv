class uart_agent extends uvm_agent;
  uart_driver driver;
  uart_sequencer seqr;
  uart_monitor mon;
  //UVM automation macros for general components
  `uvm_component_utils(uart_agent)

  function new(string name ="uart_agent", uvm_component parent);
    super.new (name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    driver = uart_driver::type_id::create("driver", this);
    mon = uart_monitor::type_id::create("mon", this);
    seqr = uart_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
