// ============================================================================
// lib.typ — Typst library reproducing the AUT (Amirkabir Univ) Persian PhD
// thesis/proposal style. RTL Persian (Vazir) body + LTR Latin (Neuton).
//
// Compile from repo root with:
//   typst compile --root <repo-root> --font-path proposal/fonts ...
// ============================================================================

// ---------------------------------------------------------------------------
// 0. Basic helpers
// ---------------------------------------------------------------------------

// Forced-LTR Latin run inside Persian text (the LaTeX \متن‌لاتین equivalent).
#let lr(body) = text(dir: ltr, font: "Neuton")[#body]

// Bold helper (LaTeX \matn-siah / textbf)
#let bold(body) = text(weight: "bold")[#body]

// Persian footnote (LaTeX \پانویس). Just a thin wrapper over Typst footnote.
#let panevis(body) = footnote[#body]

// Persian digits formatter: turn an integer into Persian-Indic digits.
#let _fa-digits = ("۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹")
#let _latin-digits = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
#let fa-num(n) = {
  let s = str(n)
  let out = ""
  for ch in s.clusters() {
    let d = _latin-digits.position(c => c == ch)
    out += if d == none { ch } else { _fa-digits.at(d) }
  }
  out
}

// Today's date in Persian digits (Gregorian, since Typst has no Jalali).
#let today() = {
  let d = datetime.today()
  fa-num(d.year()) + "/" + fa-num(d.month()) + "/" + fa-num(d.day())
}

// ---------------------------------------------------------------------------
// 1. Persian ordinal words for chapter numbering (1..30)
// ---------------------------------------------------------------------------
#let _fa-ordinals = (
  "اول", "دوم", "سوم", "چهارم", "پنجم", "ششم", "هفتم", "هشتم", "نهم", "دهم",
  "یازدهم", "دوازدهم", "سیزدهم", "چهاردهم", "پانزدهم", "شانزدهم", "هفدهم",
  "هجدهم", "نوزدهم", "بیستم", "بیست‌ویکم", "بیست‌ودوم", "بیست‌وسوم",
  "بیست‌وچهارم", "بیست‌وپنجم", "بیست‌وششم", "بیست‌وهفتم", "بیست‌وهشتم",
  "بیست‌ونهم", "سی‌ام",
)
// Map 1..30 -> Persian ordinal word. Falls back to the plain Persian number.
#let fa-ordinal(n) = {
  if n >= 1 and n <= _fa-ordinals.len() { _fa-ordinals.at(n - 1) }
  else { fa-num(n) }
}

// ---------------------------------------------------------------------------
// 2. Theorem-like environments (shared counter, numbered <section>.<n>)
// ---------------------------------------------------------------------------
// All theorem kinds share ONE counter, matching setting.tex ("definition"
// counter, [section] reset). The number is <current-section>.<n>.
#let _thm-counter = counter("aut-theorem")

#let _thm-block(kind-label, body, name: none) = context {
  _thm-counter.step()
  // section number within current chapter:
  let sec = counter(heading).get()
  let secnum = if sec.len() >= 2 { fa-num(sec.at(0)) + "-" + fa-num(sec.at(1)) }
               else if sec.len() >= 1 { fa-num(sec.at(0)) }
               else { "" }
  let n = _thm-counter.get().at(0)
  let head = bold(kind-label + " " + secnum + "-" + fa-num(n))
  let title = if name != none { " (" + name + ")" } else { "" }
  block(
    width: 100%,
    inset: (right: 1em),
    spacing: 1em,
  )[#head#bold(title): #body]
}

#let definition(body, name: none)  = _thm-block("تعریف",  body, name: name)
#let remark(body, name: none)      = _thm-block("نکته",   body, name: name)
#let note(body, name: none)        = _thm-block("یادداشت", body, name: name)
#let example(body, name: none)     = _thm-block("نمونه",  body, name: name)
#let question(body, name: none)    = _thm-block("سوال",   body, name: name)
#let remember(body, name: none)    = _thm-block("یاداوری", body, name: name)
#let theorem(body, name: none)     = _thm-block("قضیه",   body, name: name)
#let lemma(body, name: none)       = _thm-block("لم",     body, name: name)
#let proposition(body, name: none) = _thm-block("گزاره",  body, name: name)
#let corollary(body, name: none)   = _thm-block("نتیجه",  body, name: name)

