function varargout = GTfinal(varargin)
% GTFINAL MATLAB code for GTfinal.fig
%      GTFINAL, by itself, creates a new GTFINAL or raises the existing
%      singleton*.
%
%      H = GTFINAL returns the handle to a new GTFINAL or the handle to
%      the existing singleton*.
%
%      GTFINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GTFINAL.M with the given input arguments.
%
%      GTFINAL('Property','Value',...) creates a new GTFINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GTfinal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GTfinal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GTfinal

% Last Modified by GUIDE v2.5 16-Jun-2013 06:28:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GTfinal_OpeningFcn, ...
                   'gui_OutputFcn',  @GTfinal_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end

% --- Executes just before GTfinal is made visible.
function GTfinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GTfinal (see VARARGIN)

% Choose default command line output for GTfinal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cam_on=0;
permission='y';
calibration_done=0;
profile_done=0;
handles.cam_on=cam_on;
handles.permission=permission;
handles.calibration_done=calibration_done;
handles.profile_done=profile_done;
guidata(hObject,handles);

% UIWAIT makes GTfinal wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = GTfinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)%///////////////////////Open device
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
preview(vid);
handles.vid=vid;
guidata(hObject,handles);
end
end


% --- Executes on button press in pushbutton2.////////////Close Device
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.cam_on==1
vid=handles.vid;
closepreview;
release(vid);
handles.cam_on=0;
guidata(hObject,handles);
end
end

% --- Executes on button press in pushbutton3.///////obtain background
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
preview(vid);
handles.vid=vid;
%guidata(hObject,handles);
end
mseg=msgbox('Obtaining Background...Please Wait','Alert');
while (strcmp(handles.permission,'y')==1)
    vid=handles.vid;
     iavg=step(vid);
            for f=2:100
               im=step(vid);
               iavg=((f-1)*iavg + im)/f;   
            end
 handles.iavg=iavg; 

 %Dialog Box
 prompt={'Do you want to obtain background again?'};
 handles.permission=inputdlg(prompt,'Not Satisfied?',1);
 
 %guidata(hObject,handles);
end 
 axes(handles.axes9);
 i=handles.iavg;
 imshow(i);
 handles.permission='y';
closepreview;
release(vid);
handles.cam_on=0;
guidata(hObject,handles);
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton5./////Calibrate
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.profile_done=0;
if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
preview(vid);
handles.vid=vid;
%guidata(hObject,handles);
end
profile on
while (strcmp(handles.permission,'y')==1)
    vid=handles.vid;
     iavg=step(vid);
            for f=2:100
               im=step(vid);
               iavg=((f-1)*iavg + im)/f;   
            end
 handles.iavg=iavg; 
 axes(handles.axes9);
  i=handles.iavg;
  imshow(i);
 %Dialog Box
 prompt={'Do you want to obtain background again?(y/n)'};
 handles.permission=inputdlg(prompt,'Not Satisfied?',1);
 
 end
 handles.permission='y';
 %OBTAIN GLOVE IMAGE.
 handles.permission=inputdlg('Do you want to calibrate The Glove?','Must Before Run.',1);
 
 if (strcmp(handles.permission,'y')==1)
     
 while (strcmp(handles.permission,'y')==1)
 mesg=msgbox('Hold the Glove in front of the camera before Timeout.','Instruction'); 
     for ct=1:100 
          i=step(vid);   
     end; 
   %delete(mesg);
   prompt={'Timeout! Do you want to get Glove clicked again?(y/n)'};
   handles.permission=inputdlg(prompt,'Click Again?',1);
 end
  handles.permission='y';
  
  [x, u, z]=size(iavg);
  bg1=zeros(x,u,z);
  th=0.25;
  st=1;%//////////////////////////////////////////////////////Function calibrate has st=1
  
   for c1=1:st:x
      
          for c2=1:st:u
           if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
               bg1(c1:(c1+st-1),c2:(c2+st-1),1)=i(c1,c2,1);
               bg1(c1:(c1+st-1),c2:(c2+st-1),2)=i(c1,c2,2);
               bg1(c1:(c1+st-1),c2:(c2+st-1),3)=i(c1,c2,3);
           end;
        
         end;
   end;
   
   inth=0.5;
   small=0.5;% must be more for Dark red detection but then C is seen as B...check deng denb values% ////WAS 0.3....Changed to 0.4 as in calibrate
   error1=1;
   error2=0.7;%%%%%%%%%%%%%%%%%%%%%WAS0.5
     
     
