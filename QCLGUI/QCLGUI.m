function varargout = QCLGUI(varargin)
% QCLGUI MATLAB code for QCLGUI.fig
%      QCLGUI, by itself, creates a new QCLGUI or raises the existing
%      singleton*.
%
%      H = QCLGUI returns the handle to a new QCLGUI or the handle to
%      the existing singleton*.
%
%      QCLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QCLGUI.M with the given input arguments.
%
%      QCLGUI('Property','Value',...) creates a new QCLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QCLGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QCLGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QCLGUI

% Last Modified by GUIDE v2.5 18-Mar-2019 20:23:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @QCLGUI_OpeningFcn, ...
    'gui_OutputFcn',  @QCLGUI_OutputFcn, ...
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


% --- Executes just before QCLGUI is made visible.
function QCLGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QCLGUI (see VARARGIN)

global QCLLaser timerObject guiUnits prefQCL;

QCLLaser = [];

guiUnits = 'cm-1';

prefQCL = 1;

try
    QCLLaser = MIRcat_QCL.getInstance;
catch
    error('SGRLAB:SimulationMode','QCL not Initialized');
end

numQCLs = QCLLaser.numQCLs;

set(handles.QCLInfoTable,'Data',cell(3, numQCLs));
% set(handles.QCLTuningRangeTable, 'Data', cell(numQCLs, 1));

rowNames = cell(1, numQCLs);

tuningRangePanelWidth = handles.tuningRangePanel.Position(3);
textboxWidth = tuningRangePanelWidth./numQCLs;
tuningRangePanelHeight = handles.tuningRangePanel.Position(4);
textboxHeight = tuningRangePanelHeight./2;

for ii = 1:numQCLs
    rowNames{ii} = sprintf('QCL %i', ii);
    tuningRange = QCLLaser.QCLs{ii}.tuningRange_cm1;
    handles.(['QCLRangeTB' num2str(ii)]) = uicontrol('Style','toggle','String',...
        ['<html>', sprintf('%0.2f to %0.2f', tuningRange(1),tuningRange(2)),...
        ' cm<sup>-1</sup></html>'],'FontWeight', 'bold', 'parent',handles.tuningRangePanel);
    set(handles.(['QCLRangeTB' num2str(ii)]), 'Units', 'characters');
    set(handles.(['QCLRangeTB' num2str(ii)]), 'Position', [(ii-1)*textboxWidth 0 textboxWidth textboxHeight]);
    set(handles.(['QCLRangeTB' num2str(ii)]), 'FontSize', 10);
    set(handles.(['QCLRangeTB' num2str(ii)]), 'Tag', num2str(ii));
    
    handles.(['QCLLabel' num2str(ii)]) = uicontrol('Style','edit','enable','inactive','String',...
        sprintf('QCL %i', ii),'FontWeight', 'bold', 'parent',handles.tuningRangePanel);
    set(handles.(['QCLLabel' num2str(ii)]), 'Units', handles.tuningRangePanel.Units);
    set(handles.(['QCLLabel' num2str(ii)]), 'Position', [(ii-1)*textboxWidth textboxHeight textboxWidth textboxHeight]);
    set(handles.(['QCLLabel' num2str(ii)]), 'FontSize', 10);
end
set(handles.QCLInfoTable, 'RowName', rowNames);


updateQCLInfo(handles);

timerObject = timer('TimerFcn',{@updateQCLInfoTimer, handles},'ExecutionMode','fixedRate',...
                    'Period',0.5);
start(timerObject);

movegui('center');

% Choose default command line output for QCLGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QCLGUI wait for user response (see UIRESUME)
% uiwait(handles.QCLController);


% --- Outputs from this function are returned to the command line.
function varargout = QCLGUI_OutputFcn(hObject, eventdata, handles)
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
global QCLLaser

