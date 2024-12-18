module Serializer #(parameter Data_Width = 8) (
    input  wire [Data_Width-1:0] P_Data,
    input  wire                  Data_Valid,
    input  wire                  Ser_En,
    input  wire                  Busy,
    input  wire                  clk,
    input  wire                  rst,
    output wire                  Ser_Data,
    output wire                  Ser_Done
    );

reg [2:0] Ser_Counter;
reg [Data_Width-1:0] Store_Data;       // To Store Data as Data_Valid is High for one bit only

// Sequential Always to Store Data //

always @(posedge clk or negedge rst)
  begin
    if (!rst) 
      begin
        Store_Data <= 'b0;
      end
    else if (Data_Valid && !Busy) 
      begin
        Store_Data <= P_Data;
      end
    else if (Ser_En)
      begin
        Store_Data <= Store_Data >> 1;
      end
  end

// Sequential Always of Output //

always @(posedge clk or negedge rst)
  begin
    if (!rst) 
      begin
        Ser_Counter <= 'b0;
      end
    else if (Ser_En)
      begin
        Ser_Counter <= Ser_Counter + 1'b1;
      end
    else
      begin
        Ser_Counter <= 'b0;
      end
  end

assign Ser_Data = Store_Data[0];

assign Ser_Done = (Ser_Counter == 'b111)? 1'b1 : 1'b0 ;     // Implementing Ser_Done Flag Logic

endmodule