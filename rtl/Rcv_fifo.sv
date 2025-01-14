module Rcv_fifo(clk, rst, wr_fifo, wr_fifo_data, rd_rcv_fifo, full, empty, wr_mem_data, wr_cmd);
  
  input clk,rst;
  input wr_fifo;
  input [7:0]wr_fifo_data;
  input rd_rcv_fifo;
  output reg full;
  output reg empty;
  output reg [7:0]wr_mem_data;
  output reg wr_cmd;
  
  reg [7:0] fifo_mem1 [0:7];
  reg [2:0] wr_ptr,rd_ptr;
   // Write pointer
  always @(posedge clk or posedge rst) begin
    if (rst)
      wr_ptr <= 3'b000;
    else if (wr_fifo )
      wr_ptr <= wr_ptr + 1'b1;
  end

  // Read pionter
  always @(posedge clk or posedge rst) begin
    if (rst)
      rd_ptr <= 3'b000;
    else if(rd_rcv_fifo & !empty)
      rd_ptr <= rd_ptr + 1'b1;
  end
  
  //Read and Write logic
  always @(*) begin 
    if (wr_fifo)
      fifo_mem1[wr_ptr] = wr_fifo_data;
 
    else if(!empty)
      wr_mem_data = fifo_mem1[rd_ptr];
  end
  
  //Logic for full and empty flags
  always @(*) begin
    full = (wr_ptr == 7)? 1:0;
    empty = (wr_ptr == 0)? 1:0;
  end
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      wr_cmd <= 1'b0;
    else
      wr_cmd <= wr_fifo;
  end
endmodule
