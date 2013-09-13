function [R,G,B,C,Y,M,bg,rR,gR,bR,rG,gG,bG,rB,gB,bB,rC,gC,bC,rY,gY,bY,rM,gM,bM,Rstdr,Rstdg,Rstdb,Gstdr,Gstdg,Gstdb,Bstdr,Bstdg,Bstdb,Cstdr,Cstdg,Cstdb,Ystdr,Ystdg,Ystdb,Mstdr,Mstdg,Mstdb] = calibrator();

permission='n';

while (permission=='n')

      %The function takes in a BGSubtracted image i of the gloves and returns the
      %mode of the RGB values of the six contrasting colours.
      vid=imaq.VideoDevice('winvideo',1);
       set(vid.DeviceProperties,'Brightness',60);
      set(vid.DeviceProperties,'Saturation',100);
      iavg=step(vid);
      for f=2:100
             im=step(vid);
             iavg=((f-1)*iavg + im)/f;    %get background
      end; 
      release(vid);
      permission=input('Ready?(y/n): n will reobtain the background:','s');
end; 

%   BGSubtraction By the Averaged BG.
pause(2);
[x u z]=size(iavg);
bg=zeros(x,u,z);   %THE BGSubtracted image will be stored to bg.
th=0.15;

      vid=imaq.VideoDevice('winvideo',1);
       set(vid.DeviceProperties,'Brightness',60);
      set(vid.DeviceProperties,'Saturation',100);
      i=step(vid);
      release(vid);

  for c1=1:x
      
          for c2=1:u
           if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
               bg(c1,c2,1)=i(c1,c2,1);
               bg(c1,c2,2)=i(c1,c2,2);
               bg(c1,c2,3)=i(c1,c2,3);
           end;
        
         end;
   end;


inth=0.5;
small=0.3;
%large=8;
error1=1;
error2=0.5;

R=zeros(x,u,z);
G=zeros(x,u,z);
B=zeros(x,u,z);
C=zeros(x,u,z);
Y=zeros(x,u,z);
M=zeros(x,u,z);


%If R+G+B>inth then,
 for c1=1:x
      for c2=1:u
          
          if (bg(c1,c2,1)+bg(c1,c2,2)+bg(c1,c2,3))>inth
              gr=(bg(c1,c2,2)+0.01)/(bg(c1,c2,1)+0.01); %Prepare arrays GR and BR with g/r and b/r of each pixel respectivly.
              br=(bg(c1,c2,3)+0.01)/(bg(c1,c2,1)+0.01);
              s=(bg(c1,c2,1)+bg(c1,c2,2)+bg(c1,c2,3))/3;
               %There are 6 image arrays R G B C M Y.Divide according to GR and BR values.

                %BOTH SMALL====RED..
                %BOTH LARGE====CYAN..
                %GR=1 BR=SMALL=====YELLOW
                %GR=1 BR=LARGE=====BLUE
                %GR=LARGE BR=1===GREEN..
                %GR=SMALL BR=1====MAGENTA..
                
              if (gr<small)
                  if(br<small)
                      R(c1,c2,1)=s;
                      R(c1,c2,2)=gr;
                      R(c1,c2,3)=br;
                      
                  else if abs(br-1)<error2
                           M(c1,c2,1)=s;
                           M(c1,c2,2)=gr;
                           M(c1,c2,3)=br;
                          
                       end
                  end    
                  
              else if((1/gr)<small)
                       if((1/br)<small)
                            C(c1,c2,1)=s;
                            C(c1,c2,2)=gr;
                            C(c1,c2,3)=br;
                      
                       else if abs(br-1)<error1
                                G(c1,c2,1)=s;
                                G(c1,c2,2)=br;
                                G(c1,c2,3)=gr;
                          
                           end
                       end 
                       
                  else if abs(gr-1)<=error1
                          if (br<small)&&(abs(gr-1)<=error2)
                               Y(c1,c2,1)=s;
                               Y(c1,c2,2)=gr;
                               Y(c1,c2,3)=br;
                              
                          else if ((1/br)<small)
                                   B(c1,c2,1)=s;
                                   B(c1,c2,2)=gr;
                                   B(c1,c2,3)=br;
                                  
                              end
                          end   
                          
                       end
                      
                  end
                  
              end    
                
                

          end
      end
 end
 

[rR,Rstdr,gR,Rstdg,bR,Rstdb]=calculate(R);
[rG,Gstdr,gG,Gstdg,bG,Gstdb]=calculate(G);
[rB,Bstdr,gB,Bstdg,bB,Bstdb]=calculate(B);
[rC,Cstdr,gC,Cstdg,bC,Cstdb]=calculate(C);
[rM,Mstdr,gM,Mstdg,bM,Mstdb]=calculate(M);
[rY,Ystdr,gY,Ystdg,bY,Ystdb]=calculate(Y);

end