R=zeros(x,u,z);
G=zeros(x,u,z);
B=zeros(x,u,z);
C=zeros(x,u,z);
Y=zeros(x,u,z);
M=zeros(x,u,z);

    
%If R+G+B>inth then,
 for c1=1:x
      for c2=1:u
          
          if (bg1(c1,c2,1)+bg1(c1,c2,2)+bg1(c1,c2,3))>inth
              gr=bg1(c1,c2,2)/(bg1(c1,c2,1)+0.005); %Prepare arrays GR and BR with g/r and b/r of each pixel respectivly.%%%%%%%%%%%%%%%%%%WAS 0.1
              br=bg1(c1,c2,3)/(bg1(c1,c2,1)+0.005);

               %There are 6 image arrays R G B C M Y.Divide according to GR and BR values.

                %BOTH SMALL====RED..
                %BOTH LARGE====CYAN..
                %GR=1 BR=SMALL=====YELLOW
                %GR=1 BR=LARGE=====BLUE
                %GR=LARGE BR=1===GREEN..
                %GR=SMALL BR=1====MAGENTA..
                
              if (gr<small)
                  if(br<small)
                      R(c1,c2,1)=bg1(c1,c2,1);
                      R(c1,c2,2)=bg1(c1,c2,2);
                      R(c1,c2,3)=bg1(c1,c2,3);
                      
                  else if abs(br-1)<error2
                           M(c1,c2,1)=bg1(c1,c2,1);
                           M(c1,c2,2)=bg1(c1,c2,2);
                           M(c1,c2,3)=bg1(c1,c2,3);
                          
                       end
                  end    
                  
              else if((1/gr)<small)
                       if((1/br)<small)&&(abs((gr/br)-1)<=error2)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&& was not there
                            C(c1,c2,1)=bg1(c1,c2,1);
                            C(c1,c2,2)=bg1(c1,c2,2);
                            C(c1,c2,3)=bg1(c1,c2,3);
                      
                       else if abs(br-1)<error1
                                G(c1,c2,1)=bg1(c1,c2,1);
                                G(c1,c2,2)=bg1(c1,c2,2);
                                G(c1,c2,3)=bg1(c1,c2,3);
                          
                           end
                       end 
                       
                  else if abs(gr-1)<=error1
                          if (br<small)&&(abs(gr-1)<=error2)
                               Y(c1,c2,1)=bg1(c1,c2,1);
                               Y(c1,c2,2)=bg1(c1,c2,2);
                               Y(c1,c2,3)=bg1(c1,c2,3);
                              
                          else if ((1/br)<small)
                                   B(c1,c2,1)=bg1(c1,c2,1);
                                   B(c1,c2,2)=bg1(c1,c2,2);
                                   B(c1,c2,3)=bg1(c1,c2,3);
                                  
                              end
                          end   
                          
                       end
                      
                  end
                  
              end    
                
                

          end
      end
 end     
     
handles.R=R;
handles.G=G;
handles.B=B;
handles.C=C;
handles.Y=Y;
handles.M=M;
handles.BGRD=bg1;

