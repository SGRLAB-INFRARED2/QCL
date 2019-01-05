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
        current;
        actualTemp;
        mode;
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
        function tuningRange_um = get.tuningRange_um(obj)
            minRangePtr = libpointer('singlePtr', 0);
            maxRangePtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQclTuningRange', obj.QCLNum,...
                minRangePtr, maxRangePtr, obj.QCLconsts.MIRcatSDK_UNITS_MICRONS);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
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
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            pulseRate = pulseRatePtr.value;
        end
        
        function pulseWidth = get.pulseWidth(obj)
            pulseWidthPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLPulseWidth', obj.QCLNum, pulseWidthPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            pulseWidth = pulseWidthPtr.value;
        end
        
        function currentInMilliAmps = get.current(obj)
            currentInMilliAmpsPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLCurrent', obj.QCLNum, currentInMilliAmpsPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end            
            currentInMilliAmps = currentInMilliAmpsPtr.value;
        end
        
        function actualTemp = get.actualTemp(obj)
            QclTempPtr = libpointer('singlePtr', 0);
            
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperature', obj.QCLNum, QclTempPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            actualTemp = QclTempPtr.value;
        end
        
        function mode = get.mode(obj)
            mode = uint8(0);
            modePtr = libpointer('uint8Ptr', mode);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLOperatingMode', obj.QCLNum, modePtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
%             #define MIRcatSDK_MODE_ERROR                                ((uint8_t)0)
%             #define MIRcatSDK_MODE_PULSED                               ((uint8_t)1)
%             #define MIRcatSDK_MODE_CW                                   ((uint8_t)2)
%             #define MIRcatSDK_MODE_CW_MOD                               ((uint8_t)3)
%             #define MIRcatSDK_MODE_CW_MR                                ((uint8_t)6)	//currently not supported in firmware
%             #define MIRcatSDK_MODE_CW_MR_MOD                            ((uint8_t)7)	//currently not supported in firmware
%             #define MIRcatSDK_MODE_CW_FLTR1                             ((uint8_t)8)
%             #define MIRcatSDK_MODE_CW_FLTR2                             ((uint8_t)9)
%             #define MIRcatSDK_MODE_CW_FLTR1_MOD                         ((uint8_t)10)
            mode = modePtr.value;
        end
        
        function setTemp = get.setTemp(obj)
            QCLSetTempPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQclSetTemperature', obj.QCLNum, QCLSetTempPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            setTemp = QCLSetTempPtr.value;
        end
        
        function tempRange = get.tempRange(obj)
            nominalTempPtr = libpointer('singlePtr', 0);
            minTempPtr = libpointer('singlePtr', 0);
            maxTempPtr = libpointer('singlePtr', 0);
            ret = calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperatureRange', ...
                obj.QCLNum, nominalTempPtr, minTempPtr, maxTempPtr);
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 elseif obj.QCLconsts.MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
%                     error('Error! Code: %d. *[User Error]* QCL is out of range. Must be 1-4.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            tempRange = [minTempPtr.value nominalTempPtr.value maxTempPtr.value];
        end
        
        function active = get.active(obj)
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
            checkError(ret);
%             if obj.QCLconsts.MIRcatSDK_RET_SUCCESS ~= ret
%                 % If the operation fails raise an error.
%                 if obj.QCLconsts.MIRcatSDK_RET_NOT_INITIALIZED == ret
%                     error('Error! Code: %d. MIRcat controller is not yet initialized.', ret);
%                 else
%                     error('Error! Code: %d', ret);
%                 end
%             end
            tecParams = struct('voltage', voltagePtr.value, 'current',...
                currentPtr.value, 'resistance', resistancePtr.value);
        end           
            
    end
    
%     methods (Access = private)
%         function convertedWavelength = convertWavelength(obj, currentWavelength, currentUnits, newUnits)
%             currentWavelengthPtr = libpointer('singlePtr', currentWavelength);
%             convertedWavelength = 0;
%             convertedWavelengthPtr = libpointer('singlePtr', convertedWavelength);
%             switch currentUnits
%                 case 'um'
%                     curUnits = obj.QCLconsts.MIRcatSDK_UNITS_MICRONS;
%                 case 'cm1'
%                     curUnits = obj.QCLconsts.MIRcatSDK_UNITS_CM1;
%                 otherwise
%                     error('Please select wavenumbers (cm-1) or wavelength (um) for the current units');
%             end
%             
%             switch newUnits
%                 case 'um'
%                     nUnits = obj.QCLconsts.MIRcatSDK_UNITS_MICRONS;
%                 case 'cm1'
%                     nUnits = obj.QCLconsts.MIRcatSDK_UNITS_CM1;
%                 otherwise
%                     error('Please select wavenumbers (cm-1) or wavelength (um) for the new units');
%             end
%             
%             calllib('MIRcatSDK', 'MIRcatSDK_ConvertWW', currentWavelengthPtr,...
%                 curUnits, nUnits, convertedWavelengthPtr);
%             
%             convertedWavelength = convertedWavelengthPtr.value;
%         end
%     end
end