// ---------------------------------------------------------------------------
// 3. Figure / table caption helpers (Persian, "X-Y" numbering via SepMark)
// ---------------------------------------------------------------------------
// Persian-captioned figure. `img` is the path string (relative to --root).
#let fa-figure(img, caption: none, width: 80%, label: none) = {
  let f = figure(
    image(img, width: width),
    caption: caption,
    kind: image,
    supplement: [شکل],
  )
  if label != none { [#f #label] } else { f }
}

// Persian-captioned table. `content` is a fully-built table/grid.
#let fa-table(content, caption: none, label: none) = {
  let f = figure(
    content,
    caption: caption,
    kind: table,
    supplement: [جدول],
  )
  if label != none { [#f #label] } else { f }
}

// ---------------------------------------------------------------------------
// 4. Title pages
// ---------------------------------------------------------------------------

// Persian title page. `supervisors` is an array of Persian names.
#let persian-title-page(
  title-fa: none,
  faculty: none,
  department: none,
  degree-line: "پیشنهاد رساله دکتری",
  supervisors: (),
  author: none,
  date: none,
  logo: "img/aut-logo-fa.png",
) = {
  set align(center)
  page(numbering: none, header: none, footer: none)[
    #v(0.5cm)
    #image(logo, height: 3.8cm)
    #v(0.4cm)
    #text(size: 16pt, weight: "bold")[دانشگاه صنعتی امیرکبیر]
    #v(-0.2cm)
    #text(size: 14pt)[(پلی‌تکنیک تهران)]
    #v(0.2cm)
    #text(size: 16pt)[#faculty]
    #v(0.5cm)
    #text(size: 16pt, weight: "bold")[#degree-line]
    #v(-0.1cm)
    #text(size: 14pt)[#department]
    #v(1cm)
    #text(size: 20pt, weight: "bold")[#title-fa]
    #v(0.8cm)
    #text(size: 16pt, weight: "bold")[نگارش]
    #v(0.1cm)
    #text(size: 18pt, weight: "bold")[#author]
    #v(0.8cm)
    #text(size: 16pt, weight: "bold")[
      #if supervisors.len() > 1 [استادان راهنما] else [استاد راهنما]
    ]
    #v(0.1cm)
    #for s in supervisors {
      text(size: 18pt, weight: "bold")[#s]
      linebreak()
    }
    #v(1fr)
    #text(size: 16pt)[#date]
    #v(0.5cm)
  ]
}

// English (LTR) title page. `supervisors` is an array of English names.
#let english-title-page(
  title-en: none,
  faculty: none,
  degree-line: "Ph.D. Thesis Proposal",
  supervisors: (),
  author: none,
  date: none,
  logo: "img/aut-logo-en.png",
) = {
  page(numbering: none, header: none, footer: none)[
    #set text(lang: "en", dir: ltr, font: "Neuton")
    #set align(center)
    #v(0.5cm)
    #image(logo, height: 3.8cm)
    #v(0.4cm)
    #text(size: 18pt, weight: "bold")[Amirkabir University of Technology]
    #v(-0.2cm)
    #text(size: 16pt)[(Tehran Polytechnic)]
    #v(0.2cm)
    #text(size: 16pt)[#faculty]
    #v(0.5cm)
    #text(size: 16pt, weight: "bold")[#degree-line]
    #v(1cm)
    #text(size: 22pt, weight: "bold")[#title-en]
    #v(0.8cm)
    #text(size: 16pt, weight: "bold")[By]
    #v(0.1cm)
    #text(size: 18pt, weight: "bold")[#author]
    #v(0.8cm)
    #text(size: 16pt, weight: "bold")[
      #if supervisors.len() > 1 [Supervisors] else [Supervisor]
    ]
    #v(0.1cm)
    #for s in supervisors {
      text(size: 18pt, weight: "bold")[#s]
      linebreak()
    }
    #v(1fr)
    #text(size: 16pt)[#date]
    #v(0.5cm)
  ]
}

// ---------------------------------------------------------------------------
// 5. Version (colophon) page
// ---------------------------------------------------------------------------
#let version-page(date: none) = {
  let d = if date != none { date } else { today() }
  page(numbering: none, header: none, footer: none)[
    #set align(center + horizon)
    این سند برپایه #lr[Typst] گونه #lr[0.14.2] توسعه پیدا کرده است.

    ویرایش شده به تاریخ #d
  ]
}

