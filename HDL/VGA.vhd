library ieee;
use ieee.std_logic_1164.all;


entity VGA_Driver is 
                    port (	                        
                            clk         : in    std_logic;           
	                        reset_n     : in    std_logic;  
	                        vga_hs      : out   std_logic:='1';
	                        vga_vs      : out   std_logic:='0';           
	                        vga_de      : out   std_logic:='0';
	                        vga_rgb     : out   std_logic_vector(23 downto 0);
                            data_exist  : in    std_logic;
                            rgb_in      : in    std_logic_vector(23 downto 0 )
                        );

end entity ;



architecture behavioral of VGA_Driver is 
signal h_count : integer range 0 to 799;
signal v_count : integer range 0 to 524;
signal pixel_x:integer:=0;
signal h_act_d,h_act:std_logic:='0';
signal v_act_d,v_act:std_logic:='0';
signal color_mode:std_logic_vector(3 downto 0 ):=(others=>'0');
signal pre_vga_de :std_logic:='0';
signal boarder:std_logic:='0';
begin 
---################ Horizental synchrnization  #####################

P_Horizental_Sync: Process(clk,reset_n)
                        begin 
                            if (rising_edge(clk) ) then 
                                if (reset_n='0')then
                                    h_act_d <='0';
                                    h_count <=0;
                                    pixel_x <=0;
                                    vga_hs  <='1';
                                    h_act   <='0';
                                elsif data_exist='1' then
                                    h_act_d<=h_act;                                 ---1
                                    ---------------------------------------------------2
                                    if (h_count=799) then   
                                       h_count<=0; 
                                    else
                                       h_count<=h_count+1;
                                    end if;
                                    ---------------------------------------------------3
                                    if (h_act_d='1')then    
                                        pixel_x<=pixel_x+3;
                                    else
                                        pixel_x<=0;
                                    end if;
                                    ---------------------------------------------------4
                                    if ((h_count>=95) and (h_count/=799)) then
                                        vga_hs<='1';   
                                    else
                                        vga_hs<='0'; 
                                    end if;
                                    ---------------------------------------------------5
                                    if (h_count= 141 )then                          
                                        h_act<='1';
                                    elsif (h_count=781) then 
                                        h_act<='0';
                                    end if;

                                end if; 

                            end if;


                        end process P_Horizental_Sync;




---################ Vertical   synchrnization  #####################

P_Vertical_Sync: Process(clk,reset_n)
                        begin 
                            if (rising_edge(clk) ) then 
                                if (reset_n='0')then
                                    v_act_d <='0';
                                    v_count <=0;
                                    vga_vs  <='1';
                                    v_act   <='0';
                                    color_mode<=(others=>'0');
                                elsif  data_exist='1' then    
                                    if (h_count=799) then
                                        v_act_d<=v_act;                          ---1
                                        --------------------------------------------2
                                        if (v_count=524)then
                                            v_count<=0;
                                        else
                                            v_count<=v_count+1;
                                        end if;
                                        --------------------------------------------3
                                        if  ((v_count >=1) and (v_count/=524)) then
                                            vga_vs<='1';
                                        else 
                                            vga_vs<='0';
                                        end if;
                                        --------------------------------------------4
                                        if (v_count=34) then 
                                            v_act<='1';
                                        elsif (v_count=514) then 
                                            v_act<='0';
                                        end if;
                                        --------------------------------------------5
                                        if (v_count=34) then 
                                            color_mode(0)<='1';
                                        elsif (v_count=154) then 
                                            color_mode(0)<='0';
                                        end if;
                                        --------------------------------------------6
                                        if (v_count=154) then 
                                        color_mode(1)<='1';
                                        elsif (v_count=274) then 
                                            color_mode(1)<='0';
                                        end if; 
                                        --------------------------------------------7
                                        if (v_count=274) then 
                                            color_mode(2)<='1';
                                        elsif (v_count=394) then 
                                            color_mode(2)<='0';
                                        end if;
                                        --------------------------------------------8
                                        if (v_count=394) then 
                                            color_mode(3)<='1';
                                        elsif (v_count=514) then 
                                            color_mode(3)<='0';
                                        end if;

                                    end if;

                                end if;

                            end if;
                        end process P_Vertical_Sync;

---################ Reciving and Sending data  #####################

P_Display_Enable: Process(clk,reset_n)
                        begin 
                            if (rising_edge(clk) ) then 
                               if (reset_n='0')then
                                    vga_de      <='0';
                                    pre_vga_de  <='0';
                                    boarder     <='0';
                                elsif data_exist='1' then 
                                    vga_de      <=pre_vga_de;       ---1
                                    pre_vga_de  <=(v_act and h_act);---2
                                    -----------------------------------3
                                    if ( (h_act_d='0' and h_act='1') or h_count=781 or (v_act_d='0' and v_act='1')or v_count=514) then 
                                        boarder<='1';
                                    else 
                                        boarder<='0';
                                    end if; 
                                    -----------------------------------4
                                    if (boarder='1') then 
                                        vga_rgb<=(others=>'0');
                                    else 
                                        vga_rgb<=RGB_in;
                                    end if;
                                end if;     
                            end if;
                        end process P_Display_Enable;

end; 
