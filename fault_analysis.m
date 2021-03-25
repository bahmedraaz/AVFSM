
clear all;
close all;
clc;


fid_main = fopen('module_main_file.txt');

tline = fgetl(fid_main);

while ischar(tline)

    
    matches_protected_state = strfind(tline, 'protected_state');
    if length(matches_protected_state)
        tline = fgetl(fid_main);
        protect_state=tline;
    end

    
    tline = fgetl(fid_main);
end



fileID_fault = fopen('./temp/fault_matlab.txt','w');

fileID_fsm = fopen('./Required_files/report_fsm.txt');  
    
 fileID_time = fopen('./Required_files/static_time.rpt');

tline = fgetl(fileID_time);

index_i=1;
while ischar(tline)
    
    matches_slack = strfind(tline, 'slack');
    num_slack = length(matches_slack);
    
    if num_slack > 0
        expression = '\d.*\d';
        C1 = regexp(tline,expression,'match');
        X = str2double(C1);
        Path_delay(index_i)=X;
        index_i=index_i+1;
        
    end
    
    tline = fgetl(fileID_time);
end
    
encode_found=0;

encode_num=1;

tline = fgetl(fileID_fsm);

Path_delay=5.2-Path_delay   %Calculating data arrival time. NEEDs MAUAL EDITING HERE
avg_path_delay=mean(Path_delay);
var_path=.05*mean(Path_delay);
count_fault=0;
count_fault2=0;
Total_transition=0;


while ischar(tline)

    if length(strfind(tline, 'Vector'))>0 
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      FSM_REG_name=C{3};
    end
    
    if length(strfind(tline, 'Encodings'))>0 
        encode_found=1;
    end
        
      if encode_found==1   
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      
      for i=2:length(C)
          
          encode_str=(regexp(C(i),'\d*','match'));
          encode_str_num=str2double(encode_str{1});
          
          if length(encode_str_num)>0
              encodings_x(encode_num,:)=C{i};
              encodings_name(encode_num,:)=C(i-1);
              encode_num=encode_num+1;
          end
      end
      end
    
    
    tline = fgetl(fileID_fsm);
end

encodings_x;
[No_pattern,state_bits]=size(encodings_x);

num_state_x=0;


fclose(fileID_fsm);
protect_extra=cat(1, protect_state);
next_state_comp=[];
present_state_comp=[];

fileID_STG = fopen('./Reports/STG.txt','w');

for ijk=1:No_pattern
file_name=sprintf('./IFT/pattern%d.rpt',ijk);
fid = fopen(file_name);

tline = fgetl(fid);
num_patt_x=1;
found_equal=0;

while ischar(tline)
    
   matches_patt = strfind(tline, 'force');
   num_patt = length(matches_patt);
   
   matches_patt_no = strfind(tline, 'measure');
   num_patt_no = length(matches_patt_no);
   
   expression = '\w*\w*';
   Cxx = regexp(tline,expression,'match');
      
   if num_patt > 0 && ~strcmp(tline(length(tline)),'=')
       expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      
      for i=1:length(C)
          
          if length(strfind(C{i}, 'force'))>0
              patt_str2='';
          for j=i+1:length(C)
              patt_str2=strcat(patt_str2, C{j});
          end
          patt_final(num_patt_x,:)=patt_str2;
          num_patt_x=num_patt_x+1;
          end
      end
      
   elseif strcmp(tline(length(tline)),'=') && ~(num_patt_no > 0)
       found_equal=1;
   
   
   elseif found_equal==1
       
      expression = '\w*\w*';
      C = regexp(tline,expression,'match');
      patt_str2='';
      found_equal=0;
           for j=1:length(C)
              patt_str2=strcat(patt_str2, C{j});
           end
          %patt_str2
       patt_final(num_patt_x,:)=patt_str2;
       num_patt_x=num_patt_x+1;
   end
   
   
   
%       if length(Pattern_str_num) > 0
%        expression = '\w*\w*';
%       C = regexp(tline,expression,'match')
% 
%       end
   
   tline = fgetl(fid);
end
next_state_x=patt_final(1,state_bits+1:2*state_bits)


fwrite(fileID_STG, sprintf(' \n '));
fwrite(fileID_STG, sprintf(' \n '));
format_STG='next_state = %s';
format_STG_str=sprintf(format_STG, next_state_x);
fwrite(fileID_STG, format_STG_str);
fwrite(fileID_STG, sprintf(' \n '));
fwrite(fileID_STG, 'Present_state = ');
fwrite(fileID_STG, sprintf(' \n '));
present_state_x=patt_final(:, 1:state_bits);


