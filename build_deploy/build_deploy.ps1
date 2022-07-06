$envObj = Get-Content -Path .\deploy\env.json | ConvertFrom-Json | Select-Object -ExpandProperty "Environment" | Select-Object $env
#Write-Host $envObj.$env.clusterendpoint
$packagePath = ".\pkg\Release"

Try{
    Connect-ServiceFabricCluster -ConnectionEndpoint $envObj.$env.clusterendpoint `
          -KeepAliveIntervalInSec 10 `
          -X509Credential -ServerCertThumbprint $envObj.$env.thumbprint `
          -FindType FindByThumbprint -FindValue $envobj.$env.thumbprint `
          -StoreLocation CurrentUser -StoreName My -ErrorAction Stop

    [xml]$xmlAppManifest=Get-Content -Path $packagePath"\ApplicationManifest.xml"


    
    foreach($application in $envObj.$env.applicationNames){
        [xml]$xmlServiceManifest = Get-Content -Path $packagepath\$application"pkg"\ServiceManifest.xml
        if($xmlServiceManifest)
        {
            $serviceTypeName = $xmlServiceManifest.ServiceManifest.ServiceTypes.StatelessServiceType.ServiceTypeName
            $sfApplication = Get-ServiceFabricApplication -ApplicationName "fabric:/"$application
            if($sfApplication)
            {
            
                if($xmlAppManifest.ApplicationManifest.ApplicationTypeVersion -eq $sfApplication.ApplicationTypeVersion)
                {
                    Write-Host "Applications are of the same version"
                } else
                {
                    Copy-ServiceFabricApplicationPackage -ApplicationPackagePath $packagePath -ApplicationPackagePathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version
                    Register-ServiceFabricApplicationType -ApplicationPathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version
                    Remove-ServiceFabricApplicationPackage -ApplicationPackagePathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version -ImageStoreConnectionString fabric:ImageStore
                    Start-ServiceFabricApplicationUpgrade -ApplicationName "fabric:/"$application -ApplicationTypeVersion $xmlAppManifest.ApplicationManifest.ApplicationTypeVersion -HealthCheckStableDurationSec 60 -UpgradeDomainTimeoutSec 1200 -UpgradeTimeout 3000   -FailureAction Rollback -Monitored
                }
            }else
            {
                Copy-ServiceFabricApplicationPackage $packagepath -ImageStoreConnectionString fabric:ImageStore -ApplicationPackagePathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version -ShowProgress -ShowProgressIntervalMilliseconds 500
                Register-ServiceFabricApplicationType -ApplicationPathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version
                Remove-ServiceFabricApplicationPackage -ImageStoreConnectionString fabric:ImageStore -ApplicationPackagePathInImageStore $application"_"$xmlServiceManifest.ServiceManifest.Version
                New-ServiceFabricApplication -ApplicationName "fabric:/"$application -ApplicationTypeName $xmlAppManifest.ApplicationManifest.ApplicationTypeName -ApplicationTypeVersion $xmlAppManifest.ApplicationManifest.ApplicationTypeVersion
                New-ServiceFabricService -ApplicationName "fabric:/"$application -ServiceName "fabric:/"$application/svc1 -ServiceTypeName $serviceTypeName -Stateless -PartitionSchemeSingleton -InstanceCount -1
            }
        } else {
            Write-Error "Service Manifest could not be found for "$application
        }
        
    }
}
Catch{
    Write-Host $_.Exception.Message
}
