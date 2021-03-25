%Written by Adib Nahiayn 

clear all;
close all;
clc;


fid_main = fopen('module_main_file.txt');

tline = fgetl(fid_main);

while ischar(tline)
    matches_Module_name = strfind(tline, 'Module_name');
    if length(matches_Module_name)
        tline = fgetl(fid_main);
        Module_name=tline;
    end

    matches_Module_name = strfind(tline, 'Library_directory');
    if length(matches_Module_name)
        tline = fgetl(fid_main);
        Library_directory=tline;
    end
    
    matches_Module_name = strfind(tline, 'File_directory');
    if length(matches_Module_name)
        tline = fgetl(fid_main);
        File_directory=tline;
    end
    
    
    tline = fgetl(fid_main);
end
        

fileID_fsm = fopen('./Required_files/report_fsm.txt')

format_module_name='./Required_files/%s.txt';
format_module_name_2='./temp/%s_2.txt';
format_module_name_3='./IFT/%s_3.v';
format_format_module_name_str=sprintf(format_module_name, Module_name);
format_format_module_name_str_2=sprintf(format_module_name_2, Module_name);
format_format_module_name_str_3=sprintf(format_module_name_3, Module_name);



fid = fopen(format_format_module_name_str);
fileID = fopen(format_format_module_name_str_2,'w');

fileID_or = fopen('./temp/matlab_or.txt','w');
fileID_assign = fopen('./temp/matlab_assign.txt','w');

new_line_FSM=0;
new_line_DFF=0;

DFF_str_num=-1;    
num_input_XOR=1;
num_input_x=1;
num_input_inv=1;
num_state_next=1;
Gate_ID=10000;
Net_ID=10000;
state_next_num=0;
extra_FF_num=0;

encode_found=0;

encode_num=1;


tline = fgetl(fileID_fsm);

while ischar(tline)

    if length(strfind(tline, 'Vector'))>0 
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      FSM_REG_name=C{3}
    end
    
    tline = fgetl(fileID_fsm);
end

fclose(fileID_fsm);  

tline = fgetl(fid);

