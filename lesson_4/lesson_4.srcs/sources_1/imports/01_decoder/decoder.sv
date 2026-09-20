`timescale 1ns/1ps
// ---------------------------------------------------------------------------
// Parameterised one-hot decoder.
//
//   WIDTH = number of OUTPUTS
//
//   WIDTH=4 -> 2-bit input, 4 outputs
//   WIDTH=8 -> 3-bit input, 8 outputs
// ---------------------------------------------------------------------------
module decoder #(
    parameter WIDTH = 4
)(
    input  logic [$clog2(WIDTH)-1:0] in,
    input  logic                     en,
    output logic [WIDTH-1:0]         out
);
    always_comb begin
        out = '0;                  // default: everything off
        if (en) out[in] = 1'b1;    // exactly one output driven high
    end
endmodule
