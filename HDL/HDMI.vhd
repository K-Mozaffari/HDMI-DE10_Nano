library ieee;
use ieee.std_logic_1164.all;
USE work.myhdmi.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity HDMI is 
	port (
      --///////// FPGA /////////
                    FPGA_CLK1_50 :in std_logic;
     -- ///////// HDMI /////////
                    HDMI_I2C_SCL:inout std_logic;
                    HDMI_I2C_SDA:inout std_logic;
                    HDMI_I2S    :inout std_logic;
                    HDMI_LRCLK  :inout std_logic;
                    HDMI_MCLK   :inout std_logic;
                    HDMI_SCLK   :inout std_logic;
                    HDMI_TX_INT :inout std_logic;
----------------------------------------------------------------------------------------
                    HDMI_TX_CLK :out std_logic;
                    HDMI_TX_D   :out std_logic_vector(23 downto 0);
                    HDMI_TX_DE  :out std_logic;
                    HDMI_TX_HS  :out std_logic;
                    HDMI_TX_VS  :out std_logic;
                    KEY         :in std_logic_vector(1 downto 0 );
---///////// LED /////////
                    LED :out std_logic_vector(7 downto 0 )

);
end entity;

architecture behavioral of HDMI is 

--//=======================================================
--//  signal  declarations
--//=======================================================
signal pixel_clk   :std_logic:='0';
signal Not_key0:std_logic:='0';
signal gen_clk_locked:std_logic:='1';
signal rgb:std_logic_vector(23 downto 0 ):=(others=>'0');
 
begin 

 

---//=======================================================
---//  Structural coding
--//=======================================================
 --LED(3 downto 0)  <= vpg_mode;
 LED(7)<=FPGA_CLK1_50;
 LED(6)<=pixel_clk;
 HDMI_TX_CLK<=pixel_clk;
--LED(1)<=FULL_fifo;
--LED(0)<=empty_fifo;
Not_key0<=not(KEY(0));

--//=============== PLL clock 25.175 MHZ
G_pll:pll port map (
                    refclk  =>FPGA_CLK1_50,           
	                rst     =>Not_key0,         --//rest key     
	                outclk_0=>pixel_clk, ---// clock 25.175 MHZ 
                    
	                locked  =>gen_clk_locked 
                    );

--
--//HDMI Configuration via  I2C
G_I2C_HDMI_Config: I2C_HDMI_Config port map (
	                 iCLK       =>FPGA_CLK1_50,
	                 iRST_N     =>KEY(0),
	                 I2C_SCLK   =>HDMI_I2C_SCL,
	                 I2C_SDAT   =>HDMI_I2C_SDA,
	                 HDMI_TX_INT=>HDMI_TX_INT
	                 );
--

--//=============== pattern generator according to vga timing===========================
G_vga_generator: VGA_Driver port map (                                    
	                            clk=>pixel_clk,  -- //clock 25 MHZ             
	                            reset_n=>gen_clk_locked,  
	                            vga_hs=>HDMI_TX_HS,
	                            vga_vs=>HDMI_TX_VS,           
	                            vga_de=>HDMI_TX_DE,
	                            vga_rgb=>HDMI_TX_D,
                                data_exist=>KEY(1),
                                rgb_in=>  rgb
                                );

testpatern:PROCESS(pixel_clk)
begin 
rgb<=rgb+16;
end process;


end ;
