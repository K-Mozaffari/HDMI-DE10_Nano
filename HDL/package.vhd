library ieee;
use ieee.std_logic_1164.all;

package myhdmi is 
	component pll is
		port (
			refclk   : in  std_logic := 'X'; -- clk
			rst      : in  std_logic := 'X'; -- reset
			outclk_0 : out std_logic;
			locked   : out std_logic         -- export
		);
	end component pll;
 


component I2C_HDMI_Config is 
port (	--//	Host Side
			iCLK          :in  std_logic:='0';
                        iRST_N        :in  std_logic:='0';
	--				//	I2C Side
			I2C_SCLK      :out std_logic:='0';
			I2C_SDAT      :inout  std_logic:='0';
			HDMI_TX_INT   :in  std_logic:='0';
			READY         :out std_logic:='0'
					 );
end component I2C_HDMI_Config;
 component VGA_Driver is 
                    port (	                        
                            clk         : in    std_logic;           
	                        reset_n     : in    std_logic;  
	                        vga_hs      : out   std_logic;
	                        vga_vs      : out   std_logic;           
	                        vga_de      : out   std_logic;
	                        vga_rgb     : out   std_logic_vector(23 downto 0);
                            data_exist  : in    std_logic;
                            rgb_in      : in    std_logic_vector(23 downto 0 )
                        );

end component ;




end package;
