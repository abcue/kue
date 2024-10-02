package app

import (
	"encoding/yaml"
	"list"
	"path"
)

B=#Base: {
	N=name: string
	D=deploy: image: uri: string
	#var: {
		config: {
			files: *{} | {[string]: string}
			// NB: incompatible `cue fmt` between v0.6.0 in CLI and latest v0.10.0
			mountPath: *"/app/config/" | string
		}
		env: {
			kv: [string]:        string
			fieldPath: [string]: string
			secret: [...string]
		}
		command?: [...string]
		args?: [...string]
		sh?: *#". /vault/secrets/envrc; \#(#var.command) "$@""# | _
		ports?: [PN=string]: {
			name:      PN
			port:      int
			service:   *port | int
			container: *port | int
		}
		volumes: [VN=string]: {
			volume: name: VN
			mount: name:  VN
		}
		replicas?:  _
		resources?: _
		affinity?:  _
		labels: app:           N
		selector: matchLabels: labels
		grpc?: {
			service: _
			package: _
			prefix:  "/\(package).\(service)/"
		}
		db?: {
			name:     _
			host:     _
			username: _
		}
		diag?: aws?: _
	}
	_local: {
		volumes: #var.volumes & {
			if #var.config != _|_ {
				(N): {
					volume: configMap: name: N
					mount: "path": #var.config.mountPath
				}
			}
			if kubernetes.#resources.certificates[N] != _|_ {
				let TLS = N + "-tls"
				(TLS): {
					volume: secret: secretName: kubernetes.#resources.certificates[N].spec.secretName
					mount: path: "/tls"
				}
			}
			if B.vault != _|_ {
				let VT = "vault-token"
				(VT): {
					volume: projected: sources: [{
						serviceAccountToken: {
							audience:          P.vault.addr + ":443"
							expirationSeconds: 3600
							path:              "token"
						}
					}]
					mount: mountPath: "/var/run/secrets/vault/serviceaccount"
				}
			}
		}
	}

	sops?: data: {for k in #var.env.secret {(k): _}}

	kubernetes: #resources: {
		[_]: [N=_]: metadata: {
			name: N
			labels: {
				#var.labels
				...
			}
		}
		if #var.config != _|_ {
			for n, f in #var.config.files {
				configmaps: (N)?: data: (n): f
			}
		}
		if B.sops != _|_ {
			secrets?: (N)?: stringData: B.sops.data
		}
		deployments?: (N)?: spec: {
			if #var.replicas != _|_ {
				replicas: #var.replicas
			}
			selector: #var.selector
			template: {
				metadata: {
					labels: #var.labels
					if B.vault != _|_ {
						let VAULT = {
							authPath:  _
							tokenPath: "token"
							secret: {
								path: _
								name: "env"
							}
							injectFile: "envrc"
							namespace:  B.vault.namespace
						}
						let SECRET = path.Join(VAULT.secret.path, VAULT.secret.name)
						annotations: yaml.Unmarshal("""
								vault.hashicorp.com/agent-init-first: 'true'
								vault.hashicorp.com/agent-inject: 'true'
								vault.hashicorp.com/agent-inject-secret-\(VAULT.injectFile): \(SECRET)
								vault.hashicorp.com/agent-inject-template-\(VAULT.vault.injectFile): |
								  {{ with secret "\(SECRET)" }}
								    {{ range $k, $v := .Data.data }}
								    export {{ $k }}={{ $v }}
								    {{ end }}
								  {{ end }}
								vault.hashicorp.com/auth-config-path: \(#var.volumes["vault-token"].mount.path)/\(VAULT.tokenPath)
								vault.hashicorp.com/auth-config-remove_jwt_after_reading: 'false'
								vault.hashicorp.com/auth-config-role: \(N)-role
								vault.hashicorp.com/auth-path: \(VAULT.authPath)
								vault.hashicorp.com/auth-type: jwt
								vault.hashicorp.com/namespace: \(VAULT.namespace)
								""")
					}
				}
				spec: {
					if #var.affinity != _|_ {
						affinity: #var.affinity
					}
					containers: [
						{
							name:  N
							image: D.image.uri
							if #var.command != _|_ {
								command: *#var.command | _
							}
							if #var.args != _|_ {
								args: *#var.args | _
							}
							if #var.sh != _|_ {
								command: ["sh", "-euc", #var.sh]
								args: list.FlattenN(["--", #var.args], -1)
							}
							envFrom: [
								{
									configMapRef: name: N
								},
								if B.sops != _|_ {
									secretRef: name: N
								},
							]
							env: [
								for e, v in #var.env.kv {
									name:  e
									value: v
								},
								for n, fp in #var.env.fieldPath {
									name: n
									valueFrom: fieldRef: {
										apiVersion: "v1"
										fieldPath:  fp
									}
								},
							]
							if #var.ports != _|_ {
								ports: [for n, p in #var.ports {
									name:          n
									containerPort: p.container
								}]
							}
							if #var.resources != _|_ {
								resources: #var.resources
							}
							volumeMounts: [for v in #var.volumes {v.mount}]
							livenessProbe?:  _
							readinessProbe?: _
						},
						if #var.diag.aws != _|_ {
							name:  "diag-aws"
							image: "amazon/aws-cli"
							command: [
								"sh",
								"-euc",
								"tail -f /dev/null",
							]
							volumeMounts: [for v in #var.volumes {v.mount}]
						},
					]
					if B.vault != _|_ {
						serviceAccountName: N
					}
					volumes: [for v in #var.volumes {v.volume}]
				}
			}
		}
		if #var.ports != _|_ {
			services?: (N)?: spec: {
				ports: [for n, p in #var.ports {
					name:       n
					port:       p.service
					protocol:   "TCP"
					targetPort: *n | int | string
				}]
				selector: #var.labels
			}
			mappings?: (N)?: spec: {
				ambassador_id?: _
				prefix:         *"/\(N)/" | _
				service:        "http://\(N).\(deploy.namespace).svc"
				resolver:       "endpoint"
				load_balancer: policy: "least_request"
				idle_timeout_ms: 60000
				timeout_ms:      0
				shadow?:         true
				weight?:         >=0 & <=100
			}
		}
	}
}
