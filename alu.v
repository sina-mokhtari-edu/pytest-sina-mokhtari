module alu (input [3:0] control, input [31:0] a, input [31:0] b, output reg [31:0] c, output zero);
    
    assign zero = (c == 32'd0 ? 1'b1 : 1'b0);
    
    always @(*)
        case (control)
            0: c = a & b;
            1: c = a | b;
            2: c = a + b;
			3: c = a ^ b;
			4: c = a << b;
			5: c = a >> b;
            6: c = a - b;
			7: c = a >>> b;
        endcase
endmodule