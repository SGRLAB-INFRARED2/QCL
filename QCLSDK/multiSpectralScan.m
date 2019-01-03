MIRcatSDK_RET_SUCCESS = consts.MIRcatSDK_RET_SUCCESS;
MIRcatSDK_UNITS_MICRONS = consts.MIRcatSDK_UNITS_MICRONS;

wavelengths = 4.7:0.01:4.83;
numWavelengths = length(wavelengths);

fprintf('========================================================\n');
fprintf('Starting Multi-Spectral Scan ... ');
fprintf('========================================================\n');
fprintf('Test: Set Amount of Multi-Specral Elements ... ');

ret = calllib('MIRcatSDK','MIRcatSDK_SetNumMultiSpectralElements', numWavelengths);

if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
%     unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

fprintf('========================================================\n');
fprintf('Test: Add Multi-Specral Elements ... ');

for ii = 1:numWavelengths
    fprintf('\tTest: Add Multi-Specral Element ... ');
    ret = calllib('MIRcatSDK','MIRcatSDK_AddMultiSpectralElement', ...
        single(wavelengths(ii)), MIRcatSDK_UNITS_MICRONS, 50, 1);
    if MIRcatSDK_RET_SUCCESS == ret
        fprintf(' Successful\n' );
    else
        % If the operation fails, unload the library and raise an error.
        fprintf(' Failure\n' );
%         unloadlibrary MIRcatSDK;
        error('Error! Code: %d', ret);
    end
end

fprintf('========================================================\n');
fprintf('Test: Start Multi-Spectral Scan ... ');

ret = calllib('MIRcatSDK','MIRcatSDK_StartMultiSpectralModeScan', 4);

if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
%     unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

isScanInProgress = true;
isScanInProgressPtr = libpointer('bool', isScanInProgress);
isScanActive = false;
isScanActivePtr = libpointer('bool', isScanActive);
isScanPaused = false;
isScanPausedPtr = libpointer('bool', isScanPaused);
curScanNum = uint16(0);
curScanNumPtr = libpointer('uint16Ptr', curScanNum);
curScanPercent = uint16(0);
curScanPercentPtr = libpointer('uint16Ptr', curScanPercent);
curWW = single(0);
curWWPtr = libpointer('singlePtr', curWW);
units = uint8(0);
unitsPtr = libpointer('uint8Ptr', units);
isTECinProgress = false;
isTECinProgressPtr = libpointer('bool', isTECinProgress);
isMotionInProgress = false;
isMotionInProgressPtr = libpointer('bool', isMotionInProgress);

fprintf('========================================================\n');
fprintf('Test: Get Scan Status\n');

while isScanInProgress
    calllib('MIRcatSDK','MIRcatSDK_GetScanStatus', ...
        isScanInProgressPtr, isScanActivePtr, isScanPausedPtr, ...
        curScanNumPtr, curScanPercentPtr, curWWPtr, unitsPtr, ...
        isTECinProgressPtr, isMotionInProgressPtr);
    isScanInProgress = isScanInProgressPtr.value;
    isScanActive = isScanActivePtr.value;
    isScanPaused = isScanPausedPtr.value;
    curScanNum = curScanNumPtr.value;
    curScanPercent = curScanPercentPtr.value;
    curWW = curWWPtr.value;
    units = unitsPtr.value;
    isTECinProgress = isTECinProgressPtr.value;
    isMotionInProgress = isMotionInProgressPtr.value;
    fprintf(['\tIsScanInProgress: %d \tIsScanActive: %d \tisScanPaused: %d', ...
        '\tcurScanNum: %d \tcurWW: %.3f \tunits: %u \tcurScanPercent: %.2f', ...
        '\tisTECinProgress: %d \tisMotionInProgress: %d\n'], ...
        isScanInProgress, isScanActive, isScanPaused, curScanNum, curWW, ...
        units, curScanPercent, isTECinProgress, isMotionInProgress);
    pause(0.3);
end



