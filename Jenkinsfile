pipeline {
agent any 
tools {
maven 'MY_MAVEN'
}

stages {
stage("git checkout"){
steps{
git 'https://github.com/AbhishekGowdaLc/staragile-healthcare.git'
 }
 }
stage('maven build'){
steps{
echo 'cleaning..compiling..testing..packaging..'
sh 'mvn clean package'
 }
 }
 
stage('Publish HTML Report'){
steps{
 publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: 
false, reportDir: '/var/lib/jenkins/workspace/Project3_healthcare/target/surefirereports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', 
useWrapperFileDirectly: true])
 }
}
stage('Containerize the application'){
steps{
echo 'Creating a docker image'
sh 'docker build -t abhishekgowda123/healthcareapp:1.0 .'
 }
} 
stage('Pushing the image to dockerhub'){
steps{
withDockerRegistry([ credentialsId: "dockerhub", url: "https://hub.docker.com/?ref=login" ]) {
sh 'docker push abhishekgowda123/healthcareapp:1.0'
 }
 } 
 }

stage('deploy to kubernetes'){
steps{
sshagent(['K8s']) {
sh 'scp -o StrictHostKeyChecking=no deployment.yml
ubuntu@172.42.22.152:/home/ubuntu'
script{
try{
sh 'ssh ubuntu@44.214.143.86 kubectl apply -f .'
}catch(error)
{
sh 'ssh ubuntu@44.214.143.86 kubectl create -f .'
}
}
}
}
}
}
}
