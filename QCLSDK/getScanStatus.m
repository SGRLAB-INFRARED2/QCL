function out = getScanStatus()

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

out.isScanInProgress = isScanInProgress;
out.isScanActive = isScanActive;
out.isScanPaused = isScanPaused;
out.curScanNum = curScanNum;
out.curWW = curWW;
out.units = units;
out.curScanPercent = curScanPercent;
out.isTECinProgress = isTECinProgress;
out.isMotionInProgress = isMotionInProgress;

end