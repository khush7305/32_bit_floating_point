`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2025 08:08:41 PM
// Design Name: 
// Module Name: test_bench
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


module test_bench;

    // Inputs
    reg  [31:0] in_1;
    reg  [31:0] in_2;

    // Output
    wire [31:0] out;
    // Instantiate DUT
    top_module dut (
        .in_1(in_1),
        .in_2(in_2),
        .out(out)
    );

    // Task: print floating-point values in binary and hex
    task display_case(input [31:0] a, input [31:0] b, input [31:0] y);
        begin
            $display("Time=%0t | in1=%h | in2=%h | out=%h",
                     $time, a, b, y);
        end
    endtask

    initial begin
        // Monitor every change
        $monitor("t=%0t | in1=%h | in2=%h | out=%h", $time, in_1, in_2, out);

        // ------------------
        // Edge Case Tests
        // ------------------

        // 1. Normal numbers
        in_1 = 32'h3F800000; // 1.0
        in_2 = 32'h40000000; // 2.0
        #10 display_case(in_1,in_2,out);

        // 2. Zero * Any
        in_1 = 32'h00000000; // +0
        in_2 = 32'h3F800000; // 1.0
        #10 display_case(in_1,in_2,out);

        // 3. Negative * Positive
        in_1 = 32'hBF800000; // -1.0
        in_2 = 32'h40000000; // 2.0
        #10 display_case(in_1,in_2,out);

        // 4. Large * Small
        in_1 = 32'h7F7FFFFF; // Max finite (~3.4e38)
        in_2 = 32'h00800000; // Smallest normal (~1.175e-38)
        #10 display_case(in_1,in_2,out);

        // 5. Infinity * Number
        in_1 = 32'h7F800000; // +INF
        in_2 = 32'h3F800000; // 1.0
        #10 display_case(in_1,in_2,out);

        // 6. NaN * Number
        in_1 = 32'h7FC00000; // Quiet NaN
        in_2 = 32'h3F800000; // 1.0
        #10 display_case(in_1,in_2,out);

        // 7. Denormalized * Normal
        in_1 = 32'h00000001; // Smallest subnormal
        in_2 = 32'h3F800000; // 1.0
        #10 display_case(in_1,in_2,out);

        // 8. Negative * Negative
        in_1 = 32'hBF800000; // -1.0
        in_2 = 32'hBF800000; // -1.0
        #10 display_case(in_1,in_2,out);

        // Finish simulation
        #20;
        $finish;
    end
endmodule