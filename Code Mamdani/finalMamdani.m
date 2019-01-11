data = csvread("C:\Users\geek\Downloads\nnfs_cw\skin_noskin_csv");
input = data(:,1:3);
input = fliplr(input);
output = data(:,4);

%RGB to YCBCR using the equation defined in the research paper
MatrixB = [65.738 129.057 25.064; -37.945 -74.494 112.439; 112.439 -94.154 -18.285];  
MatrixA = [16; 128 ;128];
YCBCRinput = (MatrixA + (1/256)*(MatrixB * input'));
YCBCRinput = YCBCRinput';

%reading the created fuzzy inference system and evaluating it on data
fisPrePared=readfis('SkinOrNoSkin.fis');
evalResult = evalfis(YCBCRinput,fisPrePared);
evalfisResultRounded = evalResult;

%checking the result to find the accuracy
for i=1:size(evalfisResultRounded)
    if(evalfisResultRounded(i) <= 0.53)
        evalfisResultRounded(i) = 2;
    else
        evalfisResultRounded(i) = 1;
    end
end
counter = 0;
for i = 1:size(evalfisResultRounded,1)
    if output(i,1) == evalfisResultRounded(i,1)
        counter = counter + 1;
    end
end

%calculating accuracy with respect to recognition rate
accuracy = counter/size(evalfisResultRounded,1) * 100;
%% display
disp(accuracy);