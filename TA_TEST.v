`define p 100
module TA_TEST;
	
	integer total = 25*8*2, correct = 0, i = 0, j = 0;
	real point;
	
    reg [3:0] control;
    reg [31:0] a, b, result;
    
    wire [31:0] c;
    wire zero;

    reg [3:0] controlValue [7:0];
    
    alu alu1 (
        .control (control),
        .a (a),
        .b (b),
        .c (c),
        .zero (zero)
    );
    
    initial begin
        controlValue[0] = 0;
        controlValue[1] = 1;
        controlValue[2] = 2;
        controlValue[3] = 3;
		controlValue[4] = 4;
		controlValue[5] = 5;
		controlValue[6] = 6;
		controlValue[7] = 7;
        
        for (i = 0; i < 25; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                control = controlValue[j];
                a = $mti_random();
                b = (j==7) ? ($mti_random()%32) : $mti_random();
                #1;
                case (control)
                    0: result = a & b;
					1: result = a | b;
					2: result = a + b;
					3: result = a ^ b;
					4: result = a << b;
					5: result = a >> b;
					6: result = a - b;
					7: result = $signed(a) >>> b;
				endcase
				if (result == c)
					correct = correct + 1;
				if (c == 0 && zero == 1)
					correct = correct + 1;
				else if (c != 0 && zero == 0)
					correct = correct + 1;
				#9;
            end
        end
		
		#(`p);		
		point = correct * 100 / total;
		$display ("grade: %f", point);
		$finish;
	end
	
	
endmodule

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