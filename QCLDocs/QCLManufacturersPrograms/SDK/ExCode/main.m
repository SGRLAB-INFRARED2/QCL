clear all;

hfile = 'MIRcatSDK.h';
[notfound, warnings] = loadlibrary('libs/MIRcatSDK', hfile, 'alias', 'MIRcatSDK');
load('MIRcatSDKconstants.mat'); % Load the constants from the SDK



fprintf('========================================================\n');
fprintf('Quering API Version ... ');
% Create your variables and Pointers if necessary.
major = uint16(0);
majorPtr = libpointer('uint16Ptr', major);
minor = uint16(0);
minorPtr = libpointer('uint16Ptr', minor);
patch = uint16(0);
patchPtr = libpointer('uint16Ptr', patch);
% Call the function
ret = calllib('MIRcatSDK','MIRcatSDK_GetAPIVersion', majorPtr, minorPtr, patchPtr);
% Check to see if function call was Successful
if MIRcatSDK_RET_SUCCESS == ret
    fprintf('Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end
% Convert the pointer values to the original variables.
major = majorPtr.value;
minor = minorPtr.value;
patch = patchPtr.value;

fprintf(' API Version: %d.%d.%d\n', major, minor, patch);


% Initialize Connection to MIRcat
fprintf('========================================================\n');
fprintf('Initializing MIRcat ... ');
% Call your function
ret = calllib('MIRcatSDK','MIRcatSDK_Initialize');
% Check to see if function call was Successful
if MIRcatSDK_RET_SUCCESS == ret
    fprintf('Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end



% Step 1: Get the number of installed QCLs
fprintf('========================================================\n');
fprintf('Test: How many QCLs are installed? ... ');
numQCLs = uint8(0);
numQCLsPtr = libpointer('uint8Ptr', numQCLs);
calllib('MIRcatSDK','MIRcatSDK_GetNumInstalledQcls', numQCLsPtr);
numQCLs = numQCLsPtr.value;
fprintf(' %d\n', numQCLs);


% Step 2: Check for Interlock Status
fprintf('========================================================\n');
fprintf('Test: Is Interlock Set ... ');
isInterlockSet = false;
isInterlockSetPtr = libpointer('bool', isInterlockSet);
ret = calllib('MIRcatSDK','MIRcatSDK_IsInterlockedStatusSet', isInterlockSetPtr);
isInterlockSet = isInterlockSetPtr.value;
if logical(isInterlockSet)
    fprintf(' Yes\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' NO\n' );
    calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    unloadlibrary MIRcatSDK;
    error('Error! Interlock is not set. Code: %d', ret);
end

% Step 3: Check for Key Switch Status
fprintf('========================================================\n');
fprintf('Test: Is Key Switch Set ... ');
isKeySwitchSet = false;
isKeySwitchSetPtr = libpointer('bool', isKeySwitchSet);
ret = calllib('MIRcatSDK','MIRcatSDK_IsKeySwitchStatusSet', isKeySwitchSetPtr);
isKeySwitchSet = isKeySwitchSetPtr.value;
if logical(isKeySwitchSet)
    fprintf(' Yes\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' NO\n' );
    calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    unloadlibrary MIRcatSDK;
    error('Error! KeySwitch is not set. Code: %d', ret);
end


% Step 4: Arm the laser
fprintf('========================================================\n');
fprintf('Test: Arm Laser ... ');
isArmed = false;
isArmedPtr = libpointer('bool', isArmed);
calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
isArmed = isArmedPtr.value;

if ~isArmed
    ret = calllib('MIRcatSDK','MIRcatSDK_ArmDisarmLaser');
    if MIRcatSDK_RET_SUCCESS == ret
        fprintf(' Successful\n' );
        fprintf('========================================================\n');
        fprintf('Test: Is Laser Armed?\n');
    else
        % If the operation fails, unload the library and raise an error.
        fprintf(' Failure\n');
        unloadlibrary MIRcatSDK;
        error('Error! Code: %d', ret);
    end
else
    fprintf(' Already Armed\n ');
end

while ~isArmed
    calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
    isArmed = isArmedPtr.value;
    if logical(isArmed)
        fprintf('\tTrue\n' );
    else
        fprintf('\tFalse\n');
    end
    pause(1.0);
end

% Step 5: Wait for TECs to arrive at safe operating temperature
fprintf('========================================================\n');
fprintf('Are TECs at Safe Operating Temp? ... \n');
atTemp = false;
atTempPtr = libpointer('bool', atTemp);
calllib('MIRcatSDK','MIRcatSDK_AreTECsAtSetTemperature', atTempPtr);
atTemp = atTempPtr.value;
if logical(atTemp)
    fprintf('\tTrue\n' );
end

while ~atTemp
    calllib('MIRcatSDK','MIRcatSDK_AreTECsAtSetTemperature', atTempPtr);
    atTemp = atTempPtr.value;
    if logical(atTemp)
        fprintf('\tTrue\n' );
    else
        fprintf('\tFalse\n');
    end
    pause(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Manual Tuning                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('========================================================\n');
fprintf('Starting Single Tune Test\n\n');
fprintf('========================================================\n');
fprintf('Test: Tune to WW 10.235 Microns ... ');
ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ... 
    single(10.235), MIRcatSDK_UNITS_MICRONS, 1);
if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
    calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end


% Check the laser tuning
isTuned = false;
isTunedPtr = libpointer('bool', isTuned);
actualWW = single(0);
actualWWPtr = libpointer('singlePtr', actualWW);
units = uint8(0);
unitsPtr = libpointer('uint8Ptr', units);
lightValid = false;
lightValidPtr = libpointer('bool', lightValid);

fprintf('Test: Is Tuned? ... \n');
calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
isTuned = isTunedPtr.value;
if isTuned 
    fprintf('\t True\n');
end
while ~isTuned
    % Check Tuning Status
    calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
    isTuned = isTunedPtr.value;
    if logical(isTuned)
        fprintf('\tTrue');
    else
        fprintf('\tFalse');
    end
    % Check Actual Wavelength
    calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);
    actualWW = actualWWPtr.value;
    units = unitsPtr.value;
    fprintf('\tActual WW: %.3f \tunits: %u\n', actualWW, units);
    pause(0.1);   

end

% Enable Laser Emission
fprintf('========================================================\n');
isEmitting = false;
isEmittingPtr = libpointer('bool', isEmitting);
calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr);
isEmitting = isEmittingPtr.value;
if ~isEmitting
    fprintf('Enable Laser Emission... ');
    ret = calllib('MIRcatSDK','MIRcatSDK_TurnEmissionOn');
    if MIRcatSDK_RET_SUCCESS == ret
        fprintf(' Successful\n' );
    else
        % If the operation fails, unload the library and raise an error.
        fprintf('Failure\n' );
        calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
        unloadlibrary MIRcatSDK;
        error('Error! Code: %d', ret);
    end
end

% Check for Laser Emission
fprintf('========================================================\n');
fprintf('Is Laser Emitting? ... ');
calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr);
isEmitting = isEmittingPtr.value;
if isEmitting
    fprintf(' True\n');
end
fprintf('\n');
while ~isEmitting
    calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr);
    isEmitting = isEmittingPtr.value;
    if isEmitting
        fprintf('\tTrue\n');
    else
        fprintf('\tFalse\n');
    end
    pause(0.5);
