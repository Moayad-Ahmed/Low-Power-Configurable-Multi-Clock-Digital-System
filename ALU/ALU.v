
module	ALU # ( parameter Op_Width = 8, Fun_Width = 4, Out_Width = Op_Width*2 ) 

(
  input	wire   [Op_Width-1:0]    A,
  input wire   [Op_Width-1:0]    B,
  input	wire                     CLK,
  input wire                     RST,
  input wire                     ENABLE,
  input	wire   [Fun_Width-1:0]   ALU_FUN,
  output reg   [Out_Width-1:0]   ALU_OUT,
  output reg                     OUT_VALID
);

// Internal Signals //

 reg	[Out_Width-1:0]		ALU_OUT_COMB;
 reg                    OUT_VALID_COMB;

// Separating Sequential and Comb Logic: 1) Sequential Logic //

always @(posedge CLK or negedge RST)
  begin
  if (!RST)
    begin
    ALU_OUT <= 'b0;
    OUT_VALID <= 'b0;
    end
  else
    begin
    ALU_OUT <= ALU_OUT_COMB;
    OUT_VALID <= OUT_VALID_COMB;	
    end
end

// 2) Combinational Logic //

always @(*)
  begin
    if (ENABLE)
      begin
      OUT_VALID_COMB = 1'b1;
      case (ALU_FUN)

      // Arithmatic Operations

       4'b0000: begin	 //Addition
                ALU_OUT_COMB = A + B;
	              end
       4'b0001: begin	 //Subtraction
		            ALU_OUT_COMB = A - B;
	              end 
       4'b0010: begin	 //Multiplication
		            ALU_OUT_COMB = A * B;
	              end
       4'b0011: begin	 //Division
		            ALU_OUT_COMB = A / B;
	              end 

	    // Logical Operations

       4'b0100: begin	 //Logic AND
		            ALU_OUT_COMB = A & B;
	              end
       4'b0101: begin	 //Logic OR
		            ALU_OUT_COMB = A | B;
	              end
       4'b0110: begin	 //Logic NAND
		            ALU_OUT_COMB = ~ (A & B);
	              end
       4'b0111: begin	 //Logic NOR
		            ALU_OUT_COMB = ~ (A | B);
	              end
       4'b1000: begin	 //Logic XOR
		            ALU_OUT_COMB = A ^ B;
	              end
       4'b1001: begin	 //Logic XNOR
		            ALU_OUT_COMB = ~ (A ^ B);
	              end

	    // Comparison Operations

       4'b1010: begin	 //A Equals B
		            ALU_OUT_COMB = (A == B) ? 'h1 : 'b0;
	              end
       4'b1011: begin	 //A Greater Than B
		            ALU_OUT_COMB = (A > B) ? 'h2 : 'b0;
	              end 
       4'b1100: begin	 //A Less Than B
		            ALU_OUT_COMB = (A < B) ? 'h3 : 'b0;
	              end

	    // Shift Operations

       4'b1101: begin	 //Shift Right
		            ALU_OUT_COMB = A >> 1;
	              end
       4'b1110: begin	 //Shift Left
		            ALU_OUT_COMB = A << 1;
	              end
       default: begin
		            ALU_OUT_COMB = 'b0;
	              end
      endcase
      end
    else
      begin
      ALU_OUT_COMB = 'b0;
      OUT_VALID_COMB = 1'b0;
      end
end

endmodule