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

% Last Modified by GUIDE v2.5 19-Mar-2019 16:26:06

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

global QCLLaser timerObject tuningUnits prefQCL numQCLs;

guiLaserParamLabels = {'Active QCL:'; 'Mode:'; 'Pulse Rate (Hz):'; 'Pulse Width (ns):';...
    'Current (mA):'; 'Wavenumber (cm^{-1}):'; 'Wavelength (\mum):'};

guiLaserParams = {'activeQCL'; 'mode'; 'pulseRate'; 'pulseWidth';...
    'currentQCL'; 'wavenumber'; 'wavelength'};

tuningUnits = 'cm-1';

prefQCL = -1;

QCLLaser = [];
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
jj = numQCLs;
for ii = 1:numQCLs
    rowNames{ii} = sprintf('QCL %i', ii);
    tuningRange = QCLLaser.QCLs{jj}.tuningRange_cm1;
    handles.(['pbQCLRange' num2str(jj)]) = uicontrol('Style','toggle','String',...
        ['<html>', sprintf('%0.1f to %0.1f', tuningRange(1),tuningRange(2)),...
        ' cm<sup>-1</sup></html>'],'FontWeight', 'bold', 'Tag', num2str(jj),...
        'Units', handles.tuningRangePanel.Units, 'FontSize', 10,...
        'parent', handles.tuningRangePanel,...
        'Position', [(jj-1)*textboxWidth 0 textboxWidth textboxHeight],...
        'BackgroundColor', 'white', 'Value', 1, 'Callback',...
        @(hObject,eventdata)QCLGUI('pbWhichQCL_Callback',hObject,eventdata,guidata(hObject)));
    
    handles.(['pbQCLLabel' num2str(jj)]) = uicontrol('Style','push', 'String',...
        sprintf('QCL %i', jj),'FontWeight', 'bold', 'BackgroundColor', 'white',...
        'Tag', num2str(jj), 'Units', handles.tuningRangePanel.Units, 'FontSize', 10,...
        'parent',handles.tuningRangePanel,...
        'Position', [(jj-1)*textboxWidth textboxHeight textboxWidth textboxHeight],...
        'Callback', ...
        @(hObject,eventdata)QCLGUI('pbWhichQCL_Callback',hObject,eventdata,guidata(hObject)));
    
    jj = jj - 1;
end
clear ii jj

panelHeight = handles.laserParamsPanel.Position(4);
for ii = 1:length(guiLaserParamLabels)
    handles.([guiLaserParams{ii} 'Label']) = uibutton(handles.laserParamsPanel, 'Style', 'text',...
        'String', guiLaserParamLabels{ii}, 'FontSize', 11, 'Units', handles.laserParamsPanel.Units,...
        'Position', [0 (panelHeight-(ii)*2) 28 1.5],...
        'ForegroundColor', 'black', 'HorizontalAlignment', 'right',...
        'Interpreter','tex');
    
    handles.([guiLaserParams{ii} 'Value']) = uicontrol(handles.laserParamsPanel, 'Style', 'edit',...
        'FontSize', 10, 'Units', handles.laserParamsPanel.Units,...
        'Position', [28 (panelHeight-(ii)*2)-0.1 10 1.5], 'Enable', 'inactive',...
        'ForegroundColor', 'black');
end

set(handles.QCLInfoTable, 'ColumnName', {'<html>Temp (&#8451;)</html>'; 'Active'; '<html>TEC I (mA)</html>'});
set(handles.QCLInfoTable, 'RowName', rowNames);
% set(handles.QCLLabel1, 'FontSize', 14, 'ForegroundColor', [10, 96, 7]./255);
% set(handles.QCLRangeTB1, 'Value', 1);

set(handles.pumUnits, 'String', {'<html>cm<sup>-1</sup></html>'; '<html>&mu;m</html>'});

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
global tuningUnits numQCLs QCLLaser

unitsArray = {'cm-1', 'um'};

wavelength = str2double(get(handles.wavelengthTextEdit, 'String'));
unitsInd = get(handles.pumUnits, 'Value');
newUnits = unitsArray{unitsInd};
oldUnits = tuningUnits;


