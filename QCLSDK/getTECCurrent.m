function TECcurrent = getTECCurrent(TECnum)

% MIRCAT_LIB uint32_t MIRcatSDK_GetTecCurrent(uint8_t bTec, uint16_t * pfCurrentInMilliAmps);

bTec = TECnum;

currentInMilliAmps = uint16(0);
currentInMilliAmpsPtr = libpointer('uint16Ptr', currentInMilliAmps);

calllib('MIRcatSDK', 'MIRcatSDK_GetTecCurrent', bTec, currentInMilliAmpsPtr);

currentInMilliAmps = currentInMilliAmpsPtr.value;

TECcurrent = currentInMilliAmps;

end