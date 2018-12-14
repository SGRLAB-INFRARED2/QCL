function out = startMultiSpectralScan(numScans)

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

fprintf('========================================================\n');
fprintf('Test: Start Multi-Spectral Scan ... ');

ret = calllib('MIRcatSDK','MIRcatSDK_StartMultiSpectralModeScan', numScans);

if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
    out = true;
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
    out = false;
%     unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

end