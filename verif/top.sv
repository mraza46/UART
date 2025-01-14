import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_top;
   
  //clock and reset signal declaration
  bit clk;
  bit rst;
 
  //clock generation
  always #5 clk = ~clk;
   
  //reset Generation
  initial begin
    rst = 1;
    #25 rst =0;
  end
  
  uartif uif(clk,rst);
  
     UART DUT(uif);
  
  initial begin
    uvm_config_db#(virtual uartif)::set(null,"*","uif",uif);
  end
   
  initial begin
    run_test("uart_test");
  end
  
  initial begin
    $dumpfile("top.fsdb");
    $dumpvars(0, tb_top);
  end
endmodule
