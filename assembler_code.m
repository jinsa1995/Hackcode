close all
clear all
%A-instruction look-up table
A_lookup={'R0' '0';'R1' '1';'R2' '2';
    'R3' '3'; 'R4' '4';'R5' '5';'R6' '6';
          'R7' '7'; 'R8' '8'; 'R9' '9'; 'R10' '10';
          'R11' '11'; 'R12' '12'; 'R13' '13'; 'R14' '14';
          'R15' '15';'SCREEN' '16384';'KBD' '24576';'SP' '0';
         'LCL' '1';'ARG' '2';'THIS' '3';'THAT' '4'};
A_lookup1=A_lookup';
          

%C-instruction look-up table
comp={'0' '0101010';'1' '0111111';'-1' '0111010';'D' '0001100';'A' '0110000';'!D' '0001101';'!A' '0110001';
       '-D' '0001111';'-A' '0110011';'D+1' '0011111';'A+1' '0110111';'D-1' '0001110';'A-1' '0110010';'D+A' '0000010';
       'D-A' '0010011';'A-D' '0000111';'D&A' '0000000';'D|A' '0010101';'M' '1110000';'!M' '1110001';'-M' '1110011';
       'M+1' '1110111';'M-1' '1110010';'D+M' '1000010';'D-M' '1010011';'M-D' '1000111';'D&M' '1000000';'D|M' '1010101'};

comp1=comp';
dest={' ' '000';'M' '001';'D' '010';'MD' '011';'A' '100';'AM' '101';'AD' '110';'AMD' '111'};
dest1=dest';
jump={' ' '000';'JGT' '001';'JEQ' '010';'JGE' '011';'JLT' '100';'JNE' '101';'JLE' '110';'JMP' '111'};
jump1=jump';

%main program
prompt = 'Input file name';
str = input(prompt,'s');
fid = fopen(str,'r');

global labels; 
labels = cell(2,10000);
tline = fgetl(fid);
cnt=1;
global labelCnt;
labelCnt = 24;

for i = 1:23
    labels(1,i) = A_lookup1(1,i);
    labels(2,i) = A_lookup1(2,i);
end

while ischar(tline)
    [label,value]= LabelFinder(tline);
    if value ~= 0
        labels(1,labelCnt) = label;
        labels(2,labelCnt) = cellstr(num2str(value));
        labelCnt = labelCnt + 1;
    end   
    cnt=cnt+1;
    tline = fgetl(fid);
end

frewind(fid);
tline = fgetl(fid);
code={};
cnt=1;

fwrid=fopen([str(1:end-4) '.hack'],'w');

while ischar(tline)
  disp(tline)
  code = char(instructionType(tline,comp1,dest1,jump1));
  disp(code)
  if strlength(code) > 0
    fprintf(fwrid,'%s\n',code);
  end
  cnt=cnt+1;
  tline = fgetl(fid);
end
fclose(fid);
fclose(fwrid);

