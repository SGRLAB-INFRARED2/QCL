function checkError(ret)

MIRcatSDK_RET_SUCCESS                               = uint32(0);
MIRcatSDK_RET_UNSUPPORTED_TRANSPORT                 = uint32(1);
MIRcatSDK_RET_INITIALIZATION_FAILURE                = uint32(32);
MIRcatSDK_RET_ARMDISARM_FAILURE                     = uint32(64);
MIRcatSDK_RET_STARTTUNE_FAILURE                     = uint32(65);
MIRcatSDK_RET_INTERLOCKS_KEYSWITCH_NOTSET           = uint32(66);
MIRcatSDK_RET_STOP_SCAN_FAILURE                     = uint32(67);
MIRcatSDK_RET_PAUSE_SCAN_FAILURE                    = uint32(68);
MIRcatSDK_RET_RESUME_SCAN_FAILURE                   = uint32(69);
MIRcatSDK_RET_MANUAL_STEP_SCAN_FAILURE              = uint32(70);
MIRcatSDK_RET_START_SWEEPSCAN_FAILURE               = uint32(71);
MIRcatSDK_RET_START_STEPMEASURESCAN_FAILURE         = uint32(72);
MIRcatSDK_RET_INDEX_OUTOFBOUNDS                     = uint32(73);
MIRcatSDK_RET_START_MULTISPECTRALSCAN_FAILURE       = uint32(74);
MIRcatSDK_RET_TOO_MANY_ELEMENTS                     = uint32(75);
MIRcatSDK_RET_NOT_ENOUGH_ELEMENTS                   = uint32(76);
MIRcatSDK_RET_BUFFER_TOO_SMALL                      = uint32(77);
MIRcatSDK_RET_FAVORITE_NAME_NOTRECOGNIZED           = uint32(78);
MIRcatSDK_RET_FAVORITE_RECALL_FAILURE               = uint32(79);
MIRcatSDK_RET_WW_OUTOFTUNINGRANGE                   = uint32(80);
MIRcatSDK_RET_NO_SCAN_INPROGRESS                    = uint32(81);
MIRcatSDK_RET_EMISSION_ON_FAILURE                   = uint32(82);
MIRcatSDK_RET_EMISSION_ALREADY_OFF                  = uint32(83);
MIRcatSDK_RET_EMISSION_OFF_FAILURE                  = uint32(84);
MIRcatSDK_RET_EMISSION_ALREADY_ON                   = uint32(85);
MIRcatSDK_RET_PULSERATE_OUTOFRANGE                  = uint32(86);
MIRcatSDK_RET_PULSEWIDTH_OUTOFRANGE                 = uint32(87);
MIRcatSDK_RET_CURRENT_OUTOFRANGE                    = uint32(88);
MIRcatSDK_RET_SAVE_SETTINGS_FAILURE                 = uint32(89);
MIRcatSDK_RET_QCL_NUM_OUTOFRANGE                    = uint32(90);
MIRcatSDK_RET_LASER_ALREADY_ARMED                   = uint32(91);
MIRcatSDK_RET_LASER_ALREADY_DISARMED                = uint32(92);
MIRcatSDK_RET_LASER_NOT_ARMED                       = uint32(93);
MIRcatSDK_RET_LASER_NOT_TUNED                       = uint32(94);
MIRcatSDK_RET_TECS_NOT_AT_SET_TEMPERATURE           = uint32(95);
MIRcatSDK_RET_CW_NOT_ALLOWED_ON_QCL                 = uint32(96);
MIRcatSDK_RET_INVALID_LASER_MODE                    = uint32(97);
MIRcatSDK_RET_TEMPERATURE_OUT_OF_RANGE              = uint32(98);
MIRcatSDK_RET_LASER_POWER_OFF_ERROR                 = uint32(99);
MIRcatSDK_RET_COMM_ERROR                            = uint32(100);
MIRcatSDK_RET_NOT_INITIALIZED                       = uint32(101);
MIRcatSDK_RET_ALREADY_CREATED                       = uint32(102);
MIRcatSDK_RET_START_SWEEP_ADVANCED_SCAN_FAILURE	    = uint32(103);
MIRcatSDK_RET_INJECT_PROC_TRIG_ERROR                = uint32(104);

