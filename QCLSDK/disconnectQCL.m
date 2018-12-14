function [out, isConnected] = disconnectQCL()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n'); 
fprintf('De-Initialize MIRcatSDK ... '); 

ret = calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
isConnected = isLaserConnected;

if MIRcatSDK_RET_SUCCESS == ret     
    fprintf('Successful\n' ); 
    out = ret;
else     
    % If the operation fails, unload the library and raise an error.     
%     unloadlibrary MIRcatSDK;
    out = ret;
    error('Error! Code: %d', ret); 
end 



end