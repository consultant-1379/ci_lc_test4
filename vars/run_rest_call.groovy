#!/usr/bin/env groovy

def call(rest_call) {
    def http_code = sh(script: rest_call.replace('curl', 'curl -o ${WORKSPACE}/rest_call_output.txt -s -w "%{http_code}\n"'), returnStdout: true)
    if (!http_code.startsWith("2")) {
        sh 'cat ${WORKSPACE}/rest_call_output.txt'
        currentBuild.rawBuild.result = Result.FAILURE
        throw new hudson.AbortException('Failure')
    }
}