while ischar(tline)

    
   matches_DFF = strfind(tline, 'DFFSR');
   num_DFF = length(matches_DFF);
   
   matches_FSM = strfind(tline, FSM_REG_name);
   num_FSM = length(matches_FSM);
   
   
   if num_FSM > 0 || new_line_FSM==1

      if new_line_FSM==1
      expression = '\w*\w*';
      C1 = regexp(tline,expression,'match')
      C=cat(2,C,C1)
      new_line_FSM=0;
      else
      expression = '\w*\w*';
      C = regexp(tline,expression,'match')
      
      Nextline_FSM=regexp(tline,'\x3B','match')
      
      if length(Nextline_FSM)==0
          new_line_FSM=1
          
      end
      
      end
  
      
      
      if new_line_FSM==0
      
         
         
     state_next_num=state_next_num+1
      
     FF_str=(regexp(C(2),'\d*','match'));
     
     FF_str_num=str2double(FF_str{1})
     
      
      for i=1:length(C)

          if strcmp(C(i),'D')
              D_str=(regexp(C(i+2),'\d*','match'))
              D_str_num=str2double(D_str{1})
               isempty(D_str)
              if length(D_str_num)>0
              format_XOR='XOR2X1 U%d ( .A(%s[%d]), .B(state_next[%d]), .Y(n%d) );';
              XOR_str=sprintf(format_XOR,Gate_ID,C{i+1},D_str_num, FF_str_num, Net_ID)    
              Gate_ID=Gate_ID+1;
              Net_ID=Net_ID+1;
              
              else
              format_XOR='XOR2X1 U%d ( .A(%s), .B(state_next[%d]), .Y(n%d) );';
              XOR_str=sprintf(format_XOR,Gate_ID,C{i+1}, FF_str_num, Net_ID)    
              Gate_ID=Gate_ID+1;
              Net_ID=Net_ID+1;
              end    

              fwrite(fileID, XOR_str);
             fwrite(fileID, sprintf(' \n '));
          end

          if strcmp(C(i),'Q')
              
              
              if i<length(C)-1
              Q_str=(regexp(C(i+2),'\d*','match'))
              Q_str_num=str2double(Q_str{1})
               
              if length(Q_str_num)>0
              format_input='assign %s[%d] = state_present[%d];';    
              Input_aasign_str=sprintf(format_input, C{i+1}, Q_str_num, FF_str_num)    
              
              else
              format_input='assign %s = state_present[%d];';
              Input_aasign_str=sprintf(format_input, C{i+1}, FF_str_num) 
              end   
              
              else
              format_input='assign %s = state_present[%d];';
              Input_aasign_str=sprintf(format_input, C{i+1}, FF_str_num) 
              end 
              
              fwrite(fileID_assign, Input_aasign_str);
             fwrite(fileID_assign, sprintf(' \n '));

          end
                  
          if strcmp(C(i),'QN')
               
              if i<length(C)-1
              format_INV='INVX1 U%d ( .A(state_present[%d]),  .Y(%s[%s]) );';
              INV_str_Q=sprintf(format_INV,Gate_ID,FF_str_num, C{i+1}, C{i+2})    
              Gate_ID=Gate_ID+1;
              
              else
              format_INV='INVX1 U%d ( .A(state_present[%d]),  .Y(%s) );';
              INV_str_Q=sprintf(format_INV,Gate_ID,FF_str_num, C{i+1})    
              Gate_ID=Gate_ID+1;
              end
              
              fwrite(fileID, INV_str_Q);
             fwrite(fileID, sprintf(' \n '));
              
              
          end
          

          
      end
      
      end
      
   
   
  
   
   
   
   elseif (num_DFF > 0 && num_FSM==0) || new_line_DFF==1
       
       
      if new_line_DFF==1
      expression = '\w*\w*';
      C1 = regexp(tline,expression,'match')
      C=cat(2,C,C1)
      new_line_DFF=0;
      else
      expression = '\w*\w*';
      C = regexp(tline,expression,'match')
      
      Nextline_DFF=regexp(tline,'\x3B','match')
      
      if length(Nextline_DFF)==0
          new_line_DFF=1
          
      end
      
      end
  
      
      
      if new_line_DFF==0
      

     DFF_str_num=DFF_str_num+1;
     extra_FF_num=extra_FF_num+1;
      
      for i=1:length(C)
     
          if strcmp(C(i),'Q')
              
              if i<length(C)-1
              Q_str=(regexp(C(i+2),'\d*','match'))
              Q_str_num=str2double(Q_str{1})
               
              if length(Q_str_num)>0
              format_input='assign %s[%d] = extra_FF[%d];';    
              Input_aasign_str=sprintf(format_input, C{i+1}, Q_str_num, DFF_str_num)    
              
              else
              format_input='assign %s = extra_FF[%d];';
              Input_aasign_str=sprintf(format_input, C{i+1}, DFF_str_num) 
              end   
              
              else
              format_input='assign %s = extra_FF[%d];';
              Input_aasign_str=sprintf(format_input, C{i+1}, DFF_str_num) 
              end 
              
              fwrite(fileID_assign, Input_aasign_str);
             fwrite(fileID_assign, sprintf(' \n '));

          end
                  
          if strcmp(C(i),'QN')
               
              if i<length(C)-1
                  
              format_INV='INVX1 U%d ( .A(extra_FF[%d]),  .Y(%s[%s]) );';
              INV_str_Q=sprintf(format_INV,Gate_ID,DFF_str_num, C{i+1}, C{i+2})    
              Gate_ID=Gate_ID+1;
              
              else
              format_INV='INVX1 U%d ( .A(extra_FF[%d]),  .Y(%s) );';
              INV_str_Q=sprintf(format_INV,Gate_ID,DFF_str_num, C{i+1})    
              Gate_ID=Gate_ID+1;
              end
              
              fwrite(fileID, INV_str_Q);
             fwrite(fileID, sprintf(' \n '));
           end
