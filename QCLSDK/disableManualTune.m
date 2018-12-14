function isManualTuneEnabled = disableManualTune()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n');
fprintf('Test: Disable Manual Tune Mode ... '); 

ret = calllib('MIRcatSDK','MIRcatSDK_CancelManualTuneMode'); 

if MIRcatSDK_RET_SUCCESS == ret 
    isManualTuneEnabled = false;
    fprintf(' Successful\n' );
else     
    % If the operation fails, unload the library and raise an error.
    isManualTuneEnabled = true;
    fprintf(' Failure\n' );     
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');     
%     unloadlibrary MIRcatSDK;     
    error('Error! Code: %d', ret); 
end

end