if ~QCLLaser.isEmitting
    set(handles.pbEmissionOnOff, 'String', 'Turning Emission On', 'BackgroundColor', 'yellow');
    QCLLaser.turnEmissionOn;
    while ~QCLLaser.isEmitting
        pause(0.5);
    end
    if QCLLaser.isEmitting
        set(handles.pbEmissionOnOff, 'String', 'Turn Emission Off', 'BackgroundColor', 'green');
        set(handles.emissionStatusText, 'BackgroundColor', 'green');
    end
else
    QCLLaser.turnEmissionOff;
    if ~QCLLaser.isEmitting
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
global guiUnits

wavelength = str2double(get(handles.wavelengthTextEdit, 'String'));
unitsArray = get(handles.pumUnits, 'String');
unitsInd = get(handles.pumUnits, 'Value');
newUnits = unitsArray{unitsInd};
oldUnits = guiUnits;


newWavelength = convertWavelength(wavelength, oldUnits, newUnits);
if strcmp(newUnits, 'um')
    set(handles.wavelengthTextEdit, 'String', sprintf('%0.2f', newWavelength));
else
    set(handles.wavelengthTextEdit, 'String', sprintf('%0.1f', newWavelength));
end
guiUnits = newUnits;

 




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
global QCLLaser

set(hObject, 'String', 'Tuning', 'BackgroundColor', 'yellow');

wavelength = str2double(get(handles.wavelengthTextEdit, 'String'));
unitsArray = get(handles.pumUnits, 'String');
unitsInd = get(handles.pumUnits, 'Value');
units = unitsArray{unitsInd};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure out best way to select QCL
QCLNum = QCLLaser.whichQCL(wavelength, units);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if QCLNum == -1
    set(hObject, 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);
    set(handles.errorMessage1, 'String', 'ERROR: WAVELENGTH OUT OF RANGE');
    error(sprintf('\n*******************************************\n*     ERROR: WAVELENGTH OUT OF RANGE      *\n*******************************************\n'));
    
else
    QCLLaser.tuneTo(wavelength, units, QCLNum);
end

while ~QCLLaser.isTuned
    pause(0.5);
end

if QCLLaser.isTuned
    set(handles.pbTuneQCL, 'String', 'Tuned', 'BackgroundColor', 'green');
    set(handles.errorMessage1, 'String', '');
    set(handles.pbEmissionOnOff, 'Enable', 'on');
end



% --- Executes on button press in pbArmDisarmQCL.
function pbArmDisarmQCL_Callback(hObject, eventdata, handles)
% hObject    handle to pbArmDisarmQCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global QCLLaser

if ~QCLLaser.isArmed
    set(handles.pbArmDisarmQCL, 'String', 'Arming Laser', 'BackgroundColor', 'yellow')
    QCLLaser.armLaser;
    while ~QCLLaser.isArmed
        pause(1.0);
    end
    set(handles.pbArmDisarmQCL, 'String', 'Disarm Laser', 'BackgroundColor', 'green');
    while ~QCLLaser.areTECsAtTemp
        pause(1);
    end
    
    if QCLLaser.areTECsAtTemp
        set(handles.tempStatusText, 'BackgroundColor', 'green');
        set(handles.pbTuneQCL, 'Enable', 'on');
    end
else
    if QCLLaser.isEmitting
        QCLLaser.turnEmissionOff;
        set(handles.pbEmissionOnOff, 'String', 'Turn Emission On', 'BackgroundColor', [0.94 0.94 0.94]);
    end
    QCLLaser.disarmLaser;
    set(handles.pbArmDisarmQCL, 'String', 'Arm Laser', 'BackgroundColor', [0.94 0.94 0.94]);
    set(handles.pbEmissionOnOff, 'Enable', 'off');
    set(handles.pbTuneQCL, 'Enable', 'off', 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);
end

function QCLInfoTable_CreateFcn(hObject, eventdata, handles)



function disableArmDisarmButton(handles)
set(handles.pbArmDisarmQCL, 'String', 'Arm Laser', 'BackgroundColor', [0.94 0.94 0.94]);
set(handles.pbEmissionOnOff, 'Enable', 'off');
set(handles.pbTuneQCL, 'Enable', 'off', 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);

