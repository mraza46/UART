module serializer(xmt_bit, sr_ready, load_ps, rd_fifo_data, clk, rst); 
  input [7:0] rd_fifo_data;
  input clk, rst;
  input load_ps;
  output reg sr_ready;
  output reg xmt_bit;
  
  reg [3:0]count;
  reg [7:0]temp;
  reg count_en;
  
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      xmt_bit <= 1'b0; 
      count<=4'b0;
      sr_ready<=1'b1;
      temp <= 8'b0;
      count_en <=1'b0;
    end
    else if(load_ps) begin
      temp <= rd_fifo_data;
      count_en <=1'b1;
      sr_ready<=1'b0;
    end
    else if(count==8) begin
      count<=4'b0;
      sr_ready<=1'b1;
      count_en <= 1'b0;
      temp <= 8'b0;
    end
    else if (count < 8 & (count_en)) begin
      xmt_bit <= temp[count];
      count <= count+1'b1;
      sr_ready <= 1'b0;
    end

  end 
endmodule