if MIRcatSDK_RET_SUCCESS ~= ret
    
    if MIRcatSDK_RET_UNSUPPORTED_TRANSPORT == ret
        error('Error! Code: %d -- The user specified `commType` is invalid', ret);
        
    elseif MIRcatSDK_RET_INITIALIZATION_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* MIRcat controller initialization failed.', ret);
        
    elseif MIRcatSDK_RET_ARMDISARM_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to either arm or disarm the laser.', ret);
        
    elseif MIRcatSDK_RET_STARTTUNE_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to tune the laser to the user specified wavelength.', ret);
        
    elseif MIRcatSDK_RET_INTERLOCKS_KEYSWITCH_NOTSET == ret
        error('Error! Code: %d -- *[User Error]* The interlock status is not set or the key switch is not set.', ret);
        
    elseif MIRcatSDK_RET_STOP_SCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to successfully stop the scan in progress.', ret);
        
    elseif MIRcatSDK_RET_PAUSE_SCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to pause the scan in progress.', ret);
        
    elseif MIRcatSDK_RET_RESUME_SCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to resume the scan in progress.', ret);
        
    elseif MIRcatSDK_RET_MANUAL_STEP_SCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to manually move to the next step.', ret);
        
    elseif MIRcatSDK_RET_START_SWEEPSCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to start a Sweep Scan.', ret);
        
    elseif MIRcatSDK_RET_START_STEPMEASURESCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to start a step and measure scan.', ret);
        
    elseif MIRcatSDK_RET_INDEX_OUTOFBOUNDS == ret
        error('Error! Code: %d -- *[User Error]* The user specified index is invalid and out of bounds.', ret);
        
    elseif MIRcatSDK_RET_START_MULTISPECTRALSCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to start a Multi-Spectral Scan.', ret);
        
    elseif MIRcatSDK_RET_TOO_MANY_ELEMENTS == ret
        error('Error! Code: %d -- *[User Error]* The user specified number of elements is too large.', ret);
        
    elseif MIRcatSDK_RET_NOT_ENOUGH_ELEMENTS == ret
        error('Error! Code: %d -- *[User Error]* The user did not define enough Multi-Spectral scan elements.', ret);
        
    elseif MIRcatSDK_RET_BUFFER_TOO_SMALL == ret
        error('Error! Code: %d -- *[User Error]* The user specified buffer is too small for the character array.', ret);
        
    elseif MIRcatSDK_RET_FAVORITE_NAME_NOTRECOGNIZED == ret
        error('Error! Code: %d -- *[User Error]* The user specified an invalid favorite name.', ret);
        
    elseif MIRcatSDK_RET_FAVORITE_RECALL_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to recall the favorite with the user specified name.', ret);
        
    elseif MIRcatSDK_RET_WW_OUTOFTUNINGRANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified wavelength is out of the valid range.', ret);
        
    elseif MIRcatSDK_RET_NO_SCAN_INPROGRESS == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to modify a scan when there was no current scan in progress.', ret);
        
    elseif MIRcatSDK_RET_EMISSION_ON_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to enable the laser emission.', ret);
        
    elseif MIRcatSDK_RET_EMISSION_ALREADY_OFF == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to diable laser emission when it was already disabled.', ret);
        
    elseif MIRcatSDK_RET_EMISSION_OFF_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to disable the laser emission.', ret);
        
    elseif MIRcatSDK_RET_EMISSION_ALREADY_ON == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to enable the laser emission while the laser was already emitting.', ret);
        
    elseif MIRcatSDK_RET_PULSERATE_OUTOFRANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified pulse rate is invalid and out of range.', ret);
        
    elseif MIRcatSDK_RET_PULSEWIDTH_OUTOFRANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified pulse width is invalid and out of range.', ret);
        
    elseif MIRcatSDK_RET_CURRENT_OUTOFRANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified an invalid current that is out of range.', ret);
        
    elseif MIRcatSDK_RET_SAVE_SETTINGS_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to save the QCL settings.', ret);
        
    elseif MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified QCL is out of range. Must be 1-4.', ret);
        
    elseif MIRcatSDK_RET_LASER_ALREADY_ARMED == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to arm the laser when it has already been armed.', ret);
        
    elseif MIRcatSDK_RET_LASER_ALREADY_DISARMED == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to disarm the laser when it has already been disarmed.', ret);
        
    elseif MIRcatSDK_RET_LASER_NOT_ARMED == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to modify the laser when the laser was not yet armed.', ret);
        
    elseif MIRcatSDK_RET_LASER_NOT_TUNED == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to enable laser emission before tuning the laser.', ret);
        
    elseif MIRcatSDK_RET_TECS_NOT_AT_SET_TEMPERATURE == ret
        error('Error! Code: %d -- *[System Error]* The system is not operating at the set temperature.', ret);
        
    elseif MIRcatSDK_RET_CW_NOT_ALLOWED_ON_QCL == ret
        error('Error! Code: %d -- *[User Error]* The user specified QCL does not support CW.', ret);
        
    elseif MIRcatSDK_RET_INVALID_LASER_MODE == ret
        error('Error! Code: %d -- *[User Error]* The user specified an invalid laser mode.', ret);
        
    elseif MIRcatSDK_RET_TEMPERATURE_OUT_OF_RANGE == ret
        error('Error! Code: %d -- *[User Error]* The user specified an invalid temperature that is out of range.', ret);
        
    elseif MIRcatSDK_RET_LASER_POWER_OFF_ERROR == ret
        error('Error! Code: %d -- *[System Error]* The system failed to power off the laser.', ret);
        
    elseif MIRcatSDK_RET_COMM_ERROR == ret
        error('Error! Code: %d -- *[System Error]* Communication error.', ret);
        
    elseif MIRcatSDK_RET_NOT_INITIALIZED == ret
        error('Error! Code: %d -- *[User Error]* User attempted to modify the MIRcat object or call a function before the MIRcatController was initialized.', ret);
        
    elseif MIRcatSDK_RET_ALREADY_CREATED == ret
        error('Error! Code: %d -- *[User Error]* The user attempted to create a new MIRcatObject when an instance has already been initialized.', ret);
        
    elseif MIRcatSDK_RET_START_SWEEP_ADVANCED_SCAN_FAILURE == ret
        error('Error! Code: %d -- *[System Error]* The system failed to start a Sweep-Advanced Scan.', ret);
        
    elseif MIRcatSDK_RET_INJECT_PROC_TRIG_ERROR == ret
        error('Error! Code: %d -- *[System Error]* The system failed to inject a process trigger.', ret);
        
    else
        error('Error! Code: %d', ret);
    end
end



