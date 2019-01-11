data = csvread("C:\Users\geek\Downloads\nnfs_cw\skin_noskin_csv");

%% Software attributes
trainingOnPercentage=60;
MaxEpochs=10;
LearningRate=0.02;
Neurons=10;
PerformanceGoal=0.02;
StartWeights=0.3232;

%% finding data size using matlab's 'size' method with require demention as a parameter. 
dataTotalSize=size(data,1);

%% Setting Percentage Variables
spareDataPercentage=100-trainingOnPercentage;

%% data sorting with respect to output so skin get separated from nonskin
data=sortrows(data,3);

%% sperate input data
input=data(:,1:3);
output=data(:,4);

%count skin
skinCount=0;
for i=1:dataTotalSize
    if data(i,4)==1
        skinCount=skinCount+1;
    end
end

%count nonskin
nonskinCount=dataTotalSize-skinCount;


%% seperating skin and nonskin
skins=(input(1:skinCount,:));
nonskins=(input(skinCount+1:dataTotalSize,:));

%% percentage calculation
trainingskinCount=ceil((skinCount*trainingOnPercentage)/100);
trainingnonskinCount=ceil((nonskinCount*trainingOnPercentage)/100);

%% preparing Training and validation Data Inputs
trainingInputData = [skins(1:trainingskinCount,:) 
    nonskins(1:trainingnonskinCount,:)];
validationInputData =  [skins( trainingskinCount+1: skinCount,:)
    nonskins(trainingnonskinCount+1: skinCount,:)];

%% Calculating size
trainingInputDataSize=size(trainingInputData,1);
validationInputDataSize=size(validationInputData,1);

%% preparing Training and validation Output Data
trainingOutputData=zeros(trainingInputDataSize,2);
for i=(1:trainingInputDataSize)
    if (i<=trainingskinCount)
        trainingOutputData(i,1)=1;
    else
        trainingOutputData(i,2)=1;
    end
end

validationOutputData=zeros(validationInputDataSize,2);
for i=(1:validationInputDataSize)
    if (i<= skinCount-trainingskinCount)
        validationOutputData(i,1)=1;
    else
        validationOutputData(i,2)=1;
    end  
end

%% Building feedforward Net
net = feedforwardnet([100,10],'traingd');

net.layers{1}.transferFcn = 'tansig'; %poslin %logsig %tansig(default)
net.divideFcn='dividetrain';
net.trainParam.lr=LearningRate;
net.trainParam.epochs=1; %because we want to change it after one iteration
net.trainParam.goal = PerformanceGoal;
net.trainParam.max_fail= 10;

[net] = train(net,trainingInputData',trainingOutputData');
weights = getwb(net);

for i=1:size(weights,1)
    weights(i,1)=StartWeights;% changing waits
end
%seting weights again
net = setwb(net,weights);
net.trainParam.epochs=MaxEpochs;
[net,tr] = train(net,trainingInputData',trainingOutputData');
weights1 = getwb(net);
%% Testing data via sim 
testing = sim(net,validationInputData');
%% checking data with expected solution
count=0;
testing=testing';
for i=1:validationInputDataSize
    [a, b]=max(testing(i,:));
    %a batata hay kya berra hay or b main uska index aata hay
    if validationOutputData(i,b)==1
        count=count+1;
    end
end
%% finding accuracy
accuracy=(count/validationInputDataSize)*100;
%% display
disp(accuracy);
