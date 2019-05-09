classdef QCL_Unit < handle
    
    properties (SetAccess = private)
        QCLNum;
        QCLconsts;
    end
    
    properties (Dependent)
        tuningRange_um;
        tuningRange_cm1;
        pulseRate;
        pulseWidth;
        dutyCycle;
        current;
        actualTemp;
        modeIndex;
        modeString;
        setTemp;
        tempRange;
        active;
        tecParams;
    end
    
    methods %(Access = protected)
        
        function obj = QCL_Unit(QCLNum, QCLconsts)
            obj.QCLNum = QCLNum;
            obj.QCLconsts = QCLconsts;
        end
    end
    
    methods
        function setQCLParams(obj, pulseRate, pulseWidth, current)
            ret = calllib('MIRcatSDK', 'MIRcatSDK_SetQCLParams', obj.QCLNum, pulseRate, pulseWidth, current);
            checkMIRcatReturnError(ret);
        end
    end
    
    methods
        function tuningRange_um = get.tuningRange_um(obj)
            minRangePtr = libpointer('singlePtr', 0);
            maxRangePtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQclTuningRange', obj.QCLNum,...
                minRangePtr, maxRangePtr, obj.QCLconsts.MIRcatSDK_UNITS_MICRONS);
            checkMIRcatReturnError(ret);
            tuningRange_um = [minRangePtr.value maxRangePtr.value];
        end
        
        function tuningRange_cm1 = get.tuningRange_cm1(obj)
            tuningRange_cm1 = [0 0];
            tuningRange_cm1(1) = 10000./obj.tuningRange_um(2);
            tuningRange_cm1(2) = 10000./obj.tuningRange_um(1);
        end
        
        function pulseRate = get.pulseRate(obj)
            pulseRatePtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLPulseRate', obj.QCLNum, pulseRatePtr);
            checkMIRcatReturnError(ret);
            pulseRate = pulseRatePtr.value;
        end
        
        function pulseWidth = get.pulseWidth(obj)
            pulseWidthPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLPulseWidth', obj.QCLNum, pulseWidthPtr);
            checkMIRcatReturnError(ret);
            pulseWidth = pulseWidthPtr.value;
        end
        
        function dutyCycle = get.dutyCycle(obj)
            dutyCycle = obj.pulseWidth*10^(-9) * obj.pulseRate * 100;
        end
        
        function currentInMilliAmps = get.current(obj)
            currentInMilliAmpsPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLCurrent', obj.QCLNum, currentInMilliAmpsPtr);
            checkMIRcatReturnError(ret);        
            currentInMilliAmps = currentInMilliAmpsPtr.value;
        end
        
        function actualTemp = get.actualTemp(obj)
            QclTempPtr = libpointer('singlePtr', 0);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperature', obj.QCLNum, QclTempPtr);
            checkMIRcatReturnError(ret);
            actualTemp = QclTempPtr.value;
        end
        
        function modeIndex = get.modeIndex(obj)
            modeIndex = uint8(0);
            modePtr = libpointer('uint8Ptr', modeIndex);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLOperatingMode', obj.QCLNum, modePtr);
            checkMIRcatReturnError(ret);
%             #define MIRcatSDK_MODE_ERROR                                ((uint8_t)0)
%             #define MIRcatSDK_MODE_PULSED                               ((uint8_t)1)
%             #define MIRcatSDK_MODE_CW                                   ((uint8_t)2)
%             #define MIRcatSDK_MODE_CW_MOD                               ((uint8_t)3)
%             #define MIRcatSDK_MODE_CW_MR                                ((uint8_t)6)	//currently not supported in firmware
%             #define MIRcatSDK_MODE_CW_MR_MOD                            ((uint8_t)7)	//currently not supported in firmware
%             #define MIRcatSDK_MODE_CW_FLTR1                             ((uint8_t)8)
%             #define MIRcatSDK_MODE_CW_FLTR2                             ((uint8_t)9)
%             #define MIRcatSDK_MODE_CW_FLTR1_MOD                         ((uint8_t)10)
            modeIndex = modePtr.value;
        end
        
        function modeString = get.modeString(obj)            
            switch obj.modeIndex
                case 1
                    modeString = 'PULSED';
                case 2
                    modeString = 'CW'; 
                case 3
                    modeString = 'CW MOD';
                case 6 
                    modeString = 'CW MR';
                case 7
                    modeString = 'CW MR MOD';
                case 8 
                    modeString = 'CW FLTR1'; 
                case 9
                    modeString = 'CW FLTR2'; 
                case 10
                    modeString = 'CW FLTR1 MOD';
                otherwise
                    modeString = 'ERROR';
            end
        end
        
        function setTemp = get.setTemp(obj)
            QCLSetTempPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQclSetTemperature', obj.QCLNum, QCLSetTempPtr);
            checkMIRcatReturnError(ret);
            setTemp = QCLSetTempPtr.value;
        end
        
        function tempRange = get.tempRange(obj)
            nominalTempPtr = libpointer('singlePtr', 0);
            minTempPtr = libpointer('singlePtr', 0);
            maxTempPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperatureRange', ...
                obj.QCLNum, nominalTempPtr, minTempPtr, maxTempPtr);
            checkMIRcatReturnError(ret);
            tempRange = [minTempPtr.value nominalTempPtr.value maxTempPtr.value];
        end
        
        function active = get.active(obj)
            activeQCL = uint8(0);
            activeQCLPtr = libpointer('uint8Ptr', activeQCL);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetActiveQcl', activeQCLPtr);
            checkMIRcatReturnError(ret);
            activeQCL = activeQCLPtr.value;
            active = false;
            if activeQCL == obj.QCLNum
                active = true;
            end
        end
        
        function tecParams = get.tecParams(obj)
            voltagePtr = libpointer('singlePtr', 0);
            currentPtr = libpointer('singlePtr', 0);
            resistancePtr = libpointer('singlePtr', 0);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetAllTecParams', ...
                obj.QCLNum, voltagePtr, currentPtr, resistancePtr);
            checkMIRcatReturnError(ret);
            tecParams = struct('voltage', voltagePtr.value, 'current',...
                currentPtr.value, 'resistance', resistancePtr.value);
        end
    end
end