[rR,Rstdr,gR,Rstdg,bR,Rstdb]=calculate(R);
[rG,Gstdr,gG,Gstdg,bG,Gstdb]=calculate(G);
[rB,Bstdr,gB,Bstdg,bB,Bstdb]=calculate(B);
[rC,Cstdr,gC,Cstdg,bC,Cstdb]=calculate(C);
[rM,Mstdr,gM,Mstdg,bM,Mstdb]=calculate(M);
[rY,Ystdr,gY,Ystdg,bY,Ystdb]=calculate(Y);
     
    
     Rm= [rR,gR,bR];
     Gm= [rG,gG,bG];
     Bm= [rB,gB,bB];
     Cm= [rC,gC,bC];
     Ym= [rY,gY,bY];
     Mm= [rM,gM,bM];
     
     r1=1;
     g1=1;
     b1=1;
     c1=1;
     y1=1;
     m1=1;
     
     deng=1;%//////////////////////////can be 4 for more strict surveillance
     denb=1;
     
     min_pix=100;  %/////////////////////must be tested     
        
 if (rR>0)||(gR>0)||(bR>0)
 else
     Rm=zeros(3);
     r1=0;
     mesg=msgbox({'RED was Not detected at all';'You may want to calibrate again.'},'RED Alert');
 end
 
 if (rG>0)||(gG>0)||(bG>0)
 else
     Gm=zeros(3);
     g1=0;
     mesg=msgbox({'GREEN was Not detected at all';'You may want to calibrate again.'},'GREEN Alert');
 end
 
 if (rB>0)||(gB>0)||(bB>0)
 else
     Bm=zeros(3);
     b1=0;
     mesg=msgbox({'BLUE was Not detected at all';'You may want to calibrate again.'},'BLUE Alert');
 end
 
 if (rC>0)||(gC>0)||(bC>0)
 else
     Cm=zeros(3);
     c1=0;
     mesg=msgbox({'CYAN was Not detected at all';'You may want to calibrate again.'},'CYAN Alert');
 end
 
 if (rY>0)||(gY>0)||(bY>0)
 else
     Ym=zeros(3);
     y1=0;
     mesg=msgbox({'YELLOW was Not detected at all';'You may want to calibrate again.'},'YELLOW Alert');
 end
 
 if (rM>0)||(gM>0)||(bM>0)
 else
     Mm=zeros(3);
     m1=0;
     mesg=msgbox({'MAGENTA was Not detected at all';'You may want to calibrate again.'},'MAGENTA Alert');
 end
 
     
        Rmn=(Rm(1)+Rm(2)+Rm(3))/3;
        Rratiog=Rm(2)/(Rm(1)+0.001);%///////////////////can be 0.05
        Rratiob=Rm(3)/(Rm(1)+0.001);
        Rgt=(Rratiog+0.01)/deng;
        Rbt=(Rratiob+0.01)/denb;
        
        Gmn=(Gm(1)+Gm(2)+Gm(3))/3;
        Gratiog=Gm(2)/(Gm(1)+0.001);
        Gratiob=Gm(3)/(Gm(1)+0.001);
        Ggt=(Gratiog+0.01)/deng;
        Gbt=(Gratiob+0.01)/denb;
        
        Bmn=(Bm(1)+Bm(2)+Bm(3))/3;
        Bratiog=Bm(2)/(Bm(1)+0.001);
        Bratiob=Bm(3)/(Bm(1)+0.001);
        Bgt=(Bratiog+0.01)/deng;
        Bbt=(Bratiob+0.01)/denb;
        
               
        Cmn= (Cm(1)+Cm(2)+Cm(3))/3;
        Cratiog=Cm(2)/(Cm(1)+0.001);
        Cratiob=Cm(3)/(Cm(1)+0.001);
        Cgt=(Cratiog+0.01)/deng;
        Cbt=(Cratiob+0.01)/denb;
        
        Ymn= (Ym(1)+Ym(2)+Ym(3))/3;
        Yratiog=  Ym(2)/(Ym(1)+0.001);
        Yratiob=  Ym(3)/(Ym(1)+0.001);
        Ygt=(Yratiog+0.01)/deng;
        Ybt=(Yratiob+0.01)/denb;
        
               
        Mmn= (Mm(1)+Mm(2)+Mm(3))/3;
        Mratiog=  Mm(2)/(Mm(1)+0.001);
        Mratiob=  Mm(3)/(Mm(1)+0.001);
        Mgt=(Mratiog+0.01)/deng;
        Mbt=(Mratiob+0.01)/denb;
        
        handles.Rmn    =Rmn;
        handles.Rratiog=Rratiog;
        handles.Rratiob=Rratiob;
        handles.Rgt    =Rgt;
        handles.Rbt    =Rbt;
        
        handles.Gmn    =Gmn;
        handles.Gratiog=Gratiog;
        handles.Gratiob=Gratiob;
        handles.Ggt    =Ggt;
        handles.Gbt    =Gbt;
        
        handles.Bmn    =Bmn;
        handles.Bratiog=Bratiog;
        handles.Bratiob=Bratiob;
        handles.Bgt    =Bgt;
        handles.Bbt    =Bbt;
        
        handles.Cmn    =Cmn;
        handles.Cratiog=Cratiog;
        handles.Cratiob=Cratiob;
        handles.Cgt    =Cgt;
        handles.Cbt    =Cbt;

        
        handles.Ymn    =Ymn;
        handles.Yratiog=Yratiog;
        handles.Yratiob=Yratiob;
        handles.Ygt    =Ygt;
        handles.Ybt    =Ybt;
        
        handles.Mmn    =Mmn;
        handles.Mratiog=Mratiog;
        handles.Mratiob=Mratiob;
        handles.Mgt    =Mgt;
        handles.Mbt    =Mbt;
        
        handles.r1=r1;
        handles.g1=g1;
        handles.b1=b1;
        handles.c1=c1;
        handles.y1=y1;
        handles.m1=m1;
