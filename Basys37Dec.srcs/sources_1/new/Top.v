`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/12 16:56:05
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input               clk,
    input               rst,
    input       [15:0]  sw,
    output reg [6:0]    seg,
    output reg          dp,
    output reg [3:0]    an
    );
    
    function [6:0] segdec;
    input   [3:0] sldsw;
    begin
        case(sldsw) 
            4'h0:   segdec = 7'b1000000;
            4'h1:   segdec = 7'b1111001;
            4'h2:   segdec = 7'b0100100;
            4'h3:   segdec = 7'b0110000;
            4'h4:   segdec = 7'b0011001;
            4'h5:   segdec = 7'b0010010;
            4'h6:   segdec = 7'b0000010;
            4'h7:   segdec = 7'b1011000;
            4'h8:   segdec = 7'b0000000;
            4'h9:   segdec = 7'b0010000;
            4'ha:   segdec = 7'b0001000;
            4'hb:   segdec = 7'b0000011;
            4'hc:   segdec = 7'b1000110;
            4'hd:   segdec = 7'b0100001;
            4'he:   segdec = 7'b0000110;
            4'hf:   segdec = 7'b0001110;
            default:segdec = 7'b1111111;
        endcase
    end
    endfunction
    
    wire one_ms;
    
    reg [19:0] cnt1m;
    
    always @(posedge clk) begin
        if(rst) begin
            cnt1m <= 1'h0;
        end
        else begin
            cnt1m <= cnt1m + 1'h1;
        end
    end
        
    assign one_ms = (cnt1m == 20'hfffff);
        
    reg[1:0] an_cnt;
        
    always @(posedge one_ms or posedge rst) begin
        if(rst)begin
            an_cnt <= 1'h0;
        end
        else begin
            an_cnt <= an_cnt + 1'h1;
        end
    end
    
    always @(posedge one_ms) begin
        case(an_cnt)
            4'h0: begin
                seg <= segdec(sw[3:0]);
                an <= 4'he;
            end
            4'h1:begin
                seg <= segdec(sw[7:4]);
                an <= 4'hd;
            end
            4'h2:begin
                seg <= segdec(sw[11:8]);
                an <= 4'hb;
            end
            4'h3: begin
                seg <= segdec(sw[15:12]);
                an <= 4'h7;
            end
            default: begin
                seg <= 6'h0;
                an <= 4'hf;
            end
        endcase
    end
endmodule
