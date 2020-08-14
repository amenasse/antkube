#!/bin/bash
set -o errexit -o nounset -o pipefail

# Helper functions for Cluster management

cmd_shell () {
    kubectl run -it --rm --restart=Never  alpine --image=alpine sh
}

cmd_debug () {
    if [ -z "${1:-}" ]; then
        echo "Usage: debug <pod name>"
        exit 2
    fi
    # Create interactive debugging session in pod and attach.
    # Requires kube api server to be  started with the  EphemeralContainers feature gate enabled
    kubectl alpha debug -it "$1" --image=alpine
}

if [[ -n $1 ]]; then
    "cmd_$1" "${@:2}"
fi
