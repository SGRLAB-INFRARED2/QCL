% hfile = 'C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\MIRcatSDK.h'; % Denote the location of the headerfile 
% 
% fprintf('========================================================\n');
% fprintf('Loading MIRcatSDK Library\n');
% [notfound, warnings] = loadlibrary('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\Win32\MIRcatSDK', hfile, 'alias', 'MIRcatSDK');
% fprintf('MIRcatSDK Library Loaded\n');
% 
% global QCLconsts;
% QCLconsts = load('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\MIRcatSDKconstants.mat');

[notfound, warnings] = setupQCLEnv;
%%
version = getQCLAPIVersion();
[~,isConnected] = connectQCL();
numQCLs = getNumQCLs;

%%
isKey = isKeySwitchSet;
isInterlock = isInterlockSet;

%%

[~,isArmed] = armLaser();

isTECs = areTECsAtSetTemp;
%%
units = 'um';
wavelength = 4.75; 

QCLnum = whichQCLNum(wavelength, units);
%%
[out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelength, units, QCLnum);
%%
[out_emission, isEmitting] = turnEmissionOn();
%%
[~, isEmitting] = turnEmissionOff();
%%
isManualTuneEnabled = disableManualTune();


%%
[~,isArmed] = disarmLaser();

%%
[~,isConnected] = disconnectQCL();
%%
fprintf('========================================================\n');
fprintf('Unloading MIRcatSDK Library\n');
unloadlibrary MIRcatSDK;
fprintf('MIRcatSDK Library Unloaded\n');
fprintf('========================================================\n');

%% SGR thoughts on ret DONT RUN THIS IT KILLS MATLAB!!!
wavelength = 5.2; %um
ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ...
            single(wavelength), MIRcatSDK_UNITS_MICRONS, 1);
if (ret.isNull)
    %do nothing
else
    setdatatype(ret,'uint32Ptr',1)
    fprintf('return val %d\n',ret.Value)
end

