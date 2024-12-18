
module RST_SYNC
(
 input  wire RST,
 input  wire CLK,
 output wire SYNC_RST
);

// Synchronizer Flip Flops //
reg SYNC_FF1;
reg SYNC_FF2;

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   // Reset Assertion
   SYNC_FF1 <= 1'b0;
   SYNC_FF2 <= 1'b0;
   end
 else
   begin
   // Reset Deassertion
   SYNC_FF1 <= 1'b1;
   SYNC_FF2 <= SYNC_FF1;	
   end
end

assign SYNC_RST = SYNC_FF2;

endmodule