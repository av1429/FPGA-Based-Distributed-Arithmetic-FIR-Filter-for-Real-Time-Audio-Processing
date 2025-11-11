module BandPassFilterDA (
    input clk,
    input rst,
    input AUD_BCLK,
    input AUD_DACLRCK,
    input AUD_ADCLRCK,
    input [31:0] audioIn,

    output reg [31:0] audioOut
);

    // Input channels split
    wire signed [15:0] in_left = audioIn[31:16];
    wire signed [15:0] in_right = audioIn[15:0];

    // Filter outputs
    wire signed [15:0] out_left;
    wire signed [15:0] out_right;

    // Instantiate the DA-Based BPF module for both channels
    bpf_da bpf_left (
        .clk(clk),
        .rst(rst),
        .x_in(in_left),
        .y_out(out_left)
    );

    bpf_da bpf_right (
        .clk(clk),
        .rst(rst),
        .x_in(in_right),
        .y_out(out_right)
    );

    // Output update on each sample (sync with DACLRCK)
    always @(posedge AUD_BCLK or negedge rst) begin
        if (!rst)
            audioOut <= 32'd0;
        else if (AUD_DACLRCK)
            audioOut <= {out_left, out_right};
    end

endmodule