// ---------------------------------------------------------------------------
// 6. Abstract page
// ---------------------------------------------------------------------------
#let abstract-page(body, keywords: none) = {
  page(header: align(right)[چکیده])[
    #align(center)[#text(size: 16pt, weight: "bold")[چکیده]]
    #v(0.5cm)
    #body
    #if keywords != none [
      #v(1cm)
      #bold[واژه‌های کلیدی:] #keywords
    ]
  ]
}

// ---------------------------------------------------------------------------
// 7. Acronyms list & glossary renderers
// ---------------------------------------------------------------------------
// acronyms: array of (abbr, expansion). Sorted by abbr, rendered LTR.
#let acronyms-list(entries) = {
  set text(dir: ltr, font: "Neuton")
  let sorted = entries.sorted(key: e => e.at(0))
  for e in sorted {
    grid(
      columns: (auto, 1fr, auto),
      align: (left, center, right),
      bold(e.at(0)),
      box(width: 100%, repeat[.]),
      e.at(1),
    )
    v(0.3em)
  }
}

// glossary: array of (english, persian). Sorted by english.
// RTL row: Persian flush right, dots, English flush left.
#let glossary-list(entries) = {
  let sorted = entries.sorted(key: e => e.at(0))
  for e in sorted {
    grid(
      columns: (auto, 1fr, auto),
      align: (right, center, left),
      text(font: "Vazir")[#e.at(1)],
      box(width: 100%, repeat[.]),
      lr[#e.at(0)],
    )
    v(0.4em)
  }
}

// ---------------------------------------------------------------------------
// 8. Top-level template
// ---------------------------------------------------------------------------
// Wrap the WHOLE document. Front-matter pages (title/version/abstract) are
// emitted by the caller BEFORE the body chapters; this template installs the
// global page setup, fonts, RTL, headings, headers/footers, and outlines.
#let aut-thesis(
  title-fa: "",
  title-en: "",
  faculty: "",
  department: "",
  supervisors: (),
  supervisors-en: (),
  author: "",
  author-en: "",
  date-fa: "",
  date-en: "",
  abstract: none,
  keywords: none,
  body,
) = {
  // --- global text/paragraph setup ---
  set text(lang: "fa", dir: rtl, font: "Vazir", size: 11pt)
  set par(leading: 1em, justify: true)   // ~1.5 line spacing feel
  set page(
    paper: "a4",
    margin: (top: 30mm, bottom: 30mm, left: 25mm, right: 30mm),
  )

  // --- heading numbering: level-1 chapters use Persian ordinal words ---
  set heading(numbering: (..nums) => {
    let n = nums.pos()
    if n.len() == 1 {
      "فصل " + fa-ordinal(n.at(0))
    } else {
      // section/subsection: "chapter-section..." with Persian digits & "-"
      n.map(x => fa-num(x)).join("-")
    }
  })
  // reset the shared theorem counter at every section
  show heading.where(level: 2): it => {
    _thm-counter.update(0)
    it
  }

  // --- chapter (level-1) heading look: "فصل اول" big, then title big ---
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(width: 100%)[
      #set align(right)
      #if it.numbering != none [
        #text(size: 24pt, weight: "bold")[#counter(heading).display(it.numbering)]
        #v(0.3cm)
      ]
      #text(size: 22pt, weight: "bold")[#it.body]
    ]
    v(1.2cm)
  }
  show heading.where(level: 2): set text(size: 15pt)
  show heading.where(level: 3): set text(size: 13pt)

  // --- references / bibliography heading in Persian ---
  set bibliography(title: [منابع و مراجع])

  // --- running header: current chapter on body pages ---
  set page(
    header: context {
      let here = here().page()
      // find the most recent level-1 heading at/before this page
      let chapters = query(heading.where(level: 1))
      let cur = none
      for c in chapters {
        if c.location().page() <= here { cur = c }
      }
      if cur != none {
        set text(size: 9pt)
        align(right)[
          #if cur.numbering != none [
            #counter(heading).at(cur.location()).map(x => "").join()
          ]
          #cur.body
        ]
        line(length: 100%, stroke: 1.2pt)
      }
    },
    footer: context align(center)[#fa-num(counter(page).get().at(0))],
  )

  body
}
