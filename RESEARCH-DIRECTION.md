# Research-Direction Recommendation: Age of Information in LoRa / LoRaWAN

**Candidate context.** PhD, CEIT, Amirkabir University of Technology. Supervisors: Dr. Bahador Bakhshi, Dr. Mehdi Rasti.
**Prior topic (rejected):** "LoRaWAN end-to-end performance evaluation" — rejected by the internal committee as too broad.
**Current framing:** Age of Information (AoI) in LoRa/LoRaWAN networks as an optimization problem with cross-layer trade-offs.

This document grounds a defensible direction in the 2023–2026 state of the art and proposes a concrete, novel, feasible thesis plan. All cited references were located via literature search and carry URLs/DOIs for verification (Section 4).

---

## 1. Why the original topic was rejected, and what makes a PhD-defensible contribution

**Why "LoRaWAN end-to-end performance evaluation" was (correctly) rejected.**

1. **No falsifiable thesis.** "Performance evaluation" is an *activity*, not a *claim*. A committee cannot tell what would constitute success, novelty, or failure. There is no hypothesis to defend in a viva.
2. **The literature is saturated.** End-to-end LoRaWAN evaluation (PDR, scalability, capacity, ADR behavior, coverage) has been done extensively for ~8 years, including reproducible simulators (ns-3 LoRaWAN module, FLoRa/OMNeT++, LoRaSim) and large measurement campaigns. A new "evaluation" adds a data point, not knowledge.
3. **No methodological core.** A PhD must own a *method* (a model, an algorithm, a proof, an architecture). Pure measurement/benchmarking is engineering, not doctoral research, unless it overturns a belief or yields a new model.
4. **Unbounded scope.** "End-to-end" spans PHY, MAC, network server, application, and backhaul — impossible to defend depth across all of them.

**What makes a PhD-defensible contribution here.** A defensible thesis needs (a) a **sharp metric** that re-orders the design space, (b) a **formal model** that produces *insight* (closed-form bounds, structural optimality, or provable approximation guarantees), and (c) **artifacts** (an algorithm + a validated implementation) that a committee can attack and that practitioners can reuse. AoI is an excellent pivot precisely because it *changes the optimal operating point* relative to throughput/PDR: classic LoRaWAN wisdom (maximize PDR, minimize energy, ADR toward highest data rate) is **provably suboptimal for freshness** — the AoI-optimal sampling rate is interior (too-frequent sampling congests the duty-cycle-limited channel and *increases* age), and the AoI-optimal spreading factor (SF) balances time-on-air against collision probability. That tension is a genuine, unexploited research object in LoRaWAN.

**The strategic move:** reframe from "evaluate LoRaWAN" to "**make LoRaWAN information-fresh under duty-cycle and energy constraints**," where the novelty is a *model + optimization/scheduling method*, validated, not a benchmark.

---

## 2. Candidate research directions (ranked)

For each: **Gap → Contribution → Method/Tooling → Evaluation → Risk.**

### Direction A (RANK 1) — Cross-layer AoI optimization under the LoRaWAN duty-cycle constraint: joint SF/rate allocation and sampling control

