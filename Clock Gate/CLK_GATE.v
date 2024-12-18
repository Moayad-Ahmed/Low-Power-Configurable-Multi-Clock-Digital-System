
/////////////////////////////////////////////////////////////
/////////////////////// Clock Gating ////////////////////////
/////////////////////////////////////////////////////////////

module CLK_GATE
(
 input      CLK_EN,
 input      CLK,
 output     GATED_CLK
);

// Internal Signals //

reg     Latch_Out ;

// Latch (Level Sensitive Device)
always @(CLK or CLK_EN)
 begin
  if(!CLK)      // active low
   begin
    Latch_Out <= CLK_EN ;
   end
 end
 
// ANDING

assign  GATED_CLK = CLK && Latch_Out ;

endmodule