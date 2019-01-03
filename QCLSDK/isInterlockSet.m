function out = isInterlockSet()

% fprintf('========================================================\n'); 
% fprintf('Test: Is Interlock Set ... '); 

out = false;

isInterlockSet = false; 
isInterlockSetPtr = libpointer('bool', isInterlockSet); 
ret = calllib('MIRcatSDK','MIRcatSDK_IsInterlockedStatusSet', isInterlockSetPtr); 
isInterlockSet = isInterlockSetPtr.value; 

if logical(isInterlockSet)     
%     fprintf(' Yes\n' );
    out = isInterlockSet;
else     
    % If the operation fails, unload the library and raise an error.     
%     fprintf(' NO\n' );     
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
    out = isInterlockSet;
%     unloadlibrary MIRcatSDK;     
%     error('Error! Interlock is not set. Code: %d', ret); 
end

% out = logical(isInterlockSet);

end