- **Gap.** Existing LoRa-AoI work is almost entirely either (i) pure-learning black boxes on a Slotted-ALOHA abstraction that *ignore energy and the 1% duty cycle* (e.g., the SAC-DRL work of Cheng et al., 2025, which explicitly states it omits energy and packet-loss; and the Q-learning relay work of 2024), or (ii) generic AoI-random-access theory that never models LoRa's SF-dependent time-on-air, capture effect, or sub-band duty-cycle regulation. **Nobody has a tractable model that couples (sampling rate λ_i) × (SF/time-on-air) × (duty-cycle budget) × (capture-based collisions) and *derives* the AoI-optimal operating point.**
- **Contribution.** (1) A queueing/Markov model of per-device peak and average AoI in a single-gateway LoRaWAN cell that is *explicitly* parameterized by SF (hence airtime and collision/capture probability) and by the regulatory duty cycle as a hard rate cap. (2) A proof of the structural form of the AoI-optimal sampling rate and SF assignment (interior optimum; a "freshness waterfilling" over SF groups). (3) A practical, ADR-compatible scheduling/allocation algorithm that the network server can run, plus its duty-cycle-feasibility guarantee.
- **Method/Tooling.** Analysis: discrete-time Markov chains / SHS (stochastic hybrid systems) for AoI moments; capture-aware collision model (per-SF, à la sequential-waterfilling ADR literature). Optimization: the per-cell problem is a non-convex mixed integer program (SF is integer); attack via (a) Lyapunov drift-plus-penalty for an online sampling-and-transmit policy with provable AoI–energy trade-off, and (b) a relaxation + rounding with an approximation bound. Validation: **FLoRa (OMNeT++/INET)** or the **ns-3 LoRaWAN module**, extended with an AoI tracker and EU868 duty-cycle enforcement; calibrate collision/capture against measurements.
- **Evaluation.** Metrics: time-average AoI, peak-AoI violation probability (P{PAoI > τ}), energy-per-fresh-update, fairness (max AoI). Baselines: standard ADR, throughput-optimal allocation, AoI-blind round-robin, the DRL baseline from Cheng et al. Sweep device density, payload, traffic mix; show the AoI-optimal point differs from PDR/throughput-optimal.
- **Risk.** *Medium.* Capture-effect modeling in dense LoRa is messy; mitigate by validating the collision kernel against measurement traces and keeping the analytical model conservative (bounds, not exact). Non-convexity is real but standard relaxation/Lyapunov tooling applies.

### Direction B (RANK 2) — AoI-threshold / age-aware random access for LoRaWAN Class A, with energy harvesting

- **Gap.** Age-threshold and age-gain-dependent slotted-ALOHA policies (Zhao et al., 2024; Yavascan/Uysal; Wang & Chen, 2023) provably halve the AoI growth rate vs. plain ALOHA, but they are derived for synchronous, single-airtime slot models. LoRaWAN Class A is **asynchronous, multi-airtime (SF heterogeneous), duty-cycle-capped, and battery/EH-powered** — none of which the threshold-ALOHA theory captures. The energy–age trade-off literature (e.g., "Sleep, Sense or Transmit"; EH RL control) is likewise not specialized to LoRa's regulatory and PHY structure.
- **Contribution.** A *decentralized, age-and-energy-threshold transmission policy* for Class A end-devices (transmit only when local AoI exceeds an age-gain threshold *and* the EH buffer allows), with analysis of average/peak AoI under heterogeneous SF and a duty-cycle budget, and a proof that it dominates blind periodic reporting at high density.
- **Method/Tooling.** Mean-field / fixed-point analysis of the decentralized threshold game; MDP/Whittle-index per device for the sample-or-sleep decision under EH; simulation in FLoRa/ns-3 with an energy-harvesting model.
- **Evaluation.** Average AoI vs. node density and harvest rate; threshold robustness to clock drift; comparison against TSA-style baselines and confirmed/unconfirmed LoRaWAN traffic.
- **Risk.** *Medium-high.* Decentralized fixed-point analysis under heterogeneous airtime can become intractable; mitigate by restricting to a few SF classes and validating mean-field accuracy by simulation. Overlap risk with generic threshold-ALOHA papers — novelty must stay anchored in the *LoRa-specific* constraints.

### Direction C (RANK 3) — Network-calculus / stochastic bounds on peak-AoI for LoRaWAN (guarantees, not averages)

- **Gap.** Almost all LoRa-AoI results are *average-case* (mean AoI) or empirical. Mission/industrial monitoring needs **probabilistic freshness guarantees**: P{PAoI > τ} ≤ ε. The (max,+)/stochastic-network-calculus machinery for AoI tail bounds exists in the abstract wireless setting but has never been instantiated for LoRaWAN's G/G/1-like uplink with duty-cycle-shaped arrivals.
- **Contribution.** Closed-form / computable **upper bounds on the peak-AoI violation probability** for a LoRaWAN device as a function of SF, payload, duty cycle, and contention, using stochastic network calculus (arrival/service curves with a duty-cycle "shaper" element and a capture-aware service process). Turn the bound into an *admission-control / SF-assignment rule* that certifies a freshness SLA.
- **Method/Tooling.** (max,+) algebra, moment-generating-function service-curve bounds; the duty cycle modeled as a leaky-bucket shaper. Tooling: analytical + numerical bound evaluation, cross-checked against FLoRa simulation.
- **Evaluation.** Tightness of the bound vs. simulated PAoI tails; how many devices can be admitted under a given SLA per SF.
- **Risk.** *High* on tightness (SNC bounds can be loose under capture/collisions) but *high reward* — a guarantee-style result is rare and very defensible. De-risk by targeting *bounds + their use in admission control* rather than tightness as the headline.

