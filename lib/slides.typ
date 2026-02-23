#import "@preview/scienceicons:0.1.0": bluesky-icon, cc-by-icon, cc-icon, email-icon, open-access-icon, website-icon

// These states keep track of key information about the document
#let sec = state("section", "Introduction")
#let col = state("color", blue)
#let ttl = state("title", "Presentation title")
#let stl = state("shorttitle", "Short title")
#let cnf = state("venue", "Venue")
#let bg = state("background", "default.png")

// These counters are here to keep track of the slide progress, they are used
// for section slides if shown as well as for the progressbar
#let pnum = counter("partnumber")
#let snum = counter("slidenumber")

// This is used internall to keep track of elements that are revealed or popped,
// and are super important. The last counter is switched between 0 and 1 to
// track whether we should estimate the number of stages to render, or move into
// rendering later slide stages
#let mstage = counter("mstage")
#let nstage = counter("nstage")
#let in_layout_stage = state("inlayoutstage", true)

// These variables are for page size
#let _left_margin = 1 / 32 * 100%
#let _right_margin = 2 * _left_margin
#let _bottom_margin = 1.25 / 18 * 100%
#let _top_margin = 2 * _bottom_margin

// These state are used to illustrate slides, i.e. to put content in the space that is not occupied by the main text when there is main text in a slide
#let illustration_is_on_the_left = state("illustrateleft", true)
#let slide_content_width = state("contentwidth", 100%)

// This is the function we use to determine the maximum number of stages when we need  multi-stage slides. The initial max is `on`.
#let __get_max_from_reveal_element(on: 1, until: none, from: none) = {
  let current_maximum = 1
  if on != none {
    if on > current_maximum {
      current_maximum = on
    }
  }
  if until != none {
    if until > current_maximum {
      current_maximum = until
    }
  }
  if from != none {
    if from > current_maximum {
      current_maximum = from
    }
  }
  return current_maximum
}

// This function determines whether an element included in pop or reveal must be
// rendered on a given slide stage
#let _stage_builder(on: 1, until: none, from: none, pop: false, body) = {
  context {
    if in_layout_stage.get() {
      // If we are in layout stage, we do not render anything, but simply look at
      // the maximum value for the number of stages

      let element_stage = __get_max_from_reveal_element(on: on, until: until, from: from)
      if element_stage > mstage.get().first() {
        mstage.update(element_stage)
      }
    }
    // If we are not in layout stage, then we can render. There are a few situations in which we render an element

    let element_is_rendered = false
    if from != none {
      if nstage.get().first() >= from {
        element_is_rendered = true
      } else {
        element_is_rendered = false
      }
    }
    if until != none {
      if nstage.get().first() <= until {
        element_is_rendered = true
      } else {
        element_is_rendered = false
      }
    }
    if on != none {
      if nstage.get().first() == on {
        element_is_rendered = true
      }
    }
    if element_is_rendered {
      body
    } else {
      if (not pop) {
        hide(body)
      }
    }
  }
}

// The reveal function will reserve space in the layout
#let reveal(on: none, until: none, from: none, body) = {
  _stage_builder(on: on, until: until, from: from, pop: false, body)
}

// The pop function will add things to the layout
#let pop(on: none, until: none, from: none, body) = {
  _stage_builder(on: on, until: until, from: from, pop: true, body)
}

// This function can be used to set the maximum number of stages a slide must go
// through
#let stages(body) = {
  context {
    return mstage.update(body)
  }
}

// This function is used to tell us whether we are on a specific stage of the
// animation, this is useful for conditional formatting
#let onstage(n) = {
  context {
    if in_layout_stage.get() {
      if n > mstage.get().first() {
        return mstage.update(n)
      }
    }
    if n == nstage.get().first() { true } else { false }
  }
}

// This function is used to handle slides with a space for illustration, in order to avoid using calls to grid, which does not play nice with reveal functions
#let __slide_margin_calculation(align: left, width: 100%, realdim: 0pt) = {
  // Default margins
  let mleft = _left_margin
  let mright = _right_margin
  if width != 100% {
    // We start by calculating how much we need the margin to shift by
    let differential = (100% - width) * realdim * (100% - (_left_margin + _right_margin))
    // In case the width is not 100%, we will have to change one of the margins
    if align == left {
      mright = mright + differential
    } else {
      mleft = mleft + differential
    }
  }
  return (left: mleft, right: mright, top: _top_margin, bottom: _bottom_margin)
}

