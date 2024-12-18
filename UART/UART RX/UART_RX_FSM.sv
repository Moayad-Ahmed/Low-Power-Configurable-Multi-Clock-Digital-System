module UART_RX_FSM (
    input wire RX_In,
    input wire Par_En,
    input wire [3:0] Bit_Cnt,
    input wire [5:0] Edge_Cnt,
    input wire [5:0] Prescale,
    input wire Strt_Glitch,
    input wire Par_Err,
    input wire Stp_Err,
    input wire clk,rst,
    output reg Bit_Cnt_En,
    output reg Data_Samp_En,
    output reg strt_chk_en,
    output reg par_chk_en,
    output reg stp_chk_en,
    output reg Deser_En,
    output reg Data_Valid
    );

// States Encoding //

typedef enum bit [2:0] {
        Idle   = 3'b000,
        Start  = 3'b001,
        Data   = 3'b011,
        Parity = 3'b010,
        Stop   = 3'b110,
        Output = 3'b111
} state_e;

// State Signals //

state_e Current_State;
state_e Next_State;

// Internal Signal //

wire Sample_Ready;

assign Sample_Ready = (Edge_Cnt == ((Prescale >> 1) + 3));  //Bit Value is Captured to enable Checkers 

// Sequential Always Block //

always @(posedge clk or negedge rst) 
  begin
    if (!rst) 
      begin
        Current_State <= Idle;
      end
    else
      begin
        Current_State <= Next_State;
      end
end

// Next State Logic //

always @(*)
  begin
    case (Current_State)
     Idle:    begin
                if (!RX_In)
                  Next_State = Start;
                else
                  Next_State = Idle;
              end
     Start:   begin
                if (Bit_Cnt == 4'b0001)
                  if (!Strt_Glitch)
                    Next_State = Data;
                  else
                    Next_State = Idle;
                else
                  Next_State = Start;
              end
     Data:    begin
                if (Bit_Cnt == 4'b1001)
                  if (Par_En)
                    Next_State = Parity;
                  else
                    Next_State = Stop;
                else
                  Next_State = Data;
              end
     Parity:  begin
                if (Bit_Cnt == 4'b1010)
                  if (!Par_Err)
                    Next_State = Stop;
                  else
                    Next_State = Idle;
                else
                  Next_State = Parity;
              end
     Stop:    begin
                if (Par_En)
                  if (Bit_Cnt == 4'b1010 && Edge_Cnt == Prescale -1) // With Parity Stop Bit is 11
                    if(!Stp_Err)
                      Next_State = Output;
                    else
                      Next_State = Idle;
                  else
                    Next_State = Stop;
                else
                  if (Bit_Cnt == 4'b1001 && Edge_Cnt == Prescale - 1) // No Parity Stop Bit is no. 10
                    if(!Stp_Err)
                      Next_State = Output;
                    else
                      Next_State = Idle;
                  else
                    Next_State = Stop;
              end
     Output:   begin
                if (!RX_In)
                  Next_State = Start;
                else
                  Next_State = Idle;
              end
     default: begin
                Next_State = Idle;
              end
     endcase
end

// Output Logic Always Block //

always @(*)
  begin
    Bit_Cnt_En   = 1'b0;
    Data_Samp_En = 1'b0;
    strt_chk_en  = 1'b0;
    par_chk_en   = 1'b0;
    stp_chk_en   = 1'b0;
    Deser_En     = 1'b0;
    Data_Valid = 1'b0;
    case (Current_State)
     Idle:    begin
                Bit_Cnt_En   = 1'b0;
                Data_Samp_En = 1'b0;
                strt_chk_en  = 1'b0;
                par_chk_en   = 1'b0;
                stp_chk_en   = 1'b0;
                Deser_En     = 1'b0;
                Data_Valid = 1'b0;
              end
     Start:   begin
                Bit_Cnt_En   = 1'b1;
                Data_Samp_En = 1'b1;
                if (Sample_Ready)
                strt_chk_en  = 1'b1;
                else
                strt_chk_en  = 1'b0;
              end
     Data:    begin
                Bit_Cnt_En   = 1'b1;
                Data_Samp_En = 1'b1;
                Deser_En     = 1'b1;
              end
     Parity:  begin
                Bit_Cnt_En   = 1'b1;
                Data_Samp_En = 1'b1;
                if (Sample_Ready)
                par_chk_en   = 1'b1;
                else
                par_chk_en   = 1'b0;
                
              end
     Stop:    begin
                Bit_Cnt_En   = 1'b1;
                Data_Samp_En = 1'b1;
                if (Sample_Ready)
                stp_chk_en   = 1'b1;
                else
                stp_chk_en   = 1'b0;
                
              end
     Output:   begin
                Bit_Cnt_En   = 1'b0;
                Data_Samp_En = 1'b0;
                if (!Par_Err && !Stp_Err)
                Data_Valid = 1'b1;
                else
                Data_Valid = 1'b0;
              end
     default: begin
                Bit_Cnt_En   = 1'b0;
                Data_Samp_En = 1'b0;
                strt_chk_en  = 1'b0;
                par_chk_en   = 1'b0;
                stp_chk_en   = 1'b0;
                Deser_En     = 1'b0;
                Data_Valid = 1'b0;
              end
    endcase
end
endmodule