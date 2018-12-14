function [out, isArmed] = armLaser()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

% fprintf('========================================================\n');
% fprintf('Test: Arm Laser ... \n');

isArmed = isLaserArmed;

if ~isArmed
    ret = calllib('MIRcatSDK','MIRcatSDK_ArmDisarmLaser');
%     if MIRcatSDK_RET_SUCCESS == ret
%         fprintf('\tSuccessful\n' );
%         fprintf('========================================================\n');
%         fprintf('Test: Is Laser Armed?\n');
%     else
%         % If the operation fails, unload the library and raise an error.
%         fprintf('\tFailure\n');
% %         unloadlibrary MIRcatSDK;
%         error('Error! Code: %d', ret);
%     end
% else
%     fprintf('\tAlready Armed\n');
end

% while ~isArmed
%     isArmed = isLaserArmed;
%     if logical(isArmed)
%         fprintf('\tTrue\n' );
%     else
%         fprintf('\tFalse\n');
%     end
%     pause(1.0);
% end

out = isArmed;

end