handles.calibration_done=1;        
 end   
handles.permission='y';
profile off;
handles.profile_done=1;
closepreview;
release(vid);
handles.cam_on=0;
guidata(hObject,handles);

end


% --- Executes on selection change in popupmenu1.////////VEIW
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
opt=get(handles.popupmenu1,'value');

switch opt
    case 1
        axes(handles.axes9);
        imshow('blank.png');
    case 2
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.BGRD;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 3
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.R;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 4
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.G;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 5
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.B;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 6
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.C;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 7
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.Y;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 8
        if handles.calibration_done==1
        axes(handles.axes9);
        i=handles.M;
        imshow(i);
        else msgbox('Please Calibrate First.','Error');
        end
    case 9
        axes(handles.axes9);
        i=handles.iavg;
        imshow(i);
end

guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton7./////////////RUN
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.profile_done=0;
if handles.calibration_done==1
if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
preview(vid);
handles.vid=vid;
%guidata(hObject,handles);
end
       r1=handles.r1;
       g1=handles.g1;
       b1=handles.b1;
       c1=handles.c1;
       y1=handles.y1;
       m1=handles.m1;
       
       
       Rmn=    handles.Rmn;
        Rratiog=handles.Rratiog;
        Rratiob=handles.Rratiob;
        Rgt=    handles.Rgt;
        Rbt=    handles.Rbt;
        
        Gmn=    handles.Gmn;
        Gratiog=handles.Gratiog;
        Gratiob=handles.Gratiob;
        Ggt=    handles.Ggt;
        Gbt=    handles.Gbt;
        
        Bmn=    handles.Bmn;
        Bratiog=handles.Bratiog;
        Bratiob=handles.Bratiob;
        Bgt=    handles.Bgt;
        Bbt=    handles.Bbt;
        
        Cmn=    handles.Cmn;
        Cratiog=handles.Cratiog;
        Cratiob=handles.Cratiob;
        Cgt=    handles.Cgt;
        Cbt=    handles.Cbt;
        
        Ymn=    handles.Ymn;
        Yratiog=handles.Yratiog;
        Yratiob=handles.Yratiob;
        Ygt=    handles.Ygt;
        Ybt=    handles.Ybt;
        
        Mmn=    handles.Mmn;
        Mratiog=handles.Mratiog;
        Mratiob=handles.Mratiob;
        Mgt=    handles.Mgt;
        Mbt=    handles.Mbt;
        
   
     %CONSTANTS

     %CONSTANTS
th=0.3;
n=100;
st=3;
brightness=0.2;
erodesize=10;
se=strel('square',erodesize);

i=step(vid);
[x,u,z]=size(i);
axes(handles.axes9);
 iavg=handles.iavg;
