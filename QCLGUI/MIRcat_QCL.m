classdef MIRcat_QCL < handle
    
    properties (SetAccess = private, Hidden = true)
        libname = 'MIRcatSDK';
        unitsArray = {'cm-1', 'um'};
    end
    
    properties (SetAccess = private)
        QCLs = {};
        QCLconsts;
        Tag = 'MIRcat_QCL';
    end
    
    properties
        unitsIndex = 1;
    end
    
    properties (Dependent)
        APIVersion;
        modelNumber;
        serialNumber;
        numQCLs;
        isConnected;
        isInterlockSet;
        isKeySwitchSet;
        isEmitting;
        isArmed;
        isSystemError;
        areTECsAtTemp;
        systemErrorWord;
        unitsString;
        activeQCL;
        actualWavelength;
        tuneWavelength;
        isTuned;
    end
    
    %make the constructor private
    methods (Access = private)
        
        function obj = MIRcat_QCL
            Initialize(obj);
        end
        
    end
    
    %hold the instance as a persistent variable
    methods (Static)
        function singleObj = getInstance
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                localObj = MIRcat_QCL;
            end
            singleObj = localObj;
        end
    end
    
    methods (Access = protected) %private
        function Initialize(obj)
            
            %% START HERE
            try
                if ~libisloaded(obj.libname) % If the QCL library isn't loaded, load the library
                    obj.setupQCLEnv;
                end
                obj.QCLconsts = load(strcat(fileparts(mfilename('fullpath')), '\lib\MIRcatSDKconstants.mat'));
                obj.connect;
                for ii = 1:obj.numQCLs
                    obj.QCLs{ii} = QCL_Unit(ii, obj.QCLconsts);
                end
                
                obj.ReadDefaults;
                
            catch Err
                warning('Error Initializing QCL.  Entering simulation mode.');
            end
            
        end
        
        
    end
    
    %% Methods for Setup and Deletion
    methods (Access = private, Static)
        function setupQCLEnv
            
            dir = fileparts(mfilename('fullpath'));
            
            
            hfile = strcat(dir,'\lib\MIRcatSDK.h'); % 'C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\MIRcatSDK.h'; % Denote the location of the headerfile
            
            %[notfound, warnings] = loadlibrary('C:\Users\INFRARED\Documents\MATLAB\QCLSDK\SDK\Win32\MIRcatSDK', hfile, 'alias', 'MIRcatSDK');
            [notfound, warnings] = loadlibrary(strcat(dir,'\lib\Win32\MIRcatSDK'), hfile, 'alias', 'MIRcatSDK');
            
            if ~isempty(notfound)
                error('!!! ERROR: MIRcatSDK Library Not Found !!!\n');
            elseif ~isempty(warnings)
                warning('WARNING: %s', warnings);
            end
            
            %             obj.QCLconsts = load(strcat(dir, '\lib\MIRcatSDKconstants.mat'));
            
        end
        
        function connect
            % Call your function
            ret = calllib('MIRcatSDK','MIRcatSDK_Initialize');
            % Check to see if function call was Successful
            checkMIRcatReturnError(ret);
        end
        
        function disconnect
            ret = calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
            checkMIRcatReturnError(ret);
        end
    end
    
    %% Methods That Change Laser State
    methods (Static)
        function armLaser
            ret = calllib('MIRcatSDK','MIRcatSDK_ArmLaser');
            checkMIRcatReturnError(ret);
        end
        
        function disarmLaser
            ret = calllib('MIRcatSDK','MIRcatSDK_DisarmLaser');
            checkMIRcatReturnError(ret);
        end
        
        function disableManualTune
            ret = calllib('MIRcatSDK','MIRcatSDK_CancelManualTuneMode');
            checkMIRcatReturnError(ret);
        end
        
        function turnEmissionOn
            ret = calllib('MIRcatSDK','MIRcatSDK_TurnEmissionOn');
            checkMIRcatReturnError(ret);
        end
        
        function turnEmissionOff
            ret = calllib('MIRcatSDK','MIRcatSDK_TurnEmissionOff');
            checkMIRcatReturnError(ret);
        end
    end
    
    methods
        function tuneTo(obj, wavelength, units, QCLnum)
            switch units
                case 'cm-1'
                    ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ...
                        single(wavelength), obj.QCLconsts.MIRcatSDK_UNITS_CM1, QCLnum);
                case 'um'
                    ret = calllib('MIRcatSDK','MIRcatSDK_TuneToWW', ...
                        single(wavelength), obj.QCLconsts.MIRcatSDK_UNITS_MICRONS, QCLnum);
                otherwise
                    error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
            end
            checkMIRcatReturnError(ret);
        end
        
        function cancelManualTune(obj)
            ret = calllib('MIRcatSDK', 'MIRcatSDK_CancelManualTuneMode');
            checkMIRcatReturnError(ret);
        end
        
        function [newWavelength, newUnits] = convertWavelength(obj,currentWavelength, currentUnits, newUnits)
            switch currentUnits
                case 'um'
                    switch newUnits
                        case 'um'
                            newWavelength = currentWavelength;
                        case 'cm-1'
                            newWavelength = 10000./currentWavelength;
                        otherwise
                            error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
                    end
                case 'cm-1'
                    switch newUnits
                        case 'um'
                            newWavelength = 10000./currentWavelength;
                        case 'cm-1'
                            newWavelength = currentWavelength;
                        otherwise
                            error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
                    end
                otherwise
                    error('Error! *[User Error]* Units must be either ''cm-1'' or ''um''');
            end
        end
        
        function QCLNum = whichQCL(obj, wavelength, units)
            if strcmp(units, 'um')
                wavelength = obj.convertWavelength(wavelength, units, 'cm-1');
            end
            
            if wavelength >= obj.QCLs{3}.tuningRange_cm1(1) && wavelength < 1750
                QCLNum = 3;
            elseif wavelength >= 1750 && wavelength < 1975
                QCLNum = 2;
            elseif wavelength >= 1975 && wavelength < obj.QCLs{1}.tuningRange_cm1(2)
                QCLNum = 1;
            else
                QCLNum = -1;
            end
        end
                
    end
    
    %% Get Properties Methods
    methods
        
        function APIVersion = get.APIVersion(obj)
            major = uint16(0);
            majorPtr = libpointer('uint16Ptr', major);
            
            minor = uint16(0);
            minorPtr = libpointer('uint16Ptr', minor);
            
            patch = uint16(0);
            patchPtr = libpointer('uint16Ptr', patch);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_GetAPIVersion', majorPtr, minorPtr, patchPtr);
            checkMIRcatReturnError(ret);
            % Convert the pointer values to the original variables.
            APIVersion = [majorPtr.value minorPtr.value patchPtr.value];
        end
        
        function modelNumber = get.modelNumber(obj)
            [ret, modelNumber] = calllib('MIRcatSDK', 'MIRcatSDK_GetModelNumber', blanks(100), 100);
            checkMIRcatReturnError(ret);
        end
        
        function serialNumber = get.serialNumber(obj)
            [ret, serialNumber] = calllib('MIRcatSDK', 'MIRcatSDK_GetSerialNumber', blanks(100), 100);
            checkMIRcatReturnError(ret);
        end
        
        function numQCLs = get.numQCLs(obj)
            numQCLs = uint8(0);
            numQCLsPtr = libpointer('uint8Ptr', numQCLs);
            ret = calllib('MIRcatSDK','MIRcatSDK_GetNumInstalledQcls', numQCLsPtr);
            checkMIRcatReturnError(ret);
            
            numQCLs = numQCLsPtr.value;
        end
        
        function isConnected = get.isConnected(obj)
            isConnected = false;
            isConnectedPtr = libpointer('bool', isConnected);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsConnectedToLaser', isConnectedPtr);
            checkMIRcatReturnError(ret);
            
            isConnected = isConnectedPtr.value;
        end
        
        function isInterlockSet = get.isInterlockSet(obj)
            isInterlockSet = false;
            isInterlockSetPtr = libpointer('bool', isInterlockSet);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsInterlockedStatusSet', isInterlockSetPtr);
            checkMIRcatReturnError(ret);
            isInterlockSet = isInterlockSetPtr.value;
        end
        
        function isKeySwitchSet = get.isKeySwitchSet(obj)
            isKeySwitchSet = false;
            isKeySwitchSetPtr = libpointer('bool', isKeySwitchSet);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsKeySwitchStatusSet', isKeySwitchSetPtr);
            checkMIRcatReturnError(ret);
            isKeySwitchSet = isKeySwitchSetPtr.value;
        end
        
        function isEmitting = get.isEmitting(obj)
            isEmitting = false;
            isEmittingPtr = libpointer('bool', isEmitting);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr);
            checkMIRcatReturnError(ret);
            isEmitting = isEmittingPtr.value;
        end
        
        function isArmed = get.isArmed(obj)
            isArmed = false;
            isArmedPtr = libpointer('bool', isArmed);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
            checkMIRcatReturnError(ret);
            isArmed = isArmedPtr.value;
        end
        
        function isSystemError = get.isSystemError(obj)
            isSystemError = false;
            isSystemErrorPtr = libpointer('bool', isSystemError);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsSystemError', isSystemErrorPtr);
            checkMIRcatReturnError(ret);
            isSystemError = isSystemErrorPtr.value;
        end
        
        function areTECsAtTemp = get.areTECsAtTemp(obj)
            areTECsAtTemp = false;
            areTECsAtTempPtr = libpointer('bool', areTECsAtTemp);
            ret = calllib('MIRcatSDK','MIRcatSDK_AreTECsAtSetTemperature', areTECsAtTempPtr);
            checkMIRcatReturnError(ret);
            areTECsAtTemp = areTECsAtTempPtr.value;
        end
        
        function systemErrorWord = get.systemErrorWord(obj)
            systemErrorWord = uint16(0);
            systemErrorWordPtr = libpointer('uint16Ptr', systemErrorWord);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetSystemErrorWord', systemErrorWordPtr);
            checkMIRcatReturnError(ret);
            systemErrorWord = systemErrorWordPtr.value;
        end
        
