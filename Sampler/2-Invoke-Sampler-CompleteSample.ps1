$newSampleModuleParameters = @{
    DestinationPath   = 'C:\Code\modules-beta\EnhancedLoggingAO-Sampler-Complete'
    ModuleType        = 'CompleteSample'
    ModuleName        = 'EnhancedLoggingAO'
    ModuleAuthor      = 'Abdullah Ollivierre'
    ModuleDescription = 'Enhanced logging module for PowerShell scripts.'
}

New-SampleModule @newSampleModuleParameters