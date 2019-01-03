function [out, isInitialized] = connectQCL()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n');
fprintf('Initializing MIRcat ... ');

isInitialized = isLaserConnected;

if isInitialized
    fprintf('Already Initialized\n');
    out = 0;
else

    % Call your function
    ret = calllib('MIRcatSDK','MIRcatSDK_Initialize');
    isInitialized = isLaserConnected;
    % Check to see if function call was Successful
    if MIRcatSDK_RET_SUCCESS == ret
        out = ret;
        
        fprintf('Successful\n' );
    else
        % If the operation fails, unload the library and raise an error.
        isInitialized = isLaserConnected;
        out = ret;
    %     unloadlibrary MIRcatSDK;
        error('Error! Code: %d', ret);
    end
end

end