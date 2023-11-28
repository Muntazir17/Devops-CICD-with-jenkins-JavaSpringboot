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
            steps{
                sh 'mvn clean install'
            }
        }

        stage('static code analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }
            }
        }

        stage('Quality Gate status'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                }
            }
        }

        stage('upload war/jar file on nexus'){
            steps{
                script{
                    def readPomVersion = readMavenPom file: 'pom.xml'
                    def nexusRepo = readMavenPom.version.endwith("SNAPSHOT") ? "demoapp-snapshot" : "demoapp-release"
                    nexusArtifactUploader artifacts: [
                            [
                                artifactId: 'springboot',
                                classifier: '', 
                                file: 'target/Uber.jar', 
                                type: 'jar'
                                ]
                        ], 
                        credentialsId: 'nexus-auth', 
                        groupId: 'com.example', 
                        nexusUrl: '52.73.197.54:9000', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: ${nexusRepo}, 
                        version: ${readPomVersion.version}
                }
            }
        }
            
        stage('building docker Image'){
            steps{
                script{
                    sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID mrace17/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image tag $JOB_NAME:v1.$BUILD_ID mrace17/$JOB_NAME:v1.latest'
                }
            }
        }
        stage('Pushing docker image'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker-cred', variable: 'dockerHub-cred')]) {

                        sh 'docker login -u mrace17 -p ${dockerHub-cred}'
                        sh 'docker image push mrace17/$JOB_NAME:v1.$BUILD_ID'
                        sh 'docker image push mrace17/$JOB_NAME:v1.latest'
                    }
                }
                    
            }
        }
        


    }
}