function label = recog( X,D,numofclass)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here   

D=D./repmat(sqrt(sum(D.*D)),[size(D,1) 1]);
sparsity=4;
recogmode=1;
subsize=size(D,2)/(numofclass+1);     %2200/11=200;
res=zeros(numofclass,1);

switch recogmode  %  0 统计系数多少
    case 0
        spcoeff=omp(D'*X,D'*D,sparsity);
        for i=1:numofclass
            res(i,1)=nnz(spcoeff((i-1)*subsize+1:i*subsize,:));
        end
        [~, label]=max(res);
    case 1
        reconerr=zeros(1,numofclass);
        spcoeff=omp(D'*X,D'*D,sparsity);
        for i=1:numofclass
            reconerr(1,i)=norm((X-D(:,(i-1)*subsize+1:i*subsize)*spcoeff((i-1)*subsize+1:i*subsize,:)),'fro');
        end
         [~, label]=min(reconerr);
        
        
        
        
end  % end switch


end  %  end function

