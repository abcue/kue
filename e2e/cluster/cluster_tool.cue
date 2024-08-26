package cluster

import "github.com/abcue/kue"

if kubernetes.apiResources != _|_ {
	command: kue.#Command & {
		#var: {
			apiResources: kubernetes.apiResources
			package:      "cluster"
		}
	}
}
