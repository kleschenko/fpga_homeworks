`timescale 1ns/1ps
// ---------------------------------------------------------------------------
// 4-bit counter: 0 -> 1 -> ... -> 15 -> 0, one step per rising clock edge.
// `rst` is asynchronous and active high, and clears the counter to 0.
// Each led bit is one binary digit of the current value.
// ---------------------------------------------------------------------------
module counter4 (
    input  logic       clk,
    input  logic       rst,
    output logic [3:0] led
);
    logic [3:0] count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) count <= 4'd0;
        else     count <= count + 4'd1;
    end

    assign led = count;
endmodule
