`timescale 1ns/1ns
`include "uart_tx.v"

module tb_uart_tx;

    parameter DATA_BITS = 8;
    parameter STOP_BITS = 1;

    reg clk = 0;
    reg n_rst;
    reg valid_in;
    reg [DATA_BITS-1:0] data_in;
    wire tx, ready_out;

    uart_tx #(
        .DATA_BITS(DATA_BITS),
        .STOP_BITS(STOP_BITS)
    ) dut (
        .clk(clk),
        .n_rst(n_rst),
        .valid_in(valid_in),
        .data_in(data_in),
        .tx(tx),
        .ready_out(ready_out)
    );


    always #5 clk = ~clk;

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        n_rst = 0;
        valid_in = 0;
        data_in = 0;

        #20;
        n_rst = 1;

        @(posedge clk);
        wait (ready_out == 1);

        data_in = 8'h55;
        valid_in = 1;
        @(posedge clk);
        valid_in = 0;


        repeat ((1 + DATA_BITS + STOP_BITS) * 16)
        @(posedge clk);

        wait (ready_out == 1);

        data_in = 8'hA3;
        valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        repeat ((1 + DATA_BITS + STOP_BITS) * 16)
        @(posedge clk);

        wait (ready_out == 1);

        data_in = 8'hFF;
        valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        repeat ((1 + DATA_BITS + STOP_BITS) * 16)
        @(posedge clk);

        $display("Transmissão concluída.");
        #100;
        $finish;
    end
endmodule
