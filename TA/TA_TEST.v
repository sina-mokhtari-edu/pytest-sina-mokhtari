`define p 100
module TA_TEST;
	
	integer total = 1024 + 2*38, correct = 0, i, j;
	real point;
	
    reg clk, write, read;
    reg [9:0] addr;
    reg [31:0] wrdata;
    wire [31:0] rddata;
    
    mem mem1 (
        .clk (clk),
        .write (write),
        .read (read),
        .addr (addr),
        .wrdata (wrdata),
        .rddata (rddata)
    );
    
    initial clk = 1'b0;
    always #(`p/2) clk = ~clk;
    
    reg [7:0] temp [3:0];
    
    integer multFactor [3:0];
    reg [1:0] wasReset;
	initial
	begin
        multFactor [0] = 13;
        multFactor [1] = 17;
        multFactor [2] = 23;
        multFactor [3] = 7;
        
        write = 1'b1;
        read = 1'b0;
        for (i = 0; i < 1024; i = i + 4) begin
            addr = i;
            temp[0] = ((13*i) % 1097)%(2**8);
            temp[1] = ((17*(i+1)) % 1097)%(2**8);
            temp[2] = ((23*(i+2)) % 1097)%(2**8);
            temp[3] = ((7*(i+3)) % 1097)%(2**8);
            wrdata = {temp[3], temp[2], temp[1], temp[0]};
            #(`p);
		end
        
        write = 1'b0;
        read = 1'b1;
        for (i = 0; i < 1024; i = i + 1) begin
            addr = i;
            temp[0] = (((multFactor[i%4]*i) % 1097)%(2**8));
            #(1);
            if (rddata [7:0] == temp[0])
                correct = correct + 1;
            #(1);
		end
        
        write = 1'b0;
        read = 1'b0;
        wasReset = 1'b1;
        for (i = 0; i < 1024; i = i + 1) begin
            addr = i;
            #(1);
            if (rddata != 0)
                wasReset = 1'b0;
            #(1);
		end
        if (wasReset)
            correct = correct + 38;
        
        write = 1'b1;
        read = 1'b1;
        wasReset = 1'b1;
        for (i = 0; i < 1024; i = i + 1) begin
            addr = i;
            #(1);
            if (rddata != 0)
                wasReset = 1'b0;
            #(1);
		end
        if (wasReset)
            correct = correct + 38;
        
		#(`p);
		point = correct * 100 / total;
		$display ("grade: %f", point);
		$finish;
	end
	
	
endmodule