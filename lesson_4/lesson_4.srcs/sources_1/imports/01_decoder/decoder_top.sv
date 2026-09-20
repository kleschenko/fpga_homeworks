`timescale 1ns/1ps
// Simulation wrapper: THE SAME decoder module instantiated twice with
// different WIDTH, proving the code is width-independent.
module decoder_top (
    input  logic [1:0] in4,
    input  logic [2:0] in8,
    input  logic       en,
    output logic [3:0] out4,
    output logic [7:0] out8
);
    decoder #(.WIDTH(4)) u_dec4 (.in(in4), .en(en), .out(out4));
    decoder #(.WIDTH(8)) u_dec8 (.in(in8), .en(en), .out(out8));
endmodule
