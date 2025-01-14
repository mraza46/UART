module memory(clk,rst,addr,wr_mem_data,wr_mem,rd_mem_data,rd_mem);
  input clk;
  input rst;
  input [3:0]addr;
  // Write port signals
  input [7:0] wr_mem_data;
  input wr_mem;
  // Read port signals
  input rd_mem;
  output reg [7:0] rd_mem_data;

  reg [7:0] memory [0:15];
  
  // Read port
  always @(posedge clk or posedge rst) 
    begin
      if (rst) 
        rd_mem_data <= 8'b0;
      else if(rd_mem) 
        rd_mem_data <= memory[addr];
    end

  // write port
  always @(posedge clk or posedge rst)
    begin
      if (rst)
        begin
          for (int i = 0; i < 16; i=i+1)
            memory[i] <= 8'b0;
        end
      else if (wr_mem)
        memory[addr] <= wr_mem_data;
    end

endmodule
