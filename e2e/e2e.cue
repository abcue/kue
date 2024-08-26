package e2e

import minikube "github.com/abcue/kue/e2e/cluster/minikube:cluster"

k: minikube.#kue & {
	#var: resources: {
		bindings: ex:                          _
		componentstatuses: ex:                 _
		configmaps: ex:                        _
		endpoints: ex:                         _
		limitranges: ex:                       _
		namespaces: ex:                        _
		nodes: ex:                             _
		persistentvolumeclaims: ex:            _
		persistentvolumes: ex:                 _
		pods: ex:                              _
		podtemplates: ex:                      _
		replicationcontrollers: ex:            _
		resourcequotas: ex:                    _
		secrets: ex:                           _
		serviceaccounts: ex:                   _
		services: ex:                          _
		mutatingwebhookconfigurations: ex:     _
		validatingadmissionpolicies: ex:       _
		validatingadmissionpolicybindings: ex: _
		validatingwebhookconfigurations: ex:   _
		controllerrevisions: ex:               _
		daemonsets: ex:                        _
		deployments: ex:                       _
		replicasets: ex:                       _
		statefulsets: ex:                      _
		selfsubjectreviews: ex:                _
		tokenreviews: ex:                      _
		localsubjectaccessreviews: ex:         _
		selfsubjectaccessreviews: ex:          _
		selfsubjectrulesreviews: ex:           _
		subjectaccessreviews: ex:              _
		horizontalpodautoscalers: ex:          _
		cronjobs: ex:                          _
		jobs: ex:                              _
		certificatesigningrequests: ex:        _
		leases: ex:                            _
		endpointslices: ex:                    _
		flowschemas: ex:                       _
		prioritylevelconfigurations: ex:       _
		ingressclasses: ex:                    _
		ingresses: ex:                         _
		networkpolicies: ex:                   _
		runtimeclasses: ex:                    _
		poddisruptionbudgets: ex:              _
		clusterrolebindings: ex:               _
		clusterroles: ex:                      _
		rolebindings: ex:                      _
		roles: ex:                             _
		priorityclasses: ex:                   _
		csidrivers: ex:                        _
		csinodes: ex:                          _
		csistoragecapacities: ex:              _
		storageclasses: ex:                    _
		volumeattachments: ex:                 _
	}
}
