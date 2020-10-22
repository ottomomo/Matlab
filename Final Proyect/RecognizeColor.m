function varargout = RecognizeColor(varargin)
% RECOGNIZECOLOR MATLAB code for RecognizeColor.fig
%      RECOGNIZECOLOR, by itself, creates a new RECOGNIZECOLOR or raises the existing
%      singleton*.
%
%      H = RECOGNIZECOLOR returns the handle to a new RECOGNIZECOLOR or the handle to
%      the existing singleton*.
%
%      RECOGNIZECOLOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNIZECOLOR.M with the given input arguments.
%
%      RECOGNIZECOLOR('Property','Value',...) creates a new RECOGNIZECOLOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RecognizeColor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RecognizeColor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RecognizeColor

% Last Modified by GUIDE v2.5 26-Jun-2019 23:35:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RecognizeColor_OpeningFcn, ...
                   'gui_OutputFcn',  @RecognizeColor_OutputFcn, ...
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


% --- Executes just before RecognizeColor is made visible.
function RecognizeColor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RecognizeColor (see VARARGIN)

% Choose default command line output for RecognizeColor
handles.output = hObject;

global cButton;
cButton = 1;
global  colorThreshold;
colorThreshold=zeros(3,6);
colorThreshold(1,1)=3;
colorThreshold(1,2)=178;
colorThreshold(1,3)=58;
colorThreshold(1,4)=255;
colorThreshold(1,5)=0;
colorThreshold(1,6)=150;
colorThreshold(2,1)=30;
colorThreshold(2,2)=160;
colorThreshold(2,3)=11;
colorThreshold(2,4)=140;
colorThreshold(2,5)=40;
colorThreshold(2,6)=198;
colorThreshold(3,1)=28;
colorThreshold(3,2)=160;
colorThreshold(3,3)=0;
colorThreshold(3,4)=97;
colorThreshold(3,5)=0;
colorThreshold(3,6)=48;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RecognizeColor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RecognizeColor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openimagebutton.
function openimagebutton_Callback(hObject, eventdata, handles)
% hObject    handle to openimagebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_handle;
[file,dir]=uigetfile('*.jpg','Select image to open');
if isequal(file,0)
else 
    img_handle = imread(fullfile(dir,file));
    myImg=img_handle;
    imshow(myImg,'Parent',handles.image);
    
end

% --- Executes on button press in detectbutton.
function detectbutton_Callback(hObject, eventdata, handles)
% hObject    handle to detectbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cButton;
global colorThreshold;
global img_handle;
% handles.myImage=get(handles.image,'Children');
% img=get(handles.myImage, 'CData');
img=img_handle;

% EyeDetect = vision.CascadeObjectDetector('EyePairBig');
% BB=step(EyeDetect,img);
% rectangle('Position',BB(1:4),'LineWidth',4,'LineStyle','-','EdgeColor','b');
% Eyes =imcrop(img,BB(1:4));

Igray = rgb2gray(img);
[centers,radii] = imfindcircles (img, [fix(size(Igray,1)/15) fix(size(Igray,1)/6)],'ObjectPolarity',...
'dark','Sensitivity',0.9);
viscircles(centers,radii);
Icrop = imcrop(img,[centers(1,1)-radii(1) centers(1,2)-radii(1) radii(1)*2 radii(1)*2]);
imshow(Icrop,'Parent',handles.cropImage)

% rlow = get(handles.redlow,'Value');
% rhigh = get(handles.redhigh,'Value');
% glow = get(handles.greenlow,'Value');
% ghigh = get(handles.greenhigh,'Value');
% blow = get(handles.bluelow,'Value');
% bhigh = get(handles.bluehigh,'Value');
if(get(handles.greenbutton, 'Value') > 0)
    cButton=1;
elseif(get(handles.bluebutton, 'Value') > 0 )
    cButton=2;
elseif(get(handles.brownbutton, 'Value') > 0)
    cButton=3;
