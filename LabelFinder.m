function [labelName,labelValue] = LabelFinder(instruction)
    persistent lineNumber;
    if isempty(lineNumber)
        lineNumber = 0;
    end

    labelName = '0';
    labelValue = 0;

    if isempty(instruction)
       return;
    elseif strfind(instruction,'//') > 0
        comd = split(instruction,'//');
        if strlength(strtrim(comd(1)))> 0
            lineNumber = lineNumber + 1;
        end
    elseif strfind(instruction,'(')>0
        labelName = extractBetween(instruction,'(',')');
        labelValue = lineNumber;
    else
        lineNumber = lineNumber + 1;
    end
end

