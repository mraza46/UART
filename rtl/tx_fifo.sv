module tx_fifo(clk, rst, wr_xmt_fifo, rd_mem_data, load_ps, rd_fifo_data, xf_full, xf_empty);
  input clk,rst;
  input wr_xmt_fifo;
  input [7:0]rd_mem_data;
  input load_ps;
  output reg [7:0]rd_fifo_data;
  output reg xf_full;
  output reg xf_empty;
  
  reg [7:0] fifo_mem2 [0:7];
  reg [2:0] wr_ptr,rd_ptr;
  
  // Write pointer
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 3'b000;
    end else if (wr_xmt_fifo)
      wr_ptr <= wr_ptr + 1;
    else if(wr_ptr == rd_ptr)
      wr_ptr <= 3'b000;
  end

  // Read pointer
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_ptr <= 3'b000;
    end else if (load_ps)
      rd_ptr <= rd_ptr + 1;
    else if(wr_ptr == rd_ptr)
      rd_ptr <= 3'b000;
  end
  //Read/Write logic
  always @(*) begin
    if (wr_xmt_fifo)
      fifo_mem2[wr_ptr] = rd_mem_data;
    if (load_ps)
      rd_fifo_data = fifo_mem2[rd_ptr];
  end
  
  //Logic for full and empty flags
  always @(*) begin
    xf_full = (wr_ptr == 7)? 1:0;
    xf_empty = (wr_ptr == 0)? 1:0;
  end
  
endmodule
