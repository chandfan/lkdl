or=ones(100,100)*255;
featdes=round(255*rand(10,10));
b=ones(10,10);
c=kron(featdes,b);
for i=10:30:size(c,2)-30
   c(:,i+1:i+20)= or(:,i+1:i+20);
end
figure,imshow(c,[]);
colormap(hot)
figure,imshow(c,[]);
colormap()

featdes2=round(255*rand(10,20));
cc=kron(featdes2,b);
figure,imshow(cc,[]);
colormap(hot)