#BTP = Build, Test, Publish

$newSampleModuleParameters = @{
    DestinationPath   = 'C:\Code\modules-beta\EnhancedBoilerPlateAO-Sampler-Simple-BTP'
    ModuleType        = 'SimpleModule'
    ModuleName        = 'EnhancedBoilerPlateAO'
    ModuleAuthor      = 'Abdullah Ollivierre'
    ModuleDescription = 'Enhanced Boiler Plate for PowerShell scripts.'
}

New-SampleModule @newSampleModuleParameters