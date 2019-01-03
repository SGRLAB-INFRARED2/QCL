function QCLSetTemp = getQCLSetTemp(QCLnum)
% MIRCAT_LIB uint32_t MIRcatSDK_GetQclSetTemperature(uint8_t bQcl, float * pfQclSetTemperature);

bQcl = QCLnum;

QCLSetTemp = 0;
QCLSetTempPtr = libpointer('singlePtr', QCLSetTemp);

calllib('MIRcatSDK', 'MIRcatSDK_GetQclSetTemperature', bQcl, QCLSetTempPtr);

QCLSetTemp = QCLSetTempPtr.value;