%           
       end
      
      end
    
      else   
     
     fwrite(fileID, tline);
fwrite(fileID, sprintf(' \n '));
end
              


   tline = fgetl(fid);
end

num_OR=10000:Net_ID-1

for ijk=1:1000
    i=1;
    if length(num_OR)==1
        break
    end
    format_OR='OR2X1 U%d ( .A(n%d), .B(n%d), .Y(n%d) );';
    last_termz=(num_OR(length(num_OR))+1);
    OR_str=sprintf(format_OR,Gate_ID,num_OR(i),num_OR(i+1), last_termz)  
    num_OR(num_OR==num_OR(i))=[];
    num_OR(num_OR==num_OR(i))=[];
    num_OR=cat(2,num_OR,last_termz);
    Gate_ID=Gate_ID+1;
    fwrite(fileID_or, OR_str);
    fwrite(fileID_or, sprintf(' \n '));

end
fclose(fid);
fclose(fileID);
fclose(fileID_assign);
fclose(fileID_or);


flag_module=0;
flag_gate=1;
fileID = fopen(format_format_module_name_str_2);
fileID_new = fopen(format_format_module_name_str_3,'w');
tline = fgetl(fileID);

while ischar(tline)
    
   matches_module = strfind(tline, 'module');
   num_module = length(matches_module);
   
   module_finish=strfind(tline, ';');
   num_module_finish=length(module_finish);
 
   
    if length(strfind(tline, 'endmodule'))>0
       fwrite(fileID_new, tline);
       %fwrite(fileID_new, sprintf(' \n '));
   
    elseif num_module>0
       flag_module=1;
       expression = '\w*\w*';
       C222 = regexp(tline,expression,'match');
       module_name_str=C222{2}
       for i=1:length(tline)
            
           if strcmp(tline(i), '(')
               if DFF_str_num~=-1
            format_module='state_present, state_next, extra_FF, n%d,';
               else
            format_module='state_present, state_next, n%d,';       
               end
            format_module=sprintf(format_module, num_OR)   
            tline=strcat(tline(1:i), format_module, tline(i+1:length(tline)))
            fwrite(fileID_new, tline);
            fwrite(fileID_new, sprintf(' \n '));
            break
           end
       end
       
       
   elseif (flag_module==1) && num_module_finish>0
       fwrite(fileID_new, tline);
       fwrite(fileID_new, sprintf(' \n '));
       fwrite(fileID_new, sprintf(' \n '));
       tl_1='input [%d:0] state_present; \n';
       tl_1_str=sprintf(tl_1, state_next_num-1);
       fwrite(fileID_new, tl_1_str);
       tl_2='input [%d:0] state_next; \n';
       tl_2_str=sprintf(tl_2, state_next_num-1);
       fwrite(fileID_new, tl_2_str);
       if DFF_str_num~=-1
       tl_3='input [%d:0] extra_FF; \n';
       tl_3_str=sprintf(tl_3, extra_FF_num-1);
       fwrite(fileID_new, tl_3_str);
       end
       tl_4='output n%d; \n';
       tl_4_str=sprintf(tl_4, num_OR);
       fwrite(fileID_new, tl_4_str);
       fwrite(fileID_new, sprintf(' \n '));
       
       
       tl_5='wire   n10000';
       
       for k=10001:num_OR
           tl_5_str=sprintf(', n%d', k);
           tl_5=strcat(tl_5,tl_5_str);
       end
       
       tl_5=strcat(tl_5, ';');
       
       fwrite(fileID_new, tl_5);
       fwrite(fileID_new, sprintf(' \n '));
       
       flag_module=0;
       
       
    elseif length(strfind(tline, 'X'))>0 && flag_gate==1
        
        fileID_assign = fopen('./temp/matlab_assign.txt');
        tline_assign = fgetl(fileID_assign)
        
        while ischar(tline_assign)
            fwrite(fileID_new, tline_assign);
            fwrite(fileID_new, sprintf(' \n '));
            tline_assign = fgetl(fileID_assign)
        end
        
        fileID_or = fopen('./temp/matlab_or.txt');
        tline_or = fgetl(fileID_or)
        
        while ischar(tline_or)
            fwrite(fileID_new, tline_or);
            fwrite(fileID_new, sprintf(' \n '));
            tline_or = fgetl( fileID_or)
        end
        
        fwrite(fileID_new, tline);
        fwrite(fileID_new, sprintf(' \n '));
        flag_gate=0;

   
   else 
       
    fwrite(fileID_new, tline);
    fwrite(fileID_new, sprintf(' \n '));
       
   end
       
    tline = fgetl(fileID);
    
