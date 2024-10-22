package cluster

import "github.com/abcue/kue/v0:kue"

if kubernetes.apiResources != _|_ {
	let KC = kue.#Command & {
		#var: {
			apiResources: kubernetes.apiResources
			package:      "cluster"
		}
	}
	command: KC.#output
}
