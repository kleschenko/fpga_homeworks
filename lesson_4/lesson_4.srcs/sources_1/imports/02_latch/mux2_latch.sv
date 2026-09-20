`timescale 1ns/1ps
// ---------------------------------------------------------------------------
// BROKEN ON PURPOSE.
//
// A 2-to-1 mux whose case statement only covers sel == 0. There is no branch
// for sel == 1 and no default, so when sel == 1 the language says "y keeps
// its previous value" -- which in hardware is a LATCH, not a mux.
// ---------------------------------------------------------------------------
module mux2_latch (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic y
);
    always_comb begin
        case (sel)
            1'b0: y = a;
            // 1'b1 deliberately missing
            // default deliberately missing
        endcase
    end
endmodule
