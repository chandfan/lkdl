
load('E:\程序\结构字典学习\16年8月\plotcolorfig\sprrepresentation.mat')

aa=XX{1,4}(:,167);
plot(aa)
hold on
for j=1:11
    plot([j*200 j*200],[-.3 .4],':r')
end











% [sa sb]=size(aa);
% bb=zeros(sa,1);
% for j=1:sa
%     bb(j,1)=nnz(aa(j,:));
% end
% plot(bb)