present_state_uni = unique(present_state_x, 'rows')

[row2, col2]=size(present_state_uni);

for ix=1:row2
    num_state_x=num_state_x+1;
    state_mat(num_state_x,:)=cat(2,next_state_x, present_state_uni(ix,:));
    fwrite(fileID_STG, present_state_uni(ix,:));
    fwrite(fileID_STG, sprintf(' \n '));
end

fwrite(fileID_STG, sprintf(' \n '));




Transition=setdiff(encodings_x,present_state_uni,'rows');
[row_tran, col_tran]=size(Transition);
Total_transition=Total_transition+row_tran;

protect_extra_num=1;

if strcmp (next_state_x,protect_state) 
    protect_extra = setdiff(present_state_uni,encodings_x,'rows');
     protect_extra=cat(1, protect_state, protect_extra)
else   
    
next_state_comp=vertcat(next_state_x, next_state_comp);   
present_state_comp=vertcat(present_state_uni, present_state_comp);  
    
format_t1=sprintf('%s ', next_state_x);
fwrite(fileID_fault, format_t1);

for m=1:row2
    format_t2=sprintf('%s ', present_state_uni(m,:));
    fwrite(fileID_fault, format_t2);
end
fwrite(fileID_fault, sprintf(' \n '));
end

end

global unreachable_state; 
unreachable_state =setdiff(present_state_comp,next_state_comp,'rows');


fclose(fid);
fclose(fileID_fault);

fileID_listf = fopen('./Reports/Fault_Details.txt','w');

fileID_fault = fopen('./temp/fault_matlab.txt');

tline = fgetl(fileID_fault);
[row_ex,col_ex]=size(protect_extra);
[row_dont,col_dont]=size(unreachable_state);

