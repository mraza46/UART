module ctrl_logic (clk,rst,wr_cmd,wr_fifo,wr_mem_data,full,empty,xf_full,xf_empty,sr_ready,rd_mem,wr_mem,addr,rd_rcv_fifo,wr_xmt_fifo,load_ps);
  input clk;
  input rst;
  input wr_cmd;
  input wr_fifo;
  input [7:0] wr_mem_data;       // Data from fifo
  input full;                    // Receive fifo full signal
  input empty;                   // Receive fifo empty signal
  input xf_full;                 // Transmit fifo full signal
  input xf_empty;                // Transmit fifo empty signal
  input sr_ready;                // Indicate serializer is ready to transmit
  output reg rd_mem;             // To perform read
  output reg wr_mem;             // To write to memory
  output reg [3:0] addr;         // Address of Data of memory
  output reg wr_xmt_fifo;
  output reg rd_rcv_fifo;
  output reg load_ps;
  
  // State definitions using localparam
  localparam IDLE = 2'b00;
  localparam READ_MEM = 2'b01;
  localparam WRITE_MEM = 2'b10;

  reg [2:0] data_out;
  reg [2:0] val;
  reg [1:0] state;

  // FSM state transition and outputs
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      val <= 3'b0;
      addr <= 4'b0;
      data_out <= 3'b0;
      rd_mem <= 1'b0;
      wr_mem <= 1'b0;
      wr_xmt_fifo <= 1'b0;
      rd_rcv_fifo <= 1'b0;
      load_ps <= 1'b0;
    end else begin
      // Default assignments
      rd_mem <= 1'b0;
      wr_mem <= 1'b0;
      wr_xmt_fifo <= 1'b0;
      rd_rcv_fifo <= wr_fifo;
      load_ps <= 1'b0;

      case (state)
        IDLE: begin
          val <= 3'b0;
          if (wr_mem_data[0] == 1'b1) begin
            state <= READ_MEM;
          end else if (wr_mem_data[0] == 1'b0) begin
            state <= WRITE_MEM;
          end
          addr <= wr_mem_data[4:1];
          data_out <= wr_mem_data[7:5];
        end

        READ_MEM: begin
          if (val < data_out) begin
            rd_mem <= 1'b1;
            wr_xmt_fifo <= 1'b1;
            if (!empty) begin
              addr <= addr + 1'b1;
              val <= val + 1'b1;
            end
          end else if (xf_empty && wr_fifo) begin
            state <= IDLE;
          end
        end

        WRITE_MEM: begin
          if (val < data_out) begin
            if (wr_cmd && !empty) begin
              wr_mem <= 1'b1;
              val <= val + 1'b1;
            end
          end else if (wr_fifo) begin
            state <= IDLE;
          end
        end
      endcase

      if (wr_mem) begin
        addr <= addr + 1'b1;
      end
    end
  end

  // To indicate load_ps for serializer
  always @(*) begin
    if (state == READ_MEM && !xf_empty && sr_ready) begin
      load_ps = 1;
    end else begin
      load_ps = 0;
    end
  end

endmodule


/*  input clk;
  input rst;
  input wr_cmd;
  input wr_fifo;
  input [7:0]wr_mem_data;       // Data from fifo
  input full;                   //Receive fifo full signal
  input empty;                  //Receive fifo empty signal
  input xf_full;                //Transmit fifo full signal
  input xf_empty;               //Transmit fifo empty signal
  input sr_ready;               //Indicate serializer is ready to transmit
  output reg rd_mem;            // To perform read
  output reg wr_mem;            // To write to memory
  output reg [3:0] addr;        // Address of Data of memory
  output reg wr_xmt_fifo;
  output reg rd_rcv_fifo;
  output reg load_ps;
  
  reg [2:0] data_out;
  reg [2:0] val;
  reg [1:0] state;

  // State definitions
  parameter IDLE = 2'b00;
  parameter READ_MEM = 2'b01;
  parameter WRITE_MEM = 2'b10;

  always @(posedge clk or posedge rst)
    begin
      if (rst)
        begin
          state <= IDLE;
          val <= 3'b0;
        end
      else begin
        case (state)
          IDLE:
            begin
              val <= 3'b0;
              if (wr_mem_data[0]==1'b1) begin
                state <= READ_MEM;
              end
              else if (wr_mem_data[0]==1'b0) begin
                state <= WRITE_MEM;
              end
            end

          READ_MEM:
            begin
              if (val < data_out) begin
                state <= READ_MEM;
                val <= val + 1'b1;
              end
              else if(xf_empty & wr_fifo)
                state <= IDLE;
            end

          WRITE_MEM:
            begin
              if (val < data_out) begin
                state <= WRITE_MEM;
                if(wr_cmd & !empty)
                  val <= val + 1'b1;
              end
              else if(wr_fifo)
                state <= IDLE;
            end
        endcase
      end
    end
  // Signaling to read from Fifo
  always @(*) begin
    if(wr_fifo )
      rd_rcv_fifo = 1'b1;
    else
      rd_rcv_fifo = 1'b0;
  end
  //Signaling to write to memory
  always @(*) begin
    if(wr_cmd & (state==WRITE_MEM))
      wr_mem <= 1'b1;
    else
      wr_mem <= 1'b0;
  end
  // Address Increment logic
  always @(posedge clk) begin
    if(rst)begin
      addr <= 4'b0;
      data_out <= 3'b0;
    end
    else if(state==IDLE) begin
      addr <= wr_mem_data[4:1];
      data_out <= wr_mem_data[7:5];
    end
    else if((rd_mem | wr_mem) & !empty)
      addr <= addr + 1'b1;
  end
  //Signaling to read from memory
  always @(*) begin
    if(state==READ_MEM & (val < data_out))
      rd_mem <= 1'b1;
    else
      rd_mem <= 1'b0;
  end
  
  //To write data to transmit fifo
  always @(posedge clk or posedge rst) begin
    if(state==READ_MEM & (val < data_out))
      wr_xmt_fifo <= 1'b1;
    else
      wr_xmt_fifo <= 1'b0;
  end
  //To indicate load_ps for serializer
  always @(*) begin
    if(state==READ_MEM & (!xf_empty) & sr_ready)
      load_ps = 1;
    else
      load_ps = 0;
  end

endmodule */
