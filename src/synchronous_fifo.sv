`timescale 1ns / 1ps
module synchronous_fifo #(parameter DEPTH = 8, DATA_WIDTH = 8)(
    input clk,
    input rst_n,
    input wr_en, rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output full, empty

    );
    
    localparam PTR_WIDTH = $clog2(DEPTH);
    reg [PTR_WIDTH:0] w_ptr, r_ptr; //additional MSB to detect full/empty condition
    reg [DATA_WIDTH-1:0] fifo[DEPTH];
    reg wrap_around;
    
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            data_out <= 0;
        end
        else begin
            if(wr_en && !full) begin
                fifo[w_ptr[PTR_WIDTH-1:0]] <= data_in;
                w_ptr <= w_ptr+1;
            end
            
            if(rd_en && !empty) begin
                data_out <= fifo[r_ptr[PTR_WIDTH-1:0]];
                r_ptr <= r_ptr+1;
            end
        end
    end
    
    assign wrap_around = w_ptr[PTR_WIDTH] ^ r_ptr[PTR_WIDTH];
    assign full = wrap_around & (w_ptr[PTR_WIDTH-1:0] ==  r_ptr[PTR_WIDTH-1:0]);
    assign empty = (w_ptr == r_ptr);
    
endmodule
