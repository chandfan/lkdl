clc,clear,close all;
%%%%%%%%%%% 
numberofclass=10;


%%%%%%%%%%%%%%



load('DesTr.mat')

datatrain=[];
htrain=[];
R = randn(128,1728);
R = normc(R);
for i=1:10
Y=[];
Y = [Y DesTr{2:9,i}];
y1=R*Y;
clear Y;
datatrain=[datatrain y1];

ll=zeros(10,1);
ll(i,1)=1;
la=repmat(ll,[1 size(y1,2)]);
htrain=[htrain la];
end

%%%%%%%%%%%%%%%%  testing data
datatest=[];htest=[];
for i=1:10
Y=[];
Y = [Y DesTr{10:10,i}];
y1=R*Y;
clear Y;
datatest=[datatest y1];

ll=zeros(10,1);
ll(i,1)=1;
la=repmat(ll,[1 size(y1,2)]);
htest=[htest la];
end




save('formatdata.mat','datatrain','htrain','datatest','htest');