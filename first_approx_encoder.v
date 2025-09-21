`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:14:57 PM
// Design Name: 
// Module Name: first_approx_encoder
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


module first_approx_encoder #(
    parameter N = 24,
    parameter ROW_INDEX = 0
) (
    input  signed [N-1:0] multiplicand,
    input  [2:0] b_group,              // three bits from the multiplier
    output signed [2*N-1:0] pp_row
);

    wire b_minus1 = b_group[0];        // bit at position i-1
    wire b_0 = b_group[1];             // bit at position i
    wire b_plus1 = b_group[2];         // bit at position i+1

    // our approximation logic
    wire select = (b_0 ^ b_plus1) & b_minus1;

    // generate the partial product
    wire signed [N:0] pp_temp = select ? {multiplicand[N-1], multiplicand} : {(N+1){1'b0}};

    // shift to the right position
    assign pp_row = $signed({{(N-1){pp_temp[N]}}, pp_temp}) << (ROW_INDEX * 2);

endmodule
