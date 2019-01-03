function out = getQCLAPIVersion()

global QCLconsts;

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

if ~libisloaded('MIRcatSDK')
    fprintf('\n\tERROR: MIRcatSDK library is not loaded.\n\n')
    out = struct('versionStr', '', 'major', 0, 'minor', 0, 'patch',0);
else
    
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
end
    
    fprintf(' API Version: %d.%d.%d\n', major, minor, patch);
    
    out = struct('versionStr', sprintf(' API Version: %d.%d.%d\n', major, minor, patch), 'major', major, 'minor', minor, 'patch', patch);
    
