class uart_driver extends uvm_driver #(uart_seq_item);
  virtual uartif uif;
  //uart_seq_item trans;
  `uvm_component_utils(uart_driver)

  function new(string name ="uart_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //trans = uart_seq_item::type_id::create("trans",this);
    if(!uvm_config_db#(virtual uartif)::get(this,"","uif",uif))
      `uvm_fatal("Driver : ALU",{"virtual if must be set for:",get_full_name(),".uif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    while(1) begin
      //uart_seq_item trans;
      seq_item_port.get_next_item(req);
      //@(uif.ucb);
      drive();
      seq_item_port.item_done();
    end
  endtask

  extern virtual task drive();

endclass

task uart_driver::drive();
  wait(!uif.rst);
   for (int i = 7; i >= 0; i--) begin
     uif.rcv_bit <= req.rcv_bit[i];
     @(posedge uif.clk);
     `uvm_info(get_type_name(), $sformatf("rcv_bit=%0b at bit position %0d", uif.rcv_bit, i), UVM_LOW);
   end

endtask