while ischar(tline)
      
    expression = '\w*\w*';
    C = regexp(tline,expression,'match');
    
    for i=2:length(C)
        if ~strcmp (C{i},protect_state)
            y_temp=C{i};
            x_temp=C{1};
            
            for k=1:row_ex
                flag_neg=0;
                path_OK=[];
                path_vio=[];
                path_DONT_CARE=[];
            for j=1:length(x_temp)
                
                if strcmp(x_temp(j),y_temp(j))
                    
                    if ~strcmp(x_temp(j),protect_extra(k,j))
                        
                        flag_neg=1;
                        
                        break
                        
                    else
                        
                        path_DONT_CARE=cat(2,path_DONT_CARE,state_bits-j);
                        
                    end
                    
                else
                    
                    if strcmp(x_temp(j),protect_extra(k,j))
                        path_OK=cat(2,path_OK,state_bits-j);
                    else
                    
                    path_vio=cat(2,path_vio,state_bits-j);
                    end
                end
            end
            
            
            
            if flag_neg==0 && ~strcmp(y_temp, protect_extra(k,:))
                
            flag_dont_found=0;    
            flag_dontcare=0;
            for qw=1:row_dont
                if strcmp (y_temp,unreachable_state(qw,:))
                    flag_dont_found=1;
                    [ flag_dontcare, path_OK_x, path_vio_x, path_DONT_CARE_x, x_temp2, y_temp2 ] = fault_finder( y_temp, state_bits);
                end
            end
            
            
                
              if flag_dont_found==0  
                  
              Path_delay_vio=min(Path_delay(path_vio+1))+var_path;
             Path_delay_OK=min(Path_delay(path_OK+1))-var_path;
             Path_delay_final=Path_delay_vio-Path_delay_OK;
             
                
              susceptiblity_factor(count_fault+1)=Path_delay_final/avg_path_delay;
              count_fault=count_fault+1;
              
              if Path_delay_final>0
              susceptiblity_factor2(count_fault+1)=Path_delay_final/avg_path_delay;
              count_fault2=count_fault2+1; 
              end
                
              format_fault1='Transition %s ---> %s; Inject Fault to go %s; \n';
              format_fault1_str=sprintf(format_fault1,y_temp,x_temp, protect_extra(k,:)) ;
              fwrite(fileID_listf, format_fault1_str);
              
              format_fault2='Successful Fault Injection Condition:';
              fwrite(fileID_listf, format_fault2);
              fwrite(fileID_listf, sprintf(' \n '));
              
              
              format_fault3='Time constraint Violated: Path %s; \n';
              format_fault3_str=sprintf(format_fault3,num2str(path_vio)) ;
              fwrite(fileID_listf, format_fault3_str);
              
              format_fault4='Time constraint OK: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_OK)) ;
              fwrite(fileID_listf, format_fault4_str);
              
              format_fault4='Time constraint Dont Care: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_DONT_CARE)) ;
              fwrite(fileID_listf, format_fault4_str);
              
              
              format_fault5=sprintf('Path Difference:  %d; \n', Path_delay_final);
              fwrite(fileID_listf, format_fault5);
              
              format_fault6=sprintf('susceptiblity_factor:  %d; \n', susceptiblity_factor(count_fault));
              fwrite(fileID_listf, format_fault6);
              fwrite(fileID_listf, sprintf(' \n '));
              
              end
              
              if flag_dontcare==0 && flag_dont_found==1  
                  
                  format_fault1='Transition %s ---> %s; Inject Fault to go %s; \n';
              format_fault1_str=sprintf(format_fault1,y_temp,x_temp, protect_extra(k,:)) ;
              fwrite(fileID_listf, format_fault1_str);
              
              format_fault2='Successful Fault Injection Condition:';
              fwrite(fileID_listf, format_fault2);
              fwrite(fileID_listf, sprintf(' \n '));
              
              
              format_fault3='Time constraint Violated: Path %s; \n';
              format_fault3_str=sprintf(format_fault3,num2str(path_vio)) ;
              fwrite(fileID_listf, format_fault3_str);
              
              format_fault4='Time constraint OK: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_OK)) ;
              fwrite(fileID_listf, format_fault4_str);
              
              format_fault4='Time constraint Dont Care: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_DONT_CARE)) ;
              fwrite(fileID_listf, format_fault4_str);
              fwrite(fileID_listf, sprintf(' \n '));
              
                  
              format_fault1='Transition %s ---> %s; Inject Fault to go %s; \n';
              format_fault1_str=sprintf(format_fault1,y_temp2,x_temp2, y_temp) ;
              fwrite(fileID_listf, format_fault1_str);
              
              format_fault2='Successful Additional Fault Injection Condition:'
              fwrite(fileID_listf, format_fault2);
              fwrite(fileID_listf, sprintf(' \n '));
              
              
              format_fault3='Time constraint Violated: Path %s; \n';
              format_fault3_str=sprintf(format_fault3,num2str(path_vio_x)) ;
              fwrite(fileID_listf, format_fault3_str);
              
              format_fault4='Time constraint OK: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_OK_x)) ;
              fwrite(fileID_listf, format_fault4_str);
              
              format_fault4='Time constraint Dont Care: Path %s; \n';
              format_fault4_str=sprintf(format_fault4,num2str(path_DONT_CARE_x)) ;
              fwrite(fileID_listf, format_fault4_str);
              fwrite(fileID_listf, sprintf(' \n '));
              
              format_fault5=sprintf('Path Difference:  %d; \n', Path_delay_final);
              fwrite(fileID_listf, format_fault5);
              
              format_fault6=sprintf('susceptiblity_factor:  %d; \n', susceptiblity_factor(count_fault));
              fwrite(fileID_listf, format_fault6);
              fwrite(fileID_listf, sprintf(' \n '));
              
              end
            end
            end
                
                
        end
    end
    
    tline = fgetl(fileID_fault);
    
end
    
Overall_susceptiblity_factor=sum(susceptiblity_factor2)/count_fault2
vulnerable_transitions=count_fault2
Total_transition_number=Total_transition
fclose(fileID_fault);
    
fclose(fileID_listf);



[row_ori, col_ori]=size(state_mat);

baseName = './Reports/functionCalls';
dotFile = [baseName '.dot'];
fid = fopen(dotFile, 'w');
fprintf(fid, 'digraph G {\n');

for i=1:row_ori
    
    parent(i,:)=mat2str(state_mat(i,state_bits+1:2*state_bits));
    child(i,:)=mat2str(state_mat(i,1:state_bits));
    fprintf(fid, '   "%s" -> "%s"\n', parent(i,:), child(i,:));
    
end


fprintf(fid, '}\n');
fclose(fid);


% Render to image
%imageFile = [baseName '.png'];
% Assumes the GraphViz bin dir is on the path; if not, use full path to dot.exe
%addpath('C:/release/bin')
%cmd = sprintf('C:/release/bin/dot -Tpng -Gsize="100,100" "%s" -o"%s"', dotFile, imageFile);
%system(cmd);
%fprintf('Wrote to %s\n', imageFile);

exit


