Import-Module $PSScriptRoot
import-module pester


Invoke-Pester -OutputFile "C:\testout\$((get-date).ToString("ddMMyyhhmmss")).xml" -OutputFormat NUnitXml
