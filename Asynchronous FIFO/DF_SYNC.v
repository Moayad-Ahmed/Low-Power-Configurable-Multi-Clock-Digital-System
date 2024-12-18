
module DF_SYNC
(
 input  wire             CLK,
 input  wire             RST,
 input  wire    [3:0]    ASYNC_DATA,
 output wire    [3:0]    SYNC_DATA
);

// Synchronize Flip Flops //

reg   [3:0]   meta_ff;
reg   [3:0]   sync_ff;

always @(posedge CLK or negedge RST)
 begin
 if (!RST)
   begin
   meta_ff <= 0;
   sync_ff <= 0;
   end
 else
   begin
   meta_ff <= ASYNC_DATA;
   sync_ff <= meta_ff;
   end
end

assign SYNC_DATA = sync_ff;

endmodule