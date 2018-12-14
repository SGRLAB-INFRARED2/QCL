function range = getQCLTuningRange(QCLnum, units)
% MIRCAT_LIB uint32_t MIRcatSDK_GetQclTuningRange(uint8_t bQcl, float * pfMinRange, float * pfMaxRange, uint8_t * pbUnits);
global QCLconsts;

MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;

bQcl = QCLnum;

minRange = 0;
minRangePtr = libpointer('singlePtr', minRange);

maxRange = 0;
maxRangePtr = libpointer('singlePtr', maxRange);

calllib('MIRcatSDK', 'MIRcatSDK_GetQclTuningRange', bQcl, minRangePtr, maxRangePtr, MIRcatSDK_UNITS_MICRONS);
minRange = minRangePtr.value;
maxRange = maxRangePtr.value; 

switch units
    case 'um'
        range = [minRange maxRange];
    case 'cm-1'
        range = [convertWavelength(maxRange, 'um','cm') convertWavelength(minRange, 'um', 'cm')];
    otherwise
        error('Please select wavenumbers (cm-1) or wavelength (um)');
end
