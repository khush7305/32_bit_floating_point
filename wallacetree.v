`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:13:18 PM
// Design Name: 
// Module Name: wallacetree
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wallacetree #(
    parameter N = 24,
    parameter NUM_PP = 13
)(

    input  signed [NUM_PP * 2*N - 1 : 0] pp_array_flat,
    output signed [2*N-1:0] sum
);


    wire signed [2*N-1:0] pp_array [0:NUM_PP-1];
    genvar j;
    generate
        for (j = 0; j < NUM_PP; j = j + 1) begin : unpack_pp
            assign pp_array[j] = pp_array_flat[(j+1)*2*N-1 : j*2*N];
        end
    endgenerate


    integer i;
    reg signed [2*N-1:0] temp_sum;

    always @(*) begin
        temp_sum = 0;
        for (i = 0; i < NUM_PP; i = i + 1) begin
            temp_sum = temp_sum + pp_array[i];
        end
    end

    assign sum = temp_sum;

endmodule