end
color = recogniseColor(Icrop, colorThreshold, cButton);
if (color==1)
    r="Green eyed";
elseif(color==2)
        r="Blue eyed";
else
        r="Brown eyed";
end
set(handles.resultText,'String', r);

% --- Executes on slider movement.
function redlow_Callback(hObject, eventdata, handles)
% hObject    handle to redlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.rlowvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,1)=r;

% We have a problem with global variable, we need to ask
% colorThreshold(cButton,1)=r;

% --- Executes during object creation, after setting all properties.
function redlow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function redhigh_Callback(hObject, eventdata, handles)
% hObject    handle to redhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.rhighvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,2)=r;

% --- Executes during object creation, after setting all properties.
function redhigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function greenlow_Callback(hObject, eventdata, handles)
% hObject    handle to greenlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.glowvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,3)=r;

% --- Executes during object creation, after setting all properties.
function greenlow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function greenhigh_Callback(hObject, eventdata, handles)
% hObject    handle to greenhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.ghighvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,4)=r;

% --- Executes during object creation, after setting all properties.
function greenhigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bluelow_Callback(hObject, eventdata, handles)
% hObject    handle to bluelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.blowvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,5)=r;

% --- Executes during object creation, after setting all properties.
function bluelow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bluelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function bluehigh_Callback(hObject, eventdata, handles)
% hObject    handle to bluehigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
r = get(hObject,'Value');
set(handles.bhighvalue,'String',num2str(r));
global colorThreshold;
global cButton;
colorThreshold(cButton,6)=r;

% --- Executes during object creation, after setting all properties.
function bluehigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bluehigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in greenbutton.
function greenbutton_Callback(hObject, eventdata, handles)
% hObject    handle to greenbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cButton;
global colorThreshold;
% Hint: get(hObject,'Value') returns toggle state of greenbutton
cButton = 1;
set(handles.greenbutton,'Value',1);
set(handles.bluebutton,'Value',0);
set(handles.brownbutton,'Value',0);

set(handles.redlow,'Value',colorThreshold(cButton,1));
set(handles.redhigh,'Value',colorThreshold(cButton,2));
set(handles.greenlow,'Value',colorThreshold(cButton,3));
set(handles.greenhigh,'Value',colorThreshold(cButton,4));
set(handles.bluelow,'Value',colorThreshold(cButton,5));
set(handles.bluehigh,'Value',colorThreshold(cButton,6));
% set(handles.redlow,'Value',3);
% set(handles.redhigh,'Value',178);
% set(handles.greenlow,'Value',58);
% set(handles.greenhigh,'Value',255);
% set(handles.bluelow,'Value',0);
% set(handles.bluehigh,'Value',150);

% set(handles.rlowvalue,'String',"3");
% set(handles.rhighvalue,'String',"178");
% set(handles.glowvalue,'String',"58");
% set(handles.ghighvalue,'String',"255");
% set(handles.blowvalue,'String',"0");
% set(handles.bhighvalue,'String',"150");
set(handles.rlowvalue,'String',num2str(colorThreshold(cButton,1)));
set(handles.rhighvalue,'String',num2str(colorThreshold(cButton,2)));
set(handles.glowvalue,'String',num2str(colorThreshold(cButton,3)));
set(handles.ghighvalue,'String',num2str(colorThreshold(cButton,4)));
set(handles.blowvalue,'String',num2str(colorThreshold(cButton,5)));
set(handles.bhighvalue,'String',num2str(colorThreshold(cButton,6)));


% --- Executes on button press in bluebutton.
function bluebutton_Callback(hObject, eventdata, handles)
% hObject    handle to bluebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of bluebutton
global cButton;
global colorThreshold;

cButton = 2;
set(handles.greenbutton,'Value',0);
set(handles.bluebutton,'Value',1);
set(handles.brownbutton,'Value',0);

