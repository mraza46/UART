interface uartif(input clk, input rst);
  logic rcv_bit=1'b1;
  logic xmt_bit;

  clocking ucb @(posedge clk);
    output rcv_bit;
    input xmt_bit;
  endclocking

endinterface: uartif