function updateQCLInfoTable(handles)
global QCLLaser
colorgen = @(color,text) ['<html><table border=0 width=65 bgcolor=',color,'><tr><td align=center><b>',text,'</b></td></tr> </table></html>'];

numQCLs = QCLLaser.numQCLs;

QCLInfoData = cell(numQCLs, 3);

activeQCL = QCLLaser.activeQCL;

for ii = 1:numQCLs
    bQcl = ii;
    
    setTemp = QCLLaser.QCLs{bQcl}.setTemp;
    tempRange = [QCLLaser.QCLs{bQcl}.tempRange(1) QCLLaser.QCLs{bQcl}.tempRange(3)];
    actualTemp = QCLLaser.QCLs{bQcl}.actualTemp;
    tecCurrent = QCLLaser.QCLs{bQcl}.tecParams.current*1000;
    
    if actualTemp > 0.975*setTemp && actualTemp < 1.025*setTemp
        QCLInfoData{ii, 1} = colorgen('#00FF00', sprintf('%2.3f',actualTemp));
    elseif actualTemp >= tempRange(1) && actualTemp <= tempRange(2)
        QCLInfoData{ii, 1} = colorgen('#FFFF00', sprintf('%2.3f',actualTemp));
    else
        QCLInfoData{ii, 1} = colorgen('#FF0000', sprintf('%2.3f',actualTemp));
    end
    
    if ii == activeQCL
        QCLInfoData{ii, 2} = colorgen('#00FF00', 'Y');
    else
        QCLInfoData{ii, 2} = colorgen('#FFFFFF', 'N');
    end
    
    QCLInfoData{ii,3} = colorgen('FFFFFF', num2str(tecCurrent)); 
end

handles.QCLInfoTable.Data = QCLInfoData;


function updateQCLInfo(handles)
global QCLLaser

if QCLLaser.isConnected
    set(handles.connectedStatusText, 'BackgroundColor', 'green');
    if QCLLaser.isKeySwitchSet
        set(handles.keySwitchStatusText, 'BackgroundColor', 'green');
        if QCLLaser.isInterlockSet
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

if QCLLaser.areTECsAtTemp
    set(handles.tempStatusText, 'BackgroundColor', 'green');
    set(handles.pbTuneQCL, 'Enable', 'on');
else
    set(handles.tempStatusText, 'BackgroundColor', 'red');
    set(handles.pbTuneQCL, 'Enable', 'off');
end
    

updateQCLInfoTable(handles);

% fprintf('Timer is Working.\n')
% 
% % Choose default command line output for QCLGUI
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

stop(timerObject);
delete(timerObject);
delete(QCLLaser);

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over wavelengthTextEdit.
function wavelengthTextEdit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to wavelengthTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on wavelengthTextEdit and none of its controls.
function wavelengthTextEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to wavelengthTextEdit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.pbTuneQCL, 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);

if strcmp(eventdata.Key, 'return') && strcmp(handles.pbTuneQCL.Enable, 'on')
    uicontrol(handles.pbTuneQCL);
    pbTuneQCL_Callback(handles.pbTuneQCL,[],handles);
end

function newWavelength = convertWavelength(currentWavelength, currentUnits, newUnits)
    % wavelength - wavelength you want to convert
    % units - the units of the input wavelength
switch currentUnits
    case 'um'
        switch newUnits
            case 'um'
                newWavelength = currentWavelength;
            case 'cm-1'
                newWavelength = 10000./currentWavelength;
            otherwise
                error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
        end
    case 'cm-1'
        switch newUnits
            case 'um'
                newWavelength = 10000./currentWavelength;
            case 'cm-1'
                newWavelength = currentWavelength;
            otherwise
                error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
        end
    otherwise
        error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
end


% --- Executes when selected object is changed in tuningRangePanel.
function tuningRangePanel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tuningRangePanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prefQCL

prefQCL = str2double(hObject.Tag);
