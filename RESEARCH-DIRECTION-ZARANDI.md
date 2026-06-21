# Research-Direction Recommendation (Zarandi pivot): Reliability-Aware Task Mapping & Scheduling Optimization on NoC-Based Multicore Real-Time Systems

**Candidate context.** PhD, CEIT, Amirkabir University of Technology. New supervisor (Spring 2026): **Dr. Hamid R. Zarandi** (Associate Professor & Dept. Head, Computer Engineering, AUT; Google Scholar `ZA9rRWAAAAAJ`, DBLP `54/2774`).

**Pivot rationale.** Keep the candidate's methodological identity — **stochastic modeling** (Markov chains, queueing, stochastic hybrid systems) + **mathematical optimization** (MINLP relaxation/rounding with approximation bounds, Lyapunov drift-plus-penalty) — but move the *domain* from wireless AoI/LoRaWAN to **dependable computer architecture**, which is Zarandi's field. See `RESEARCH-DIRECTION.md` for the prior (AoI/LoRaWAN) direction the toolkit is ported from.

All claims below were located via literature search and adversarially verified (24/25 verified claims confirmed by 3-vote check). Sources in §5.

---

## 1. Supervisor fit — the key nuance

**Zarandi's verified interests (Google Scholar):** Networks-on-Chip, Reliable System Design, Computer Architectures, Embedded Systems.

**This topic was his pre-2020 core strength — and he supervised it.**
- *HYSTERY* — hybrid scheduling+mapping optimizing temperature, energy, and lifetime reliability of heterogeneous MPSoCs (Abdi & Zarandi, J. Supercomputing 74(5):2213–2238, 2018).
- *Fault-Tolerant Dynamic Task Mapping and Scheduling for NoC-Based Multicore* (Khalili & Zarandi, ACM TECS, 2017) — unified mapping+scheduling meeting deadlines, minimizing communication energy, with a predictive model flagging failure-prone cores for redundant allocation.
- *ERPOT* (Abdi, Zarandi, Girault, IEEE TPDS, 2019).

**But his 2020–2026 momentum has shifted** (DBLP `54/2774`): NoC *design* optimization (NSGA-II reliability/latency, J. Supercomputing 2025); **in-memory computing + approximate computing reliability** — Approx-IMC / Stoch-IMC on STT-MRAM (FGCS 2024), online soft-error tolerance in ReRAM crossbars for DL accelerators (IEEE Trans. Reliability 2025); gate-merging/NBTI (OptGM); blockchain/PoW; NB-IoT reliability. **No 2020–2026 paper of his is a real-time mapping+scheduling MINLP/ILP with DVFS+deadlines.**

**Consequence.** This direction fits his expertise and supervisory track record perfectly, but is *off his current publishing line*. To align with his present interests, bridge through **approximate computing / in-memory reliability as an optimization knob** (formulation E). Worth confirming with him: (a) any current funded project on real-time scheduling vs. in-memory/NoC-design, and (b) possible **co-supervision with Athena Abdi (KNTU)** — his HYSTERY/ERPOT co-author, whose group produced the QSMix scheduler.

---

## 2. State of the art (2021–2025) and the competitor to beat

**Closest active work — Lei Mo et al.** (the direct competitor):
- *Energy-aware task mapping combining DVFS and task duplication for multicore networked systems* (J. Franklin Institute, 2025; HAL `hal-05531517`). Non-convex **MINLP** jointly optimizing task-to-node/core allocation, frequency-to-task assignment, duplication, and multipath routing under real-time, dependency, and reliability constraints.
- *Energy Efficient, Real-time and Reliable Task Deployment on NoC-based Multicores with DVFS* (IEEE, 2022, doc 9774667) — same MINLP framing, joint compute + NoC communication energy.
- *CRATMS* (IEEE Trans. Reliability, 2024, doc 10486970) — adds **network contention** as a third axis to reliability+energy, but via a **heuristic**.

**Dominant exact technique:** transform the non-convex MINLP into a **MILP** via auxiliary variables / linearizing constraints, solved to optimality by branch-and-bound. **Exactness holds *only* for discrete one-hot DVFS levels** (reliability `exp(-λ(f)t)` becomes a finite constant set; log-sum/bilinear terms linearize via big-M/McCormick). This caveat is the seam your contribution lives in.

**Parallel strand — no guarantees:** metaheuristics/RL solve the same energy-vs-reliability problem but yield only "near-optimal" results without optimality or approximation-gap bounds:
- Improved Whale Optimization Algorithm (J. Supercomputing 2021).
- *QSMix* — Q-learning mixed-criticality scheduler (Afshari & Abdi, J. Supercomputing 2024).
- Heuristic energy/reliability knobs — overlap-minimization + speed scaling + backups (Saberikia & Beitollahi, JCSC 2022).

**Saturation read:** moderately saturated for *heuristic* energy-vs-reliability trade-offs; **wide open for guarantee-bearing, stochastic, model-plus-method contributions.**

---

## 3. The seam: where your toolkit beats the state of the art

