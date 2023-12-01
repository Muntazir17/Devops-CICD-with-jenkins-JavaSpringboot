pipeline{

    agent any
    parameters{
        choice(name: 'action', choices: 'create\ndestroy\ndestroyekscluster', description: 'Create/update or destroy the eks cluster')
        string (name: 'cluster', defaultValue: 'demo-cluster', description: 'Eks cluster name')
        string (name: 'region', defaultValue: 'us-east-1a', description: 'Eks cluster region')
    }  
    environment{
        ACCESS_KEY = Credentials('aws_access_key_id')
        SECRET_KEY = Credentials('aws_secret_access_key_id')
    }
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




// ================================CD PART======================================
        


        stage('eks connect'){
            steps{
                sh """

                    aws configure set aws_access_key_id "$ACCESS_KEY"
                    aws configure set aws_secret_access_key_id "$SECRET_KEY"
                    aws configure set region ""

                    aws eks --region ${params.region} update-kubeconfig --name ${params.cluster}

                """
            }
        }

        stage('eks deployment'){

            when { expression {params.action == "create"}}

            steps {

                def apply = false 
                try{
                    input: message:'please  confirm the apply to initiate the deployments', ok: 'Ready to apply the config'
          
                    apply = true
                }
                catch(err){
                    apply = false 
                    CurrentBuild.result = 'UNSTABLE'
                }
                if(apply){

                    sh """

                        kubectl apply -f .

                    """
                }
            }
        }
        stage('eks deployment delete'){

            when { expression {params.action == "destroy"}}

            steps {

                def destroy = false 
                try{
                    input: message:'please  confirm the apply to delete the deployments', ok: 'Ready to destroy the config'
          
                    destroy = true
                }
                catch(err){
                    destroy = false 
                    CurrentBuild.result = 'UNSTABLE'
                }
                if(destroy){

                    sh """

                        kubectl delete -f .

                    """
                }
            }
        }
        stage('eks cluster destroy'){

            when { expression {params.action == "destroyekscluster"}}

            steps {

                def destroyeks = false 
                try{
                    input: message:'please  confirm the apply to delete the eks cluster', ok: 'Ready to destroy the infra'
          
                    destroyeks = true
                }
                catch(err){
                    destroyeks = false 
                    CurrentBuild.result = 'UNSTABLE'
                }
                if(destroyeks){

                    sh """
                        cd Terraform_eks
                        terraform destroy --var-file="./config/terraform.tfvars"  --auto-approve
                        cd ..
                    
                    """
                }
            }
        }

    }
}