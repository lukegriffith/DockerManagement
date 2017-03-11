
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