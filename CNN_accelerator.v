`timescale 1ns / 1ps

module matrix_mult #(parameter SIZE = 3, DATA_WIDTH = 8)(
    input clk,
    input rst,
    input [SIZE*SIZE*DATA_WIDTH-1:0] matrix,
    input [SIZE*SIZE*DATA_WIDTH-1:0] kernel,
    output reg [SIZE*SIZE*DATA_WIDTH-1:0] result
);
    
    genvar i;
    generate
        for (i = 0; i < SIZE*SIZE; i = i + 1) begin : mult_gen
            wire [DATA_WIDTH-1:0] product;
            assign product = matrix[i*DATA_WIDTH +: DATA_WIDTH] * kernel[i*DATA_WIDTH +: DATA_WIDTH];
            assign result[i*DATA_WIDTH +: DATA_WIDTH] = product;
        end
    endgenerate

endmodule

module relu #(parameter DATA_WIDTH = 8, SIZE = 3)(
    input [SIZE*SIZE*DATA_WIDTH-1:0] in_data,
    output reg [SIZE*SIZE*DATA_WIDTH-1:0] out_data
);
    
    genvar i;
    generate
        for (i = 0; i < SIZE*SIZE; i = i + 1) begin : relu_gen
            assign out_data[i*DATA_WIDTH +: DATA_WIDTH] = (in_data[i*DATA_WIDTH + DATA_WIDTH-1] == 1'b1) ? 8'd0 : in_data[i*DATA_WIDTH +: DATA_WIDTH];
        end
    endgenerate

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

module CNN_accelerator #(parameter SIZE = 3, DATA_WIDTH = 8) (
    input clk,
    input rst,
    input [SIZE*SIZE*DATA_WIDTH-1:0] input_matrix,
    input [SIZE*SIZE*DATA_WIDTH-1:0] kernel,
    output [DATA_WIDTH-1:0] max_output
);

    wire [SIZE*SIZE*DATA_WIDTH-1:0] conv_output;
    wire [SIZE*SIZE*DATA_WIDTH-1:0] relu_output;

    matrix_mult #(SIZE, DATA_WIDTH) conv_layer (
        .clk(clk),
        .rst(rst),
        .matrix(input_matrix),
        .kernel(kernel),
        .result(conv_output)
    );
    
    relu #(DATA_WIDTH, SIZE) relu_layer (
        .in_data(conv_output),
        .out_data(relu_output)
    );
    
    maxpool #(SIZE, DATA_WIDTH) max_pooling (
        .matrix(relu_output),
        .max_value(max_output)
    );
    
endmodule
