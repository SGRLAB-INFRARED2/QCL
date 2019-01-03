function [out, isArmed] = disarmLaser()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n'); 
fprintf('Disarming Laser ... '); 

ret = calllib('MIRcatSDK','MIRcatSDK_DisarmLaser'); 

if MIRcatSDK_RET_SUCCESS == ret
    out = ret;
    fprintf('Successful\n' ); 
else     
    % If the operation fails, unload the library and raise an error. 
    out = ret;
%     calllib('MIRcatSDK','MIRcatSDK_DeInitialize');     
%     unloadlibrary MIRcatSDK;     
    error('Error! Code: %d', ret); 
end

isArmed = isLaserArmed;

end