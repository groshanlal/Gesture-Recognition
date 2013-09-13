function [meanr,stdr,meang,stdg,meanb,stdb ] = calculate(im)
im=255*im;
[x y z]=size(im);

meanr=0;meang=0;meanb=0;
i=0;
for c1=1:x
    for c2=1:y
        if(im(c1,c2,1)+im(c1,c2,2)+im(c1,c2,3))~=0
           
            meanr=meanr+im(c1,c2,1);
          
            meang=meang+im(c1,c2,2);
            
            meanb=meanb+im(c1,c2,3);
            
            i=i+1;
        end
    end
end

stdr=0;stdb=0;stdg=0;
if i>100

meanr=meanr/i;
meang=meang/i;
meanb=meanb/i;

varr=0;varg=0;varb=0;
i=i-1;
for c1=1:x
    for c2=1:y
        if(im(c1,c2,1)+im(c1,c2,2)+im(c1,c2,3))~=0
           
            varr=varr+(im(c1,c2,1)-meanr)^2;
            
            varg=varg+(im(c1,c2,2)-meang)^2;
            
            varb=varb+(im(c1,c2,3)-meanb)^2;
        end
    end
end


stdr=(varr/i)^(0.5);
stdg=(varg/i)^(0.5);
stdb=(varb/i)^(0.5);
else
    meanr=0;
    meang=0;
    meanb=0;
        
end
end

