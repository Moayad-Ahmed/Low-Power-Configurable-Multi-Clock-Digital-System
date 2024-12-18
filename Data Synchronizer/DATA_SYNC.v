
module DATA_SYNC # (parameter Bus_Width = 8)
(
 input wire                         CLK,
 input wire                         RST,
 input wire     [Bus_Width-1:0]     Unsync_Bus,
 input wire                         Bus_Enable,
 output reg                         Enable_Pulse,
 output reg     [Bus_Width-1:0]     Sync_Bus
);

// Internal Signals //

reg SYNC_FE1;
reg SYNC_FE2;
reg Enable_FF;

wire Enable_Pulse_Comb;
wire [Bus_Width-1:0] Sync_Bus_Comb;

// Double Flip Flop Synchronizer //

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   // Reset
   SYNC_FE1 <= 1'b0;
   SYNC_FE2 <= 1'b0;
   end
 else
   begin
   SYNC_FE1 <= Bus_Enable;
   SYNC_FE2 <= SYNC_FE1;
   end
end

// Pulse Generator //

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   Enable_FF <= 1'b0;
   end
 else
   begin
   Enable_FF <= SYNC_FE2;
   end
end

assign Enable_Pulse_Comb = SYNC_FE2 & !Enable_FF;

// Enable Bus //

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   Enable_Pulse <= 1'b0;
   end
 else
   begin
   Enable_Pulse <= Enable_Pulse_Comb;
   end
end

// Synchronized Bus //

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   Sync_Bus <= 1'b0;
   end
 else
   begin
   Sync_Bus <= Sync_Bus_Comb;
   end
end

assign Sync_Bus_Comb = Enable_Pulse_Comb ? Unsync_Bus : Sync_Bus ;

endmodule