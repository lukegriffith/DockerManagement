
[DSCResource()]
class DockerContainer {

    [DSCProperty(Key=$true)]
    [String]$Name

    [DSCProperty(Mandatory=$true)]
    [String]$Image

    [DSCProperty(Mandatory=$true)]
    [String]$Command

    [DSCProperty(NotConfigurable=$true)]
    [System.DateTime]$Created

    [DSCProperty(NotConfigurable=$true)]
    [String]$OnlineFor

    [DockerContainer]Get(){
        
        $Container = Get-Container -Names My_Container | Where-Object {$_.Image }

        $Container.Status -match "((\S+\s)|(\S+\s\([0-9]+\)))\s(?<Time>.+)$"

        if ($Matches.Contains("Time")) {
            $this.StateFor = $Matches.Time
        }
        
        return $this
    }


    [Void]Set(){

        Run-ContainerImage -Image $this.Image -Name $this.Name -Command $this.Command

    }

}