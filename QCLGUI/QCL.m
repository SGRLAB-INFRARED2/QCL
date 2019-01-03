classdef QCL < handle
    
    properties (SetAccess = private, Hidden = true)
        libname;
    end
    
    methods
        
        function obj = QCL
            obj.libname = 'MIRcatSDK'; % Add rest of library path
            if ~libisloaded(obj.libname) % If the QCL library isn't loaded, load the library
                setupQCLEnv;
            end
            connectQCL; % Connect to QCL
        end
        
        function delete(obj)
            
            if isLaserArmed % If QCL is armed, disarm it
                disarmLaser;
            end
            
            disconnectQCL; % Disconnect QCL
            
            if libisloaded(obj.libname) % If library is loaded, unload the library
                unloadlibrary(obj.libname);
            end
        end
    end
    
end