set(handles.redlow,'Value',colorThreshold(cButton,1));
set(handles.redhigh,'Value',colorThreshold(cButton,2));
set(handles.greenlow,'Value',colorThreshold(cButton,3));
set(handles.greenhigh,'Value',colorThreshold(cButton,4));
set(handles.bluelow,'Value',colorThreshold(cButton,5));
set(handles.bluehigh,'Value',colorThreshold(cButton,6));
% set(handles.redlow,'Value',30);
% set(handles.redhigh,'Value',160);
% set(handles.greenlow,'Value',11);
% set(handles.greenhigh,'Value',140);
% set(handles.bluelow,'Value',40);
% set(handles.bluehigh,'Value',198);

% set(handles.rlowvalue,'String',"30");
% set(handles.rhighvalue,'String',"160");
% set(handles.glowvalue,'String',"11");
% set(handles.ghighvalue,'String',"140");
% set(handles.blowvalue,'String',"40");
% set(handles.bhighvalue,'String',"198");
set(handles.rlowvalue,'String',num2str(colorThreshold(cButton,1)));
set(handles.rhighvalue,'String',num2str(colorThreshold(cButton,2)));
set(handles.glowvalue,'String',num2str(colorThreshold(cButton,3)));
set(handles.ghighvalue,'String',num2str(colorThreshold(cButton,4)));
set(handles.blowvalue,'String',num2str(colorThreshold(cButton,5)));
set(handles.bhighvalue,'String',num2str(colorThreshold(cButton,6)));


% --- Executes on button press in brownbutton.
function brownbutton_Callback(hObject, eventdata, handles)
% hObject    handle to brownbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of brownbutton
global cButton;
global colorThreshold;

cButton = 3;
set(handles.greenbutton,'Value',0);
set(handles.bluebutton,'Value',0);
set(handles.brownbutton,'Value',1);

set(handles.redlow,'Value',colorThreshold(cButton,1));
set(handles.redhigh,'Value',colorThreshold(cButton,2));
set(handles.greenlow,'Value',colorThreshold(cButton,3));
set(handles.greenhigh,'Value',colorThreshold(cButton,4));
set(handles.bluelow,'Value',colorThreshold(cButton,5));
set(handles.bluehigh,'Value',colorThreshold(cButton,6));
% set(handles.redlow,'Value',28);
% set(handles.redhigh,'Value',160);
% set(handles.greenlow,'Value',0);
% set(handles.greenhigh,'Value',97);
% set(handles.bluelow,'Value',0);
% set(handles.bluehigh,'Value',48);

% set(handles.rlowvalue,'String',"28");
% set(handles.rhighvalue,'String',"160");
% set(handles.glowvalue,'String',"0");
% set(handles.ghighvalue,'String',"97");
% set(handles.blowvalue,'String',"0");
% set(handles.bhighvalue,'String',"48");
set(handles.rlowvalue,'String',num2str(colorThreshold(cButton,1)));
set(handles.rhighvalue,'String',num2str(colorThreshold(cButton,2)));
set(handles.glowvalue,'String',num2str(colorThreshold(cButton,3)));
set(handles.ghighvalue,'String',num2str(colorThreshold(cButton,4)));
set(handles.blowvalue,'String',num2str(colorThreshold(cButton,5)));
set(handles.bhighvalue,'String',num2str(colorThreshold(cButton,6)));

% --- Executes on button press in default.
function default_Callback(hObject, eventdata, handles)
% hObject    handle to default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cButton;
global colorThreshold;
% if(get(handles.greenbutton, 'Value') > 0)
cButton = 1;
set(handles.greenbutton,'Value',1);
set(handles.bluebutton,'Value',0);
set(handles.brownbutton,'Value',0);

set(handles.redlow,'Value',3);
set(handles.redhigh,'Value',178);
set(handles.greenlow,'Value',58);
set(handles.greenhigh,'Value',255);
set(handles.bluelow,'Value',0);
set(handles.bluehigh,'Value',150);

