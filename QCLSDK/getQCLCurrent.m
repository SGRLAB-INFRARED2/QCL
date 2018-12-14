function QCLcurrent = getQCLCurrent(QCLnum)

% MIRCAT_LIB uint32_t MIRcatSDK_GetTecCurrent(uint8_t bTec, uint16_t * pfCurrentInMilliAmps);

bQcl = QCLnum;

currentInMilliAmps = 0;
currentInMilliAmpsPtr = libpointer('singlePtr', currentInMilliAmps);

calllib('MIRcatSDK', 'MIRcatSDK_GetQCLCurrent', bQcl, currentInMilliAmpsPtr);

currentInMilliAmps = currentInMilliAmpsPtr.value;

QCLcurrent = currentInMilliAmps;

end

