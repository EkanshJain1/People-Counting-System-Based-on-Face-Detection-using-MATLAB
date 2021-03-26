function varargout = FACECOUNTER(varargin)
% FACECOUNTER MATLAB code for FACECOUNTER.fig
%      FACECOUNTER, by itself, creates a new FACECOUNTER or raises the existing
%      singleton*.
%
%      H = FACECOUNTER returns the handle to a new FACECOUNTER or the handle to
%      the existing singleton*.
%
%      FACECOUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACECOUNTER.M with the given input arguments.
%
%      FACECOUNTER('Property','Value',...) creates a new FACECOUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FACECOUNTER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FACECOUNTER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FACECOUNTER

% Last Modified by GUIDE v2.5 20-Apr-2020 13:51:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FACECOUNTER_OpeningFcn, ...
                   'gui_OutputFcn',  @FACECOUNTER_OutputFcn, ...
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


% --- Executes just before FACECOUNTER is made visible.
function FACECOUNTER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FACECOUNTER (see VARARGIN)

% Choose default command line output for FACECOUNTER
handles.output = hObject;
axes(handles.axes1);
imshow('blank1.jpg');
axis off;
set(handles.text2,'string','COUNT WILL BE SHOWN HERE');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FACECOUNTER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FACECOUNTER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid     % making the variable global
vid = videoinput('winvideo' , 1, 'YUY2_640X480');% Create a video input with YUY2 format and 640X480 resolution


% --- Executes on button press in FACECOUNTER.
function count_Callback(hObject, eventdata, handles)
% hObject    handle to FACECOUNTER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid     

% Set the parameters for video
triggerconfig( vid ,'manual');                                      % the trigger occurs only after the trigger function
set(vid, 'FramesPerTrigger',1);                                     % one frame acquired per trigger
set(vid, 'TriggerRepeat',Inf);                                      % Keep executing the trigger every time the trigger condition is met until the stop function is called 
set(vid,'ReturnedColorSpace','rgb');                                % to get the rgb colour image 
vid.Timeout = 10;
start(vid);  

while (1)  
facedetector = vision.CascadeObjectDetector;                                % Create a cascade detector object                                              
trigger(vid);                                                               %trigger to get the frame from the video
image = getdata(vid);                                                       %store that frame in 'image'
bbox = step(facedetector, image);                                           % position of face in 'bbox' (x, y, width and height)
insert_object = insertObjectAnnotation(image,'rectangle',bbox,'Face');      % Draw the bounding box around the detected face.
imshow(insert_object);
axis off;                                                                   % invisible the axis from GUI
no_block = size(bbox,1);                                                     % get the number of rows (which will be equal to number of people)
X = sprintf('%d', no_block);
set(handles.text2,'string',X);                                              %display the value of X in GUI
end



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
stop(vid),clear vid %stop the running video
