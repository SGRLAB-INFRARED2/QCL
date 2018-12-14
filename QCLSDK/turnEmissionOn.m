function [out, isEmitting] = turnEmissionOn()

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n');

isEmitting = isEmissionOn;

out = 0;

if ~isEmitting
    fprintf('Enable Laser Emission... ');
    ret = calllib('MIRcatSDK','MIRcatSDK_TurnEmissionOn');
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
    
    fprintf('========================================================\n');
    fprintf('Is Laser Emitting? ... ');
    
    isEmitting = isEmissionOn;
    
    % if isEmitting
    %     fprintf(' True\n');
    % else
    %     fprintf('False\n');
    % end
    
    while ~isEmitting
        isEmitting = isEmissionOn;
        if isEmitting
            fprintf('\tTrue\n');
        else
            fprintf('\tFalse\n');
        end
        pause(0.5);
    end
    
else
    fprintf('Laser Is Already Emitting\n');
end

end