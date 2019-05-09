function varargout = QCLGUITest1(varargin)
% QCLGUITEST1 MATLAB code for QCLGUITest1.fig
%      QCLGUITEST1, by itself, creates a new QCLGUITEST1 or raises the existing
%      singleton*.
%
%      H = QCLGUITEST1 returns the handle to a new QCLGUITEST1 or the handle to
%      the existing singleton*.
%
%      QCLGUITEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QCLGUITEST1.M with the given input arguments.
%
%      QCLGUITEST1('Property','Value',...) creates a new QCLGUITEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QCLGUITest1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QCLGUITest1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QCLGUITest1

% Last Modified by GUIDE v2.5 13-Dec-2018 19:18:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @QCLGUITest1_OpeningFcn, ...
    'gui_OutputFcn',  @QCLGUITest1_OutputFcn, ...
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


% --- Executes just before QCLGUITest1 is made visible.
function QCLGUITest1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QCLGUITest1 (see VARARGIN)

global QCLLaser timerObject cr1 cr2;

% Initialize our custom cell renderer class object
javaaddpath(strcat(fileparts(mfilename('fullpath')), '\ColoredFieldCellRenderer.zip'));
cr1 = ColoredFieldCellRenderer(java.awt.Color.white);
cr2 = ColoredFieldCellRenderer(java.awt.Color(240/255, 240/255, 240/255));

QCLLaser = [];

try
    QCLLaser = QCL;
catch
    warning('SGRLAB:SimulationMode','QCL not Initialized');
end

set(handles.QCLInfoTable,'Data',cell(3,3));
set(handles.QCLInfoTable, 'RowName', {'QCL 1', 'QCL 2', 'QCL 3'});

updateQCLInfo(handles);

timerObject = timer('TimerFcn',{@updateQCLInfoTimer, handles},'ExecutionMode','fixedRate',...
                    'Period',0.5);
start(timerObject);

movegui('center');

% Choose default command line output for QCLGUITest1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QCLGUITest1 wait for user response (see UIRESUME)
% uiwait(handles.QCLController);


% --- Outputs from this function are returned to the command line.
function varargout = QCLGUITest1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pbEmissionOnOff.
function pbEmissionOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to pbEmissionOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isEmissionOn
    set(handles.pbEmissionOnOff, 'String', 'Turning Emission On', 'BackgroundColor', 'yellow');
    turnEmissionOn;
    while ~isEmissionOn
        pause(0.5);
    end
    if isEmissionOn
        set(handles.pbEmissionOnOff, 'String', 'Turn Emission Off', 'BackgroundColor', 'green');
        set(handles.emissionStatusText, 'BackgroundColor', 'green');
    end
else
    turnEmissionOff;
    if ~isEmissionOn
        set(handles.pbEmissionOnOff, 'String', 'Turn Emission On', 'BackgroundColor', [0.94 0.94 0.94]);
        set(handles.emissionStatusText, 'BackgroundColor', 'red');
    end
end



function wavelengthTextEdit_Callback(hObject, eventdata, handles)
% hObject    handle to wavelengthTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavelengthTextEdit as text
%        str2double(get(hObject,'String')) returns contents of wavelengthTextEdit as a double


% --- Executes during object creation, after setting all properties.
function wavelengthTextEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelengthTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pumUnits.
function pumUnits_Callback(hObject, eventdata, handles)
% hObject    handle to pumUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumUnits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumUnits


% --- Executes during object creation, after setting all properties.
function pumUnits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbTuneQCL.
function pbTuneQCL_Callback(hObject, eventdata, handles)
% hObject    handle to pbTuneQCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

wavelength = str2double(get(handles.wavelengthTextEdit, 'String'));
unitsArray = get(handles.pumUnits, 'String');
unitsInd = get(handles.pumUnits, 'Value');
units = unitsArray{unitsInd};

QCLNum = whichQCLNum(wavelength, units);

if QCLNum == -1
    error('Error: WAVELENGTH OUT OF RANGE');
else
    tuneQCL(wavelength, units, QCLNum);
end

while ~isQCLTuned
    pause(0.5);
end

if isQCLTuned
    set(handles.pbEmissionOnOff, 'Enable', 'on');
end



% --- Executes on button press in pbArmDisarmQCL.
function pbArmDisarmQCL_Callback(hObject, eventdata, handles)
% hObject    handle to pbArmDisarmQCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isLaserArmed
    set(handles.pbArmDisarmQCL, 'String', 'Arming Laser', 'BackgroundColor', 'yellow')
    armLaser;
    while ~isLaserArmed
        pause(1.0);
    end
    set(handles.pbArmDisarmQCL, 'String', 'Disarm Laser', 'BackgroundColor', 'green');
    while ~areTECsAtSetTemp
        pause(1);
    end
    
    if areTECsAtSetTemp
        set(handles.tempStatusText, 'BackgroundColor', 'green');
        set(handles.pbTuneQCL, 'Enable', 'on');
    end
