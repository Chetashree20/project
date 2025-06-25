pipeline {
  agent none

  environment {
    MAVEN_HOME = "/mnt/build-tools/apache-maven-3.9.10"
    PATH = "${env.MAVEN_HOME}/bin:${env.PATH}"
  }

  stages {

    stage('Clone Git Repository') {
      agent { label 'built-in' } // Master node
      steps {
        dir('/mnt/project') {
          git url: 'https://github.com/Chetashree20/project.git'
        }
      }
    }

    stage('Build WAR on Master') {
      agent { label 'built-in' }
      steps {
        dir('/mnt/project') {
          sh 'rm -rf ~/.m2/repository'
          sh 'mvn clean package'
          stash name: 'warfile', includes: 'target/LoginWebApp.war'
        }
      }
    }

    stage('Deploy on Slave') {
      agent { label 'slave1' }
      steps {
        dir('/mnt/projects') {
          deleteDir()
          unstash 'warfile'
          
          // Place WAR in Tomcat
          sh '''
            cp target/LoginWebApp.war /mnt/servers/apache-tomcat-9.0.106/webapps/
          '''
        }
      }
    }

    stage('Update JSP for RDS') {
      agent { label 'slave1' }
      steps {
        sh '''
          sleep 10
          sed -i 's|jdbc:mysql://localhost:3306/test", "root", "root"|jdbc:mysql://database-1.cb48gkq0ufgf.ap-south-1.rds.amazonaws.com:3306/test", "admin", "admin123456"|g' /mnt/servers/apache-tomcat-9.0.106/webapps/LoginWebApp/userRegistration.jsp
        '''
      }
    }

    stage('Start Tomcat on Slave') {
      agent { label 'slave1' }
      steps {
        sh '''
          /mnt/servers/apache-tomcat-9.0.106/bin/shutdown.sh || true
          /mnt/servers/apache-tomcat-9.0.106/bin/startup.sh
        '''
      }
    }
  }
}
