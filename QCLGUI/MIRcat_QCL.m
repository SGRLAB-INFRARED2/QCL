classdef MIRcat_QCL < handle
    
    properties (SetAccess = private, Hidden = true)
        libname = 'MIRcatSDK'; % Add rest of library path;
    end
    
    properties (SetAccess = private)
        QCLs = struct('QCL', QCL_Unit(0, 0));
        QCLconsts;
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
        units;
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
%             try
                if ~libisloaded(obj.libname) % If the QCL library isn't loaded, load the library
                    obj.setupQCLEnv;
                end
                obj.QCLconsts = load(strcat(fileparts(mfilename('fullpath')), '\lib\MIRcatSDKconstants.mat'));
                obj.connect;
                for ii = 1:obj.numQCLs
                    obj.QCLs(ii) = struct('QCL', QCL_Unit(ii, obj.QCLconsts));
                end
%                 
%             catch
%                 warning('Error Initializing.  Enter simulation mode.');
%             end
%             
        end
        
        
    end
    
    %% Methods for Setup and Deletion
    methods (Access = private)
        function setupQCLEnv(obj)
            
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
        
        function connect(obj)
            if ~obj.isConnected
                % Call your function
                ret = calllib('MIRcatSDK','MIRcatSDK_Initialize');
                % Check to see if function call was Successful
                checkError(ret);
