`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2025 12:28:42 AM
// Design Name: 
// Module Name: exponent
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
module exponent(
    input  [31:0] A,
    input  [31:0] B,
    input  [47:0]  product,
    output reg [7:0]  Expo_Out,
    output reg [22:0] norm_manti
);
    wire [7:0] exp_A;
    assign exp_A = A[30:23];
    wire [7:0] exp_B;
    assign exp_B = B[30:23];
    wire [22:0] manti_A;
    assign manti_A = A[22:0];
    wire [22:0] manti_B;
    assign manti_B = B[22:0]; 
    reg [8:0] temp_exp;  // 9 bits for intermediate exponent (avoid overflow)
    reg [7:0] expo_out;
    always @(*) begin
        // temporary exponent adder with bias subtraction (127)
        if(exp_A==8'hFF && manti_A!=23'b0)begin
            assign Expo_Out = exp_A;
            assign norm_manti = manti_A;
        end
        else if(exp_B==8'hFF && manti_B!=23'b0) begin
            assign Expo_Out = exp_B;
            assign norm_manti = manti_B;
        end
        else begin
        temp_exp = exp_A + exp_B - 8'd127;
        // normalizer
        if (product[47] == 1'b1) begin
            // product >= 2.0 → shift right and increment exponent
            norm_manti = product[45:23];  // take 23 bits after hidden 1
            expo_out   = temp_exp + 1;    // adjust exponent
        end 
        else begin
            // product in [1.0, 2.0) → already normalized
            norm_manti = product[46:24];  // take 23 bits after hidden 1
            expo_out   = temp_exp;        // no increment
        end
    end
    assign Expo_Out = expo_out - 8'b00000001;
    end
endmodule

