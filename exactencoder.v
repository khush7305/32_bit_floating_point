`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:17:42 PM
// Design Name: 
// Module Name: exactencoder
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


module exactencoder #(
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

    // standard booth encoding
    wire [1:0] booth_ctrl = {(b_0 ^ b_plus1), (b_minus1 ^ b_0)};

    reg signed [N:0] pp_temp;

    always @(*) begin
        case (booth_ctrl)
            2'b00: pp_temp = {(N+1){1'b0}};                   // zero
            2'b01: pp_temp = {multiplicand[N-1], multiplicand}; // +A
            2'b10: pp_temp = {multiplicand, 1'b0};           // +2A
            2'b11: pp_temp = -{{multiplicand[N-1], multiplicand}}; // -A
            default: pp_temp = {(N+1){1'b0}};
        endcase

        // handle special case for -2A
        if (b_group == 3'b100)
            pp_temp = -{multiplicand, 1'b0};
    end

    // shift to the right position

    assign pp_row = $signed({{(N-1){pp_temp[N]}}, pp_temp}) << (ROW_INDEX * 2);

endmodule
