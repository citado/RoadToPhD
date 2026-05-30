# Ph.D. Proposal

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/citado/roadtophd/build.yaml?style=flat-square)

- **Topic**: Age of Information Minimization in LoRaWAN via Spreading-Factor Allocation
- **Start Date**: Spring 2026
- **Under Supervision**: Dr. Hamid R. Zarandi

## Introduction 👋

A fresh restart of the Ph.D. proposal, under the supervision of Dr. Hamid R. Zarandi.

The proposal targets **Age of Information (AoI)** in LoRa/LoRaWAN networks, framed
as a cross-layer optimization problem: minimizing the average (and peak) age of
information of sensor nodes through spreading-factor allocation under duty-cycle,
energy, and ALOHA-collision constraints. The aim is to study how different
parameters affect age of information and where tuning one layer creates a
bottleneck in another.

## How to write a proposal

General proposal-writing tips:

- Do not use different words for the same concept
- Be specific about what you are doing, measuring, etc.
- Do not use etcetera
- Chapters can be read without any dependency
- Use specific citation in each line even for other sections or chapters

## Literature Sources 📚

- [Google Scholar](https://scholar.google.com/)
- [MDPI](https://www.mdpi.com/)
- [Science Direct](https://www.sciencedirect.com/)
- [IEEE Xplore](https://ieeexplore.ieee.org/Xplore/guesthome.jsp)
- [ACM Digital Library](https://dl.acm.org/)
- [Wiley Online Library](https://onlinelibrary.wiley.com/)
- [Springer](https://link.springer.com/)

## Meetings 🤝

| Location            |    Date    |
| :------------------ | :--------: |
|                     |            |

## Build 📜

The proposal is written in [Typst](https://typst.app/) (RTL Persian), while the
presentation is still written in latex with [XePersian](https://github.com/persiantex/xepersian).

### Proposal (Typst)

The proposal uses the local fonts checked into `proposal/fonts` (Vazir for the
Persian body, Neuton for Latin text), so no system fonts are required.

Requirements:

- [Typst](https://github.com/typst/typst) `0.14.2` or newer.

Compile from the repository root with:

```bash
typst compile \
  --root . \
  --font-path proposal/fonts \
  proposal/main.typ proposal/main.pdf
```

### Presentation (Latex)

The presentation is built with XePersian. The following packages are required:

```bash
tlmgr install koma-script titlesec tocloft multirow enumitem \
  cleveref tocbibind xypic datatool
```