newWavelength = convertWavelength(wavelength, oldUnits, newUnits);
if strcmp(newUnits, 'um')
    set(handles.wavelengthTextEdit, 'String', sprintf('%0.2f', newWavelength));
    for ii = 1:numQCLs
        tuningRange = QCLLaser.QCLs{ii}.tuningRange_um;
        set(handles.(['QCLRangeTB' num2str(ii)]), 'String', ...
            ['<html>', sprintf('%0.2f to %0.2f', tuningRange(1),tuningRange(2)),...
            ' &mu;m</sup></html>']);
    end
else
    set(handles.wavelengthTextEdit, 'String', sprintf('%0.1f', newWavelength));
    for ii = 1:numQCLs
        tuningRange = QCLLaser.QCLs{ii}.tuningRange_cm1;
        set(handles.(['QCLRangeTB' num2str(ii)]), 'String', ...
            ['<html>', sprintf('%0.1f to %0.1f', tuningRange(1),tuningRange(2)),...
            ' &mu;m</sup></html>']);
    end
end
tuningUnits = newUnits;

 




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
global QCLLaser prefQCL tuningUnits

set(hObject, 'String', 'Tuning', 'BackgroundColor', 'yellow');

wavelength = str2double(get(handles.wavelengthTextEdit, 'String'));

if prefQCL ~= -1
    if strcmp(tuningUnits, 'um')
        tuningRange = QCLLaser.QCLs{prefQCL}.tuningRange_um;
    else
        tuningRange = QCLLaser.QCLs{prefQCL}.tuningRange_cm1;
    end
    
    if wavelength >= tuningRange(1) && wavelength <= tuningRange(2)
        QCLLaser.tuneTo(wavelength, tuningUnits, prefQCL);
    else
        QCLNum = QCLLaser.whichQCL(wavelength, tuningUnits);
        if QCLNum == -1
            set(hObject, 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);
            set(handles.errorMessage1, 'String', 'ERROR: WAVELENGTH OUT OF RANGE');
            error(sprintf(['\n*******************************************\n',...
                '*     ERROR: WAVELENGTH OUT OF RANGE      *',...
                '\n*******************************************\n']));
        else
            QCLLaser.tuneTo(wavelength, tuningUnits, QCLNum);
        end
    end
else
    QCLNum = QCLLaser.whichQCL(wavelength, tuningUnits);
    if QCLNum == -1
        set(hObject, 'String', 'Tune', 'BackgroundColor', [0.94 0.94 0.94]);
        set(handles.errorMessage1, 'String', 'ERROR: WAVELENGTH OUT OF RANGE');
        error(sprintf(['\n*******************************************\n',...
            '*     ERROR: WAVELENGTH OUT OF RANGE      *',...
            '\n*******************************************\n']));
    else
        QCLLaser.tuneTo(wavelength, tuningUnits, QCLNum);
    end
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
global QCLLaser numQCLs

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

for ii = 1:numQCLs
    if ii == QCLLaser.activeQCL
        set(handles.(['pbQCLRange' num2str(ii)]), 'BackgroundColor', 'green');
    else
        set(handles.(['pbQCLRange' num2str(ii)]), 'BackgroundColor', 'white');
    end
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


% --- Executes when button is pressed to select QCL.
function pbWhichQCL_Callback(hObject, eventdata, handles)
% global NumQCLs

global prefQCL numQCLs
for ii = 1:numQCLs
    set(handles.(['pbQCLRange' num2str(ii)]), 'Value', 1);
end

if prefQCL == str2double(hObject.Tag)
    prefQCL = -1;
    set(handles.(['pbQCLLabel' hObject.Tag]), 'FontSize', 10,...
        'ForegroundColor', 'black');
else
    prefQCL = str2double(hObject.Tag);
    for ii = 1:numQCLs
        if ii == prefQCL
            set(handles.(['pbQCLLabel' num2str(ii)]) , 'FontSize', 14,...
                'ForegroundColor', [10, 96, 7]./255);
            
        else
            set(handles.(['pbQCLLabel' num2str(ii)]) , 'FontSize', 10,...
                'ForegroundColor', 'black');
        end
    end
end