profile on
for c=1:n
          
           i=step(vid);
           bg=zeros(x,u,z);
           ind=0;
           
          % imshow(i);
      

           for c1=1:st:x
      
                  for c2=1:st:u
                          if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
                                     bg(c1:(c1+st-1),c2:(c2+st-1),1)=i(c1,c2,1);
                                     bg(c1:(c1+st-1),c2:(c2+st-1),2)=i(c1,c2,2);
                                     bg(c1:(c1+st-1),c2:(c2+st-1),3)=i(c1,c2,3);
                          end;
        
                   end;
           end;
           
      bgcalc=zeros(x,u,z);
       imshow(bg);     
      for c1=1:st:x
             for c2=1:st:u
	              bgcalc(c1,c2,1)=(bg(c1,c2,1)+bg(c1,c2,2)+bg(c1,c2,3))/3;
	              bgcalc(c1,c2,2)=bg(c1,c2,2)/(bg(c1,c2,1)+0.001); 
	              bgcalc(c1,c2,3)=bg(c1,c2,3)/(bg(c1,c2,1)+0.001);
             end
      end
      
      %DETECTION
      d=zeros(x,u);
                     if r1==1
                         
                     for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Rmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Rratiog)<10*Rgt)&&(abs(bgcalc(c1,c2,3)-Rratiob)<10*Rbt)  %RED
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                         r1+1
                     else
                         r1+2
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+1;
                         end
                     end
                     end
                     
        
         
         d=zeros(x,u);
                     if g1==1
                     for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Gmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Gratiog)<Ggt)&&(abs(bgcalc(c1,c2,3)-Gratiob)<Gbt) %GREEN
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0%
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+2;
                         end
                     end
                     end
         
           d=zeros(x,u); 
           if b1==1
                      for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Bmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Bratiog)<Bgt)&&(abs(bgcalc(c1,c2,3)-Bratiob)<Bbt)%Blue
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+4;
                         end
                     end
           end
             d=zeros(x,u);        
              if c1==1
                  for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Cmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Cratiog)<Cgt)&&(abs(bgcalc(c1,c2,3)-Cratiob)<Cbt)  %CYAN
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+8;
                         end
                     end
              end
              
              d=zeros(x,u);
              if y1==1
                  for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Ymn)<brightness)&&(abs(bgcalc(c1,c2,2)-Yratiog)<Ygt)&&(abs(bgcalc(c1,c2,3)-Yratiob)<Ybt)  %YELLOW
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+16;
                         end
                     end
              end
              
              d=zeros(x,u);
              if m1==1
                      for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Mmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Mratiog)<Mgt)&&(abs(bgcalc(c1,c2,3)-Mratiob)<Mbt)  %MAGENTA
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+32;
                         end
                     end
              end
                     
 update(ind);
 
   % set(handles.text3,'String',num2str(ind));             
end
profile off
update(0);
handles.profile_done=1;
guidata(hObject,handles);
else msgbox('Please Calibrate First.','Note',1);
end
%closepreview;
end



% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton9./////Calibrate and run
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.profile_done=0;
if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
preview(vid);
handles.vid=vid;
%guidata(hObject,handles);
end
while (strcmp(handles.permission,'y')==1)
    vid=handles.vid;
     iavg=step(vid);
            for f=2:100
               im=step(vid);
               iavg=((f-1)*iavg + im)/f;   
            end
 handles.iavg=iavg;
  axes(handles.axes9);
  i=handles.iavg;
  imshow(i);
 %Dialog Box
 prompt={'Do you want to obtain background again?(y/n)'};
 handles.permission=inputdlg(prompt,'Not Satisfied?',1);
 
 end
 handles.permission='y';
 %OBTAIN GLOVE IMAGE.
 handles.permission=inputdlg('Do you want to calibrate The Glove?','Must Before Run.',1);
 
 if (strcmp(handles.permission,'y')==1)
     
 while (strcmp(handles.permission,'y')==1)
 mesg=msgbox('Hold the Glove in front of the camera before Timeout.','Instruction'); 
     for ct=1:100 
          i=step(vid);   
     end;
   %delete(mesg);
   prompt={'Timeout! Do you want to get Glove clicked again?(y/n)'};
   handles.permission=inputdlg(prompt,'Click Again?',1);
 end
  handles.permission='y';
  
  [x, u, z]=size(iavg);
  bg1=zeros(x,u,z);
  th=0.25;
  st=3;%//////////////////////////////////////////////////////Function calibrate has st=1
  
   for c1=1:st:x
      
          for c2=1:st:u
           if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
               bg1(c1:(c1+st-1),c2:(c2+st-1),1)=i(c1,c2,1);
               bg1(c1:(c1+st-1),c2:(c2+st-1),2)=i(c1,c2,2);
               bg1(c1:(c1+st-1),c2:(c2+st-1),3)=i(c1,c2,3);
           end;
        
         end;
   end;
   
   inth=0.5;
   small=0.5;% must be more for Dark red detection but then C is seen as B...check deng denb values% ////WAS 0.3....Changed to 0.4 as in calibrate
   error1=1;
   error2=0.7;%%%%%%%%%%%%%%%%%%%%%WAS0.5
     
     length=x*u;
     R=zeros(length,3);lr=0;
     G=zeros(length,3);lg=0;
     B=zeros(length,3);lb=0;
     C=zeros(length,3);lc=0;
     Y=zeros(length,3);ly=0;
     M=zeros(length,3);lm=0;
    
 
     
      for c1=1:x
      
            for c2=1:u
                
                 if (bg1(c1,c2,1)+bg1(c1,c2,2)+bg1(c1,c2,3))>inth
                         
                        gr=bg1(c1,c2,2)/(bg1(c1,c2,1)+0.005);%////////////////////////////////////was 0.1....definitely wrong
                        br=bg1(c1,c2,3)/(bg1(c1,c2,1)+0.005);
                        
                        if (gr<small)
                              if(br<small)
                                       lr=lr+1;
                                       R(lr,1:3)=bg1(c1,c2,1:3);
                                   
                              else   if abs(br-1)<error2
                                            lm=lm+1;
                                            M(lm,1:3)=bg1(c1,c2,1:3);
                                           
                                           
                                    end
                              end    
                  
                        else    if((1/gr)<small)
                                    if((1/br)<small)&&(abs((gr/br)-1)<=error2)%%%%%%%%%%%%%%%was not there
                                           lc=lc+1;
                                           C(lc,1:3)=bg1(c1,c2,1:3);
                                            
                      
                                    else   if abs(br-1)<error1
                                                    lg=lg+1;
                                                    G(lg,1:3)=bg1(c1,c2,1:3);
                                                    
                          
                                           end
                                    end 
                       
                                 else   if abs(gr-1)<=error1
                                              if (br<small)&&(abs(gr-1)<=error2)
                                                         ly=ly+1;
                                                         Y(ly,1:3)=bg1(c1,c2,1:3);
                                                     
                                               else if ((1/br)<small)
                                                                 lb=lb+1;
                                                                 B(lb,1:3)=bg1(c1,c2,1:3);
                                                              
                                  
                                                   end
                                              end   
                          
                                         end
                      
                                 end
                  
                        end    
                
                

                 end


            end
     end
     
     
     R((lr+1):length,:)=[];
     G((lg+1):length,:)=[];
     B((lb+1):length,:)=[];
     C((lc+1):length,:)=[];
     Y((ly+1):length,:)=[];
     M((lm+1):length,:)=[];
     
    
     Rm= mean(R,1)
     Gm= mean(G,1)
     Bm= mean(B,1)
     Cm= mean(C,1)
     Ym= mean(Y,1)
     Mm= mean(M,1)
     
     deng=3;%//////////////////////////can be 4 for more strict surveillance
     denb=3;
     
     min_pix=200;  %/////////////////////must be tested  
     
     r1=1;
     g1=1;
     b1=1;
     c1=1;
     y1=1;
     m1=1;
        
 if lr>min_pix
 else if lr>0
          mesg=msgbox({'Enough RED components were not detected!';'You may want to calibrate again.'},'RED Alert');
     else
     Rm=zeros(3);
     r1=0;
     mesg=msgbox({'RED was Not detected at all';'You may want to calibrate again.'},'RED Alert');
     end
 end
 
 if lg>min_pix
 else if lg>0
          mesg=msgbox({'Enough GREEN components were not detected!';'You may want to calibrate again.'},'GREEN Alert');
     else
     Gm=zeros(3);
     g1=0;
     mesg=msgbox({'GREEN was Not detected at all';'You may want to calibrate again.'},'GREEN Alert');
     end
 end
 
 if lb>min_pix
 else if lb>0
          mesg=msgbox({'Enough BLUE components were not detected!';'You may want to calibrate again.'},'BLUE Alert');
     else
     Bm=zeros(3);
     b1=0;
     mesg=msgbox({'BLUE was Not detected at all';'You may want to calibrate again.'},'BLUE Alert');
     end
 end
 
 if lc>min_pix
 else if lc>0
          mesg=msgbox({'Enough CYAN components were not detected!';'You may want to calibrate again.'},'CYAN Alert');
     else
     Cm=zeros(3);
     c1=0;
     mesg=msgbox({'CYAN was Not detected at all';'You may want to calibrate again.'},'CYAN Alert');
     end
 end
 
 if ly>min_pix
 else if ly>0
          mesg=msgbox({'Enough YELLOW components were not detected!';'You may want to calibrate again.'},'YELLOW Alert');
     else
     Ym=zeros(3);
     y1=0;
     mesg=msgbox({'YELLOW was Not detected at all';'You may want to calibrate again.'},'YELLOW Alert');
     end
 end
 
 if lm>min_pix
 else if lm>0
          mesg=msgbox({'Enough MAGENTA components were not detected!';'You may want to calibrate again.'},'MAGENTA Alert');
     else
     Mm=zeros(3);
     m1=0;
     mesg=msgbox({'MAGENTA was Not detected at all';'You may want to calibrate again.'},'MAGENTA Alert');
     end
 end
 
     
        Rmn=(Rm(1)+Rm(2)+Rm(3))/3;
        Rratiog=Rm(2)/(Rm(1)+0.001);%///////////////////can be 0.05
        Rratiob=Rm(3)/(Rm(1)+0.001);
        Rgt=(Rratiog+0.01)/deng;
        Rbt=(Rratiob+0.01)/denb;
        
        Gmn=(Gm(1)+Gm(2)+Gm(3))/3;
        Gratiog=Gm(2)/(Gm(1)+0.001);
        Gratiob=Gm(3)/(Gm(1)+0.001);
        Ggt=(Gratiog+0.01)/deng;
        Gbt=(Gratiob+0.01)/denb;
        
        Bmn=(Bm(1)+Bm(2)+Bm(3))/3;
        Bratiog=Bm(2)/(Bm(1)+0.001);
        Bratiob=Bm(3)/(Bm(1)+0.001);
        Bgt=(Bratiog+0.01)/deng;
        Bbt=(Bratiob+0.01)/denb;
        
               
        Cmn= (Cm(1)+Cm(2)+Cm(3))/3;
        Cratiog=Cm(2)/(Cm(1)+0.001);
        Cratiob=Cm(3)/(Cm(1)+0.001);
        Cgt=(Cratiog+0.01)/deng;
        Cbt=(Cratiob+0.01)/denb;
        
        Ymn= (Ym(1)+Ym(2)+Ym(3))/3;
        Yratiog=  Ym(2)/(Ym(1)+0.001);
        Yratiob=  Ym(3)/(Ym(1)+0.001);
        Ygt=     (Yratiog+0.01)/deng;
        Ybt=     (Yratiob+0.01)/denb;
        
               
        Mmn= (Mm(1)+Mm(2)+Mm(3))/3;
        Mratiog=Mm(2)/(Mm(1)+0.001);
        Mratiob=Mm(3)/(Mm(1)+0.001);
        Mgt=(Mratiog+0.01)/deng;
        Mbt=(Mratiob+0.01)/denb;
        
            
 end   