else
    if isEmissionOn
        turnEmissionOff;
        set(handles.pbEmissionOnOff, 'String', 'Turn Emission On', 'BackgroundColor', [0.94 0.94 0.94]);
    end
    disarmLaser;
    set(handles.pbArmDisarmQCL, 'String', 'Arm Laser', 'BackgroundColor', [0.94 0.94 0.94]);
    set(handles.pbEmissionOnOff, 'Enable', 'off');
    set(handles.pbTuneQCL, 'Enable', 'off');
end

function QCLInfoTable_CreateFcn(hObject, eventdata, handles)



function disableArmDisarmButton(handles)
set(handles.pbTuneQCL, 'Enable', 'off');
set(handles.pbEmissionOnOff, 'Enable', 'off');
set(handles.pbArmDisarmQCL, 'Enable', 'off');

function updateQCLInfoTable(handles)
    global cr1 cr2;
    
    jScroll = findjobj(handles.QCLInfoTable);
    jTable = jScroll.getViewport.getView;
    jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    jTable.setForeground(java.awt.Color.black);
    
    numQCLs = getNumQCLs;
    
    QCLInfoData = cell(numQCLs, 3);
    
    activeQCL = getActiveQCL;
    
    for ii = 1:numQCLs
        bQcl = ii;
        
        QCLInfoData{ii, 1} = sprintf('%2.3f', getQCLTemp(bQcl));
        QCLInfoData{ii,3} = num2str(getTECCurrent(bQcl));
        
        if ii == activeQCL
            QCLInfoData{ii, 2} = sprintf('\tY');
            cr1.setCellBgColor(ii-1, 1, java.awt.Color.green);  
        else
            QCLInfoData{ii, 2} = sprintf('\tN');
            cr1.setCellBgColor(ii-1, 1, java.awt.Color.white); 
        end
    end
    
    jTable.setModel(javax.swing.table.DefaultTableModel(QCLInfoData,handles.QCLInfoTable.ColumnName));
%     set(handles.QCLInfoTable,'ColumnFormat', []);
    
    jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    jTable.setGridColor(java.awt.Color.gray);
    
    set(jScroll,'VerticalScrollBarPolicy',21);     

    for colIdx = 1 : length(handles.QCLInfoTable.ColumnName)
        jTable.getColumnModel.getColumn(colIdx-1).setCellRenderer(cr1);
%         jTable.getColumnModel.getColumn(colIdx-1).setHeaderRenderer(cr2);
    end
    
    jTable.getTableHeader().setOpaque(true);
    jTable.getTableHeader().setBackground(java.awt.Color.gray);
    
%     jTable.getTableHeader().setBorder(javax.swing.BorderFactory.createMatteBorder(0,0,1,0,java.awt.Color.black));
    


function updateQCLInfo(handles)

if isLaserConnected
    set(handles.connectedStatusText, 'BackgroundColor', 'green');
    if isKeySwitchSet
        set(handles.keySwitchStatusText, 'BackgroundColor', 'green');
        if isInterlockSet
            set(handles.interlockStatusText, 'BackgroundColor', 'green');
            set(handles.pbArmDisarmQCL, 'Enable', 'on');
        else
            set(handles.interlockStatusText, 'BackgroundColor', 'red');
            disableArmDisarmButton(handles);
        end
    else
        set(handles.keySwitchStatusText, 'BackgroundColor', 'red');
        set(handles.interlockStatusText, 'BackgroundColor', 'red');
        disableArmDisarmButton(handles);
    end        
else
    set(handles.connectedStatusText, 'BackgroundColor', 'red');
    set(handles.keySwitchStatusText, 'BackgroundColor', 'red');
    set(handles.interlockStatusText, 'BackgroundColor', 'red');
    disableArmDisarmButton(handles);
end

if areTECsAtSetTemp
    set(handles.tempStatusText, 'BackgroundColor', 'green');
    set(handles.pbTuneQCL, 'Enable', 'on');
else
    set(handles.tempStatusText, 'BackgroundColor', 'red');
    set(handles.pbTuneQCL, 'Enable', 'off');
end
    

updateQCLInfoTable(handles);

% fprintf('Timer is Working.\n')
% 
% % Choose default command line output for QCLGUITest1
% handles.output = hObject;
% 
% % Update handles structure
% guidata(hObject, handles);

function updateQCLInfoTimer(timer, hEvent, handles)
% fprintf('Timer is working\n');
updateQCLInfo(handles);



% --- Executes during object deletion, before destroying properties.
function QCLController_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to QCLController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global QCLLaser timerObject;
% 
% stop(timerObject);
% delete(timerObject);
% delete(QCLLaser);


% --- Executes when user attempts to close QCLController.
function QCLController_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to QCLController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global QCLLaser timerObject;

% stop(timerObject);
% delete(timerObject);
delete(QCLLaser);

% Hint: delete(hObject) closes the figure
delete(hObject);
clear java;
