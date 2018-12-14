function [notfound, warnings] = setupQCLEnv()

dir = fileparts(mfilename('fullpath'));


hfile = strcat(dir,'\MIRcatSDK.h'); % 'C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\MIRcatSDK.h'; % Denote the location of the headerfile 

fprintf('========================================================\n');
fprintf('Loading MIRcatSDK Library\n');

%[notfound, warnings] = loadlibrary('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\Win32\MIRcatSDK', hfile, 'alias', 'MIRcatSDK');
[notfound, warnings] = loadlibrary(strcat(dir,'\Win32\MIRcatSDK'), hfile, 'alias', 'MIRcatSDK');


fprintf('MIRcatSDK Library Loaded\n');

global QCLconsts;
QCLconsts = load(strcat(dir, '\MIRcatSDKconstants.mat'));

end