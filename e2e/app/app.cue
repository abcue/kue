package app

import minikube "github.com/abcue/kue/e2e/cluster/minikube:cluster"

app: {
	name: "abc"
	kubernetes: minikube.#KUE & {
		#var: resources: {
			deployments: (name): _
		}
	}
}
