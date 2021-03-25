function [ flag_neg, path_OK, path_vio, path_DONT_CARE, x_temp, y_temp ] = fault_finder( ex_protect, state_bits)

fileID_fault = fopen('./temp/fault_matlab.txt');
global unreachable_state; 
tline = fgetl(fileID_fault);
flag_dont=0;
flag_neg=0;
[row_dont,col_dont]=size(unreachable_state);

while ischar(tline)
    expression = '\w*\w*';
    C = regexp(tline,expression,'match');
    
    for i=2:length(C)
        
            y_temp=C{i};
            x_temp=C{1};
            
            for qw=1:row_dont
                if strcmp (y_temp,unreachable_state(qw,:))
                    flag_dont=1;
                end
            end
            
            if flag_dont==1
                flag_dont=0;
                flag_neg=1;
                break
            end  
            
            
            for k=1
                flag_neg=0;
                path_OK=[];
                path_vio=[];
                path_DONT_CARE=[];
            for j=1:length(x_temp)
                
                if strcmp(x_temp(j),y_temp(j))
                    
                    if ~strcmp(x_temp(j),ex_protect(k,j))
                        
                        flag_neg=1;
                        
                        break
                        
                    else
                        
                        path_DONT_CARE=cat(2,path_DONT_CARE,state_bits-j);
                        
                    end
                    
                else
                    
                    if strcmp(x_temp(j),ex_protect(k,j))
                        path_OK=cat(2,path_OK,state_bits-j);
                    else
                    
                    path_vio=cat(2,path_vio,state_bits-j);
                    end
                end
            end
            
            end
            
    end
    tline = fgetl(fileID_fault);
end

fclose(fileID_fault);




