// Code your design here
/*`include "memory.sv"
`include "Rcv_fifo.sv"
`include "serializer.sv"
`include "deserializer.sv"
`include "tx_fifo.sv"
`include "Ctrl_fsm.sv" */
module UART(uartif uif);
/*(clk,rst,rcv_bit,xmt_bit);
  input clk;
  input rst;
  input rcv_bit;
  output xmt_bit;
  */
  wire wr_fifo;
  wire [7:0]wr_fifo_data;
  wire rd_rcv_data;
  wire [7:0]c_data;
  wire [7:0]wr_mem_data;
  wire full, empty;
  wire xf_full, xf_empty;
  wire wr_mem, rd_mem;
  wire rd_rcv_fifo, wr_xmt_fifo;
  wire [3:0]addr;
  wire [7:0]rd_mem_data;
  wire [7:0]rd_fifo_data;
  wire load_ps;
  wire wr_cmd;
  wire sr_ready;
  
  deserializer dsr(.rcv_bit(uif.rcv_bit),.wr_fifo(wr_fifo), .wr_fifo_data(wr_fifo_data), .rst(uif.rst), .clk(uif.clk));
 
  Rcv_fifo rcv(.clk(uif.clk), .rst(uif.rst), .wr_fifo(wr_fifo), .wr_fifo_data(wr_fifo_data), .full(full), .empty(empty),  .rd_rcv_fifo(rd_rcv_fifo), .wr_mem_data(wr_mem_data), .wr_cmd(wr_cmd));
  
  ctrl_logic cl(.clk(uif.clk), .rst(uif.rst), .full(full), .empty(empty), .xf_full(xf_full), .xf_empty(xf_empty), .sr_ready(sr_ready), .wr_cmd(wr_cmd), .wr_fifo(wr_fifo), .wr_mem_data(wr_mem_data), .wr_mem(wr_mem), .rd_mem(rd_mem), .rd_rcv_fifo(rd_rcv_fifo), .wr_xmt_fifo(wr_xmt_fifo), .load_ps(load_ps), .addr(addr));
  
  memory mem(.clk(uif.clk), .rst(uif.rst), .addr(addr), .wr_mem_data(wr_mem_data), .wr_mem(wr_mem), .rd_mem_data(rd_mem_data), .rd_mem(rd_mem));
  
  tx_fifo tx(.clk(uif.clk), .rst(uif.rst), .wr_xmt_fifo(wr_xmt_fifo), .load_ps(load_ps), .rd_mem_data(rd_mem_data),  .rd_fifo_data(rd_fifo_data), .xf_full(xf_full), .xf_empty(xf_empty));
  
  serializer sr(.xmt_bit(uif.xmt_bit),.sr_ready(sr_ready),.rd_fifo_data(rd_fifo_data), .load_ps(load_ps), .clk(uif.clk), .rst(uif.rst)); 
  
endmodule
