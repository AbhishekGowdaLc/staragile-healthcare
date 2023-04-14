pipeline {
agent any 
tools {
maven 'MY_MAVEN'
}
environment{
AWS_ACCESS_KEY_ID= '$(access_key)'
AWS_SECRET_KEY_ID= '$(secret_key)'
 }
stages {
stage('code checkout'){
steps{
git 'https://github.com/AbhishekGowdaLc/staragile-healthcare'
 }
 }
stage('maven build'){
steps{
echo 'cleaning..compiling..testing..packaging..'
sh 'mvn -X clean install'
 }
 }
 
stage('Publish HTML Report'){
steps{
 publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: 
false, reportDir: '/var/lib/jenkins/workspace/Project_BankingFinance/target/surefirereports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', 
useWrapperFileDirectly: true])
 }
}
stage('Containerization'){
steps{
echo 'Creating a docker image'
sh 'docker build -t abhishekgowda123/healthcareapp:1.0'
 }
} 
stage('Push image to dockerhub'){
steps{
withDockerRegistry([ credentialsId: "dockerhub"]) {
sh 'docker push abhishekgowda123/healthcareapp:1.0'
 }
 } 
 }
stage('Terraform init'){
steps{
sh 'terraform init'
}
}
stage('Terraform format'){
steps{
sh 'terraform format'
}
}
stage('Terraform validate'){
steps{
sh 'terraform validate'
}
}
stage('Terraform apply'){
steps{
sh 'terraform apply --auto-approve'
sleep 10
}
}
stage('deploy to kubernetes'){
steps{
sshagent(['K8s']) {
sh 'scp -o StrictHostKeyChecking=no deployment.yml
ubuntu@107.20.125.64:/home/ubuntu'
script{
try{
sh 'ssh ubuntu@107.20.125.64 kubectl apply -f deployment.yml .'
}catch(error)
{
sh 'ssh ubuntu@107.20.125.64 kubectl create -f deployment.yml .'
}
}
