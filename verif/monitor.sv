class uart_monitor extends uvm_monitor;
  //Handle for interface to monitor
  virtual uartif uif;
  uart_seq_item txn;
  
  uvm_analysis_port #(uart_seq_item) uart_mon_port;
  `uvm_component_utils(uart_monitor)
  
  function new (string name ="uart_monitor", uvm_component parent);
    super.new(name, parent);
    uart_mon_port = new("uart_mon_port", this); 
  endfunction
  //Get the virtual interface from config_db
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //txn = uart_seq_item::type_id::create("txn",this);
    if(!uvm_config_db#(virtual uartif)::get(this,"", "uif", uif))
      `uvm_fatal("Monitor : ALU",{"virtual if must be set for:",get_full_name(),".uif"});
  endfunction
  //Run phase
  virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
   txn = uart_seq_item::type_id::create("txn",this);
   wait(!uif.rst);
   #1;
   forever begin
    monitor_uart_if(txn);
    uart_mon_port.write(txn);
    end
  endtask
  //Sample uart if
  extern virtual task monitor_uart_if(uart_seq_item txn);
endclass

task uart_monitor::monitor_uart_if(uart_seq_item txn);
  for (int i = 7; i >= 0; i--) begin
     txn.rcv_bit[i] <= uif.rcv_bit;
     @(posedge uif.clk);
   end
   `uvm_info(get_type_name(), $sformatf("rcv_bit=%0b", txn.rcv_bit), UVM_LOW);

 endtask
