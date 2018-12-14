function [out, isEmitting] = turnEmissionOff()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n');

isEmitting = isEmissionOn;

fprintf('Disable Laser Emission... ');
if isEmitting
    ret = calllib('MIRcatSDK','MIRcatSDK_TurnEmissionOff');
    if MIRcatSDK_RET_SUCCESS == ret
        out = ret;
        fprintf(' Successful\n' );
    else
        % If the operation fails, unload the library and raise an error.
        out = ret;
        fprintf('Failure\n' );
%         calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
%         unloadlibrary MIRcatSDK;
        error('Error! Code: %d', ret);
    end
else
    fprintf('Successful\n');
    out = 0;
end

isEmitting = isEmissionOn;

end
