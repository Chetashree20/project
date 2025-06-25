pipeline {
  agent none

  tools {
    maven 'apache-maven-3.9.10'
  }

  stages {

    stage('Cloning Git Repo') {
      agent { label 'built-in' }
      steps {
        dir('/mnt/project') {
          checkout scm
        }
      }
    }

    stage('Build with Maven') {
      agent { label 'built-in' }
      steps {
        dir('/mnt/project') {
          // Fixing path to .m2 directory (it should be relative to the home directory)
          sh 'rm -rf ~/.m2/repository'
          sh 'mvn clean install'
          stash name: 'warfile', includes: 'target/*.war'
        }
      }
    }

    stage('Configure Database Connection') {
      agent { label 'built-in' }
      steps {
        dir('/mnt/project/target/LoginWebApp') {
          // Updated database URL and credentials in userRegistration.jsp
          sh '''
          sed -i 's|jdbc:mysql://localhost:3306/test", "root", "root"|jdbc:mysql://database-1.cmfhccpboiuu.ap-south-1.rds.amazonaws.com:3306/test", "admin", "admin123456"|g' userRegistration.jsp
          '''
        }
      }
    }
    

   stage('Deploy WAR to Tomcat') {
  agent { label 'slave1' }
  steps {
    unstash name: 'warfile' // This goes into the current workspace by default
    sh '''
      cp target/*.war /mnt/apache-tomcat-10.1.42/webapps/
      chmod -R 777 /mnt/apache-tomcat-10.1.42
      /mnt/apache-tomcat-10.1.42/bin/startup.sh
    '''
  }
}


  } 
