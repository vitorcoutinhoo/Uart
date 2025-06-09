`timescale 1ns/1ns
`include "uart_rx.sv"

module tb_uartrx;
    logic clk;
    logic n_rst;
    logic rx;
    logic ready_out;
    logic valid_out;
    byte data_out;

    uart_rx uut (
        .clk(clk),
        .n_rst(n_rst),
        .rx(rx),
        .ready_out(ready_out),
        .valid_out(valid_out),
        .data_out(data_out)
    );

    // Clock 100MHz (10ns período)
    always #5 clk = ~clk;

    initial begin
        // Geração de VCD LEVE
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, tb_uartrx.rx, tb_uartrx.valid_out, tb_uartrx.ready_out, tb_uartrx.data_out);

        // Inicialização
        clk = 0;
        rx = 1; // idle
        n_rst = 0;
        #50;
        n_rst = 1;

        // Aguarda receiver pronto
        @(posedge ready_out);

        // Envia byte 0xA5 (10100101) 
        rx = 0; #(160); // start
        rx = 1; #(160); // bit 0
        rx = 0; #(160); // bit 1
        rx = 1; #(160); // bit 2
        rx = 0; #(160); // bit 3
        rx = 0; #(160); // bit 4
        rx = 1; #(160); // bit 5
        rx = 0; #(160); // bit 6
        rx = 1; #(160); // bit 7
        rx = 1; #(160); // stop
        $finish;
    end
endmodule