### Direction D (RANK 4, higher-novelty/higher-risk) — Information freshness of LR-FHSS (and AoI-aware LR-FHSS resource allocation)

- **Gap.** LR-FHSS is the newest LoRaWAN PHY (intra-packet fragmentation, frequency hopping, large device density, direct-to-satellite). Recent work covers its **coverage, energy, scalability, and outage** (Maldonado et al., 2024; energy model 2024; experimental DR comparisons 2025) but **AoI/freshness of LR-FHSS is essentially untouched** — including the freshness impact of fragment redundancy, header-loss recovery, and (for satellite) intermittent gateway visibility.
- **Contribution.** First AoI characterization of LR-FHSS uplink as a function of fragmentation/redundancy and hopping, and an AoI-aware redundancy/demodulator-allocation policy; for direct-to-satellite, AoI under deterministic LEO visibility windows.
- **Method/Tooling.** Extend LR-FHSS collision/decoding models with an AoI layer; simulate; optionally couple with a satellite-pass scheduler.
- **Evaluation.** AoI vs. redundancy and density; AoI under satellite visibility duty cycles.
- **Risk.** *High.* LR-FHSS simulators are immature and the PHY is complex; strong novelty but heavier tooling cost. Best as a later thesis chapter or a stretch contribution, not the spine.

---

## 3. Recommended primary direction and formulation

**Recommendation: Direction A**, optionally absorbing the **age-threshold policy of B** as the *online-control* chapter and the **SNC bound of C** as the *guarantee* chapter. This gives a three-chapter arc: (i) model + optimal static allocation, (ii) online age-aware control, (iii) probabilistic freshness guarantees.

**Thesis statement (one sentence).**
> *In duty-cycle-limited LoRaWAN, information freshness is governed by a cross-layer trade-off between sampling rate, spreading-factor-dependent airtime, and capture-aware contention; this thesis develops a tractable AoI model that exposes the interior freshness-optimal operating point and a network-server allocation-and-control algorithm that minimizes peak Age of Information under regulatory duty-cycle and device energy budgets, provably outperforming throughput- and PDR-optimal policies.*

**Candidate optimization-problem formulation (per single-gateway cell).**

*Decision variables.*
- λ_i ≥ 0 — status-update generation (sampling) rate of device i (updates/s), i ∈ {1,…,N}.
- s_i ∈ {SF7,…,SF12} — spreading factor (hence airtime T_air(s_i, payload) and per-SF capture/collision behavior) assigned to device i.
- p_i ∈ [0,1] — (optional) transmission/age-threshold probability or threshold θ_i for the online-control variant.

*Auxiliary / model quantities.*
- T_i = T_air(s_i, L_i): time-on-air for device i.
- q_i(λ, s): successful-delivery probability for i under the capture-aware collision model given all devices' rates and SFs.
- Ā_i(λ_i, s_i, q_i): average (or peak) AoI of device i from the queueing/SHS model.
- e_i = energy per transmission (∝ T_i and TX power); E_i^budget = per-period energy budget.

*Objective (freshness, with fairness).* minimize the worst-case (or weighted-sum) age:

  minimize over {λ_i, s_i, p_i}:  max_i Ā_i(λ_i, s_i, q_i)   — (or  Σ_i w_i Ā_i)

*Constraints.*
1. **Duty cycle (regulatory, per sub-band b):**  Σ_{i ∈ b} λ_i · T_air(s_i, L_i) ≤ d_b   (d_b = 0.01 for EU868 1% sub-bands).
2. **Energy budget:**  λ_i · e_i(s_i) ≤ E_i^budget / Δ,  ∀ i.
3. **Freshness SLA (peak-AoI guarantee, ties in Direction C):**  P{ PAoI_i > τ_i } ≤ ε_i,  ∀ i.
4. **Resource/sanity:**  s_i ∈ {SF7…SF12};  λ_i^min ≤ λ_i ≤ λ_i^max;  p_i ∈ [0,1].
5. **Consistency:** q_i = capture-collision-kernel({λ_j, s_j}_j) (fixed-point coupling across devices).

