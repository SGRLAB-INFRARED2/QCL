function activeQCL = getActiveQCL()

% MIRCAT_LIB uint32_t MIRcatSDK_GetActiveQcl( uint8_t * pbActiveQcl );

activeQCL = uint8(0);
activeQCLPtr = libpointer('uint8Ptr', activeQCL);

calllib('MIRcatSDK', 'MIRcatSDK_GetActiveQcl', activeQCLPtr);

activeQCL = activeQCLPtr.value;

end