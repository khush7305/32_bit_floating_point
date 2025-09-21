`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:11:19 PM
// Design Name: 
// Module Name: booth_multiplier
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


module booth_multiplier #(
    parameter N = 24,
    parameter APPROX_FACTOR = 12,
    parameter ENCODER_TYPE = 1
)(
    input  signed [N-1:0] multiplicand,
    input  signed [N-1:0] multiplier,
    output signed [2*N-1:0] product
);

    // calculate how many partial products we need
    localparam NUM_PP = N/2 + 1;

    // add extra zero for booth encoding
    wire [N:0] b_ext = {multiplier, 1'b0};

    // array to store all the partial products
    wire signed [2*N-1:0] pp [0:NUM_PP-1];

    wire signed [NUM_PP * 2*N - 1 : 0] pp_flat;

    // generate all the partial products
    genvar i;
    generate
        for (i = 0; i < NUM_PP; i = i + 1) begin : gen_pp
            if (i*2 < APPROX_FACTOR) begin
                // use approximate encoder for less important bits
                if (ENCODER_TYPE == 1)
                    first_approx_encoder #(.N(N), .ROW_INDEX(i)) encoder (
                        .multiplicand(multiplicand),
                        .b_group(b_ext[i*2+2:i*2]),
                        .pp_row(pp[i])
                    );
                else
                    second_approxencoder #(.N(N), .ROW_INDEX(i)) encoder (
                        .multiplicand(multiplicand),
                        .b_group(b_ext[i*2+2:i*2]),
                        .pp_row(pp[i])
                    );
            end else begin
                // use exact encoder for important bits
                exactencoder #(.N(N), .ROW_INDEX(i)) encoder (
                    .multiplicand(multiplicand),
                    .b_group(b_ext[i*2+2:i*2]),
                    .pp_row(pp[i])
                );
            end

            assign pp_flat[(i+1)*2*N-1 : i*2*N] = pp[i];
        end
    endgenerate

    // add up all the partial products
    wallacetree #(.N(N), .NUM_PP(NUM_PP)) wt (
        .pp_array_flat(pp_flat),
        .sum(product)
    );

endmodule
