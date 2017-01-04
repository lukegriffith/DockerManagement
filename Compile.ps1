Import-Module Docker

configuration docker-config {


    Import-DscResource -Name cDockerContainer -ModuleName DockerManagement

    
    cDockerContainer Container1 { 

        Name = "Container1"
        Image = "ubuntu:12.04"
        Command = "/bin/bash/"

    }


}

docker-config