module UART_TX_FSM (
    input wire Data_Valid,
    input wire Ser_Done,
    input wire Par_En,
    input wire clk,rst,
    output reg [1:0] Mux_Sel,
    output reg Ser_En,
    output reg Busy
    );

// States Encoding //

typedef enum bit [2:0] {
        Idle   = 3'b000,
        Start  = 3'b001,
        Data   = 3'b011,
        Parity = 3'b010,
        Stop   = 3'b110
} state_e;

// State Signals //

state_e Current_State;
state_e Next_State;

// Internal Signal //

reg Busy_Comp;

// Sequential Always Block //

always @(posedge clk or negedge rst) 
  begin
    if (!rst) 
      begin
        Busy <= 1'b0;
        Current_State <= Idle;
      end
    else
      begin
        Busy <= Busy_Comp;
        Current_State <= Next_State;
      end
  end

// Next State Logic //

always @(*)
  begin
    case (Current_State)
     Idle:    begin
                if (Data_Valid)
                  Next_State = Start;
                else
                  Next_State = Idle;
              end
     Start:   begin
                Next_State = Data;
              end
     Data:    begin
                if (Ser_Done && Par_En)
                    Next_State = Parity;
                else if (Ser_Done && !Par_En)
                    Next_State = Stop;
                else
                  Next_State = Data;
              end
     Parity:  begin
                Next_State = Stop;
              end
     Stop:    begin
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
    Ser_En = 1'b0;
    Busy_Comp = 1'b0;
    Mux_Sel = 2'b00;
    case (Current_State)
     Idle:    begin
                Mux_Sel = 2'b11;
                Ser_En  = 1'b0;
                Busy_Comp = 1'b0;
              end
     Start:   begin
                Ser_En = 1'b0;
                Mux_Sel = 2'b00;
                Busy_Comp = 1'b1;
              end
     Data:    begin
               Mux_Sel = 2'b01;
               Ser_En = 1'b1;
               Busy_Comp = 1'b1;
               if (Ser_Done)
                 Ser_En = 1'b0;
               else
                 Ser_En = 1'b1;
              end
     Parity:  begin
                Mux_Sel = 2'b10;
                Busy_Comp = 1'b1;
              end
     Stop:    begin
                Mux_Sel = 2'b11;
                Busy_Comp = 1'b1;
              end
     default: begin
                Ser_En = 1'b0;
                Busy_Comp = 1'b0;
                Mux_Sel = 2'b11;
              end
    endcase
  end
endmodule
