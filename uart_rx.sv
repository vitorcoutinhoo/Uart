module uart_rx (
    input logic clk, n_rst, rx,
    output logic ready_out, valid_out,
    output byte data_out
);

    localparam logic[1:0]
        idle = 2'b00,
        start = 2'b01,
        data = 2'b10,
        stop = 2'b11;

    byte data_reg;
    logic ready_reg, valid_reg;
    logic [1:0] state;
    logic [3:0] clk_cnt;
    logic [2:0] data_cnt;

    always_ff @(posedge clk, negedge n_rst ) begin
        if(~n_rst) begin
            state <= idle;
            valid_reg <= 1'b0;
            data_reg <= '0;
            clk_cnt <= 0;
            data_cnt <= 0;
        end
        else begin
            case(state)
                idle: begin
                    ready_reg <= 1'b1;
                    if(~rx)
                        state <= start;
                end
                start: begin
                    ready_reg <= 1'b0;
                    if(clk_cnt == 7) begin
                        clk_cnt <= 0;
                        if (~rx) begin
                            state <= data;
                        end
                        else
                            state <= idle;
                    end
                    else
                        clk_cnt++;
                end
                data: begin
                    if (clk_cnt == 15) begin
                        data_reg <= {rx, data_reg[7:1]};
                        if(data_cnt == 7) begin
                            data_cnt <= 0;
                            valid_reg <= 1'b1;
                            state <= stop;
                        end
                        else
                            data_cnt++;
                    end
                    else
                        clk_cnt++;
                end
                stop: begin
                    if(clk_cnt == 15 && rx) begin
                        clk_cnt <= 0;
                        valid_reg <= 1'b0;
                        state <= idle;
                    end
                    else
                        clk_cnt++;
                end
            endcase
        end
    end

    assign data_out = data_reg;
    assign valid_out = valid_reg;
    assign ready_out = ready_reg;
endmodule