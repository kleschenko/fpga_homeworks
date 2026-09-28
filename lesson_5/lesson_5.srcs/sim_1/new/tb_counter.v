// tb_counter.v
// Self-checking testbench for counter.v.
//
// Console run (Vivado XSim), from the folder containing both files:
//     xvlog counter.v tb_counter.v
//     xelab tb_counter -s tb_sim
//     xsim tb_sim -R
// With waveform:
//     xelab -debug typical tb_counter -s tb_sim
//     xsim tb_sim -gui

`timescale 1ns / 1ps

module tb_counter;
    reg        clk;
    reg        rst;
    reg        load;
    reg  [3:0] data_in;
    reg        en;
    reg        up_down;
    wire [3:0] count;

    integer errors = 0;

    counter dut (
        .clk(clk), .rst(rst),
        .load(load), .data_in(data_in),
        .en(en), .up_down(up_down),
        .count(count)
    );

    // ---- Clock generator: 10 ns period (100 MHz) ----
    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Self-checking task ----
    task automatic check_count;
        input [3:0]      expected;
        input [8*16-1:0] name;
        begin
            if (count === expected)
                $display("[%0t ns] PASS: %s -> count=%0d",
                          $time, name, count);
            else begin
                $display("[%0t ns] FAIL: %s -> expected %0d, got %0d (%b)",
                          $time, name, expected, count, count);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $timeformat(-9, 0, "", 0); // %t prints whole nanoseconds

        // All inputs start in a known state, except rst: it is held at 0 for
        // a moment so that the X on count is visible in the wave window.
        rst = 0;  load = 0;  data_in = 4'd0;  en = 0;  up_down = 0;
        #1;
        $display("[%0t ns] before reset: count = %b  <- X, the register has not been assigned yet",
                  $time, count);
        #2;

        // ---- Load ----
        rst = 1; // reset for one clock
        @(posedge clk); #1;
        rst = 0;
        check_count(4'd0, "reset");

        load = 1;  data_in = 4'd10;
        @(posedge clk); #1;
        load = 0;
        check_count(4'd10, "load 10");

        // ---- Count up, including the 15 -> 0 wrap ----
        en = 1;  up_down = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check_count(4'd13, "up x3 -> 13");

        @(posedge clk); #1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check_count(4'd0, "up x3 wrap -> 0");

        // ---- Hold (en=0) ----
        en = 0;  up_down = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        check_count(4'd0, "hold en=0");

        // ---- Count down with the 0 -> 15 wrap ----
        en = 1;  up_down = 0;
        @(posedge clk); #1;
        check_count(4'd15, "down wrap -> 15");

        // ---- load has priority over en ----
        load = 1;  data_in = 4'd5;  en = 1;  up_down = 1;
        @(posedge clk); #1;
        load = 0;  en = 0;
        check_count(4'd5, "load beats en");

        // ---- Bonus: ordinary count down, no wrap ----
        load = 1;  data_in = 4'd8;
        @(posedge clk); #1;
        load = 0;
        check_count(4'd8, "load 8");

        en = 1;  up_down = 0;
        @(posedge clk); #1;
        en = 0;
        check_count(4'd7, "down 8 -> 7");

        // ---- Summary ----
        if (errors == 0)
            $display("[%0t ns] ALL TESTS PASSED", $time);
        else
            $display("[%0t ns] %0d TEST(S) FAILED", $time, errors);
        $finish;
    end

endmodule
