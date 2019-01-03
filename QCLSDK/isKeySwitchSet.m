function out = isKeySwitchSet()

% fprintf('========================================================\n');
% fprintf('Test: Is Key Switch Set ... ');

out = false;

isKeySwitchSet = false;
isKeySwitchSetPtr = libpointer('bool', isKeySwitchSet);
ret = calllib('MIRcatSDK','MIRcatSDK_IsKeySwitchStatusSet', isKeySwitchSetPtr);
isKeySwitchSet = isKeySwitchSetPtr.value;

if logical(isKeySwitchSet)
%     fprintf(' Yes\n' );
    out = isKeySwitchSet;
else
    % If the operation fails, unload the library and raise an error.
%     fprintf(' NO\n' );
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    out = isKeySwitchSet;
%     unloadlibrary MIRcatSDK;
%     error('Error! KeySwitch is not set. Code: %d', ret);
end

end