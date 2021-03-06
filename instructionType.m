function res = instructionType(instruction,comp_array,dest_array,jump_array)
    global labels;
    global labelCnt;
   
    persistent variableValue;
    
    if isempty(variableValue)
         variableValue = 16;
    end
    
    if isempty(instruction)
        res = '';
        return;
    end
    
    if strfind(instruction,'//')>0
        comd = split(instruction,'//');
        intr = strtrim(comd(1));
        if strlength(intr) == 0
            res ='';
            return;
        else
            instruction = char(intr);
        end
    end 
    if strfind(instruction,'@')>0  
        temp = split(instruction,'@');
        if ~isnan(str2double(temp(2)))
            res = char(dec2bin(str2double(strtrim(temp(2))),16));
        elseif find(strcmp(labels(1,:),strtrim(temp(2)))) > 0
            label_index = find(strcmp(labels(1,:),strtrim(temp(2))),1);
            res = char(dec2bin(str2double(cell2mat(labels(2,label_index))),16));
            %res = cell2mat(labels(2,label_index));
        else
            labels(1,labelCnt) = strtrim(temp(2));
            labels(2,labelCnt) = cellstr(num2str(variableValue));
            res = char(dec2bin(variableValue,16));
            variableValue = variableValue + 1;
            labelCnt = labelCnt + 1;
        end         
    elseif strfind(instruction,'=')>0
        temp = split(instruction,'=');
        comp_index = strcmp(comp_array(1,:),strtrim(temp(2)));
        dest_index = strcmp(dest_array(1,:),strtrim(temp(1)));
        res = strcat('111',comp_array(2,comp_index),dest_array(2,dest_index),jump_array(2,1));
    elseif strfind(instruction,';')>0
        temp1=split(instruction,';');
        jump_index = strcmp(jump_array(1,:),strtrim(temp1(2)));
        comp1_index = strcmp(comp_array(1,:),strtrim(temp1(1)));
        res = strcat('111',comp_array(2,comp1_index),dest_array(2,1),jump_array(2,jump_index));
    elseif strfind(instruction,'(')>0
        res = "";
    end
end


