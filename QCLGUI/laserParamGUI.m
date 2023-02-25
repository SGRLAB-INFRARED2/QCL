function varargout = laserParamGUI(varargin)
% LASERPARAMGUI MATLAB code for laserParamGUI.fig
%      LASERPARAMGUI, by itself, creates a new LASERPARAMGUI or raises the existing
%      singleton*.
%
%      H = LASERPARAMGUI returns the handle to a new LASERPARAMGUI or the handle to
%      the existing singleton*.
%
%      LASERPARAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LASERPARAMGUI.M with the given input arguments.
%
%      LASERPARAMGUI('Property','Value',...) creates a new LASERPARAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before laserParamGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to laserParamGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help laserParamGUI

% Last Modified by GUIDE v2.5 12-Apr-2019 17:52:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @laserParamGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @laserParamGUI_OutputFcn, ...
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


% --- Executes just before laserParamGUI is made visible.
function laserParamGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to laserParamGUI (see VARARGIN)
global QCLLaser
% numQCLs = QCLLaser.numQCLs;
numQCLs = 2;

set(hObject, 'Units', 'character');
set(hObject, 'Position', [hObject.Position(1) hObject.Position(2) numQCLs*45 25])

handleLabels = {'pulseRate', 'pulseWidth', 'dutyCycle'};
labelList = {'Pulse Rate (Hz):','Pulse Width (ns):', 'Duty Cycle:'};


for ii = 1:numQCLs
    handles.(['panelQCL' num2str(ii)]) = uipanel('Title',sprintf('QCL %i', ii),'FontSize',14,'Units', 'characters',...
        'Position',[(ii-1)*45 5 45 20]);
    for jj = 1:length(handleLabels)
        handles.([handleLabels{jj} 'LabelQCL' num2str(ii)]) = uicontrol(handles.(['panelQCL' num2str(ii)]), 'Style', 'text',...
            'String', labelList{jj}, 'FontSize', 11, 'Units', handles.(['panelQCL' num2str(ii)]).Units,...
            'Position', [0 (18-(jj)*3) 27 1.5],...
            'ForegroundColor', 'black', 'HorizontalAlignment', 'right');
        
%         num2str(QCLLaser.QCLs{ii}.(handleLabels{jj})
        handles.([handleLabels{jj} 'ValueQCL' num2str(ii)]) = uicontrol(handles.(['panelQCL' num2str(ii)]), 'Style', 'edit', ...
            'String', num2str(QCLLaser.QCLs{ii}.(handleLabels{jj})) , 'FontSize', 11, ...
            'Units', handles.(['panelQCL' num2str(ii)]).Units, 'Position', [28 (17.9-(jj)*3) 14 1.5], ...
            'ForegroundColor', 'black');
    end
    set(handles.(['dutyCycleValueQCL' num2str(ii)]), 'Enable', 'inactive');
    
    handles.(['bgQCL' num2str(ii)]) = uibuttongroup(handles.(['panelQCL' num2str(ii)]), ...
        'Units', handles.(['panelQCL' num2str(ii)]).Units, ...
        'Position', [0 0 45 18-(length(handleLabels))*3-1], 'Title', 'Mode', 'FontSize', 11);
    
    handles.(['modeTogglePulsedQCL' num2str(ii)]) = uicontrol(handles.(['bgQCL' num2str(ii)]),...
        'Style', 'radiobutton', 'String', 'Pulsed', 'FontSize', 11,...
        'Units', handles.(['bgQCL' num2str(ii)]).Units,...
        'Position', [3 handles.(['bgQCL' num2str(ii)]).Position(4)-4 40 1.5]);
    
end

handles.buttonPanel =  uipanel('Units', 'characters',...
    'Position',[0 0 numQCLs*45 5]);

handles.pbSetParams = uicontrol(handles.buttonPanel, 'Style', 'pushbutton',...
    'Units', 'characters', 'String', 'Set Parameters', 'FontSize', 11,...
    'Position', [handles.buttonPanel.Position(3)/2-25-2 handles.buttonPanel.Position(4)/2-1.5 25 3],...
    'Callback', @(hObject,eventdata)laserParamGUI('pbSetParams_Callback',hObject,eventdata,guidata(hObject)));

handles.pbCloseWindow = uicontrol(handles.buttonPanel, 'Style', 'pushbutton',...
    'Units', 'characters', 'String', 'Close', 'FontSize', 11,...
    'Position', [handles.buttonPanel.Position(3)/2+2 handles.buttonPanel.Position(4)/2-1.5 25 3],...
    'Callback', @(hObject,eventdata)laserParamGUI('pbCloseWindow_Callback',hObject,eventdata,guidata(hObject)));




% Choose default command line output for laserParamGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes laserParamGUI wait for user response (see UIRESUME)
% uiwait(handles.laserParamFig);


% --- Outputs from this function are returned to the command line.
function varargout = laserParamGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function pbSetParams_Callback(hObject, eventdata, handles)
global QCLLaser

for ii = 1:QCLLaser.numQCLs
    pulseRate = str2double(get(handles.(['pulseRateValueQCL' num2str(ii)]), 'String'));
    pulseWidth = str2double(get(handles.(['pulseWidthValueQCL' num2str(ii)]), 'String'));
    current = QCLLaser.QCLs{ii}.current;
    
    if isnan(pulseRate) || mod(pulseRate, 1) ~= 0 || pulseRate <= 0
        ret = 86;
        msgID = 'USER_ERROR:PULSE_RATE_NUMERIC_ERROR';
        msgtext = 'Error Code: %d \nPulse rate must be a postive integer';
        
        ME = MException(msgID,msgtext,ret);
        opts = struct('WindowStyle','modal', 'Interpreter','tex');
        errordlg(strcat('\fontsize{12}',ME.message), ME.identifier, opts);
        break
    elseif isnan(pulseWidth) || mod(pulseWidth, 1) ~= 0 || pulseWidth <= 0
        ret = 87;
        msgID = 'USER_ERROR:PULSE_WIDTH_NUMERIC_ERROR';
        msgtext = 'Error Code: %d \nPulse width must be a postive integer'
        
        ME = MException(msgID,msgtext,ret);
        opts = struct('WindowStyle','modal', 'Interpreter','tex');
        errordlg(strcat('\fontsize{12}',ME.message), ME.identifier, opts);
        break
    else
        QCLLaser.QCLs{ii}.setQCLParams(pulseRate, pulseWidth, current);
    end
    if ii == QCLLaser.numQCLs
        CreateStruct.Interpreter = 'tex';
        CreateStruct.WindowStyle = 'modal';
        msgbox('\fontsize{12}QCL parameters successfully changed!', 'Success!', 'help', CreateStruct);
    end
end

for ii = 1:QCLLaser.numQCLs
    set(handles.(['pulseRateValueQCL' num2str(ii)]), 'String', QCLLaser.QCLs{ii}.pulseRate);
    set(handles.(['pulseWidthValueQCL' num2str(ii)]), 'String', QCLLaser.QCLs{ii}.pulseWidth);
    set(handles.(['dutyCycleValueQCL' num2str(ii)]), 'String', QCLLaser.QCLs{ii}.dutyCycle);
end


function pbCloseWindow_Callback(hObject, eventdata, handles)
close;
