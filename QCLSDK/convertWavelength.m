function convertedWavelength = convertWavelength(currentWavelength, currentUnits, newUnits)
%% !!!!! THIS FUNCTION DOES NOT CURRENTLY WORK !!!!!
% MIRCAT_LIB uint32_t MIRcatSDK_ConvertWW(float fWW, uint8_t bcurrentUnits, uint8_t bnewUnits, float * pfConvertedWW);

% global QCLconsts;

MIRcatSDK_UNITS_MICRONS = 1;% QCLconsts.MIRcatSDK_UNITS_MICRONS;
MIRcatSDK_UNITS_CM1 = 2; %QCLconsts.MIRcatSDK_UNITS_CM1;

currentWavelengthPtr = libpointer('singlePtr', currentWavelength);
convertedWavelengthPtr = libpointer('singlePtr', 0);

switch currentUnits
    case 'um'
        curUnits = libpointer('uint8Ptr', MIRcatSDK_UNITS_MICRONS);
    case 'cm-1'
        curUnits = libpointer('uint8Ptr', MIRcatSDK_UNITS_CM1);
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um) for the current units');
end

switch newUnits
    case 'um'
        nUnits = libpointer('uint8Ptr', MIRcatSDK_UNITS_MICRONS);
    case 'cm-1'
        nUnits = libpointer('uint8Ptr', MIRcatSDK_UNITS_CM1);
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um) for the new units');
end

calllib('MIRcatSDK', 'MIRcatSDK_ConvertWW', currentWavelengthPtr,...
    curUnits, nUnits, convertedWavelengthPtr);

convertedWavelength = convertedWavelengthPtr.value;