#let titleslide(title: "Presentation title", subtitle: "Subtitle", venue: "Venue", authors: ("Firstname Lastname",)) = (
  context {
    set page(fill: col.get())
    ttl.update(title)
    cnf.update(venue)
    set align(horizon)
    [
      #h(1fr)
      #text(white, size: 30pt)[#cc-icon(color: white)#cc-by-icon(color: white)]
    ]
    v(1fr)
    block(text(white, weight: "black", size: 30pt, title))
    block(text(white, weight: "medium", size: 27pt, subtitle))
    v(5%)
    for author in authors [
      #text(white, size: 17pt, weight: "semibold", author.at("name")) #h(5%)
    ]
    v(1fr)
    [
      #show raw: set text(size: 12pt)
      #text(white)[#bluesky-icon(color: white) #h(.2em) #raw(authors.first().at("bluesky"))]
      #h(1fr)
      #text(white)[#email-icon(color: white) #h(.2em) #raw(authors.first().at("email"))]
      #h(1fr)
      #text(white)[#website-icon(color: white) #h(.2em) #raw(authors.first().at("website"))]
    ]
  }
)

// This function is in charge of the slide background -- when on a title slide,
// which is the first slide and any displayed section separator, the cover image
// is overlaid with a darkerning transparent background. Otherwise, the
// background is white, and there is a small band left on the right hand size
// through which the background is visible.
#let __render_page_background(title: false) = [
  #context {
    place(
      horizon + left,
      dx: 0%,
      dy: 0%,
      image(width: 100%, bg.get()),
    )
  }
  #if not (title) {
    place(horizon + left, dx: 0%, dy: 0%, rect(
      height: 100%,
      width: 100% - _left_margin,
      fill: white,
    ))
  } else {
    place(horizon + left, dx: 0%, dy: 0%, rect(
      height: 100%,
      width: 100%,
      fill: black.transparentize(70%),
    ))
  }
]

#let _default_authors = (
  (
    name: "First Author",
    bluesky: "bsky username",
    email: "name@email",
    website: "website",
    institution: "Institution",
  ),
)

#let slides(
  textfont: "Inter Display",
  mathfont: "STIX Two Math",
  rawfont: "JuliaMono",
  title: "CHANGE TITLE",
  subtitle: "CHANGE SUBTITLE",
  shorttitle: "CHANGE SHORT TITLE",
  introduction: "Introduction",
  venue: "CHANGE VENUE",
  authors: _default_authors,
  color: rgb("#36859c"),
  background: none,
  body,
) = {
  // We do not actually show the headings - but we keep track of where we
  // actually are in the presentation
  show heading: none

  // Update the important states
  stl.update(shorttitle)
  sec.update(introduction)

  // Prepare the color
  col.update(color)

  // Get the slide background if required -- this is stored as a state. Note
  // that the file path should be given relative to the root of the project, so
  // its first character should be /
  if background != none {
    bg.update(background)
  }

  // Setup the page
  set page(paper: "presentation-16-9")
  set page(margin: (left: _left_margin, right: _left_margin, top: _bottom_margin, bottom: _bottom_margin))

  // Text and equation styling
  set text(font: textfont)
  set par(leading: 10pt, justify: false)
  show math.equation: set text(font: mathfont)
  show raw: set text(font: rawfont, size: 14pt)

  // First slide
  set page(background: __render_page_background(title: true))
  titleslide(title: title, subtitle: subtitle, venue: venue, authors: authors)

  // Before we start the content we add the intro section to the TOC
  heading(level: 1)[#introduction]

  // We set the default margin for content slides here
  set page(margin: (left: _left_margin, right: _right_margin, top: _top_margin, bottom: _bottom_margin))

  // Rest of the presentation
  body
}

#let _render_slide_in_full(title: none, body) = {
  pagebreak()
  set text(size: 15pt)
  set list(marker: (text(col.get(), [⊳]), text(col.get().transparentize(40%), [-])))
  set par(justify: false)
  set align(horizon)

  // This is by how much we space things in the bottom
  let bottom_text_spacer = _left_margin * page.width

  // This is the text at the bottom of the slides
  let bottomtxt = (
    text(luma(45%), weight: "medium", size: 10pt, stl.get())
      + h(0.5 * bottom_text_spacer)
      + text(luma(65%), weight: "medium", size: 10pt, cnf.get())
  )

  // This is the progress bar for the slide -- it handles the progress within
  // the slide directly in case there are elements in reveal/pop. It is calculated not as a function of the margins, but as a function of the actual paper width

  let progress_spacer = measure(bottomtxt).width + bottom_text_spacer

  // The actual width in pixel is the DEFAULT slide width minus the spacer
  let progress_width = page.width * (100% - (_left_margin + _right_margin)) - progress_spacer

  // The dx value needs to be updated to ensure that if there is a left margin, it is not affecting the progress bar:
  let left_start = -here().position().x + _left_margin * page.width

  // We start by drawing the background progress bar
  place(bottom + left, dx: left_start + progress_spacer, dy: 6% - measure(bottomtxt).height / 5, rect(
    height: 4pt,
    width: progress_width,
    fill: luma(94%),
    radius: 6pt,
  ))

  // Then we draw the effective progress
  let progress_done = (snum.get().first() + 1) / (snum.final().first() + 1)
  place(bottom + left, dx: left_start + progress_spacer, dy: 6% - measure(bottomtxt).height / 5, rect(
    height: 4pt,
    width: progress_done * progress_width,
    fill: col.get().transparentize(55%),
    radius: 6pt,
  ))

  // The slide title will need to undergo the same adjustments as the rest of
  // the layout, notably when the space reserved for an illustration is on the
  // right of the slide, which contracts the margin by the reserved amount.
  let slide_header = align(right)[
    #text(luma(55%), weight: "medium", size: 10pt, upper(sec.get()))
    #v(-15pt)
    #text(col.get(), weight: "semibold", size: 17pt, title)
  ]
  let header_size = measure(slide_header).width

  let right_shift = page.width + left_start - (header_size + _right_margin * page.width + _left_margin * page.width)

  // This is the title for the slide. It has two parts: the section title, and
  // then the slide title
  place(top + left, dx: right_shift, dy: -48pt, slide_header)

  // This is the footer information, which should probably be rendered as the
  // same time as the progress bar, but oh well
  place(bottom + left, dx: left_start, bottomtxt, dy: 6%)
  body
}