%                 if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                     if obj.QCLconsts.MIRcatSDK_RET_INITIALIZATION_FAILURE == ret
%                         error('Error! Code: %d. *[System Error]* If MIRcat controller Initialization failed.', ret);
%                     else
%                         error('Error! Code: %d', ret);
%                     end
%                 end
            end
        end
        
        function disconnect(obj)
            ret = calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. *[User Error]* User tried to DeInitialize MIRcat object before controller initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
        end
    end
    
    %% Methods That Change Laser State
    methods
        function armLaser(obj)
            if ~obj.isArmed
                ret = calllib('MIRcatSDK','MIRcatSDK_ArmLaser');
            end
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_INTERLOCKS_KEYSWITCH_NOTSET == ret
%                     error('Error! Code: %d. *[User Error]* Interlock or key switch not set.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_ARMDISARM_FAILURE == ret
%                     error('Error! Code: %d. *[System Error]* System has failed to toggle laser arming.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_LASER_ALREADY_ARMED == ret
%                     error('Error! Code: %d. *[User Error]* User attempted to arm the laser when it has already been armed.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
        end
        
        function disarmLaser(obj)
            ret = calllib('MIRcatSDK','MIRcatSDK_DisarmLaser');
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_INTERLOCKS_KEYSWITCH_NOTSET == ret
%                     error('Error! Code: %d. *[User Error]* Interlock or key switch not set.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_ARMDISARM_FAILURE == ret
%                     error('Error! Code: %d. *[System Error]* System has failed to toggle laser arming.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_LASER_ALREADY_ARMED == ret
%                     error('Error! Code: %d. *[User Error]* User attempted to disarm the laser when it has already been armed.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
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
            checkError(ret);
%             % Check to see if function call was Successful
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 error('Error! Code: %d', ret);
%             end
            
            % Convert the pointer values to the original variables.
            APIVersion = [majorPtr.value minorPtr.value patchPtr.value];
        end
        
        function modelNumber = get.modelNumber(obj)
            %             MIRCAT_LIB uint32_t MIRcatSDK_GetModelNumber(char * pszModelNumber, uint8_t bSize);
            %% TO DO
            % Implement this method
            modelNumber = 0;
        end
        
        function serialNumber = get.serialNumber(obj)
            %             MIRCAT_LIB uint32_t MIRcatSDK_GetSerialNumber(char * pszSerialNumber, uint8_t bSize);
            %% TO DO
            % Implement this method
            serialNumber = 0;
        end
        
        function numQCLs = get.numQCLs(obj)
            numQCLs = uint8(0);
            numQCLsPtr = libpointer('uint8Ptr', numQCLs);
            ret = calllib('MIRcatSDK','MIRcatSDK_GetNumInstalledQcls', numQCLsPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            
            numQCLs = numQCLsPtr.value;
        end
        
        function isConnected = get.isConnected(obj)
            isConnected = false;
            isConnectedPtr = libpointer('bool', isConnected);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsConnectedToLaser', isConnectedPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            
            isConnected = isConnectedPtr.value;
        end
        
        function isInterlockSet = get.isInterlockSet(obj)
            isInterlockSet = false;
            isInterlockSetPtr = libpointer('bool', isInterlockSet);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsInterlockedStatusSet', isInterlockSetPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            isInterlockSet = isInterlockSetPtr.value;
        end
        
        function isKeySwitchSet = get.isKeySwitchSet(obj)
            isKeySwitchSet = false;
            isKeySwitchSetPtr = libpointer('bool', isKeySwitchSet);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsKeySwitchStatusSet', isKeySwitchSetPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            isKeySwitchSet = isKeySwitchSetPtr.value;
        end
        
        function isEmitting = get.isEmitting(obj)
            isEmitting = false;
            isEmittingPtr = libpointer('bool', isEmitting);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsEmissionOn', isEmittingPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_COMM_ERROR == ret
%                     error('Error! Code: %d. MIRcat controller is unable to Read Info regarding the light from the system.', ret);
%                 else
%                     error('Error! Code: %d', ret);                    
%                 end
%             end
            isEmitting = isEmittingPtr.value;
        end
            
        function isArmed = get.isArmed(obj)
            isArmed = false;
            isArmedPtr = libpointer('bool', isArmed);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            isArmed = isArmedPtr.value;
        end
        
        function isSystemError = get.isSystemError(obj)
            isSystemError = false;
            isSystemErrorPtr = libpointer('bool', isSystemError);
            
            ret = calllib('MIRcatSDK','MIRcatSDK_IsSystemError', isSystemErrorPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            isSystemError = isSystemErrorPtr.value;
        end
        
        function areTECsAtTemp = get.areTECsAtTemp(obj)
            areTECsAtTemp = false;
            areTECsAtTempPtr = libpointer('bool', areTECsAtTemp);
            ret = calllib('MIRcatSDK','MIRcatSDK_AreTECsAtSetTemperature', areTECsAtTempPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            areTECsAtTemp = areTECsAtTempPtr.value;
        end
        
        function systemErrorWord = get.systemErrorWord(obj)
            systemErrorWord = uint16(0);
            systemErrorWordPtr = libpointer('uint16Ptr', systemErrorWord);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetSystemErrorWord', systemErrorWordPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            systemErrorWord = systemErrorWordPtr.value;
        end
        
        function units = get.units(obj)
            units = uint8(0);
            unitsPtr = libpointer('uint8Ptr', units);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetWWDisplayUnits', unitsPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            units = unitsPtr.value;
        end
        
        function activeQCL = get.activeQCL(obj)
            activeQCL = uint8(0);
            activeQCLPtr = libpointer('uint8Ptr', activeQCL);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetActiveQcl', activeQCLPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
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
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret)
%                 elseif obj.QCLconsts.MIRcatSDK_RET_COMM_ERROR == ret
%                     error('Error! Code: %d. MIRcat controller is unable to Read Info regarding the light from the system.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            actualWavelength = actualWavelengthPtr.value;
        end
        
        function tuneWavelength = get.tuneWavelength(obj)
            tuneWavelengthPtr = libpointer('singlePtr', 0);
            pbUnits = uint8(0);
            unitsPtr = libpointer('uint8Ptr', pbUnits);
            prefQCL = uint8(obj.activeQCL);
            prefQCLPtr = libpointer('uint8Ptr', prefQCL);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetTuneWW', tuneWavelengthPtr, unitsPtr, prefQCLPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            
            tuneWavelength = tuneWavelengthPtr.value;
        end
        
        function isTuned = get.isTuned(obj)
            isTuned = false;
            isTunedPtr = libpointer('bool', isTuned);
            ret = calllib('MIRcatSDK','MIRcatSDK_IsTuned', isTunedPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
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
            
            if libisloaded(obj.libname) % If library is loaded, unload the library
                unloadlibrary(obj.libname);
            end
        end
    end
end