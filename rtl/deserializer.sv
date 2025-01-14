module deserializer(rcv_bit,wr_fifo, wr_fifo_data, rst, clk);
  input rcv_bit;
  input rst, clk;
  output reg wr_fifo;  
  output reg [7:0] wr_fifo_data;
  
  reg [3:0] count;
  always @(posedge clk or posedge rst) begin
    if (rst) begin 
      wr_fifo <=1'b0;
      count <= 3'b0;
      wr_fifo_data <= 8'b0;
    end
    else begin
      if (count < 8)  begin
        count <= count + 1'b1;
        wr_fifo_data[7:0] <= {wr_fifo_data[6:0], rcv_bit};
        wr_fifo <=1'b0;
      end 
      else if (count == 8) begin
        wr_fifo_data[7:0] <= {wr_fifo_data[6:0], rcv_bit};
        wr_fifo <= 1'b1;
        count <= 3'b1;
      end
    end
  end
endmodule
