module AudioFilter(
    input rst, 
    input clk, 
    input sw0,
    input sw1,

    output AUD_XCK,
    input AUD_BCLK,
    output AUD_DACDAT,
    input AUD_DACLRCK,
    input AUD_ADCDAT,
    input AUD_ADCLRCK,

    inout SDAT, 
    output SDCLK, 
    //output errorLED,
    output reg initSuccessLED
   // output [6:0] ss1,
    //output [6:0] ss2,
   // output [15:0] redLEDs
);

// Audio Clock (12.288MHz)
wire audioClk;
wire reset_source_reset;
AudioClocker myAudioClocker(
    .audio_clk_clk(audioClk),
    .ref_clk_clk(clk),
    .ref_reset_reset(rst),
    .reset_source_reset(reset_source_reset)
);
assign AUD_XCK = audioClk;

// LED Toggle Indicator
reg [31:0] audioClkCounter;
always @ (posedge AUD_BCLK) begin    
    if (AUD_DACLRCK == 1)
        audioClkCounter <= audioClkCounter + 1;

    if (audioClkCounter == 48000) begin
        initSuccessLED <= ~initSuccessLED;
        audioClkCounter <= 0;
    end
end

// Debounce Switches
wire sw0Debounced, sw1Debounced;
Debouncer sw0D(
    .rst(rst),
    .clk(clk),
    .inp(sw0),
    .out(sw0Debounced)
);
Debouncer sw1D(
    .rst(rst),
    .clk(clk),
    .inp(sw1),
    .out(sw1Debounced)
);

// Audio Chip Initialization
reg audioInitPulse;
wire audioDoneInit;
wire [3:0] audioInitError;
reg manualSend;
reg [6:0] manualRegister;
reg [8:0] manualData;
wire manualSendDone;

AudioInit myAudioInit(
    .rst(rst),
    .clk(clk),
    .initPulse(audioInitPulse),
    .SDAT(SDAT),
    .SDCLK(SDCLK),
    .doneInit(audioDoneInit),
    .audioInitError(audioInitError),
    .manualSend(manualSend),
    .manualRegister(manualRegister),
    .manualData(manualData),
    .manualDone(manualSendDone)
);

// ADC & DAC
wire DACDone;
wire ADCDone;
wire [31:0] currentADCData;
reg [31:0] currentDACData;
wire AUD_DACDATOUT;

AudioDAC myDAC(
    .clk(clk),
    .rst(rst),
    .AUD_BCLK(AUD_BCLK),
    .AUD_DACLRCK(AUD_DACLRCK),
    .data(currentDACData),
    .done(DACDone),
    .AUD_DACDAT(AUD_DACDATOUT)
);

assign AUD_DACDAT = (sw0Debounced && sw1Debounced) ? AUD_DACDATOUT : (sw0Debounced && !sw1Debounced) ? AUD_DACDATOUT : 1'b0;

AudioADC myADC(
    .clk(clk),
    .rst(rst),
    .AUD_BCLK(AUD_BCLK),
    .AUD_ADCLRCK(AUD_ADCLRCK),
    .AUD_ADCDAT(AUD_ADCDAT),
    .done(ADCDone),
    .data(currentADCData)
);

// Band-Pass DA Filter
wire [31:0] bpfFilterAudioOut;
BandPassFilterDA myBPF(
    .clk(clk),
    .rst(rst),
    .AUD_BCLK(AUD_BCLK),
    .AUD_DACLRCK(AUD_DACLRCK),
    .AUD_ADCLRCK(AUD_ADCLRCK),
    .audioIn(currentADCData),
    .audioOut(bpfFilterAudioOut)
);

// Filter selection logic based on debounced switches
always @ (*) begin
    case ({sw1Debounced, sw0Debounced})
        2'b00: currentDACData = 32'd0; // No output
        2'b01: currentDACData = currentADCData; // Pass-through audio
        2'b10: currentDACData = 32'd0; // No output
        2'b11: currentDACData = bpfFilterAudioOut; // Filtered audio
        default: currentDACData = 32'd0;
    endcase
end

endmodule
