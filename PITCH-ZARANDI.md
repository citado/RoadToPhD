# PhD Direction Proposal — for Dr. Hamid R. Zarandi

**From:** Parham Alvani (PhD candidate, CEIT) · **Re:** Reliability-aware task mapping & scheduling on NoC-based multicore real-time systems — a model-plus-method thesis

---

**Why I'm writing.** I would like to pursue my PhD under your supervision on **dependable multicore/NoC design**, building on a methodological background in **stochastic modeling and mathematical optimization** that I developed on an earlier networking topic (Age-of-Information optimization in LoRaWAN). My aim is to bring that toolkit — Markov/stochastic-hybrid modeling, Lyapunov drift-plus-penalty online control, and MINLP relaxation/rounding **with provable approximation bounds** — to reliability-aware resource management, which sits squarely in your line of work (HYSTERY, ERPOT, the ACM TECS fault-tolerant NoC mapping/scheduling).

**The problem.** Reliability-aware task mapping + DVFS scheduling on NoC-based multicores is an active area, but the recent state of the art splits into two camps, each leaving a gap:
- **Exact MILP** (e.g., Lei Mo et al., 2022–2025): optimal, but exactness holds *only* for discrete one-hot DVFS levels and a single fault class, and it does not scale or give online guarantees.
- **Metaheuristics / RL** (WOA 2021, QSMix 2024): flexible, but "near-optimal" with **no optimality or approximation-gap guarantees**.

**My proposed contribution (model + method, with guarantees).** A formal model that yields structural insight plus an algorithm a committee can attack:

1. **Static core.** Joint **soft-error (transient) + aging (permanent)** reliability-aware mapping/DVFS as a non-convex MINLP — these two fault classes trade off against each other and are usually optimized separately. Solve via **continuous relaxation + randomized rounding with a provable approximation ratio**, covering the continuous-DVFS / general-hazard regime where the exact MILP linearization breaks.
2. **Online control.** A **Lyapunov drift-plus-penalty** scheduler under uncertain workload/fault-rate arrivals, with a provable [O(1/V), O(V)] energy–reliability trade-off — a guarantee the heuristic online schedulers lack.
3. **Probabilistic guarantees.** **Chance-constrained** deadline + reliability (P{miss} ≤ ε), with **thermal–soft-error coupling modeled as a stochastic hybrid system** (Arrhenius temperature → SEU rate).

**Bridge to your current work.** I would weave in **approximation level as an explicit reliability/energy knob** (jointly chosen with mapping and DVFS under a probabilistic quality-of-result constraint), connecting the thesis to your recent approximate-computing / in-memory-reliability line (Approx-IMC, ReRAM soft-error tolerance).

**Why me.** The fault arrivals (Poisson/Markov), the reliability-by-deadline chance constraints, and the MINLP relaxation/rounding are the *same mathematics* I have already worked with; the application domain changes, the methodology transfers directly.

**What I'd value from you.** (1) Whether this aligns with a current or fundable direction in your group; (2) which of the three chapters you see as the strongest spine; (3) whether a co-supervision or collaboration (e.g., with Dr. Athena Abdi) would strengthen the optimization-theory side. I have a longer grounded write-up with the full state-of-the-art map and references, which I'm happy to share.
