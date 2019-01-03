function QCLTemp = getQCLTemp(QCLnum)
% MIRCAT_LIB uint32_t MIRcatSDK_GetQCLTemperature(uint8_t bQcl, float * pfQclTemperature);

bQcl = QCLnum;

QCLTemp = 0;
QclTempPtr = libpointer('singlePtr', QCLTemp);

calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperature', bQcl, QclTempPtr);

QCLTemp = QclTempPtr.value;

end