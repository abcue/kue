package cluster

import (
	core_v1 "k8s.io/api/core/v1"
	admissionregistration_v1 "k8s.io/api/admissionregistration/v1"
	apps_v1 "k8s.io/api/apps/v1"
	authentication_v1 "k8s.io/api/authentication/v1"
	authorization_v1 "k8s.io/api/authorization/v1"
	autoscaling_v2 "k8s.io/api/autoscaling/v2"
	batch_v1 "k8s.io/api/batch/v1"
	certificates_v1 "k8s.io/api/certificates/v1"
	coordination_v1 "k8s.io/api/coordination/v1"
	discovery_v1 "k8s.io/api/discovery/v1"
	events_v1 "k8s.io/api/events/v1"
	flowcontrol_v1 "k8s.io/api/flowcontrol/v1"
	networking_v1 "k8s.io/api/networking/v1"
	node_v1 "k8s.io/api/node/v1"
	policy_v1 "k8s.io/api/policy/v1"
	rbac_v1 "k8s.io/api/rbac/v1"
	scheduling_v1 "k8s.io/api/scheduling/v1"
	storage_v1 "k8s.io/api/storage/v1"

	"github.com/abcue/kue/v0:kue"
)

#KUE: kue.#KUE & {
	#var: {
		apiResources: kubernetes.apiResources
		resources: {
			bindings?: [_]:                          core_v1.#Binding
			componentstatuses?: [_]:                 core_v1.#ComponentStatus
			configmaps?: [_]:                        core_v1.#ConfigMap
			endpoints?: [_]:                         core_v1.#Endpoints
			events?: [_]:                            core_v1.#Event
			limitranges?: [_]:                       core_v1.#LimitRange
			namespaces?: [_]:                        core_v1.#Namespace
			nodes?: [_]:                             core_v1.#Node
			persistentvolumeclaims?: [_]:            core_v1.#PersistentVolumeClaim
			persistentvolumes?: [_]:                 core_v1.#PersistentVolume
			pods?: [_]:                              core_v1.#Pod
			podtemplates?: [_]:                      core_v1.#PodTemplate
			replicationcontrollers?: [_]:            core_v1.#ReplicationController
			resourcequotas?: [_]:                    core_v1.#ResourceQuota
			secrets?: [_]:                           core_v1.#Secret
			serviceaccounts?: [_]:                   core_v1.#ServiceAccount
			services?: [_]:                          core_v1.#Service
			mutatingwebhookconfigurations?: [_]:     admissionregistration_v1.#MutatingWebhookConfiguration
			validatingadmissionpolicies?: [_]:       admissionregistration_v1.#ValidatingAdmissionPolicy
			validatingadmissionpolicybindings?: [_]: admissionregistration_v1.#ValidatingAdmissionPolicyBinding
			validatingwebhookconfigurations?: [_]:   admissionregistration_v1.#ValidatingWebhookConfiguration
			controllerrevisions?: [_]:               apps_v1.#ControllerRevision
			daemonsets?: [_]:                        apps_v1.#DaemonSet
			deployments?: [_]:                       apps_v1.#Deployment
			replicasets?: [_]:                       apps_v1.#ReplicaSet
			statefulsets?: [_]:                      apps_v1.#StatefulSet
			selfsubjectreviews?: [_]:                authentication_v1.#SelfSubjectReview
			tokenreviews?: [_]:                      authentication_v1.#TokenReview
			localsubjectaccessreviews?: [_]:         authorization_v1.#LocalSubjectAccessReview
			selfsubjectaccessreviews?: [_]:          authorization_v1.#SelfSubjectAccessReview
			selfsubjectrulesreviews?: [_]:           authorization_v1.#SelfSubjectRulesReview
			subjectaccessreviews?: [_]:              authorization_v1.#SubjectAccessReview
			horizontalpodautoscalers?: [_]:          autoscaling_v2.#HorizontalPodAutoscaler
			cronjobs?: [_]:                          batch_v1.#CronJob
			jobs?: [_]:                              batch_v1.#Job
			certificatesigningrequests?: [_]:        certificates_v1.#CertificateSigningRequest
			leases?: [_]:                            coordination_v1.#Lease
			endpointslices?: [_]:                    discovery_v1.#EndpointSlice
			events?: [_]:                            events_v1.#Event
			flowschemas?: [_]:                       flowcontrol_v1.#FlowSchema
			prioritylevelconfigurations?: [_]:       flowcontrol_v1.#PriorityLevelConfiguration
			ingressclasses?: [_]:                    networking_v1.#IngressClass
			ingresses?: [_]:                         networking_v1.#Ingress
			networkpolicies?: [_]:                   networking_v1.#NetworkPolicy
			runtimeclasses?: [_]:                    node_v1.#RuntimeClass
			poddisruptionbudgets?: [_]:              policy_v1.#PodDisruptionBudget
			clusterrolebindings?: [_]:               rbac_v1.#ClusterRoleBinding
			clusterroles?: [_]:                      rbac_v1.#ClusterRole
			rolebindings?: [_]:                      rbac_v1.#RoleBinding
			roles?: [_]:                             rbac_v1.#Role
			priorityclasses?: [_]:                   scheduling_v1.#PriorityClass
			csidrivers?: [_]:                        storage_v1.#CSIDriver
			csinodes?: [_]:                          storage_v1.#CSINode
			csistoragecapacities?: [_]:              storage_v1.#CSIStorageCapacity
			storageclasses?: [_]:                    storage_v1.#StorageClass
			volumeattachments?: [_]:                 storage_v1.#VolumeAttachment
		}
	}
}
