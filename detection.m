function detection(n)
 %Calibrate to get the RGB of 6 colors
[R,G,B,C,Y,M,bg,rR,gR,bR,rG,gG,bG,rB,gB,bB,rC,gC,bC,rY,gY,bY,rM,gM,bM,Rstdr,Rstdg,Rstdb,Gstdr,Gstdg,Gstdb,Bstdr,Bstdg,Bstdb,Cstdr,Cstdg,Cstdb,Ystdr,Ystdg,Ystdb,Mstdr,Mstdg,Mstdb] = calibrate();

rR
gR
bR
rG
gG
bG
rB
gB
bB
rC
gC
bC
rY
gY
bY
rM
gM 
bM
q=input('Taking Background','s');

 %Open videodevice and get size of the image
 vid=imaq.VideoDevice('winvideo',1);
 set(vid.DeviceProperties,'Brightness',60);
 set(vid.DeviceProperties,'Saturation',100);
 iavg=step(vid);
 [x,y,z]=size(iavg);
 
 %Obtain averaged Background.
 for c=2:100
    im=step(vid);
    iavg=((c-1)*iavg + im)/c;    %get background
end; 
q=input('Ready','s');

profile on
 st=3;
th=0.3;
 %Obtain background subtracted image AND
 %Check for each pixel to belong to one of the 6 colors with considerable
 %confidence.
 
 %update the file accordingly.
 
 %repeat n times.
 
 for c=101:(101+n)
	 i=step(vid);
      bg=zeros(x,y,z);
      ind=0;
     for c1=1:st:x
      
          for c2=1:st:y
           if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
               bg(c1:(c1+st-1),c2:(c2+st-1),1)=i(c1,c2,1);
               bg(c1:(c1+st-1),c2:(c2+st-1),2)=i(c1,c2,2);
               bg(c1:(c1+st-1),c2:(c2+st-1),3)=i(c1,c2,3);
           end;
        
         end;
     end;
bg=255*bg;
im=rd3f(bg,rR,gR,bR,3,3,50,10);  %Call rd3(img,r,g,b,(g/r)thres,(b/r)thres,Erode_elem_size,Dilate_elem_size,Brightness_thres)
if im==0;else ind=ind+1;end;

im=rd3f(bg,rG,gG,bG,3,3,50,10);
if im==0;else ind=ind+2;end;

im=rd3f(bg,rB,gB,bB,3,3,50,10); 
if im==0;else ind=ind+4;end;

im=rd3f(bg,rC,gC,bC,3,3,50,10); 
if im==0;else ind=ind+8;end;

im=rd3f(bg,rY,gY,bY,3,3,50,20); 
if im==0;else ind=ind+16;end;

im=rd3f(bg,rM,gM,bM,3,3,50,10); 
if im==0;else ind=ind+32;end;

switch ind
    case 1 
        update(1);
    case 9
        update(2);
    case 25
        update(3);
    case 57
        update(4);
        
end;
ind

end;

release(vid);
profile off
profile report
end

 
 %update background at regular intervals.
 


