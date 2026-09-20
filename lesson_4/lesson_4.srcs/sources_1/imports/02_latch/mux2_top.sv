`timescale 1ns/1ps
// ---------------------------------------------------------------------------
// Structural wrapper: both muxes fed from the same three inputs, no stimulus
// of any kind inside.
//
// This is the simulation top for the Vivado flow, so that a/b/sel can be
// driven with add_force (Force Constant) instead of writing a testbench.
// Compare mux2_hw.sv, which does the same thing but wires the inputs to
// physical switches on the iCESugar board.
// ---------------------------------------------------------------------------
module mux2_top (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic y_latch,
    output logic y_fixed
);
    mux2_latch u_broken (.a(a), .b(b), .sel(sel), .y(y_latch));
    mux2_fixed u_fixed  (.a(a), .b(b), .sel(sel), .y(y_fixed));
endmodule
