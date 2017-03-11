
class DockerVolume {

    [string]$SourceDirector
    [string]$TargetDirectory

    [string]ToString(){
        return $this.SourceDirector + ":" + $this.TargetDirectory
    }

    DockerVolume([string]$Source, [string]$Target){

        $this.SourceDirector = $Source
        $this.TargetDirectory = $Target
    }
}


class DockerConfig : Docker.DotNet.Models.Config {

     #[Docker.DotNet.Models.Config]$config = [Docker.DotNet.Models.Config]::new()

     [void]AddVolume([DockerVolume]$Volume) {

        if ($this.Volumes -isnot [System.Collections.Generic.Dictionary[string,object]]) {
            $this.Volumes = [System.Collections.Generic.Dictionary[string,object]]::new()
        }

        # Work around due to https://github.com/Microsoft/Docker-PowerShell/issues/167
        # Limitation of string sturcts from .net to GO
        $this.Volumes.Add($Volume.ToString(), $null)
     }

}


$config = [DockerConfig]::new()

$volume = [DockerVolume]::new("D:\test", "c:\TestOut")

$config.AddVolume($volume)

$config.Image = "43723d62f8b3"

$config.Tty = $true

Run-ContainerImage -Configuration $config -ImageIdOrName "43723d62f8b3"


<#


https://github.com/Microsoft/Docker-PowerShell/issues/174

PBlogc
$pb = new-object Docker.DotNet.Models.PortBinding
$pb.HostPort = "88"
$hostConfig = new-object Docker.DotNet.Models.HostConfig
$hostConfig.PortBindings = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.iList[Docker.DotNet.Models.PortBinding]]]::new()
$hostConfig.PortBindings.Add("80/tcp",[System.Collections.Generic.List[Docker.DotNet.Models.PortBinding]]::new([Docker.DotNet.Models.PortBinding[]]@($pb)))
$c = New-Container -HostConfiguration $hostConfig microsoft/nanoserver
(Get-ContainerDetail $c).HostConfig.PortBindings


#>