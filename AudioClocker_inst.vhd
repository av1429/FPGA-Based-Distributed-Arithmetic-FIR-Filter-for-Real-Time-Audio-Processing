	component AudioClocker is
		port (
			audio_clk_clk      : out std_logic;        -- clk
			ref_clk_clk        : in  std_logic := 'X'; -- clk
			ref_reset_reset    : in  std_logic := 'X'; -- reset
			reset_source_reset : out std_logic         -- reset
		);
	end component AudioClocker;

	u0 : component AudioClocker
		port map (
			audio_clk_clk      => CONNECTED_TO_audio_clk_clk,      --    audio_clk.clk
			ref_clk_clk        => CONNECTED_TO_ref_clk_clk,        --      ref_clk.clk
			ref_reset_reset    => CONNECTED_TO_ref_reset_reset,    --    ref_reset.reset
			reset_source_reset => CONNECTED_TO_reset_source_reset  -- reset_source.reset
		);

