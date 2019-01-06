function checkMIRcatReturnError(ret)

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
        msgtext = 'Error! Code: %d -- The user specified `commType` is invalid.';
        msgID = 'MIRcatSDK:UNSUPPORTED_TRANSPORT';
        
    elseif MIRcatSDK_RET_INITIALIZATION_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* MIRcat controller initialization failed.';
        msgID = 'MIRcatSDK:INITIALIZATION_FAILURE';
        
    elseif MIRcatSDK_RET_ARMDISARM_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to either arm or disarm the laser.';
        msgID = 'MIRcatSDK:ARMDISARM_FAILURE';
        
    elseif MIRcatSDK_RET_STARTTUNE_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to tune the laser to the user specified wavelength.';
        msgID = 'MIRcatSDK:STARTTUNE_FAILURE';
        
    elseif MIRcatSDK_RET_INTERLOCKS_KEYSWITCH_NOTSET == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The interlock status is not set or the key switch is not set.';
        msgID = 'MIRcatSDK:INTERLOCKS_KEYSWITCH_NOTSET';
        
    elseif MIRcatSDK_RET_STOP_SCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to successfully stop the scan in progress.';
        msgID = 'MIRcatSDK:STOP_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_PAUSE_SCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to pause the scan in progress.';
        msgID = 'MIRcatSDK:PAUSE_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_RESUME_SCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to resume the scan in progress.';
        msgID = 'MIRcatSDK:RESUME_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_MANUAL_STEP_SCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to manually move to the next step.';
        msgID = 'MIRcatSDK:MANUAL_STEP_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_START_SWEEPSCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to start a Sweep Scan.';
        msgID = 'MIRcatSDK:START_SWEEPSCAN_FAILURE';
        
    elseif MIRcatSDK_RET_START_STEPMEASURESCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to start a step and measure scan.';
        msgID = 'MIRcatSDK:START_STEPMEASURESCAN_FAILURE';
        
    elseif MIRcatSDK_RET_INDEX_OUTOFBOUNDS == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified index is invalid and out of bounds.';
        msgID = 'MIRcatSDK:INDEX_OUTOFBOUNDS';
        
    elseif MIRcatSDK_RET_START_MULTISPECTRALSCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to start a Multi-Spectral Scan.';
        msgID = 'MIRcatSDK:START_MULTISPECTRALSCAN_FAILURE';
        
    elseif MIRcatSDK_RET_TOO_MANY_ELEMENTS == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified number of elements is too large.';
        msgID = 'MIRcatSDK:TOO_MANY_ELEMENTS';
        
    elseif MIRcatSDK_RET_NOT_ENOUGH_ELEMENTS == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user did not define enough Multi-Spectral scan elements.';
        msgID = 'MIRcatSDK:NOT_ENOUGH_ELEMENTS';
        
    elseif MIRcatSDK_RET_BUFFER_TOO_SMALL == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified buffer is too small for the character array.';
        msgID = 'MIRcatSDK:BUFFER_TOO_SMALL';
        
    elseif MIRcatSDK_RET_FAVORITE_NAME_NOTRECOGNIZED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified an invalid favorite name.';
        msgID = 'MIRcatSDK:FAVORITE_NAME_NOTRECOGNIZED';
        
    elseif MIRcatSDK_RET_FAVORITE_RECALL_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to recall the favorite with the user specified name.';
        msgID = 'MIRcatSDK:FAVORITE_RECALL_FAILURE';
        
    elseif MIRcatSDK_RET_WW_OUTOFTUNINGRANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified wavelength is out of the valid range.';
        msgID = 'MIRcatSDK:WW_OUTOFTUNINGRANGE';
        
    elseif MIRcatSDK_RET_NO_SCAN_INPROGRESS == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to modify a scan when there was no current scan in progress.';
        msgID = 'MIRcatSDK:RESUME_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_EMISSION_ON_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to enable the laser emission.';
        msgID = 'MIRcatSDK:EMISSION_ON_FAILURE';
        
    elseif MIRcatSDK_RET_EMISSION_ALREADY_OFF == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to diable laser emission when it was already disabled.';
        msgID = 'MIRcatSDK:EMISSION_ALREADY_OFF';
        
    elseif MIRcatSDK_RET_EMISSION_OFF_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to disable the laser emission.';
        msgID = 'MIRcatSDK:EMISSION_OFF_FAILURE';
        
    elseif MIRcatSDK_RET_EMISSION_ALREADY_ON == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to enable the laser emission while the laser was already emitting.';
        msgID = 'MIRcatSDK:EMISSION_ALREADY_ON';
        
    elseif MIRcatSDK_RET_PULSERATE_OUTOFRANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified pulse rate is invalid and out of range.';
        msgID = 'MIRcatSDK:PULSERATE_OUTOFRANGE';
        
    elseif MIRcatSDK_RET_PULSEWIDTH_OUTOFRANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified pulse width is invalid and out of range.';
        msgID = 'MIRcatSDK:PULSEWIDTH_OUTOFRANGE';
        
    elseif MIRcatSDK_RET_CURRENT_OUTOFRANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified an invalid current that is out of range.';
        msgID = 'MIRcatSDK:CURRENT_OUTOFRANGE';
        
    elseif MIRcatSDK_RET_SAVE_SETTINGS_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to save the QCL settings.';
        msgID = 'MIRcatSDK:SAVE_SETTINGS_FAILURE';
        
    elseif MIRcatSDK_RET_QCL_NUM_OUTOFRANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified QCL is out of range. Must be 1-4.';
        msgID = 'MIRcatSDK:QCL_NUM_OUTOFRANGE';
        
    elseif MIRcatSDK_RET_LASER_ALREADY_ARMED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to arm the laser when it has already been armed.';
        msgID = 'MIRcatSDK:LASER_ALREADY_ARMED';
        
    elseif MIRcatSDK_RET_LASER_ALREADY_DISARMED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to disarm the laser when it has already been disarmed.';
        msgID = 'MIRcatSDK:LASER_ALREADY_DISARMED';
        
    elseif MIRcatSDK_RET_LASER_NOT_ARMED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to modify the laser when the laser was not yet armed.';
        msgID = 'MIRcatSDK:LASER_NOT_ARMED';
        
    elseif MIRcatSDK_RET_LASER_NOT_TUNED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to enable laser emission before tuning the laser.';
        msgID = 'MIRcatSDK:LASER_NOT_TUNED';
        
    elseif MIRcatSDK_RET_TECS_NOT_AT_SET_TEMPERATURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system is not operating at the set temperature.';
        msgID = 'MIRcatSDK:TECS_NOT_AT_SET_TEMPERATURE';
        
    elseif MIRcatSDK_RET_CW_NOT_ALLOWED_ON_QCL == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified QCL does not support CW.';
        msgID = 'MIRcatSDK:CW_NOT_ALLOWED_ON_QCL';
        
    elseif MIRcatSDK_RET_INVALID_LASER_MODE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified an invalid laser mode.';
        msgID = 'MIRcatSDK:INVALID_LASER_MODE';
        
    elseif MIRcatSDK_RET_TEMPERATURE_OUT_OF_RANGE == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user specified an invalid temperature that is out of range.';
        msgID = 'MIRcatSDK:TEMPERATURE_OUT_OF_RANGE';
        
    elseif MIRcatSDK_RET_LASER_POWER_OFF_ERROR == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to power off the laser.';
        msgID = 'MIRcatSDK:LASER_POWER_OFF_ERROR';
        
    elseif MIRcatSDK_RET_COMM_ERROR == ret
        msgtext = 'Error! Code: %d -- *[System Error]* Communication error.';
        msgID = 'MIRcatSDK:COMM_ERROR';
        
    elseif MIRcatSDK_RET_NOT_INITIALIZED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* User attempted to modify the MIRcat object or call a function before the MIRcatController was initialized.';
        msgID = 'MIRcatSDK:NOT_INITIALIZED';
        
    elseif MIRcatSDK_RET_ALREADY_CREATED == ret
        msgtext = 'Error! Code: %d -- *[User Error]* The user attempted to create a new MIRcatObject when an instance has already been initialized.';
        msgID = 'MIRcatSDK:ALREADY_CREATED';
        
    elseif MIRcatSDK_RET_START_SWEEP_ADVANCED_SCAN_FAILURE == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to start a Sweep-Advanced Scan.';
        msgID = 'MIRcatSDK:START_SWEEP_ADVANCED_SCAN_FAILURE';
        
    elseif MIRcatSDK_RET_INJECT_PROC_TRIG_ERROR == ret
        msgtext = 'Error! Code: %d -- *[System Error]* The system failed to inject a process trigger.';
        msgID = 'MIRcatSDK:INJECT_PROC_TRIG_ERROR';
        
    else
        msgtext = 'Error! Code: %d';
        msgID = 'MIRcatSDK:UNKNOWN';
    end
    
    ME = MException(msgID,msgtext,ret);
    throw(ME);
end