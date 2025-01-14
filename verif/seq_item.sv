class uart_seq_item extends uvm_sequence_item;
  rand logic [7:0]rcv_bit;
  logic xmt_bit;

  `uvm_object_utils_begin(uart_seq_item)
    `uvm_field_int (rcv_bit, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "uart_seq_item");
    super.new(name);
  endfunction
endclass 