handles.permission='y';

handles.permission=inputdlg('Want the Detection to Begin?','Alert!',1);

if (strcmp(handles.permission,'y')==1)
if handles.cam_on==0
vid=imaq.VideoDevice('winvideo',1);
set(vid.DeviceProperties,'Brightness',60);
set(vid.DeviceProperties,'Saturation',100);
handles.cam_on=1;
%preview(vid);
handles.vid=vid;
%guidata(hObject,handles);
end

%CONSTANTS
th=0.3;
n=1000;
st=3;
brightness=0.2;
erodesize=10;
se=strel('square',erodesize);

i=step(vid);
[x,u,z]=size(i);
profile on
for c=1:n
          
           i=step(vid);
           bg=zeros(x,u,z);
           ind=0;
           axes(handles.axes9);
           %im=handles.iavg;
           imshow(i);
      

           for c1=1:st:x
      
                  for c2=1:st:u
                          if (abs(i(c1,c2,1)-iavg(c1,c2,1))>th)||(abs(i(c1,c2,2)-iavg(c1,c2,2))>th)||(abs(i(c1,c2,3)-iavg(c1,c2,3))>th)
                                     bg(c1:(c1+st-1),c2:(c2+st-1),1)=i(c1,c2,1);
                                     bg(c1:(c1+st-1),c2:(c2+st-1),2)=i(c1,c2,2);
                                     bg(c1:(c1+st-1),c2:(c2+st-1),3)=i(c1,c2,3);
                          end;
        
                   end;
           end;
           imshow(bg);
      bgcalc=zeros(x,u,z);
            
      for c1=1:st:x
             for c2=1:st:u
	              bgcalc(c1,c2,1)=(bg(c1,c2,1)+bg(c1,c2,2)+bg(c1,c2,3))/3;
	              bgcalc(c1,c2,2)=bg(c1,c2,2)/(bg(c1,c2,1)+0.001); 
	              bgcalc(c1,c2,3)=bg(c1,c2,3)/(bg(c1,c2,1)+0.001);
             end
      end
      
      %DETECTION
      d=zeros(x,u);
                     if r1==1
                     for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Rmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Rratiog)<Rgt)&&(abs(bgcalc(c1,c2,3)-Rratiob)<Rbt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+1;
                         end
                     end
                     end
                     
        
         
         d=zeros(x,u);
                     if g1==1
                     for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Gmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Gratiog)<Ggt)&&(abs(bgcalc(c1,c2,3)-Gratiob)<Gbt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+2;
                         end
                     end
                     end
         
           d=zeros(x,u); 
           if b1==1
                      for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Bmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Bratiog)<Bgt)&&(abs(bgcalc(c1,c2,3)-Bratiob)<Bbt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+4;
                         end
                     end
           end
             d=zeros(x,u);        
              if c1==1
                  for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Cmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Cratiog)<Cgt)&&(abs(bgcalc(c1,c2,3)-Cratiob)<Cbt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+8;
                         end
                     end
              end
              
              d=zeros(x,u);
              if y1==1
                  for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Ymn)<brightness)&&(abs(bgcalc(c1,c2,2)-Yratiog)<Ygt)&&(abs(bgcalc(c1,c2,3)-Yratiob)<Ybt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+16;
                         end
                     end
              end
              
              d=zeros(x,u);
              if m1==1
                      for c1=1:st:x
                           for c2=1:st:u
	                             if (abs(bgcalc(c1,c2,1)-Mmn)<brightness)&&(abs(bgcalc(c1,c2,2)-Mratiog)<Mgt)&&(abs(bgcalc(c1,c2,3)-Mratiob)<Mbt)
    		                             d(c1:(c1+st-1),c2:(c2+st-1))=1;
           		                 end;
                           end;
                     end;
                     if d==0
                     else
                         e=imerode(d,se);
                         if e==0
                         else ind=ind+32;
                         end
                     end
              end
                     
 switch ind
     case 0
         update(0);
     case 1
         update(1);
     case 4
         update(4);
     case 9 
         update(9);
     case 40
         update(40);
     case 13
         update(13);
     
     case 20
         update(20);
     case 41
         update(41);
     case 16
         update(16);
        
 end
  update(ind);
 ind
   % set(handles.text3,'String',num2str(ind));             
end
profile off
update(0);
handles.profile_done=1;
guidata(hObject,handles);
else msgbox('Fine. Thank You. Bye','Note',1);
end
%closepreview;
release(vid);
handles.cam_on=0;
end



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.profile_done==1
    profile report
else msgbox('Please Run a function.Only then a profile can be created.','Error',2);
end
end


% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes9
end




% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end




% --- Executes during object creation, after setting all properties.
function axes15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes15
axes(hObject);
imshow('bg.jpg');
text(150,250,'Display','FontWeight','bold','FontUnits','pixels','FontSize',15);
end
