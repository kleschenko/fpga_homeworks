`timescale 1ns/1ps
// ---------------------------------------------------------------------------
// The fix: every branch of sel now assigns y, so the block is complete
// combinational logic and no storage element is inferred.

// ---------------------------------------------------------------------------
module mux2_fixed (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic y
);
    always_comb begin
        case (sel)
            1'b0:    y = a;
            default: y = b;
        endcase
    end
endmodule
