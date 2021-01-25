pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    
    environment {
        TF_IN_AUTOMATION            = '1'
        ONTAP_CREDS                 = credentials('ONTAP_CREDENTIALS')
        AWS_ACCESS_KEY_ID           = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY       = credentials('AWS_SECRET_KEY')
        TF_VAR_ONTAP_USERNAME       = '$ONTAP_CREDS_USR'
        TF_VAR_ONTAP_PASSWORD       = '$ONTAP_CREDS_PSW'
        TF_VAR_ONTAP_CLUSTER        = '10.216.2.130'        
    }

    stages {
        stage('Plan') {
            steps {
                withEnv(['PATH+TERRAFORM=/var/lib/jenkins/plugins']) {
                    sh 'terraform init -input=false'
                    sh "terraform plan -input=false -out tfplan"
                    sh 'terraform show -no-color tfplan > tfplan.txt'         
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                withEnv(['PATH+TERRAFORM=/var/lib/jenkins/plugins/']) {
                    sh "terraform apply -input=false tfplan"
                }                
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}
