function [mins,maxs]=FindExtrema(x,y)
        xf = medfilt1(x,100);
        test = find(x-xf>(mean(x-xf)+std(x-xf)));
        [pks,indx] = findpeaks(x,'MinPeakDistance',20);
        counter=1;
        prebuf = 100;
        
         for ii=1:numel(test)
            if find(indx==test(ii))
                maxs(counter) = test(ii);
                counter=counter+1;
            end
        end
        maxs(maxs<prebuf+16)=[];
        maxs(maxs>length(y)-15)=[];
        
        for ii=1:numel(maxs)
            [~,mLoc] = max(y(maxs(ii)-15:maxs(ii)+15));
            maxs(ii) = maxs(ii) - (16-mLoc);
          
            
            vec = (diff(diff(y(maxs(ii)-prebuf:maxs(ii)))));
            [~,loc]=max(vec);
            
            [~,loc1] = min(y(maxs(ii)-prebuf+loc-15:maxs(ii)-prebuf+loc+15));
            mins(ii) = maxs(ii)-prebuf+loc-(16-loc1);
%             display(ii);
        end
end