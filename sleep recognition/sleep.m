%{
Criação da matriz para feature selection
bandas de frequência:
delta 1-3Hz
theta 4-7Hz
alfa 8-12Hz
beta 13-30Hz
gamma 31-40HZ

Labels/classes:
0 - deep sleep (S3 & S4)
1 - light sleep (S1 & S2)
2 - REM sleep
-ou-
0- Stage 4
1- Stage 3
2- Stage 2
3- Stage 1
4- REM sleep
%}
function finalmatrix = sleep(eegfile,hypfile,samplefreq)
%% load dos ficheiros
eeg = load(eegfile);
prelabel = load(hypfile);
fs = samplefreq; %sampling freq. in Hz

%% Plots para dataset e limites das janelas

% plot(prelabel,'k'); ylim([-1 6]); 
% 
% time=(0:8.3333e-05:30)';
% plot(time(1:360000),eeg,'b','LineWidth',1.2); 
% title('central EEG dataset, sample frequency = 200Hz, Woman (41)');
% xlabel('minutes'); ylabel('\muvolt');
% ylim([min(eeg)-10, max(eeg)+10]); 
% 
% for i = 1:360
%     x = time(1000*i);
%     line( [x x],[-258.9900, 195.9900],'Color','r','LineStyle','--');
% end
% 
% xlim([0,0.5]);

%% Label final
label = prelabel;
% utilizar esta parte para obter classes de 0 a 2
izeros= prelabel==1;
label(izeros)=0;
iuns= prelabel==2 | prelabel==3;
label(iuns)=1;
idois= prelabel==4;
label(idois)=2;

%% vector do eeg em frames de 5 seg

eegbuffer = buffer(eeg,5*fs);
[m, n] = size(eegbuffer);

%% power spectrum para cada frame
N = 5*fs*2; %number of points
T = 5; %define time of interval, 5 seconds
% t = (0:N-1)/N; %define time
% t = t*T; %define time in seconds
freq = (0:N/2-1)/T; %find the corresponding frequency in Hz

power=zeros(m,n);

for i=1:n
    p = abs(fft(eegbuffer(:,i)))/(N/2); %absolute value of the fft
    power(:,i) = p(1:N/2).^2; %take the power of positve freq. half
%     plot(freq,p); %plot power spectrum
end

%% Plots para janelas de Power Spectrum e frequências de interesse
% plot(freq,power(:,360),'k','LineWidth',1.2); 
% title('Power Spectrum, Window #360');
% xlabel('Hz'); xlim([0,45]);
% ylim = get(gca,'ylim');
% 
% line( [1 1],ylim,'Color','k','LineStyle',':');line( [3 3],ylim,'Color','k','LineStyle',':');
% line( [4 4],ylim,'Color','k','LineStyle',':');line( [7 7],ylim,'Color','k','LineStyle',':');
% line( [8 8],ylim,'Color','k','LineStyle',':');line( [12 12],ylim,'Color','k','LineStyle',':');
% line( [13 13],ylim,'Color','k','LineStyle',':');line( [30 30],ylim,'Color','k','LineStyle',':');
% line( [31 31],ylim,'Color','k','LineStyle',':');line( [40 40],ylim,'Color','k','LineStyle',':');


%% soma dos quadrados
idelta = freq>=1 & freq<=3;
itheta = freq>=4 & freq<=7;
ialfa = freq>=8 & freq<=12;
ibeta = freq>=13 & freq<=30;
igamma = freq>=31 & freq<=40;

delta=zeros(n,1);
theta=zeros(n,1);
alfa=zeros(n,1);
beta=zeros(n,1);
gamma=zeros(n,1);


for i=1:n
    deltax = power(idelta,i);
    delta(i) = sum(deltax.^2);
    
    thetax = power(itheta,i);
    theta(i) = sum(thetax.^2);

    alfax = power(ialfa,i);
    alfa(i) = sum(alfax.^2);   

    betax = power(ibeta,i);
    beta(i) = sum(betax.^2);

    gammax = power(igamma,i);
    gamma(i) = sum(gammax.^2);
end

%% matriz feature-selection vs label (cell)

matrix=zeros(n,6);
matrix(:,1) = delta/max(delta);
matrix(:,2) = theta/max(theta);
matrix(:,3) = alfa/max(alfa);
matrix(:,4) = beta/max(beta);
matrix(:,5) = gamma/max(gamma);
matrix(:,6) = label;

%nova matriz sem label 5=awake
indices=label~=5;
finalmatrix=matrix(indices,:);

csvwrite('matrix.csv',finalmatrix)