function [out, isManualTuneEnabled, isTuned] = tuneQCL(wavelength, units, QCLnum)

global QCLconsts

MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;
MIRcatSDK_UNITS_CM1 = QCLconsts.MIRcatSDK_UNITS_CM1;
MIRcatSDK_RET_SUCCESS = QCLconsts.MIRcatSDK_RET_SUCCESS;

isTuned = false;
isManualTuneEnabled = false;
out = -1;

% units = 'cm-1';
% wavelength = 2100;

% units = 'um';
% wavelength = 4.500;
switch units
    case 'cm-1'
%         fprintf('========================================================\n');
%         fprintf('Starting Single Tune Test\n\n');
%         fprintf('========================================================\n');
%         fprintf('Test: Tune to WW %.2f cm-1 ... ', wavelength);

        ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ...
            single(wavelength), MIRcatSDK_UNITS_CM1, QCLnum);
        
        if MIRcatSDK_RET_SUCCESS == ret
            out = ret;
%             fprintf(' Successful\n' );
            
            isManualTuneEnabled = true;
            isTuned = isQCLTuned;
            
            pause(0.1);
            
            if ~isTuned
                isTuned = isQCLTuned;
                pause(0.1);
            end
            
        else
            % If the operation fails, unload the library and raise an error.
            out = ret;
            isManualTuneEnabled = false;
%             fprintf(' Failure\n' );
%             calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
%             unloadlibrary MIRcatSDK;
            error('Error! Code: %d', ret);
        end
        
    case 'um'
%         fprintf('========================================================\n');
%         fprintf('Starting Single Tune Test\n\n');
%         fprintf('========================================================\n');
%         fprintf('Test: Tune to WW %.3f Microns ... ', wavelength);

        ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ...
            single(wavelength), MIRcatSDK_UNITS_MICRONS, QCLnum);
        
        if MIRcatSDK_RET_SUCCESS == ret
            out = ret;
%             fprintf(' Successful\n' );
            
            isManualTuneEnabled = true;
            isTuned = isQCLTuned;
            
            pause(0.1);
            
            if ~isTuned
                isTuned = isQCLTuned;
                pause(0.1);
            end
        else
            % If the operation fails, unload the library and raise an error.
            out = ret;
            isManualTuneEnabled = false;
%             fprintf(' Failure\n' );
%             calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
%             unloadlibrary MIRcatSDK;
            error('Error! Code: %d', ret);
        end
        
    otherwise
        fprintf('Please select wavenumbers (cm-1) or wavelength (um)\n');
end

end