use work.dlx_types.all;
use work.bv_arithmetic.all;

entity alu is

   port(operand1, operand2: in dlx_word; 
        operation: in alu_operation_code;
        signed: in bit; 
   	  result: out dlx_word; 
        error: out error_code);
end entity alu;

architecture behaviour of alu is
begin 
   alu_behav: process(operand1, operand2, operation, signed) is
   -- local variable
      variable overFlow: boolean;
      variable zero: boolean;
      variable op1_logical: boolean := false;
      variable op2_logical: boolean := false;
      variable in_result: dlx_word := x"00000000"; 
   begin
   
      if signed = '1' then
         error <= "0000";
         case operation is
            when "0000" => --Signed Add
               bv_add(operand1, operand2, in_result, overFlow);
               if overFlow then
                  error <= "0001";
               end if;
               result <= in_result; 
          
            when "0001" =>  --Signed Sub
               bv_sub(operand1, operand2, in_result, overFlow);
               if overFlow then
                  error <= "0001";
               end if;
               result <= in_result; 
            
            when "1011" => -- Slt
               if operand1 < operand2 then
                  result <= x"00000001";
               else
                  result <= x"00000000";
               end if;
            
            
            when "1110" => --Mult
               bv_mult(operand1, operand2, in_result, overFlow);
            
               --If overflow flag is true, must determine whether there is overflow or underflow
               if overFlow then
               --If OP1 and OP2 are both positive but the result is negative
                  if (operand1(31) = '0') AND (operand2(31) = '0') then
                     error <= "0001";
                  
                    --If OP1 and OP2 are both negative but the result is positive
                  elsif (operand1(31) = '1') AND (operand2(31) = '1') then
                     error <= "0001";
                  
                  
                  elsif (operand1(31) = '0') AND (operand2(31) = '1') then
                     error <= "0001";
                  
                  elsif (operand1(31) = '1') AND (operand2(31) = '0') then
                     error <= "0001";
                  end if;
               end if;
               result <= in_result;
           
            when others =>
               result <= x"00000000";
         end case;
      else
         error <= "0000";
         case operation is
            when "0000" => --Unsigned Add
               bv_addu(operand1, operand2, in_result, overFlow);
               if overFlow then
                  error <= "0001";
               end if;
               result <= in_result;
          
            when "0001" =>  --Unsigned Sub
               bv_subu(operand1, operand2, in_result, overFlow);
               if overFlow then
                  error <= "0001";
               end if;
               result <= in_result;
               
            when "0010" =>  --Bitwise And
               for i in 31 downto 0 loop
                  in_result(i) := operand1(i) and operand2(i);
               end loop;
               result <= in_result;
            
            when "0011" =>  --Bitwise OR
               for i in 31 downto 0 loop
                  in_result(i) := operand1(i) or operand2(i);
               end loop;
               result <= in_result;
            
         
            
            when "1011" => -- Slt
               if operand1 < operand2 then
                  result <= x"00000001";
               else
                  result <= x"00000000";
               end if;
              
            
            when "1110" => --Mult
               bv_multu(operand1, operand2, in_result, overFlow);
            
                --If overflow flag is true, must determine whether there is overflow or underflow
               if overFlow then
                   --If OP1 and OP2 are both positive but the result is negative
                  if (operand1(31) = '0') AND (operand2(31) = '0') then
                     error <= "0001";
                  
                   --If OP1 and OP2 are both negative but the result is positive
                  elsif (operand1(31) = '1') AND (operand2(31) = '1') then
                     error <= "0001";
                  
                   --If one of the operands is positive and one of the operands is negative but the result is positive
                  elsif (operand1(31) = '0') AND (operand2(31) = '1') then
                     error <= "0001";
                  
                  elsif (operand1(31) = '1') AND (operand2(31) = '0') then
                     error <= "0001";
                  end if;
               end if;
               result <= in_result;
            
            when others =>
               result <= x"00000000";
         end case; 
      
      end if;
    
   end process;
  
end architecture;
          
         
         
            
            
                
             
                
           
            
           

      

