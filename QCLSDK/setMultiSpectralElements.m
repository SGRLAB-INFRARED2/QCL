function out = setMultiSpectralElements(wavelengths, units, dwellTimes, offTimes)

global QCLconsts

MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;
MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;
MIRcatSDK_UNITS_CM1 = QCLconsts.MIRcatSDK_UNITS_CM1;

numWavelengths = length(wavelengths);

fprintf('========================================================\n');
fprintf('Starting Multi-Spectral Scan ... ');
fprintf('========================================================\n');
fprintf('Test: Set Amount of Multi-Specral Elements ... ');

ret = calllib('MIRcatSDK','MIRcatSDK_SetNumMultiSpectralElements', numWavelengths);

if MIRcatSDK_RET_SUCCESS == ret
    fprintf(' Successful\n' );
else
    % If the operation fails, unload the library and raise an error.
    fprintf(' Failure\n' );
%     unloadlibrary MIRcatSDK;
    error('Error! Code: %d', ret);
end

fprintf('========================================================\n');
fprintf('Test: Add Multi-Specral Elements ... ');

for ii = 1:numWavelengths
    switch units
        case 'um'
            fprintf('\tTest: Add Multi-Specral Element ... ');
            ret = calllib('MIRcatSDK','MIRcatSDK_AddMultiSpectralElement', ...
                single(wavelengths(ii)), MIRcatSDK_UNITS_MICRONS, dwellTimes(ii), offTimes(ii));
            if MIRcatSDK_RET_SUCCESS == ret
                fprintf(' Successful\n' );
            else
                % If the operation fails, unload the library and raise an error.
                fprintf(' Failure\n' );
        %         unloadlibrary MIRcatSDK;
                error('Error! Code: %d', ret);
            end
        case 'cm-1'
            fprintf('\tTest: Add Multi-Specral Element ... ');
            ret = calllib('MIRcatSDK','MIRcatSDK_AddMultiSpectralElement', ...
                single(wavelengths(ii)), MIRcatSDK_UNITS_CM1, dwellTimes(ii), offTimes(ii));
            if MIRcatSDK_RET_SUCCESS == ret
                fprintf(' Successful\n' );
            else
                % If the operation fails, unload the library and raise an error.
                fprintf(' Failure\n' );
        %         unloadlibrary MIRcatSDK;
                error('Error! Code: %d', ret);
            end
            
        otherwise
            fprintf('Please select wavenumbers (cm-1) or wavelength (um)');
    end
end

out = ret;

end