| State-of-the-art limitation | Open gap your background fills |
|---|---|
| Exact MILP only for **discrete** DVFS | Continuous DVFS / general aging hazard does **not** linearize → **relaxation + randomized rounding with provable approximation ratio** |
| Static, known fault rates | **Online control** under uncertain fault/workload arrivals → **Lyapunov drift-plus-penalty**, [O(1/V), O(V)] energy–reliability trade-off |
| One fault class at a time | **Joint soft-error (transient) + aging (permanent)** reliability — techniques that help one hurt the other (verified open gap, Ma et al. 2021) |
| Deterministic deadlines | **Chance-constrained** probabilistic deadline+reliability: P{miss} ≤ ε |
| Heuristic contention (CRATMS) | **Thermal–SEU coupling** as a **stochastic hybrid system** (Arrhenius temperature → soft-error rate) |

---

## 4. Recommended thesis arc + shortlist of formulations

**Spine (three chapters, mirroring the AoI arc):**

**A — Static (RANK 1).** Joint **soft-error + aging** reliability-aware mapping/DVFS as a single MINLP, solved by **continuous relaxation + randomized rounding with an approximation bound**.
- *Gap:* prior work optimizes one fault class or uses no-guarantee heuristics; exact MILP doesn't scale and assumes discrete DVFS.
- *Optimization core:* non-convex MINLP; relaxation/rounding with provable ratio (vs. Lei Mo exact-but-discrete, vs. WOA/QSMix no-guarantee).
- *Stochastic angle:* transient faults as Poisson/Markov arrivals → per-task `exp(-λ(f)t)`; aging via electromigration/NBTI hazard; reliability = P{no unrecovered fault by deadline} as a chance constraint.
- *Zarandi fit:* directly extends HYSTERY (temperature/energy/lifetime) + his NoC-reliability profile.

**B — Online (RANK 2).** Reliability-aware scheduling under **uncertain arrivals/fault rates** via **Lyapunov drift-plus-penalty** with provable energy–reliability trade-off.
- *Gap:* existing online methods (e.g., Longevity Framework) are aging heuristics without queue-stability/optimality guarantees.
- *Stochastic angle:* queueing + Markov-modulated fault process.

**C — Guarantees (RANK 3).** **Contention-, reliability-, thermal-coupled** NoC mapping with **chance-constrained deadlines**.
- *Gap:* CRATMS adds contention only heuristically, no thermal–soft-error coupling, no probabilistic deadline guarantee.
- *Optimization core:* chance-constrained MINLP / convex restriction.
- *Stochastic angle:* stochastic hybrid system coupling thermal RC dynamics with SEU rate (Arrhenius).
- *Zarandi fit:* NoC reliability is his core tag + 2025 NoC reliability/latency work.

**Additional / alternative formulations:**

**D — Mixed-criticality** reliability-aware scheduling with **per-criticality probabilistic** reliability/deadline guarantees and bounded suboptimality (vs. QSMix's near-optimal RL).

**E — Approximate computing as a reliability knob (BEST bridge to Zarandi's *current* work).** Jointly choose approximation level + mapping + DVFS to trade output quality for energy/reliability under a **probabilistic quality-of-result constraint**. Directly leverages his active Approx-IMC / in-memory line — recommend weaving this through the spine rather than as a standalone chapter, to keep one foot in his present momentum.

---

## 5. Verified sources

Zarandi profile / prior work:
- Google Scholar `ZA9rRWAAAAAJ`; DBLP `54/2774`; AUT CV `aut.ac.ir/cv/2188`.
- HYSTERY: 10.1007/s11227-018-2248-2 · ACM TECS: 10.1145/3055512 · Approx-IMC: ScienceDirect S0167739X2400284X.

State of the art (competitor + method):
- Lei Mo, J. Franklin Institute 2025: ScienceDirect S0016003225005897; HAL hal-05531517.
- IEEE 2022 doc 9774667 · CRATMS IEEE Trans. Reliability 2024 doc 10486970 (HAL hal-04528715).
- WOA: 10.1007/s11227-021-03764-x · QSMix: 10.1007/s11227-024-06096-8 · Saberikia & Beitollahi: 10.1142/S0218126622502255.

Open-gap framing:
- Ma, Zhou, Chantem, Dick, Hu, "Resource Management for Improving Overall Reliability of MPSoCs" (2021): 10.1007/978-3-030-52017-5_10 (soft-error vs. lifetime trade-off).
- Longevity Framework (Rathore et al., IEEE Trans. Computers 2020/2021): 10.1109/TC.2020.3006571.

---

### Bottom line

The topic is **real, active, and a documented fit for Zarandi's expertise** — but it is his *pre-2020* line, not his current one. The defensible PhD core is **not** the vanilla MINLP (Lei Mo owns that) but the **guarantee-bearing, stochastic, model-plus-method** extensions your AoI toolkit already equips you for: relaxation/rounding with approximation bounds, Lyapunov online control, chance-constrained thermal–SEU coupling, and joint soft-error+aging reliability. Bridge to his *current* interests via the approximate-computing/in-memory reliability knob, and consider co-supervision with Athena Abdi (KNTU).
