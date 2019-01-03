function [actualWavelength, units, lightValid] = getActualWavelength()

global QCLconsts;
MIRcatSDK_UNITS_MICRONS = QCLconsts.MIRcatSDK_UNITS_MICRONS;
MIRcatSDK_UNITS_CM1 = QCLconsts.MIRcatSDK_UNITS_CM1;

actualWavelength = single(0);
actualWavelengthPtr = libpointer('singlePtr', actualWavelength);
units = uint8(0);
unitsPtr = libpointer('uint8Ptr', units);
lightValid = false;
lightValidPtr = libpointer('bool', lightValid);

% Check Actual Wavelength
calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWavelengthPtr, unitsPtr, lightValidPtr);
actualWavelength = actualWavelengthPtr.value;
units = unitsPtr.value;
lightValid = lightValidPtr.value;

if units == MIRcatSDK_UNITS_MICRONS
    units = 'um';
elseif units == MIRcatSDK_UNITS_CM1
    units = 'cm-1';
else
    units = '';
end
