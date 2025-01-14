class uart_seq extends uvm_sequence#(uart_seq_item);
  //Registers ahb_seq with the factory
  `uvm_object_utils(uart_seq)
  int no_of_bytes;

  function new (string name = "uart_seq");
    super.new(name);
  endfunction

  virtual task body();
    //Create the req seq item
    req = uart_seq_item::type_id::create("req");

    start_item(req);
    assert(req.randomize() with {((req.rcv_bit[0]==0) && (req.rcv_bit[6]==1));});
    no_of_bytes = req.rcv_bit[7:5];
    `uvm_info(get_type_name(), $sformatf("rcv_bit=%0b ", req.rcv_bit), UVM_LOW);
    finish_item(req);

    for(int i=0; i<no_of_bytes; i++) begin
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
    
    start_item(req);
    assert(req.randomize() with {((req.rcv_bit[0]==1) && (req.rcv_bit[6]==1));});
    no_of_bytes = req.rcv_bit[7:5];
    `uvm_info(get_type_name(), $sformatf("rcv_bit=%0b ", req.rcv_bit), UVM_LOW);
    finish_item(req);
    
    for(int i=0; i<no_of_bytes; i++) begin
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end

  endtask

endclass
/*
class write_seq extends uart_seq;
	`uvm_object_utils(write_seq)
	// data members

	uart_seq_item write_tx;
	function new (string name="");
		super.new(name);
	endfunction : new

	// body
	virtual task body();
  
        // Generate and send bits
        for (int i = 0; i < 8; i++) begin
          if(i==0)
            write_tx.rcv_bit = 1'b0;
          else
            write_tx.rcv_bit = $urandom;
          `uvm_info("SEQ", $sformatf("Generated bit: %0b", data_bit), UVM_LOW)
            // Start item
          start_item(data_bit);
            // Wait for driver to be ready
          wait_for_grant();
            // Finish item
          finish_item(data_bit);
        end
    endtask: body

endclass : write_seq

class read_seq extends uart_seq;
	`uvm_object_utils(read_seq)
	// data members

	uart_seq_item read_tx;
	function new (string name="");
		super.new(name);
	endfunction : new

	// body
	virtual task body();
        bit data_bit;
        // Generate and send bits
        for (int i = 0; i < 8; i++) begin
          if(i==0)
            data_bit = 1'b1;
          else
            data_bit = assert(req.randomize());
          `uvm_info("SEQ", $sformatf("Generated bit: %0b", data_bit), UVM_LOW)
            // Start item
          start_item(data_bit);
            // Wait for driver to be ready
          wait_for_grant();
            // Finish item
          finish_item(data_bit);
        end
    endtask: body

endclass : read_seq */
