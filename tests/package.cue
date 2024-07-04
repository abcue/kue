package tests

import (
	"regexp"
	"strings"
)

isK8sApi: {
	"cert-manager.io/v1 ":             false
	"acme.cert-manager.io/v1":         false
	"flowcontrol.apiserver.k8s.io/v1": true
	"rbac.authorization.k8s.io/v1":    true
	"events.k8s.io/v1":                true
	"autoscaling/v2":                  true
	"v1":                              true
}

pkgId: {
	for p in [for v, vv in apiResources for k, kv in vv {kv.package}] {
		(p): regexp.ReplaceAll("[/.-]", strings.TrimPrefix(p, "k8s.io/api/"), "_")
	}
	"acme.cert-manager.io/challenge/v1":     "acme_cert_manager_io_challenge_v1"
	"cert-manager.io/certificaterequest/v1": "cert_manager_io_certificaterequest_v1"
	"k8s.io/api/flowcontrol/v1":             "flowcontrol_v1"
	"k8s.io/api/rbac/v1":                    "rbac_v1"
	"k8s.io/api/events/v1":                  "events_v1"
	"k8s.io/api/autoscaling/v2":             "autoscaling_v2"
	"k8s.io/api/core/v1":                    "core_v1"
}

isK8sApi: [A=_]: regexp.Match(".*\\.k8s\\.io(/[^/]+)", A) || !strings.Contains(A, ".")

apiResources: {
	[GV=_]: [Kind=_]: {
		_local: version: regexp.ReplaceAll("(.*/)?", GV, "")
		if isK8sApi[GV] {
			_local: {
				if !strings.Contains(GV, "/") {
					pv: "core/v1"
				}
				pv: *regexp.ReplaceAll("\\.[^/]*", GV, "") | _
			}
			package: strings.Join(["k8s.io", "api", _local.pv], "/")
		}
		if !isK8sApi[GV] {
			_local: {
				group:   strings.Split(GV, "/")[0]
				package: strings.ToLower(Kind)
			}
			package: strings.Join([_local.group, _local.package, _local.version], "/")
		}
	}
	"acme.cert-manager.io/v1": {
		"Challenge": {
			"name":       "challenges"
			"namespaced": "true"
			"package":    "acme.cert-manager.io/challenge/v1"
		}
	}
	"cert-manager.io/v1": {
		"CertificateRequest": {
			"name":       "certificaterequests"
			"namespaced": "true"
			"shortnames": [
				"cr",
				"crs",
			]
			"package": "cert-manager.io/certificaterequest/v1"
		}
	}
	"flowcontrol.apiserver.k8s.io/v1": {
		"FlowSchema": {
			"name":       "flowschemas"
			"namespaced": "false"
			"package":    "k8s.io/api/flowcontrol/v1"
		}
	}
	"rbac.authorization.k8s.io/v1": {
		"ClusterRoleBinding": {
			"name":       "clusterrolebindings"
			"namespaced": "false"
			"package":    "k8s.io/api/rbac/v1"
		}
	}
	"events.k8s.io/v1": {
		"Event": {
			"name":       "events"
			"namespaced": "true"
			"shortnames": [
				"ev",
			]
			"package": "k8s.io/api/events/v1"
		}
	}
	"autoscaling/v2": {
		"HorizontalPodAutoscaler": {
			"name":       "horizontalpodautoscalers"
			"namespaced": "true"
			"shortnames": [
				"hpa",
			]
			"package": "k8s.io/api/autoscaling/v2"
		}
	}
	"v1": {
		"Binding": {
			"name":       "bindings"
			"namespaced": "true"
			"package":    "k8s.io/api/core/v1"
		}
		"Event": {
			"name":       "events"
			"namespaced": "true"
			"shortnames": [
				"ev",
			]
			"package": "k8s.io/api/core/v1"
		}
	}
}
