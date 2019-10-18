pipeline {
  agent any
  environment {
    BACKEND_NAME = credentials('backend-name-credentials') // contains envName + base jps url
    FRONTEND_NAME = credentials('frontend-name-credentials') // contains envName
    JELASTIC_APP_CREDENTIALS = credentials('jelastic-app-credentials')
    JELASTIC_CREDENTIALS = credentials('jelastic-credentials')
  }
  stages {
    stage('Clean up environments') {
      steps {
        script {
          cleanupScript = "./delete-jelastic-env.sh"
          sh "chmod u+x $cleanupScript"
          sh "$cleanupScript ${JELASTIC_APP_CREDENTIALS_USR} ${JELASTIC_APP_CREDENTIALS_PSW} ${JELASTIC_CREDENTIALS_USR} ${JELASTIC_CREDENTIALS_PSW} ${BACKEND_NAME_USR}"
          sh "$cleanupScript ${JELASTIC_APP_CREDENTIALS_USR} ${JELASTIC_APP_CREDENTIALS_PSW} ${JELASTIC_CREDENTIALS_USR} ${JELASTIC_CREDENTIALS_PSW} ${FRONTEND_NAME_USR}"
        }
      }
    }
  }
}