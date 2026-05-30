#import "lib.typ": *

#show: aut-thesis.with(
  title-fa: [کمینه‌سازی عمر اطلاعات در شبکه #lr[LoRaWAN] با تخصیص فاکتور گسترش],
  title-en: "Age of Information Minimization in LoRaWAN Networks via Spreading-Factor Allocation",
  faculty: "دانشکده مهندسی کامپیوتر",
  department: "گرایش شبکه‌های کامپیوتری",
  supervisors: ("دکتر حمیدرضا زرندی",),
  supervisors-en: ("Dr. Hamid R. Zarandi",),
  author: "پرهام الوانی",
  author-en: "Parham Alvani",
  date-fa: "بهار ۱۴۰۱",
  date-en: "Spring 2022",
)

// ===========================================================================
// Front matter
// ===========================================================================
#persian-title-page(
  title-fa: [کمینه‌سازی عمر اطلاعات در شبکه #lr[LoRaWAN] با تخصیص فاکتور گسترش],
  faculty: "دانشکده مهندسی کامپیوتر",
  department: "گرایش شبکه‌های کامپیوتری",
  supervisors: ("دکتر حمیدرضا زرندی",),
  author: "پرهام الوانی",
  date: "بهار ۱۴۰۱",
)

#version-page()

// --- Table of Contents ---
#page(numbering: none)[
  #grid(
    columns: (1fr, auto),
    align: (right, left),
    text(weight: "bold")[عنوان], text(weight: "bold")[صفحه],
  )
  #line(length: 100%, stroke: 0.5pt)
  #outline(title: align(center)[#text(size: 16pt, weight: "bold")[فهرست مطالب]])
]

// --- List of Figures ---
#page(numbering: none)[
  #grid(
    columns: (1fr, auto),
    align: (right, left),
    text(weight: "bold")[شکل], text(weight: "bold")[صفحه],
  )
  #line(length: 100%, stroke: 0.5pt)
  #outline(
    title: align(center)[#text(size: 16pt, weight: "bold")[فهرست اشکال]],
    target: figure.where(kind: image),
  )
]

// --- List of Tables ---
#page(numbering: none)[
  #grid(
    columns: (1fr, auto),
    align: (right, left),
    text(weight: "bold")[جدول], text(weight: "bold")[صفحه],
  )
  #line(length: 100%, stroke: 0.5pt)
  #outline(
    title: align(center)[#text(size: 16pt, weight: "bold")[فهرست جداول]],
    target: figure.where(kind: table),
  )
]

// --- Persian abstract ---
#include "abstract.typ"

// ===========================================================================
// Body chapters (arabic page numbering restarts at 1)
// ===========================================================================
#counter(page).update(1)

#include "introduction.typ"
#include "concepts.typ"
#include "related.typ"
#include "problem.typ"
#include "simulation.typ"

// ===========================================================================
// Bibliography
// ===========================================================================
#bibliography("references.bib", style: "ieee")

// ===========================================================================
// Back matter: acronyms + glossary
// ===========================================================================
#include "acronyms.typ"
#include "glossary.typ"

// ===========================================================================
// English title page
// ===========================================================================
#english-title-page(
  title-en: "Age of Information Minimization in LoRaWAN Networks via Spreading-Factor Allocation",
  faculty: "Department of Computer Engineering",
  supervisors: ("Dr. Hamid R. Zarandi",),
  author: "Parham Alvani",
  date: "Spring 2022",
)