end

% IMPORTANT: Disable Manual Scan Tune before starting another scan
fprintf('Test: Disable Manual Tune Mode ... ');
ret = calllib('MIRcatSDK','MIRcatSDK_CancelManualTuneMode');
if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
    calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                          Sweep Scan                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('========================================================\n');
% fprintf('Starting Sweep mode scan from 6.7 to 7.2 um with a speed 100 microns\n');
% ret = calllib('MIRcatSDK','MIRcatSDK_StartSweepScan', ...
%     single(6.7), single(7.2), single(0.1), ... 
%     MIRcatSDK_UNITS_MICRONS, uint16(1), true, uint8(1));
% if MIRcatSDK_RET_SUCCESS == ret
%     fprintf(' Successful\n' );
% else
%     % If the operation fails, unload the library and raise an error.
%     fprintf(' Failure\n' );
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
%     unloadlibrary MIRcatSDK;
%     error('Error! Code: %d', ret);
% end
% 
% isScanInProgress = true;
% isScanInProgressPtr = libpointer('bool', isScanInProgress);
% isScanActive = false;
% isScanActivePtr = libpointer('bool', isScanActive);
% isScanPaused = false;
% isScanPausedPtr = libpointer('bool', isScanPaused);
% curScanNum = uint16(0);
% curScanNumPtr = libpointer('uint16Ptr', curScanNum);
% curScanPercent = uint16(0);
% curScanPercentPtr = libpointer ('uint16Ptr', curScanPercent);
% curWW = single(0);
% curWWPtr = libpointer('singlePtr', curWW);
% isTECinProgress = false;
% isTECinProgressPtr = libpointer('bool', isTECinProgress);
% isMotionInProgress = false;
% isMotionInProgressPtr = libpointer('bool', isMotionInProgress);
% 
% fprintf('========================================================\n');
% fprintf('Test: Get Scan Status\n');
% while isScanInProgress
%     calllib('MIRcatSDK','MIRcatSDK_GetScanStatus', ...
%         isScanInProgressPtr, isScanActivePtr, isScanPausedPtr, ...
%         curScanNumPtr, curScanPercentPtr, curWWPtr, unitsPtr, ...
%         isTECinProgressPtr, isMotionInProgressPtr);
%     isScanInProgress = isScanInProgressPtr.value;
%     isScanActive = isScanActivePtr.value;
%     isScanPaused = isScanPausedPtr.value;
%     curScanNum = curScanNumPtr.value;
%     curScanPercent = curScanPercentPtr.value;
%     curWW = curWWPtr.value;
%     units = unitsPtr.value;
%     isTECinProgress = isTECinProgressPtr.value;
%     isMotionInProgress = isMotionInProgressPtr.value;
%     fprintf(['\tIsScanInProgress: %d \tIsScanActive: %d \tisScanPaused: %d', ...
%         '\tcurScanNum: %d \tcurWW: %.3f \tunits: %u \tcurScanPercent: %.2f', ...
%         '\tisTECinProgress: %d \tisMotionInProgress: %d\n'], ...
%         isScanInProgress, isScanActive, isScanPaused, curScanNum, curWW, ...
%         units, curScanPercent, isTECinProgress, isMotionInProgress);
%     pause(0.3);
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                       Step-Measure Scan                          %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('========================================================\n');
% fprintf('Starting Step-Measure Scan ... ');
% ret = calllib('MIRcatSDK','MIRcatSDK_StartStepMeasureModeScan', ...
%     single(6.7), single(7.0), single(0.25), MIRcatSDK_UNITS_MICRONS, uint8(1));
% if MIRcatSDK_RET_SUCCESS == ret
%     fprintf(' Successful\n' );
% else
%     % If the operation fails, unload the library and raise an error.
%     fprintf(' Failure\n' );
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
%     unloadlibrary MIRcatSDK;
%     error('Error! Code: %d', ret);
% end
% 
% isScanInProgress = true;
% isScanInProgressPtr = libpointer('bool', isScanInProgress);
% isScanActive = false;
% isScanActivePtr = libpointer('bool', isScanActive);
% isScanPaused = false;
% isScanPausedPtr = libpointer('bool', isScanPaused);
% curScanNum = uint16(0);
% curScanNumPtr = libpointer('uint16Ptr', curScanNum);
% curScanPercent = uint16(0);
% curScanPercentPtr = libpointer ('uint16Ptr', curScanPercent);
% curWW = single(0);
% curWWPtr = libpointer('singlePtr', curWW);
% isTECinProgress = false;
% isTECinProgressPtr = libpointer('bool', isTECinProgress);
% isMotionInProgress = false;
% isMotionInProgressPtr = libpointer('bool', isMotionInProgress);
% 
% fprintf('========================================================\n');
% fprintf('Test: Get Scan Status\n');
% while isScanInProgress
%     calllib('MIRcatSDK','MIRcatSDK_GetScanStatus', ...
%         isScanInProgressPtr, isScanActivePtr, isScanPausedPtr, ...
%         curScanNumPtr, curScanPercentPtr, curWWPtr, unitsPtr, ...
%         isTECinProgressPtr, isMotionInProgressPtr);
%     isScanInProgress = isScanInProgressPtr.value;
%     isScanActive = isScanActivePtr.value;
%     isScanPaused = isScanPausedPtr.value;
%     curScanNum = curScanNumPtr.value;
%     curScanPercent = curScanPercentPtr.value;
%     curWW = curWWPtr.value;
%     units = unitsPtr.value;
%     isTECinProgress = isTECinProgressPtr.value;
%     isMotionInProgress = isMotionInProgressPtr.value;
%     fprintf(['\tIsScanInProgress: %d \tIsScanActive: %d \tisScanPaused: %d', ...
%         '\tcurScanNum: %d \tcurWW: %.3f \tunits: %u \tcurScanPercent: %.2f', ...
%         '\tisTECinProgress: %d \tisMotionInProgress: %d\n'], ...
%         isScanInProgress, isScanActive, isScanPaused, curScanNum, curWW, ...
%         units, curScanPercent, isTECinProgress, isMotionInProgress);
%     pause(0.3);
% end
% 
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                       Multi-Spectral Scan                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('========================================================\n');
% fprintf('Starting Multi-Spectral Scan ... ');
% 
% fprintf('========================================================\n');
% fprintf('Test: Set Amount of Multi-Specral Elements ... ');
% ret = calllib('MIRcatSDK','MIRcatSDK_SetNumMultiSpectralElements', 10);
% if MIRcatSDK_RET_SUCCESS == ret
%     fprintf(' Successful\n' );
% else
%     % If the operation fails, unload the library and raise an error.
%     fprintf(' Failure\n' );
%     unloadlibrary MIRcatSDK;
%     error('Error! Code: %d', ret);
% end
% 
% fprintf('========================================================\n');
% fprintf('Test: Add Multi-Specral Elements ... ');
% startWW = single(5.7);
% for i = 0.0 : 0.5 : 4.5
%     fprintf('\tTest: Add Multi-Specral Element ... ');
%     ret = calllib('MIRcatSDK','MIRcatSDK_AddMultiSpectralElement', ...
%         single(startWW + i), MIRcatSDK_UNITS_MICRONS, 1000, 1000);
%     if MIRcatSDK_RET_SUCCESS == ret
%         fprintf(' Successful\n' );
%     else
%         % If the operation fails, unload the library and raise an error.
%         fprintf(' Failure\n' );
%         unloadlibrary MIRcatSDK;
%         error('Error! Code: %d', ret);
%     end
% end
% 
% fprintf('========================================================\n');
% fprintf('Test: Start Multi-Spectral Scan ... ');
% ret = calllib('MIRcatSDK','MIRcatSDK_StartMultiSpectralModeScan', 1);
% if MIRcatSDK_RET_SUCCESS == ret
%     fprintf(' Successful\n' );
% else
%     % If the operation fails, unload the library and raise an error.
%     fprintf(' Failure\n' );
%     unloadlibrary MIRcatSDK;
%     error('Error! Code: %d', ret);
% end
% 
% isScanInProgress = true;
% isScanInProgressPtr = libpointer('bool', isScanInProgress);
% isScanActive = false;
% isScanActivePtr = libpointer('bool', isScanActive);
% isScanPaused = false;
% isScanPausedPtr = libpointer('bool', isScanPaused);
% curScanNum = uint16(0);
% curScanNumPtr = libpointer('uint16Ptr', curScanNum);
% curScanPercent = uint16(0);
% curScanPercentPtr = libpointer ('uint16Ptr', curScanPercent);
% curWW = single(0);
% curWWPtr = libpointer('singlePtr', curWW);
% isTECinProgress = false;
% isTECinProgressPtr = libpointer('bool', isTECinProgress);
% isMotionInProgress = false;
% isMotionInProgressPtr = libpointer('bool', isMotionInProgress);
% 
% fprintf('========================================================\n');
% fprintf('Test: Get Scan Status\n');
% while isScanInProgress
%     calllib('MIRcatSDK','MIRcatSDK_GetScanStatus', ...
%         isScanInProgressPtr, isScanActivePtr, isScanPausedPtr, ...
%         curScanNumPtr, curScanPercentPtr, curWWPtr, unitsPtr, ...
%         isTECinProgressPtr, isMotionInProgressPtr);
%     isScanInProgress = isScanInProgressPtr.value;
%     isScanActive = isScanActivePtr.value;
%     isScanPaused = isScanPausedPtr.value;
%     curScanNum = curScanNumPtr.value;
%     curScanPercent = curScanPercentPtr.value;
%     curWW = curWWPtr.value;
%     units = unitsPtr.value;
%     isTECinProgress = isTECinProgressPtr.value;
%     isMotionInProgress = isMotionInProgressPtr.value;
%     fprintf(['\tIsScanInProgress: %d \tIsScanActive: %d \tisScanPaused: %d', ...
%         '\tcurScanNum: %d \tcurWW: %.3f \tunits: %u \tcurScanPercent: %.2f', ...
%         '\tisTECinProgress: %d \tisMotionInProgress: %d\n'], ...
%         isScanInProgress, isScanActive, isScanPaused, curScanNum, curWW, ...
%         units, curScanPercent, isTECinProgress, isMotionInProgress);
%     pause(0.3);
% end


% Disarm Laser
fprintf('========================================================\n');
fprintf('Disarming Laser ... ');
ret = calllib('MIRcatSDK','MIRcatSDK_DisarmLaser');
if MIRcatSDK_RET_SUCCESS == ret
    fprintf('Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

% Disconnect from MIRcat
fprintf('========================================================\n');
fprintf('De-Initialize MIRcatSDK ... ');
ret = calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
if MIRcatSDK_RET_SUCCESS == ret
    fprintf('Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end
unloadlibrary MIRcatSDK; % Don't forget to unload the library after you are done