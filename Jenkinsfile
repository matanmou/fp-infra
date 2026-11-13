pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-deployer
  containers:
    - name: docker
      image: docker:27-cli
      command: ["cat"]
      tty: true
      env:
        - name: DOCKER_HOST
          value: tcp://localhost:2375
    - name: dind
      image: docker:27-dind
      securityContext:
        privileged: true
      env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
    - name: helm
      image: alpine/helm:3.16.3
      command: ["cat"]
      tty: true
'''
    }
  }

  triggers {
    pollSCM('H/5 * * * *')
  }

  environment {
    REGISTRY  = 'matanmo93'
    NAMESPACE = 'ipltb-space'
    CHART     = 'Helm/ipltb'
  }

  stages {
    stage('Checkout app') {
      steps {
        dir('fp-app') {
          git url: 'https://github.com/matanmou/fp-app.git', branch: 'main'
          script {
            env.APP_SHA = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
            env.TAG     = "${env.BUILD_NUMBER}-${env.APP_SHA.take(7)}"
          }
        }
        echo "Building fp-app commit ${env.APP_SHA} as tag ${env.TAG}"
      }
    }

    stage('Build & Push') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                            usernameVariable: 'DH_USER',
                                            passwordVariable: 'DH_TOKEN')]) {
            sh '''
              until docker info >/dev/null 2>&1; do sleep 1; done
              echo "$DH_TOKEN" | docker login -u "$DH_USER" --password-stdin

              docker build --build-arg APP_REF=$APP_SHA -t $REGISTRY/fp-backend:$TAG  Docker/backend
              docker build --build-arg APP_REF=$APP_SHA -t $REGISTRY/fp-frontend:$TAG Docker/frontend

              docker push $REGISTRY/fp-backend:$TAG
              docker push $REGISTRY/fp-frontend:$TAG
            '''
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        container('helm') {
          withCredentials([file(credentialsId: 'ipltb-secrets', variable: 'SECRETS_FILE')]) {
            sh '''
              helm upgrade ipltb $CHART -n $NAMESPACE -f "$SECRETS_FILE" \
                --set backend.image=$REGISTRY/fp-backend:$TAG \
                --set frontend.image=$REGISTRY/fp-frontend:$TAG \
                --wait --timeout 5m
            '''
          }
        }
      }
    }
  }
}