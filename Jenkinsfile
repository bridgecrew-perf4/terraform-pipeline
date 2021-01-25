pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    
    environment {
        TF_IN_AUTOMATION            = '1'
        ONTAP_CREDS                 = credentials('ONTAP_CREDENTIALS')
        AWS_ACCESS_KEY_ID           = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY       = credentials('AWS_SECRET_ACCESS_KEY')
        TF_VAR_ONTAP_USERNAME       = '$ONTAP_CREDS_USR'
        TF_VAR_ONTAP_PASSWORD       = '$ONTAP_CREDS_PSW'
        TF_VAR_ONTAP_CLUSTER        = '10.216.2.130'        
    }

    stages {
        stage('Plan') {
            steps {
                withEnv(['PATH+TERRAFORM=/var/lib/jenkins/plugins']) {
                    sh 'terraform init -no-color -input=false'
                    sh 'terraform plan -no-color -input=false -out tfplan -var ontap_username=$ONTAP_CREDS_USR -var ontap_password=$ONTAP_CREDS_PSW'
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
                    sh "terraform apply -no-color -input=false tfplan"
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
