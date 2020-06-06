function varargout = BTDapp(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BTDapp_OpeningFcn, ...
                   'gui_OutputFcn',  @BTDapp_OutputFcn, ...
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


% --- Executes just before BTDapp is made visible.
function BTDapp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BTDapp (see VARARGIN)

% Choose default command line output for BTDapp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BTDapp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BTDapp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global checking;
checking = 0;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1 ;
global checking
[path,nofile] = imgetfile();

if nofile 
    msgbox(sprintf('Image not found !!!!'),'Error','Warning');
    checking = 0; 
    return
end

img1 = imread(path);

axes(handles.axes1);
imshow(img1);
checking = 1;
title('\fontsize{15}\color[rgb]{0.996,0.592,0.0} Original image')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global checking;
global img1;
if (checking == 0)
     msgbox(sprintf('Image not found !!!!'),'Error','Warning');
    return
end
    
im = img1;
[rows, columns, numberOfColorChannels] = size(im);

im = im2double(im).^3;

if numberOfColorChannels > 1
    % It's a true color RGB image.  We need to convert to gray scale.
    im = rgb2gray(im);
else
    % It's already gray scale.  No need to convert.
    im = im;
end

im = medianfilter(im);
axes(handles.axes2);
imshow(im,[])
title('\fontsize{15}\color[rgb]{0.996,0.592,0.0} Preprocessing image')



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img1
global checking
if (checking == 0)
     msgbox(sprintf('Image not found or did not chosed !!!!'),'Error','Warning');
    return
end
[numberofTumours maxDiameter position] = Project(img1);

    axes(handles.axes3);
    detectedTumor = imread('detected_tumor.jpg');
    imshow(detectedTumor)
    title('\fontsize{15}\color[rgb]{0.996,0.592,0.0} Final image')
    
