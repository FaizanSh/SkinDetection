dataPercentage = 60;

data = csvread("C:\Users\geek\Downloads\nnfs_cw\skin_noskin_csv");

dataSize = size(data,1);
skinCount = size(find(data(:,4)==1),1);
nonSkinCount = dataSize - skinCount;

skin = data(1:skinCount,:);
nonSkin = data(skinCount+1:dataSize,:);

trainingDataPercentage = dataPercentage;
testingDataPercentage = 100 - trainingDataPercentage;

trainingskinCount = ceil((skinCount*trainingDataPercentage)/100);
trainingnonSkinCount = ceil((nonSkinCount*trainingDataPercentage)/100);

trainingInputData = [skin(1:trainingskinCount,:)
    nonSkin(1:trainingnonSkinCount,:)];
trainingInputData = trainingInputData(randperm(size(trainingInputData,1)),:);
validationInputData = [skin(trainingskinCount + 1 : skinCount, :)
    nonSkin(trainingnonSkinCount + 1 : nonSkinCount, :)];

fisResult=anfis([trainingInputData(:,1:3) trainingInputData(:,4)]);  

evalout = evalfis(validationInputData(:,1:3),fisResult); 
evalRounded = round(evalout);

same = evalRounded==validationInputData(:,4); 

counter = sum (same == 1);  

disp(counter/size(validationInputData,1)*100);