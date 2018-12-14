function out = whichQCLNum(wavelength, units)

global QCLconsts

numQCLs = getNumQCLs;
MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;

out = -1;

rangesMicrons = zeros(numQCLs, 2);

for i = 1:numQCLs
    bQcl = i;
    
    minRange = 0;
    minRangePtr = libpointer('singlePtr', minRange);
    
    maxRange = 0;
    maxRangePtr = libpointer('singlePtr', maxRange);
    
    calllib('MIRcatSDK', 'MIRcatSDK_GetQclTuningRange', bQcl, minRangePtr, maxRangePtr, MIRcatSDK_UNITS_MICRONS);
    minRange = minRangePtr.value;
    maxRange = maxRangePtr.value;
    
    rangesMicrons(bQcl, 1) = minRange;
    rangesMicrons(bQcl, 2) = maxRange;
end

% wavelength = 2100;
% units = 'cm-1';

switch units
    case 'um'

        for ii = 1:numQCLs
            if wavelength >= rangesMicrons(ii, 1) && wavelength <= rangesMicrons(ii, 2)
                out = ii;
                return
            end
        end
        
    case 'cm-1'
        rangesCM1 = zeros(numQCLs, 2);
        for ii = 1:numQCLs
            for jj = 1:2
                rangesCM1(ii, jj) = convertWavelength(rangesMicrons(ii, jj), 'um', 'cm-1');
            end
        end
%         rangesCM1 = 10000./rangesMicrons;
        for ii = 1:numQCLs
            if wavelength >= rangesCM1(ii, 2) && wavelength <= rangesCM1(ii, 1)
                out = ii;
                return
            end
        end
        
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um)');
    
end