*Why it is hard and defensible.* Integer SF + the nonlinear, all-to-all coupling through q_i (collisions) + the duty-cycle and energy caps make this a **non-convex MINLP with an interior AoI optimum**. The thesis contributions are: the *model* that makes Ā_i and q_i computable; a *relaxation/waterfilling* with an approximation bound for the static problem; a *Lyapunov drift-plus-penalty online policy* (Direction B) with a provable AoI–energy trade-off curve; and an *SNC admission rule* for Constraint 3 (Direction C). Validation in FLoRa/ns-3 against ADR, throughput-optimal, and the published DRL baseline.

---

## 4. Annotated bibliography (verified, 2020–2026)

LoRa/LPWAN-specific AoI:

1. **K. Cheng, C. Chen, J. Luo, Q. Chen, "Optimizing Age of Information in LoRa Networks via Deep Reinforcement Learning," *J. of Electronics & Information Technology*, 2025.** DOI: 10.11999/JEIT240404 — https://jeit.ac.cn/en/article/doi/10.11999/JEIT240404
   *Soft Actor-Critic DRL minimizes AoI under Slotted-ALOHA in a LoRa ITS scenario. Explicitly omits energy, packet-loss, and heterogeneous coexistence — the exact gap Direction A fills with a model-based, duty-cycle- and energy-aware formulation.*

2. **Q-Learning-Based Medium Access for Minimizing AoI in LoRa Wireless Relay Networks, *IEEE* (Xplore doc. 10776963), 2024.** https://ieeexplore.ieee.org/document/10776963/ (ResearchGate preprint: https://www.researchgate.net/publication/386447467)
   *RL-driven dynamic SF selection to lower AoI in a LoRa relay topology. Confirms RL-on-LoRa-AoI momentum but lacks duty-cycle/energy constraints and analytical structure.*

AoI random access / threshold policies (theory to specialize for LoRaWAN):

