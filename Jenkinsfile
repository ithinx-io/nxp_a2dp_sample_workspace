@Library('itx-jenkins-shared-lib') _
// Find documentation online here:
// http://gitlab.kelle.grp/itx/jenkins-shared-lib/blob/master/README.md

pipeline {
	options {
		gitLabConnection('ithinx gitlab connection')  // connection to git (for gitlabCommitStatus)
		buildDiscarder(logRotator(numToKeepStr: '1')) // keep only last build
	}
	triggers {
		gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
		cron('@weekly')
	}

	agent {
		node {
			label 'linux'
		}
	}

	stages {
		stage ('cleanWs') {
			steps {
				cleanWs()
			}
		}

		stage ('checkout') {
			steps {
				itxCheckout()
			}
		}

		stage ('build img') {
			agent {
				dockerfile {
					filename '.devcontainer/Dockerfile'
					dir '.'
					reuseNode true
					label 'linux'
					additionalBuildArgs '--build-arg USER_UID=$UID'
					args '''
					        --env ZEPHYR_BASE=$WORKSPACE/nxp-zephyr
					        --volume $HOME/.ssh:/builder/.ssh
					     '''
				}
			}
			steps {
				sh '''
				   west update --fetch smart --narrow
				   west blobs fetch
				   west build -b mimxrt1170_evk@B/mimxrt1176/cm7 nxp-zephyr/samples/bluetooth/a2dp_source
				'''
			}
		}

		stage ('archive') {
			steps{
				dir('build/zephyr') {
					archiveArtifacts artifacts: 'zephyr.bin,zephyr.elf,zephyr.map',
					                            fingerprint: true, onlyIfSuccessful: true, followSymlinks: true
				}
			}
		}
	}
	post {
		success {
			script {
				// clear build directory to save disk space
				sh "rm -rf $WORKSPACE/build"
			}
		}
		always {
			script {
				// This method from the ithinx shared lib will trigger gitlab, slack, and email depending on result
				triggerNotificationsOnBuild(currentBuild.result, "")

				updateGitlabCommitStatus name: 'build', state: 'SUCCESS' == currentBuild.result ? 'success' : 'failed'
			}
		}
	}
}