colorThreshold(1,1)=3;
colorThreshold(1,2)=178;
colorThreshold(1,3)=58;
colorThreshold(1,4)=255;
colorThreshold(1,5)=0;
colorThreshold(1,6)=150;

set(handles.rlowvalue,'String',"3");
set(handles.rhighvalue,'String',"178");
set(handles.glowvalue,'String',"58");
set(handles.ghighvalue,'String',"255");
set(handles.blowvalue,'String',"0");
set(handles.bhighvalue,'String',"150");

% elseif(get(handles.bluebutton, 'Value') > 0 )
% cButton = 2;
% set(handles.greenbutton,'Value',0);
% set(handles.bluebutton,'Value',1);
% set(handles.brownbutton,'Value',0);

% set(handles.redlow,'Value',30);
% set(handles.redhigh,'Value',160);
% set(handles.greenlow,'Value',11);
% set(handles.greenhigh,'Value',140);
% set(handles.bluelow,'Value',40);
% set(handles.bluehigh,'Value',198);

colorThreshold(2,1)=30;
colorThreshold(2,2)=160;
colorThreshold(2,3)=11;
colorThreshold(2,4)=140;
colorThreshold(2,5)=40;
colorThreshold(2,6)=198;

% set(handles.rlowvalue,'String',"30");
% set(handles.rhighvalue,'String',"160");
% set(handles.glowvalue,'String',"11");
% set(handles.ghighvalue,'String',"140");
% set(handles.blowvalue,'String',"40");
% set(handles.bhighvalue,'String',"198");

% elseif(get(handles.brownbutton, 'Value') > 0)
% cButton = 3;
% set(handles.greenbutton,'Value',0);
% set(handles.bluebutton,'Value',0);
% set(handles.brownbutton,'Value',1);

% set(handles.redlow,'Value',28);
% set(handles.redhigh,'Value',160);
% set(handles.greenlow,'Value',0);
% set(handles.greenhigh,'Value',97);
% set(handles.bluelow,'Value',0);
% set(handles.bluehigh,'Value',48);

colorThreshold(3,1)=28;
colorThreshold(3,2)=160;
colorThreshold(3,3)=0;
colorThreshold(3,4)=97;
colorThreshold(3,5)=0;
colorThreshold(3,6)=48;

% set(handles.rlowvalue,'String',"28");
% set(handles.rhighvalue,'String',"160");
% set(handles.glowvalue,'String',"0");
% set(handles.ghighvalue,'String',"97");
% set(handles.blowvalue,'String',"0");
% set(handles.bhighvalue,'String',"48");
%end


% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function quitMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to quitMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit();

% --------------------------------------------------------------------
function quitWindow_Callback(hObject, eventdata, handles)
% hObject    handle to quitWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --- Executes on button press in intensity.
function intensity_Callback(hObject, eventdata, handles)
% hObject    handle to intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_handle;
img=img_handle;

% EyeDetect = vision.CascadeObjectDetector('EyePairBig');
% BB=step(EyeDetect,img);
% rectangle('Position',BB(1:4),'LineWidth',4,'LineStyle','-','EdgeColor','b');
% Eyes =imcrop(img,BB(1:4));

Igray = rgb2gray(img);
[centers,radii] = imfindcircles (img, [fix(size(Igray,1)/15) fix(size(Igray,1)/6)],'ObjectPolarity',...
'dark','Sensitivity',0.9);
viscircles(centers,radii);
Icrop = imcrop(img,[centers(1,1)-radii(1) centers(1,2)-radii(1) radii(1)*2 radii(1)*2]);
imshow(Icrop,'Parent',handles.cropImage)
set(handles.helpText,'String','<------ DRAW A LINE <---- OVER THE EYE <------- AND THEN DOUBLE CLICK!! <--------------------- <-----------------------');
improfile
set(handles.helpText,'String','');
