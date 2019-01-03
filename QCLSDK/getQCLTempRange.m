function [tempRange, nominalTemp] = getQCLTempRange(QCLnum)
% MIRCAT_LIB uint32_t MIRcatSDK_GetQCLTemperatureRange(uint8_t bQcl, float * pfQclNominalTemperature, float * pfQclMinTemperature, float * pfQclMaxTemperature);

bQcl = QCLnum;

nominalTemp = 0;
nominalTempPtr = libpointer('singlePtr', nominalTemp);

minTemp = 0;
minTempPtr = libpointer('singlePtr', minTemp);

maxTemp = 0;
maxTempPtr = libpointer('singlePtr', maxTemp);

calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperatureRange', bQcl, nominalTempPtr, minTempPtr, maxTempPtr);

nominalTemp = nominalTempPtr.value;
minTemp = minTempPtr.value;
maxTemp = maxTempPtr.value;
tempRange = [minTemp maxTemp];