// An illustration is any item that is displayed in the part of the slide not
// covered by text, i.e. outside of the margins of the content but within the
// slide display area margin.
#let illustration(style: (:), body) = {
  context {
    // The width of the slide display area is pretty simple to get
    let slide_display_width = page.width - _left_margin * page.width - _right_margin * page.width

    // The amount that is not covered by content is
    let not_covered_by_content = (100% - slide_content_width.get()) * slide_display_width

    // But we also need to remove the space for the column gap
    let gutter_width = _left_margin * page.width

    // Which gives a usable width of
    let usable_width = not_covered_by_content - gutter_width

    // The precise placement of the illustration will depend as a function of
    // whether it is on the left or on the right, but the logic is fundamentally
    // the same: we must figure out what value of dx we need.

    let x_starting_offset = slide_content_width.get() * slide_display_width + _left_margin * page.width

    if illustration_is_on_the_left.get() {
      x_starting_offset = -(100% - slide_content_width.get()) * slide_display_width
    }

    place(horizon + left, dx: x_starting_offset, block(width: usable_width, ..style)[#body])
  }
}

#let slide(title: none, align: left, width: 100%, body) = {
  set page(background: __render_page_background())
  context {
    // We set these two states immediately upon preparing the slide, so that
    // calls to the illustration function will know where to display the
    // illustration
    illustration_is_on_the_left.update(align != left)
    slide_content_width.update(width)

    set page(
      margin: __slide_margin_calculation(align: align, width: width, realdim: page.width),
    )

    // We start a new slide, so we increase the slide counter
    snum.step()

    // We keep track of the elements that are popping in over time
    mstage.update(0)
    nstage.update(0)

    // We add an entry to the TOC
    heading(level: 2)[#title]

    // This is the first pass we render
    // Probe pass: scan for stages and render stage 1 content
    in_layout_stage.update(true)
    nstage.update(1)
    _render_slide_in_full(title: title, body)
    in_layout_stage.update(false)
  }

  context {
    // Render pages: emit a page for each stage from 2 to mstage
    let ms = mstage.get().first()
    for s in range(2, ms + 1) {
      nstage.update(s)
      set page(
        margin: __slide_margin_calculation(align: align, width: width, realdim: page.width),
      )
      _render_slide_in_full(title: title, body)
    }
  }
}

#let section(color: blue, display: true, counter: true, body) = (
  context {
    let bottomtxt = text(luma(75%), weight: "regular", size: 12pt, ttl.get() + "  |  " + cnf.get())
    if counter {
      pnum.step()
    }
    sec.update(body)
    heading(level: 1)[#body]
    col.update(color)
    if display {
      set page(fill: col.get())
      if counter {
        place(
          horizon + left,
          rotate(text(col.get().lighten(20%), pnum.display(), size: 450pt, weight: "black"), 8deg),
          dx: 40pt,
        )
      }

      place(horizon + left, text(col.get().lighten(90%), sec.get(), size: 60pt, weight: "black"))
    }
  }
)

#let hl(body) = (
  context {
    highlight(text(col.get(), weight: "medium", body), fill: col.get().transparentize(90%), extent: 1pt)
  }
)

#let kbd(body) = (
  context {
    highlight(text(col.get(), weight: "black", raw(body)), fill: col.get().transparentize(80%), extent: 1pt)
  }
)