%         function unitsIndex = get.unitsIndex(obj)
%             units = uint8(0);
%             unitsPtr = libpointer('uint8Ptr', units);
%             ret = calllib('MIRcatSDK', 'MIRcatSDK_GetWWDisplayUnits', unitsPtr);
%             checkMIRcatReturnError(ret);
%             unitsIndex = unitsPtr.value;
%         end
        
        function unitsString = get.unitsString(obj)
            unitsString = obj.unitsArray{obj.unitsIndex};
        end
        
        function activeQCL = get.activeQCL(obj)
            activeQCL = uint8(0);
            activeQCLPtr = libpointer('uint8Ptr', activeQCL);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetActiveQcl', activeQCLPtr);
            checkMIRcatReturnError(ret);
            activeQCL = activeQCLPtr.value;
        end
        
        function actualWavelength = get.actualWavelength(obj)
            actualWavelengthPtr = libpointer('singlePtr', 0);
            pbUnits = uint8(0);
            unitsPtr = libpointer('uint8Ptr', pbUnits);
            lightValid = false;
            lightValidPtr = libpointer('bool', lightValid);
            
            % Check Actual Wavelength
            ret = calllib('MIRcatSDK','MIRcatSDK_GetActualWW', actualWavelengthPtr, unitsPtr, lightValidPtr);
            checkMIRcatReturnError(ret);
            actualWavelength = actualWavelengthPtr.value;
        end
        
        function tuneWavelength = get.tuneWavelength(obj)
            tuneWavelengthPtr = libpointer('singlePtr', 0);
            pbUnits = uint8(0);
            unitsPtr = libpointer('uint8Ptr', pbUnits);
            prefQCL = uint8(obj.activeQCL);
            prefQCLPtr = libpointer('uint8Ptr', prefQCL);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetTuneWW', tuneWavelengthPtr, unitsPtr, prefQCLPtr);
            checkMIRcatReturnError(ret);
            tuneWavelength = tuneWavelengthPtr.value;
            
        end
        
        function isTuned = get.isTuned(obj)
            isTuned = false;
            isTunedPtr = libpointer('bool', isTuned);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
            checkMIRcatReturnError(ret);
            isTuned = isTunedPtr.value;
        end
    end
    
    %% Methods for cleanup
    methods
        function delete(obj)
            if obj.isArmed % If QCL is armed, disarm it
                obj.disarmLaser;
            end
            
            if obj.isConnected
                obj.disconnect; % Disconnect QCL
            end
            
            obj.SaveDefaults;
            
            if libisloaded(obj.libname) % If library is loaded, unload the library
                unloadlibrary(obj.libname);
            end
            
            clear obj
        end
        
        function ReadDefaults(obj)
            name = 'unitsIndex';
            d = Defaults(obj);
            d.LoadDefaults(name);
        end
        
        function SaveDefaults(obj)
            name = 'unitsIndex';
            d = Defaults(obj);
            d.SaveDefaults(name);
        end
    end
end