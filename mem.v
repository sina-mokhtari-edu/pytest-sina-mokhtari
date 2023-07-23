module mem (input clk, input write, input read, input [9:0] addr, input [31:0] wrdata, output [31:0] rddata);
    
    reg [7:0] cells [1023:0];
    
    assign rddata = ((read == 1'b1 && write == 1'b0) ? {cells [addr+3], cells [addr+2], cells [addr+1], cells [addr]} : 32'd0);
    
    always @(posedge clk) begin
        if (write == 1'b1 && read == 1'b0) begin
            cells [addr]   = wrdata [7:0];
            cells [addr+1] = wrdata [15:8];
            cells [addr+2] = wrdata [23:16];
            cells [addr+3] = wrdata [31:24];
        end
    end
    
endmodule