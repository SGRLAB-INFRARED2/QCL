function out = isQCLTuned()

isTuned = false;
isTunedPtr = libpointer('bool', isTuned);
% actualWW = single(0);
% actualWWPtr = libpointer('singlePtr', actualWW);
% units = uint8(0);
% unitsPtr = libpointer('uint8Ptr', units);
% lightValid = false;
% lightValidPtr = libpointer('bool', lightValid);

% fprintf('========================================================\n'); 
% fprintf('Test: Is Tuned? ... \n');
calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
isTuned = isTunedPtr.value;

% if isTuned
%     fprintf('\t True\n');
% end
% 
% while ~isTuned
%     % Check Tuning Status
%     calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
%     isTuned = isTunedPtr.value;
%     if logical(isTuned)
%         fprintf('\tTrue');
%     else
%         fprintf('\tFalse');
%     end
%     % Check Actual Wavelength
%     calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);
%     actualWW = actualWWPtr.value;
%     units = unitsPtr.value;
%     fprintf('\tActual WW: %.3f \tunits: %u\n', actualWW, units);
%     pause(0.1);
% end

out = isTuned;

end