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
        stage('Integration testing'){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('maven building of java application into  a jar artifact'){
            sh 'mvn clean install'
        }
        
    }
}