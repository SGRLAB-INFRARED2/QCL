function convertedWavelength = convertWavelength(currentWavelength, currentUnits, newUnits)
% MIRCAT_LIB uint32_t MIRcatSDK_ConvertWW(float fWW, uint8_t bcurrentUnits, uint8_t bnewUnits, float * pfConvertedWW);

global QCLconsts;

MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;
MIRcatSDK_UNITS_CM1 = QCLconsts.MIRcatSDK_UNITS_CM1;

currentWavelenthPtr = libpointer('singlePtr', currentWavelength);

convertedWavelength = 0;
convertedWavelengthPtr = libpointer('singlePtr', convertedWavelength);

switch currentUnits
    case 'um'
        curUnits = MIRcatSDK_UNITS_MICRONS;
    case 'cm-1'
        curUnits = MIRcatSDK_UNITS_CM1;
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um) for the current units');
end

switch newUnits
    case 'um'
        nUnits = MIRcatSDK_UNITS_MICRONS;
    case 'cm-1'
        nUnits = MIRcatSDK_UNITS_CM1;
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um) for the new units');
end

calllib('MIRcatSDK', 'MIRcatSDK_ConvertWW', currentWavelengthPtr,...
    curUnits, nUnits, convertedWavelengthPtr);

convertedWavelength = convertedWavelengthPtr.value;

