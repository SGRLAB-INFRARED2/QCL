% hfile = 'C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\MIRcatSDK.h'; % Denote the location of the headerfile
% 
% fprintf('========================================================\n');
% fprintf('Loading MIRcatSDK Library\n');
% [notfound, warnings] = loadlibrary('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\Win32\MIRcatSDK', hfile, 'alias', 'MIRcatSDK');
% fprintf('MIRcatSDK Library Loaded\n');
% 
% global QCLconsts
% QCLconsts = load('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\MIRcatSDKconstants.mat');

[notfound, warnings] = setupQCLEnv;
%% won't work with gui open -- TB
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

units = 'cm-1';
wavelengths = 2030:0.1:2090;

numShots = 500;
numScans = 1;
%%
global method
set(method.handles.editnScans,'String',num2str(numScans));
set(method.handles.editnShots,'String', num2str(numShots));

background = struct('wavelength', 0, 'shots', []);
first_scan = true;

for ii = 1:length(wavelengths)
    if first_scan
        
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end

        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);


        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);

        [~, isEmitting] = turnEmissionOn();

        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end
        first_scan = false;
        
    elseif ii == length(wavelengths)
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end

        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);


        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);

        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end

        [~, isEmitting] = turnEmissionOff();
    else
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end
        
        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);
        
        
        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);
        
        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end
    end
    
    background(ii).wavelength = actualWWPtr.value;
    background(ii).shots = method.sample(48,:);
    background(ii).meanSignal = mean(background(ii).shots);
    
end

background_wavelengths = zeros(length(background), 1);
background_meanSignal = zeros(length(background),1);

for ii = 1:length(background)
    background_wavelengths(ii) = background(ii).wavelength;
    background_meanSignal(ii) = background(ii).meanSignal;
end


%%
set(method.handles.editnScans,'String',num2str(numScans));
set(method.handles.editnShots,'String', num2str(numShots));

sample = struct('wavelength', 0, 'shots', []);
first_scan = true;

for ii = 1:length(wavelengths)
    if first_scan
        
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end

        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);


        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);

        [~, isEmitting] = turnEmissionOn();

        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end
        first_scan = false;
        
    elseif ii == length(wavelengths)
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end

        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);


        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);

        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end

        [~, isEmitting] = turnEmissionOff();
    else
        QCLnum = whichQCLNum(wavelengths(ii), units);
        [out_tune, isManualTuneEnabled, isTuned] = tuneQCL(wavelengths(ii), units, QCLnum);
        while ~isTuned
            isTuned = isQCLTuned;
            pause(0.1);
        end
        
        actualWW = single(0);
        actualWWPtr = libpointer('singlePtr', actualWW);
        unts = uint8(0);
        unitsPtr = libpointer('uint8Ptr', unts);
        lightValid = false;
        lightValidPtr = libpointer('bool', lightValid);
        
        
        calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWWPtr, unitsPtr, lightValidPtr);
        
        if isEmitting
            Spectrometer('pbGo_Callback', method.handles.pbGo, [], method.handles);
        else
            fprintf('Emission Failed\n');
        end
    end
    
    sample(ii).wavelength = actualWWPtr.value;
    sample(ii).shots = method.sample(48,:);
    sample(ii).meanSignal = mean(sample(ii).shots);
    
end

sample_wavelengths = zeros(length(sample), 1);
sample_meanSignal = zeros(length(sample),1);

for ii = 1:length(background)
    sample_wavelengths(ii) = sample(ii).wavelength;
    sample_meanSignal(ii) = sample(ii).meanSignal;
end

%%

isManualTuneEnabled = disableManualTune();

abs = -log10(sample_meanSignal./background_meanSignal);

figure(11), clf
plot(10000./sample_wavelengths, abs)