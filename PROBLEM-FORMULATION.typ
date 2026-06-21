#set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
#set text(font: "Neuton", size: 10pt, lang: "en")
#set par(justify: true, leading: 0.56em)
#set math.equation(numbering: "(1)")
#show heading: set text(weight: "bold", size: 10.5pt)
#show heading: set block(above: 0.85em, below: 0.45em)

#align(center)[
  #text(size: 14pt, weight: "bold")[Problem Description and Formulation]
  #linebreak()
  #text(size: 10.5pt)[Reliability- and SLO-Aware Scheduling of Serverless Workflows on Fault-Prone Edge Clusters]
  #linebreak()
  #text(size: 9pt, style: "italic")[Joint placement, resource sizing, keep-warm, and hedging — a non-convex MINLP]
]

#v(2pt)
#line(length: 100%, stroke: 0.5pt + gray)

== System model

A serverless application is a workflow DAG $G = (cal(V), cal(E))$ of $N = |cal(V)|$ functions; edge $(i,j) in cal(E)$ passes payload $b_(i j)$. The platform is a heterogeneous *edge/fog cluster* of $M$ resource-constrained, *fault-prone* nodes; node $m$ has capacity $C_m$ and a preemption/failure process of rate $psi_m$ (Poisson). Each function invocation runs in one of $L$ resource tiers $cal(R) = {r_1, dots, r_L}$ (vCPU/memory), with speed $s_l$, footprint $u_l$, and price $pi_l$. Workflow invocations arrive as a Poisson process of rate $Lambda$; the end-to-end *SLO* is a deadline $D$ that may be violated with probability at most $epsilon$.

== Decision variables

#grid(columns: (1fr, 1fr), gutter: 6pt,
[- $x_(i m) in {0,1}$ — function $i$ placed on node $m$
- $y_(i l) in {0,1}$ — function $i$ uses resource tier $l$],
[- $w_(i m) in {0,1}$ — keep a *warm* instance of $i$ on $m$
- $z_i in {0,dots,K}$ — *hedged* redundant invocations of $i$])

== Latency, cost, and reliability model

Compute time at tier $l$ is $t_(i l) = c_i \/ s_l$ and its price $e_(i l) = pi_l t_(i l)$. A *cold start* adds delay $delta_i$ whenever the serving node holds no warm instance, so the response time of $i$ is
$ ell_i = underbrace(q_(i m), "queueing") + (1 - w_(i m)) delta_i + t_(i l) + underbrace(b_(i j) \/ beta_(m m'), "data transfer") . $
A node completes $i$ without preemption with probability $sigma_(i m l) = e^(-psi_m t_(i l))$; with $z_i$ hedged copies and the workflow reliability by the deadline,
$ rho_i = 1 - product_m (1 - x_(i m) sigma_(i m l))^(z_i + 1), wide R = product_(i in cal(V)) rho_i . $
End-to-end latency $L = max_(p in cal(P)) sum_(i in p) ell_i$ is the critical-path delay over all source-to-sink paths $cal(P)$.

== Optimization problem

#text(size: 9.5pt)[
$ min_(x, y, w, z) quad underbrace(sum_(i in cal(V)) (z_i + 1) sum_l y_(i l) e_(i l), "invocation cost") + underbrace(sum_(i in cal(V)) sum_m w_(i m) kappa_m, "keep-warm idle cost") $
subject to, for all $i in cal(V)$, $m$:
$ sum_m x_(i m) = 1, wide sum_l y_(i l) = 1 quad &"(unique placement & tier)" $
$ sum_(i in cal(V)) x_(i m) u_l y_(i l) <= C_m quad &"(node capacity)" $
$ Pr{ L > D } <= epsilon quad &"(end-to-end SLO tail)" $
$ R >= 1 - rho_0 quad <==> quad sum_(i in cal(V)) ln(1 \/ rho_i) <= ln(1 \/ (1 - rho_0)) quad &"(reliability chance constraint)" $
$ w_(i m) <= x_(i m), wide x_(i m), y_(i l), w_(i m) in {0,1}, wide z_i in {0,dots,K} quad &"(warm-link & integrality)" $
]

== Why it is hard, and where the contribution lives

The binary placement/tier/keep-warm variables, the integer hedging, the *product* form of $R$, and the *tail* SLO over a stochastic critical path make this a *non-convex MINLP with an interior optimum*: a bigger tier or more hedging cuts latency and raises reliability but multiplies cost; keep-warm removes cold starts yet pays a continuous idle premium; cheap edge nodes are flaky while reliable nodes are scarce and contended. The thesis targets (i) cost-minimal placement/sizing/keep-warm via a *convex relaxation + randomized rounding with a provable approximation ratio*; (ii) an *online* autoscaling-and-keep-warm policy under non-stationary, stochastic invocation arrivals solved by *Lyapunov drift-plus-penalty* with an $[O(1\/V), O(V)]$ cost–SLO trade-off; and (iii) the *chance-constrained* tail-latency SLO with cold starts and node preemptions modeled as a *Markov-modulated / stochastic-hybrid* process. The edge/fault-prone setting anchors the dependability angle (node failures, redundancy) to a computer-architecture supervisor's lens.
