function out = isLaserArmed()

isArmed = false;
isArmedPtr = libpointer('bool', isArmed);
calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
isArmed = isArmedPtr.value;

out = isArmed;

end