3. **F. Zhao, N. Pappas, C. Ma, X. Sun, T. Q. S. Quek, H. H. Yang, "Age-Threshold Slotted ALOHA for Optimizing Information Freshness in Mobile Networks," 2024.** arXiv:2312.10888 — https://arxiv.org/abs/2312.10888
   *Nodes stay silent until AoI crosses a threshold; time-average AoI growth rate is halved vs. plain ALOHA. The theoretical backbone for Direction B (must be re-derived under LoRa's heterogeneous airtime + duty cycle).*

4. **Q. Wang, H. Chen, "Age of Information in Reservation Multi-Access Networks with Stochastic Arrivals: Analysis and Optimization," 2023.** arXiv:2305.15128 — https://arxiv.org/abs/2305.15128
   *Markov-chain analysis and optimization of Frame-Slotted-ALOHA-with-Reservation AoI. Useful template for Class B beacon/reservation-style AoI analysis.*

5. **Analysis of the Age of Information in Age-Threshold Slotted ALOHA, 2023.** arXiv:2306.09787 — https://arxiv.org/pdf/2306.09787
   *Closed-form AoI for age-threshold ALOHA; methodological reference for the threshold-policy analysis.*

6. **Age-Gain-Dependent Random Access for Event-Driven Periodic Updating, 2024.** arXiv:2406.00720 — https://arxiv.org/pdf/2406.00720
   *Decentralized age-gain thresholds and transmission probabilities reduce network AoI — directly informs the decentralized policy in Direction B.*

AoI ↔ energy / sampling trade-off (for the energy constraint):

7. **Sleep, Sense or Transmit: Energy-Age Tradeoff for Status Update with Two-Thresholds Optimal Policy, 2021.** arXiv:2108.06007 — https://arxiv.org/pdf/2108.06007
   *Proves a two-threshold structure for the sleep/sense/transmit decision under an energy-age trade-off — structural justification for Constraint 2 and the online policy.*

8. **Power Minimization for AoI-Constrained Dynamic Control in Wireless Sensor Networks, 2020.** arXiv:2007.05364 — https://arxiv.org/pdf/2007.05364
   *Lyapunov drift-plus-penalty for joint sampling/power/sub-channel under AoI constraints — the optimization template for the online variant of Direction A.*

9. **Age-Aware Status Update Control for Energy-Harvesting IoT Sensors via Reinforcement Learning, 2020.** arXiv:2004.12684 — https://arxiv.org/pdf/2004.12684
   *MDP/RL control of EH status updates trading off AoI and energy — baseline and method source for Direction B's EH component.*

AoI bounds / network calculus / stochastic geometry (for the guarantee chapter):

10. **Minimizing the Age of Information in Wireless Networks with Stochastic Arrivals, *IEEE Trans. Mobile Computing* (Xplore doc. 8933047).** https://ieeexplore.ieee.org/document/8933047/ — arXiv: https://arxiv.org/pdf/1905.07020
    *Lower bounds and Max-Weight / stationary-randomized policies for AoI under stochastic arrivals and interference — the optimality-gap reference for scheduling claims.*

11. **Optimizing Information Freshness in Wireless Networks: A Stochastic Geometry Approach, 2020.** arXiv:2002.08768 — https://arxiv.org/pdf/2002.08768
    *Joint queueing-geometry peak-AoI expressions for large random networks — methodological basis for density-scaling results and the SNC/PAoI bounds in Direction C.*

12. **A. Rajanna et al. (peak-AoI tail), "Optimizing the Trade-off Between Throughput and PAoI Outage Exponents," 2025.** arXiv:2501.13431 — https://arxiv.org/pdf/2501.13431
    *Throughput vs. peak-AoI outage exponents — directly relevant to the P{PAoI>τ}≤ε guarantee formulation (Constraint 3).*

LR-FHSS and new LoRaWAN PHY/MAC (for Direction D and contextual currency):

13. **D. Maldonado, M. Kaneko, J. A. Fraire, A. Guitton, O. Iova, H. Rivano, "Enhancing LR-FHSS Scalability Through Advanced Sequence Design and Demodulator Allocation," 2024.** arXiv:2407.03490 — https://arxiv.org/abs/2407.03490
    *Wide-Gap hopping sequences + "Early-Decode"/"Early-Drop" demodulator allocation for LR-FHSS scalability — the resource-allocation hook an AoI layer would extend.*

14. **Energy Performance of LR-FHSS: Analysis and Evaluation, 2024.** arXiv:2408.04908 — https://arxiv.org/pdf/2408.04908
    *Analytical current-consumption / battery-lifetime / energy-efficiency model of LR-FHSS — the energy model needed for any AoI-energy LR-FHSS study.*

15. **Experimental Evaluation of LR-FHSS: A Comparison with LoRa, *Sensors* 25(23):7209, 2025.** https://www.mdpi.com/1424-8220/25/23/7209
    *Field comparison: LR-FHSS (DR8/DR10) keeps links at 3–4 km and improves urban reception ~20% over LoRa. Establishes LR-FHSS as a live, under-studied target for freshness analysis.*

Background / supporting (LoRaWAN ADR & duty cycle, for the system model):

16. **Capture-Aware Sequential Waterfilling for LoRaWAN Adaptive Data Rate, 2019.** arXiv:1907.12360 — https://arxiv.org/pdf/1907.12360
    *Capture-effect-aware SF allocation ("sequential waterfilling") — the collision/capture kernel and allocation style to adapt into Constraint 5 and the SF-assignment algorithm.*

17. **Nature-Inspired Optimization of IoT Network for Delay-Resistant and Energy-Efficient Applications, *Scientific Reports*, 2025.** https://www.nature.com/articles/s41598-025-95138-z (PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC11929785/)
    *Golden-ratio low-duty-cycle LoRa MAC reducing latency/power vs. PSO — evidence that duty-cycle is the binding constraint on LoRa latency/freshness, motivating Constraint 1.*

---

### Bottom line
Pivot from "evaluation" to a **model-plus-method** thesis on **peak-AoI minimization in duty-cycle-limited LoRaWAN** (Direction A as spine; threshold-control and SNC-guarantee chapters from B and C; LR-FHSS as a stretch chapter D). The defensible core is the *cross-layer AoI model that reveals an interior optimum the throughput/PDR literature misses*, plus a duty-cycle-feasible, energy-aware allocation/control algorithm validated in FLoRa/ns-3 against the published DRL and ADR baselines. This is narrow enough to defend, novel against the 2023–2026 literature, and feasible with open simulators and standard optimization/queueing tooling.
