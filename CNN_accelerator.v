`timescale 1ns / 1ps

module matrix_mult #(parameter SIZE = 3, DATA_WIDTH = 8)(
    input clk,
    input rst,
    input [SIZE*SIZE*DATA_WIDTH-1:0] matrix,
    input [SIZE*SIZE*DATA_WIDTH-1:0] kernel,
    output reg [DATA_WIDTH-1:0] result
);
   
    integer i;
    reg [DATA_WIDTH-1:0] mult [0:SIZE*SIZE-1];
    reg [DATA_WIDTH-1:0] sum;
   
    always @(posedge clk or posedge rst) begin
    	if (rst) begin
        	sum <= 0;
    	end else begin
        	sum = 0;
        	for (i = 0; i < SIZE*SIZE; i = i + 1) begin
            	mult[i] = matrix[i*DATA_WIDTH +: DATA_WIDTH] * kernel[i*DATA_WIDTH +: DATA_WIDTH];
            	sum = sum + mult[i];
        	end
        	result <= sum;
    	end
    end
endmodule
 
module relu #(parameter DATA_WIDTH = 8)(
    input [DATA_WIDTH-1:0] in_data,
    output [DATA_WIDTH-1:0] out_data
);
    assign out_data = (in_data[DATA_WIDTH-1] == 1'b1) ? 8'd0 : in_data;
endmodule
 
module maxpool #(parameter SIZE = 2, DATA_WIDTH = 8)(
    input [SIZE*SIZE*DATA_WIDTH-1:0] matrix,
    output reg [DATA_WIDTH-1:0] max_value
);
    integer i;
    always @(*) begin
    	max_value = matrix[DATA_WIDTH-1:0];
    	for (i = 1; i < SIZE*SIZE; i = i + 1) begin
        	if (matrix[i*DATA_WIDTH +: DATA_WIDTH] > max_value) begin
            	max_value = matrix[i*DATA_WIDTH +: DATA_WIDTH];
        	end
    	end
    end
endmodule

module axi4_master (
    input clk,
    input rst,
    output reg [31:0] awaddr,
    output reg awvalid,
    input awready,
    output reg [31:0] wdata,
    output reg wvalid,
    input wready,
    input bvalid,
    output reg bready,
    output reg [31:0] araddr,
    output reg arvalid,
    input arready,
    input [31:0] rdata,
    input rvalid,
    output reg rready
);
    always @(posedge clk or posedge rst) begin
    	if (rst) begin
        	awvalid <= 0;
        	wvalid <= 0;
        	bready <= 1;
        	arvalid <= 0;
        	rready <= 1;
    	end else begin
        	// AXI4 Master Read/Write Logic
    	end
    end
endmodule
 
module axi4_slave (
    input clk,
    input rst,
    input [31:0] awaddr,
    input awvalid,
    output reg awready,
    input [31:0] wdata,
    input wvalid,
    output reg wready,
    output reg bvalid,
    input bready,
    input [31:0] araddr,
    input arvalid,
    output reg arready,
    output reg [31:0] rdata,
    output reg rvalid,
    input rready
);
    always @(posedge clk or posedge rst) begin
    	if (rst) begin
        	awready <= 0;
        	wready <= 0;
        	bvalid <= 0;
        	arready <= 0;
        	rvalid <= 0;
    	end else begin
        	// AXI4 Slave Read/Write Logic
    	end
    end
endmodule

module CNN_accelerator()
//integrate the modules
//write logic
endmodule