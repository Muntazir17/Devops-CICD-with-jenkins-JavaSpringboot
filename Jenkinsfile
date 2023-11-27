pipeline{

    agent any

    stages{
        stage('Git checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/Muntazir17/Devops-proj2.git'
            }
        }
        stage('unit testing'){
            steps{
                 sh 'mvn test'
            }
        }
        
    }
}