pipeline {
  agent any
  stages {
//     stage('Debug Info') {
//       steps {
//         sh 'whoami;hostname;uptime'
//       }
//     }

//     stage('Build Docker Image') {
//       steps {
//         sh '''docker build . \\
// -f Dockerfile \\
// -t tumbler-flutter'''
//       }
//     }

//     stage('Run Container') {
//       steps {
//         sh '''docker run \\
// --name tumbler-flutter \\
// --entrypoint /bin/bash \\
// -dt --rm tumbler-flutter'''
//       }
//     }

//     stage('Lint') {
//       steps {
//         sh 'docker exec tumbler-flutter bash -c \'bash lint.sh\''
//       }
//     }

//     stage('Test') {
//       steps {
//         sh 'docker exec tumbler-flutter bash -c \'bash test.sh\''
//       }
//     }

//     stage('Stop Container & Remove Image') {
//       steps {
//         sh 'docker container stop tumbler-flutter'
//         sh 'docker image remove tumbler-flutter'
//         sh 'docker system prune -f'
//       }
//     }

//     stage('List Docker Images & Containers') {
//       steps {
//         sh 'docker image ls -a'
//         sh 'docker container ls -a'
//       }
//     }

    stage('Deploy To dev-server') {
      agent {
        node {
          label 'dev-server'
        }
      }
      when {
        branch 'main'
      }
      steps {
        sh 'whoami;hostname;uptime'
        sh '''
#az storage file download --account-name tumblerstorageaccount -s tumbler-secrets -p flutter.dev.env --dest .env;
docker-compose up -d --build;
#docker system prune -f;'''
      }
      post {
        always {
          discordSend(
            title: JOB_NAME,
            link: env.BUILD_URL,
            description: "${JOB_NAME} DEV Deployment Status: ${currentBuild.currentResult}",
            result: currentBuild.currentResult,
            thumbnail: 'https://i.dlpng.com/static/png/6378770_preview.png',
            webhookURL: 'https://discord.com/api/webhooks/921772869782994994/mi4skhArIoT6heXWebPiWLn6Xc95rZgUqtW7qriBOYvnl0sTdfn16we7yPY-n-DJYRmH'
          )
        }
      }
    }
  }

  post {
    unsuccessful {
      sh 'docker container stop tumbler-flutter || true'
      sh 'docker image remove tumbler-flutter || true'
      sh 'docker system prune -f'
    }

    cleanup {
      cleanWs()
    }
  }
}
