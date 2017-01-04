enum Ensure {
    Present
    Absent
}

enum State {
    Up
    Exited
}

[DSCResource()]
class cDockerContainer {

    [DSCProperty(Key=$true)]
    [String]$Name

    [DSCProperty(Mandatory=$true)]
    [String]$Image


    [DSCProperty(Mandatory=$true)]
    [String]$Command

    [DSCProperty()]
    [State]$State

    [DSCProperty(NotConfigurable=$true)]
    [System.DateTime]$Created

    [DSCProperty(NotConfigurable=$true)]
    [String]$StateFor

    [DSCProperty()]
    [Ensure]$Ensure

    [cDockerContainer]Get(){
        
        $Container = Get-Container -Names $this.Name | Where-Object { $_.Image -eq $this.Image -and $_.Command -eq $this.Command }

        $Container.Status -match "((?<state>\S+\s)|(?<state>\S+\s\([0-9]+\)))\s(?<time>.+)$"

        if ($Matches.Contains("time")) {
            $this.StateFor = $Matches.time
        }

        if ($Matches.Contains("state")) {
            $this.State = $Matches.state
        }

        $this.Created = $Container.Created
        
        return $this
    }


    [Void]Set(){

        Run-ContainerImage -ImageName (Get-ContainerImage -ImageName $this.Image) -Name $this.Name -Command $this.Command
        
    }

    [Bool]Test(){

        $Container = Get-Container -Names $this.Name | Where-Object { $_.Image -eq $this.Image -and $_.Command -eq $this.Command }

        if ($Container) {

            if ($this.state -and ($this.get().State -ne ($this.State))) {
                return $false
            }

            return $true
        }
        else {
            return $false
        }
    }

}