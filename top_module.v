`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:06:26 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
input  [31:0] in_1,   
input  [31:0] in_2,   
output [31:0] out     
);
    wire sign_1 = in_1[31];
    wire sign_2 = in_2[31];
    wire [7:0] exp_1 = in_1[30:23];
    wire [7:0] exp_2 = in_2[30:23];
    wire [23:0] man_1 = {1'b1, in_1[22:0]};  // implicit leading 1
    wire [23:0] man_2 = {1'b1, in_2[22:0]};  // implicit leading 1
//Step 2: Sign Calculation
    wire out_sign;
    sign_calculation u0(
        .sign_1(sign_1),
        .sign_2(sign_2),
        .out_sign(out_sign)
    );
    // Step 3: Mantissa Multiplication (Booth)
    wire [47:0] product;
    booth_multiplier #(.N(24)) u1 (
        .multiplicand(man_1),
        .multiplier(man_2),
        .product(product)
    );
    // Step 4: Exponent + Normalization
    wire [7:0] out_exp;
    wire [22:0] out_mantissa;
    exponent u2 (
        .A(in_1),
        .B(in_2),
        .product(product),
        .Expo_Out(out_exp),
        .norm_manti(out_mantissa)
    );
    // Step 5: Assemble Final Output
    assign out = {out_sign, out_exp, out_mantissa};

endmodule
