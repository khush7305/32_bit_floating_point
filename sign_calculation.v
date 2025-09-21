`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:07:48 PM
// Design Name: 
// Module Name: sign_calculation
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


module sign_calculation(
input sign_1,
input sign_2,
output out_sign
);
assign out_sign = sign_1 ^ sign_2;
endmodule