end
    
    
fclose(fileID_new);
fclose(fileID);

fileID_fsm = fopen('./Required_files/report_fsm.txt');  
    
encode_found=0;

encode_num=1;


fileID_tmax = fopen('./IFT/tmax_script.tcl','w');

tline = fgetl(fileID_fsm);

while ischar(tline)

    if length(strfind(tline, 'Vector'))>0 
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      FSM_REG_name=C{3}
    end
    
    if length(strfind(tline, 'Encodings'))>0 
        encode_found=1;
    end
        
      if encode_found==1   
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      
      for i=2:length(C)
          
          encode_str=(regexp(C(i),'\d*','match'));
          encode_str_num=str2double(encode_str{1})
          
          if length(encode_str_num)>0
              encodings_x(encode_num,:)=C{i}
              encode_num=encode_num+1;
          end
      end
      end
    
    
    tline = fgetl(fileID_fsm);
end



[row, col]=size(encodings_x)

format_tmax_library= 'read_netlist %s -library';
format_tmax_library_str=sprintf(format_tmax_library, Library_directory);
fwrite(fileID_tmax, format_tmax_library_str);
fwrite(fileID_tmax, sprintf(' \n '));
format_tmax_module='read_netlist %s/IFT/%s_3.v';
format_tmax_module_str=sprintf(format_tmax_module, File_directory, Module_name);
fwrite(fileID_tmax, format_tmax_module_str);
fwrite(fileID_tmax, sprintf(' \n '));
format_tmax_build='run_build_model %s';
format_tmax_build_str=sprintf(format_tmax_build, Module_name);
fwrite(fileID_tmax, format_tmax_build_str);
fwrite(fileID_tmax, sprintf(' \n '));

for i=1:row
    format_t1='drc -force';
    fwrite(fileID_tmax, format_t1);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t2='run_build_model %s';
    format_t2_str=sprintf(format_t2, module_name_str);
    fwrite(fileID_tmax, format_t2_str);
    fwrite(fileID_tmax, sprintf(' \n '));
    for j=1:col
        format_pi_cons='add_pi_constraints %s {state_next[%d]} ';
        format_pi_cons_str=sprintf(format_pi_cons, encodings_x(i,j),col-j)
        fwrite(fileID_tmax, format_pi_cons_str);
        fwrite(fileID_tmax, sprintf(' \n '));
    end
    format_t3='run_drc';
    fwrite(fileID_tmax, format_t3);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t33='remove_faults -all';
    fwrite(fileID_tmax, format_t33);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t4='add_faults  %s/n%d -stuck 1';
    format_t4_str=sprintf(format_t4, module_name_str, num_OR);
    fwrite(fileID_tmax, format_t4_str);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t5='set_atpg -decision random';
    fwrite(fileID_tmax, format_t5);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t55='run_atpg -ndetects 100';
    fwrite(fileID_tmax, format_t55);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t555='report_patterns -all';
    fwrite(fileID_tmax, format_t555);
    fwrite(fileID_tmax, sprintf(' \n '));
    format_t66=sprintf('report_patterns -all > pattern%d.rpt', i);
    fwrite(fileID_tmax, format_t66);
    fwrite(fileID_tmax, sprintf(' \n '));
end    
    
fwrite(fileID_tmax, 'exit'); 

fclose(fileID_fsm);
fclose(fileID_tmax);
    
exit
    
    
    
    
    
    
    
    
    
