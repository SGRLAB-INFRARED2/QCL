classdef QCL_Unit < handle
    
    properties (Constant)
        MIRcatSDK_UNITS_MICRONS = 1;
        MIRcatSDK_UNITS_CM1 = 2;
    end
    
    properties (SetAccess = private)
        QCLNum;
    end
    
    properties (Dependent)
        tuningRange_um;
        tuningRange_cm1;
        actualTemp;
        setTemp;
        tempRange;
        current;
        active;
    end
    
    methods (Access = protected)
        
        function obj = QCL_Unit(QCLNum)
            obj.QCLNum = QCLNum;
        end
    end
    
    methods
        function tuningRange_um = get.tuningRange_um(obj)
            
            minRange = 0;
            minRangePtr = libpointer('singlePtr', minRange);
            
            maxRange = 0;
            maxRangePtr = libpointer('singlePtr', maxRange);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetQclTuningRange', obj.QCLNum,...
                minRangePtr, maxRangePtr, obj.MIRcatSDK_UNITS_MICRONS);
            minRange = minRangePtr.value;
            maxRange = maxRangePtr.value;
            tuningRange_um = [minRange maxRange];
        end
        
        function tuningRange_cm1 = get.tuningRange_cm1(obj)
            tuningRange_cm1 = [0 0];
            tuningRange_cm1(1) = obj.convertWavelength(obj.tuningRange_um(2), 'um', 'cm1');
            tuningRange_cm1(2) = obj.convertWavelength(obj.tuningRange_um(1), 'um', 'cm1');
        end
        
        function actualTemp = get.actualTemp(obj)
            actualTemp = 0;
            QclTempPtr = libpointer('singlePtr', actualTemp);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperature', obj.QCLNum, QclTempPtr);
            actualTemp = QclTempPtr.value;
        end
        
        function setTemp = get.setTemp(obj)
            setTemp = 0;
            QCLSetTempPtr = libpointer('singlePtr', setTemp);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetQclSetTemperature', obj.QCLNum, QCLSetTempPtr);
            
            setTemp = QCLSetTempPtr.value;
        end
        
        function [tempRange] = get.tempRange(obj)
            nominalTemp = 0;
            nominalTempPtr = libpointer('singlePtr', nominalTemp);
            
            minTemp = 0;
            minTempPtr = libpointer('singlePtr', minTemp);
            
            maxTemp = 0;
            maxTempPtr = libpointer('singlePtr', maxTemp);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetQCLTemperatureRange', obj.QCLNum, nominalTempPtr, minTempPtr, maxTempPtr);
            
            nominalTemp = nominalTempPtr.value;
            minTemp = minTempPtr.value;
            maxTemp = maxTempPtr.value;
            tempRange = [minTemp nominalTemp maxTemp];
        end
        
        function currentInMilliAmps = get.current(obj)
            currentInMilliAmps = 0;
            currentInMilliAmpsPtr = libpointer('singlePtr', currentInMilliAmps);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetQCLCurrent', obj.QCLNum, currentInMilliAmpsPtr);
            
            currentInMilliAmps = currentInMilliAmpsPtr.value;
        end
        
        function active = get.active(obj)
            
            activeQCL = uint8(0);
            activeQCLPtr = libpointer('uint8Ptr', activeQCL);
            
            calllib('MIRcatSDK', 'MIRcatSDK_GetActiveQcl', activeQCLPtr);
            
            activeQCL = activeQCLPtr.value;
            
            if activeQCL == obj.QCLNum
                active = true;
            else
                active = false;
            end
        end
        
    end
    
    methods (Access = private)
        function convertedWavelength = convertWavelength(obj, currentWavelength, currentUnits, newUnits)
            
            currentWavelengthPtr = libpointer('singlePtr', currentWavelength);
            
            convertedWavelength = 0;
            convertedWavelengthPtr = libpointer('singlePtr', convertedWavelength);
            
            switch currentUnits
                case 'um'
                    curUnits = obj.MIRcatSDK_UNITS_MICRONS;
                case 'cm1'
                    curUnits = obj.MIRcatSDK_UNITS_CM1;
                otherwise
                    error('Please select wavenumbers (cm-1) or wavelength (um) for the current units');
            end
            
            switch newUnits
                case 'um'
                    nUnits = obj.MIRcatSDK_UNITS_MICRONS;
                case 'cm1'
                    nUnits = obj.MIRcatSDK_UNITS_CM1;
                otherwise
                    error('Please select wavenumbers (cm-1) or wavelength (um) for the new units');
            end
            
            calllib('MIRcatSDK', 'MIRcatSDK_ConvertWW', currentWavelengthPtr,...
                curUnits, nUnits, convertedWavelengthPtr);
            
            convertedWavelength = convertedWavelengthPtr.value;
        end
    end
end