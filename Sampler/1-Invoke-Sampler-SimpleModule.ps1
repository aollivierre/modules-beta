$newSampleModuleParameters = @{
    DestinationPath   = 'C:\Code\modules-beta\EnhancedLoggingAO-Sampler-Simple'
    ModuleType        = 'SimpleModule'
    ModuleName        = 'EnhancedLoggingAO'
    ModuleAuthor      = 'Abdullah Ollivierre'
    ModuleDescription = 'Enhanced logging module for PowerShell scripts.'
}

New-SampleModule @newSampleModuleParameters