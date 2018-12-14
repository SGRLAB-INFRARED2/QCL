function out = getNumQCLs()

% fprintf('========================================================\n'); 
% fprintf('Test: How many QCLs are installed? ... '); 
numQCLs = uint8(0); 
numQCLsPtr = libpointer('uint8Ptr', numQCLs); 
calllib('MIRcatSDK','MIRcatSDK_GetNumInstalledQcls', numQCLsPtr); 
numQCLs = numQCLsPtr.value; 
% fprintf(' %d\n', numQCLs);

out = numQCLs;
end