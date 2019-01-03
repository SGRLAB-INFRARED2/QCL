function out = isQCLSystemError()

isQCLSystemError = false;
isQCLSystemErrorPtr = libpointer('bool', isQCLSystemError);

calllib('MIRcatSDK','MIRcatSDK_IsSystemError', isQCLSystemErrorPtr); 
isQCLSystemError = isQCLSystemErrorPtr.value; 

out = isQCLSystemError;
end