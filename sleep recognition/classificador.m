%% TREINO DO CLASSIFICADOR E DECISÃO
%% treino

% Get the same results every time we run the code.
rng default

% Matrix of features and respective labels
matrix = sleep('excerpt7.txt','Hypnogram_excerpt7.txt',200);
features = matrix(:,(1:5));
classLabels = matrix(:,6);
 
% Number of trees in the forest 
nTrees = 43;
 
% Train the TreeBagger (Decision Forest).
B = TreeBagger(nTrees,features,classLabels, 'Method', 'classification');
 
% Given a new individual WITH the features and WITHOUT the class label,
% what should the class label be?
newData = sleep('excerpt3.txt','Hypnogram_excerpt3.txt',50);
[m, n] = size(newData);
choice = input(sprintf('Choose from 1 to %d: ', m));
newData1 = newData(choice,1:5);
 
% Use the trained Decision Forest.
predClass = str2double(B.predict(newData1));
 
switch predClass
    case 0
        [y, fs] = audioread('C:\\Users\\Inês\\Dropbox\\EBB 4º ano\\Neurociências\\projecto\\beats\\0sound.wav');
    case 1
        [y, fs] = audioread('C:\\Users\\Inês\\Dropbox\\EBB 4º ano\\Neurociências\\projecto\\beats\\1sound.wav');
    case 2
        [y, fs] = audioread('C:\\Users\\Inês\\Dropbox\\EBB 4º ano\\Neurociências\\projecto\\beats\\2sound.wav');
    case 3
        [y, fs] = audioread('C:\\Users\\Inês\\Dropbox\\EBB 4º ano\\Neurociências\\projecto\\beats\\3sound.wav');
    otherwise
        [y, fs] = audioread('C:\\Users\\Inês\\Dropbox\\EBB 4º ano\\Neurociências\\projecto\\beats\\4sound.wav');
end

pl = audioplayer (y, fs);
play(pl);