param(
    [Parameter(Mandatory=$true)]
    [string] $env_name
)

$envObj = Get-Content -Path .\build_deploy\env.json | ConvertFrom-Json | Select-Object -ExpandProperty "Environment" | Select-Object $env_name

New-Item .\pkg -ItemType Directory

Copy-Item .\svastha\ApplicationPackageRoot\ApplicationManifest.xml -Destination .\pkg

foreach($application in $envObj.$env_name.applicationNames){

    New-Item .\pkg\$application"pkg" -ItemType Directory
    New-Item .\pkg\$application"pkg"\Code -ItemType Directory
    New-Item .\pkg\$application"pkg"\Config -ItemType Directory

    Copy-Item .\$application\PackageRoot\ServiceManifest.xml -Destination .\pkg\$application"pkg"
    Copy-Item .\$application\PackageRoot\Config\Settings.xml -Destination .\pkg\$application"pkg"\Config

    dotnet publish .\$application\$application.csproj -o .\pkg\$application"pkg"\Code
}

New-Item .\artifacts -ItemType Directory

Compress-Archive -Path .\pkg -DestinationPath .\artifacts\sfartifact.zip
