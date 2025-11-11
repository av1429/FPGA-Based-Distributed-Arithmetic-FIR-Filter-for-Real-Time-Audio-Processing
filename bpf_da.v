module bpf_da #(
    parameter DATA_WIDTH = 16,  // Input data width
    parameter NUM_TAPS = 16     // Number of filter coefficients
)(
    input wire clk,
    input wire rst,
    input wire signed [DATA_WIDTH-1:0] x_in,  // 16-bit Input Sample
    output reg signed [DATA_WIDTH-1:0] y_out  // Filtered Output
);

    // **Shift Register for Past Inputs**
    reg signed [DATA_WIDTH-1:0] shift_reg [0:NUM_TAPS-1];

    // **DA LUT: Stores Precomputed Partial Sums for 4-tap blocks**
    reg signed [2*DATA_WIDTH-1:0] lut [0:15];  // 4-bit index for precomputed sums

    // **Accumulator for DA Computation**
    reg signed [2*DATA_WIDTH-1:0] acc;

    // **Bit Serial Computation Variables**
    integer bit_pos, idx, k;

    // **Initialize DA LUT with Precomputed Coefficients for 16 taps split into 4-tap blocks**
    initial begin
        // Example Band-pass Filter Coefficients (adjust for vocals enhancement)
        /*lut[0]  = 16'sd0;  
        lut[1]  = 16'sd29; 
        lut[2]  = 16'sd105; 
        lut[3]  = 16'sd249; 
        lut[4]  = 16'sd429;
        lut[5]  = 16'sd601; 
        lut[6]  = 16'sd712; 
        lut[7]  = 16'sd707; 
        lut[8]  = 16'sd553;
        lut[9]  = 16'sd243; 
        lut[10] = -16'sd212; 
        lut[11] = -16'sd797; 
        lut[12] = -16'sd1449; 
        lut[13] = -16'sd2041;
        lut[14] = -16'sd2475; 
        lut[15] = -16'sd2686;
		 */ 
		/*lut[0]  = 16'sd0;
		 lut[1]  = -16'sd8;
		 lut[2]  = -16'sd39;
		 lut[3]  = -16'sd71;
		 lut[4]  = -16'sd52;
		 lut[5]  = 16'sd0;
		 lut[6]  = 16'sd62;
		 lut[7]  = 16'sd110;
		 lut[8]  = 16'sd110;
		 lut[9]  = 16'sd62;
		 lut[10] = 16'sd0;
		 lut[11] = -16'sd52;
		 lut[12] = -16'sd71;
		 lut[13] = -16'sd39;
		 lut[14] = -16'sd8;
		 lut[15] = 16'sd0;
		*/
		lut[0]  = -16'sd95;
		lut[1]  = -16'sd25;
		lut[2]  =  16'sd240;
		lut[3]  =  16'sd963;
		lut[4]  =  16'sd2234;
		lut[5]  =  16'sd3860;
		lut[6]  =  16'sd5396;
		lut[7]  =  16'sd6333;
		lut[8]  =  16'sd6333;
		lut[9]  =  16'sd5396;
		lut[10] =  16'sd3860;
		lut[11] =  16'sd2234;
		lut[12] =  16'sd963;
		lut[13] =  16'sd240;
		lut[14] = -16'sd25;
		lut[15] = -16'sd95;

end



    // **Shift Register Logic**
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (k = 0; k < NUM_TAPS; k = k + 1)
                shift_reg[k] <= 0;
        end else begin
            shift_reg[0] <= x_in;
            for (k = 1; k < NUM_TAPS; k = k + 1)
                shift_reg[k] <= shift_reg[k - 1];
        end
    end

    // **Fully DA-Based Computation (multi-stage with 4-tap blocks)**
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 0;
        end else begin
            acc = 0;  // Reset accumulator

            // **Process 4-tap blocks (4 iterations)**
            for (bit_pos = 0; bit_pos < DATA_WIDTH; bit_pos = bit_pos + 1) begin
                idx = 0;
                for (k = 0; k < NUM_TAPS; k = k + 1) begin
                    // Generate the 4-bit index for the LUT based on bit positions of shift_reg
                    idx = idx | ((shift_reg[k][bit_pos] ? 1 : 0) << (k % 4));
                end
                acc = acc + lut[idx];  // Add LUT result for each block
            end

            // **Final Output Scaling (Arithmetic Right Shift)**
            y_out <= acc >>> DATA_WIDTH;  // Right shift the result to scale down
        end
    end

endmodule
