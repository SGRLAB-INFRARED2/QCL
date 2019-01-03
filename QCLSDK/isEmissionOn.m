function out = isEmissionOn()

isEmitting = false;
isEmittingPtr = libpointer('bool', isEmitting);

calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr); 
isEmitting = isEmittingPtr.value; 

out = isEmitting;
end