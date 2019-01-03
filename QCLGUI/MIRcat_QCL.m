classdef MIRcat_QCL < handles
    
    properties (SetAccess = private, Hidden = true)
        libname = 'MIRcatSDK'; % Add rest of library path;
    end
    
    properties (SetAccess = private)
        QCLs;
        QCLconsts;
    end
    
    properties (Dependent)
        numQCLs;
        APIVersion;
        mode;
        caseTemp1;
        caseTemp2;
        PCBTemp;
        isInterlock;
        isKeySwitch;
        areTECsAtTemp;
        isConnected;
        isEmitting;
        systemFault;
        currentQCLNum;
        isTuned;
        isArmed;
        isManualTune
    end
    
    %make the constructor private
    methods (Access = private)
        
        function obj = MIRcat_QCL()
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
                obj.connect;
                for ii = 1:obj.numQCLs
                    obj.QCLs(ii) = QCL_Unit(ii);
                end
                
            catch E
                warning(E.identifier, 'Monochromator');
                warning('Error Initializing.  Enter simulation mode.');
            end
            
        end
        
        
    end
    
    methods (Access = protected, Static)
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
            
            obj.QCLconsts = load(strcat(dir, '\lib\MIRcatSDKconstants.mat'));
            
        end
        
        function connect(obj)
            if ~obj.isConnected
                % Call your function
                ret = calllib('MIRcatSDK','MIRcatSDK_Initialize');
                % Check to see if function call was Successful
                if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
                    error('Error! Code: %d', ret);
                end
            end
        end
        
        function disconnect(obj)
            ret = calllib('MIRcatSDK','MIRcatSDK_DeInitialize');
            
            if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
                % If the operation fails raise an error.
                error('Error! Code: %d', ret);
            end            
        end
        
        function armLaser(obj)            
            if ~obj.isArmed
                ret = calllib('MIRcatSDK','MIRcatSDK_ArmDisarmLaser');
            end
            
            if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
                error('Error! Code: %d', ret);
            end
        end
        
        function disarm(obj)
            ret = calllib('MIRcatSDK','MIRcatSDK_DisarmLaser');
            
            if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
                % If the operation fails raise an error.
                error('Error! Code: %d', ret);
            end
        end        
    end
    
    methods
        function isConnected = get.isConnected(obj)
            isConnected = false;
            isConnectedPtr = libpointer('bool', isConnected);
            calllib('MIRcatSDK','MIRcatSDK_IsConnectedToLaser', isConnectedPtr);
            isConnected = isConnectedPtr.value;
        end
        
        function isArmed = get.isArmed(obj)
            isArmed = false;
            isArmedPtr = libpointer('bool', isArmed);
            calllib('MIRcatSDK','MIRcatSDK_IsLaserArmed', isArmedPtr);
            isArmed = isArmedPtr.value;
        end
        
        function numQCLs = get.numQCLs(obj)
            numQCLs = uint8(0);
            numQCLsPtr = libpointer('uint8Ptr', numQCLs);
            calllib('MIRcatSDK','MIRcatSDK_GetNumInstalledQcls', numQCLsPtr);
            numQCLs = numQCLsPtr.value;
        end
        
        function delete(obj)
            if obj.isArmed % If QCL is armed, disarm it
                obj.disarm;
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