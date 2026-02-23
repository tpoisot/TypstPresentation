#import "lib/slides.typ": *
#import "@preview/colorful-boxes:1.4.3": stickybox
#import "@preview/pinit:0.2.2": *

#show: slides.with(
  textfont: "Liberation Sans",
  mathfont: "Liberation Serif",
  rawfont: "Liberation Mono",
)

#slide(title: "Hi!")[
  This is a tutorial to use the slides template
]

#section[The basics]

#slide(title: "Author information", width: 60%)[

  Author information is given as a #hl[dictionary], where each author is an entry. Currently, only the first author info is displayed on the title / take-home slides.

  #illustration[
    ```typst
    #let _authors = (
      (
        name: "First Author",
        bluesky: "bsky username",
        email: "name@email",
        website: "website",
        institution: "Institution",
      ),
    )
    ```
  ]
]

#slide(title: "Useful packages", width: 80%)[

  Here is a selection of very useful packages for slides, which can be added at the top of the document to use them:

  ```typst
  // Post-it notes
  #import "@preview/colorful-boxes:1.4.3": stickybox
  // Diagrams
  #import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
  // Icons
  #import "@preview/scienceicons:0.1.0": *
  // Pins and annotations
  #import "@preview/pinit:0.2.2": *
  ```

  #illustration[
    #stickybox(rotation: 5deg)[
      #text(font: "Special Elite")[
        The colorful-boxes package is good because you can use post-it style callouts on your slides
      ]
    ]
    #v(1em)
    #stickybox(rotation: -7deg, fill: rgb("#33ff57").lighten(60%))[
      #text(font: "Special Elite")[
        If you use fletcher, it is much better to load it in a separate file that contains the entire diagram
      ]
    ]

  ]

  This Open Access #open-access-icon(color: orange, height: 1.1em, baseline: 20%) icon is from `scienceicons`, which the slides template will load anyways!

]

#slide(title: "Using pinit")[

  The slides support the `pinit` package natively -- the usual caveats about placement with `pinit` apply, see the package documentation.

  In addition, the `pint-point-from` function may not reserve its space on the slide, and using it with `reveal` might overlap with future text. #reveal(on: 2)[This will usually result in a `layout did not converge` warning, which should not prevent the document from rendering.]

  \

  This text can be #pin(1)highlighted#pin(2) by `pinit`. The pins can also be #pin(3)animated#pin(4)

  #pinit-highlight(1, 2)

  #reveal(on: 3)[
    #pinit-highlight(3, 4)
    #pinit-point-from(4)[or this]
    #pinit-point-from(2)[Like this]
  ]

]

#slide(title: "Additional markup")[
  Text can be #hl[highlighted] with `#hl` - the color will be picked from the section color

  Code can specifically be highlighted with `kbd`: #kbd("localhost%")
]

#section[Layout]

#slide(title: "Content and illustration")[

  By default, the slide area will occupy 100% of the width of the area, which is fine when you either want

  - full width text
  - a single big picture
  - code

]

#slide(title: "Keeping space for illustrations", width: 60%)[

  You can keep some space for an illustration, which is done by specifying what proportion of the slide should be occupied by the content:

  ```typst
  #slide(
    title: "Keeping space for illustrations",
    width: 60%
  )[Content goes here]
  ```

  This slide has a width of 60%

]

#slide(title: "Picking a side for the layout", width: 60%, align: right)[

  The `slide` function takes an `align` keyword that will specify whether the content is at the `left` or `right` of the slide.

  ```typst
  #slide(
    title: "Keeping space for illustrations",
    width: 60%,
    align: right
  )[Content goes here]
  ```

  This slide has a width of 60% and is aligned to the right

]

#slide(title: "Adding an illustration", width: 55%)[

  The space that is usable for illustration can be filled with the `illustration` function:

  ```typst
  #illustration(
    style: (
      radius: 6pt,
      inset: 55pt,
      fill: luma(95%))
  )[
    #align(center)[
      The illustration for this slide
    ]
  ]
  ```

  Note that illustrations are rendered in a `block`, and that arguments to the block itself can be passed _via_ the `style` argument. Illustrations are _not_ horizontally centered by default.

  #illustration(style: (radius: 6pt, inset: 55pt, fill: luma(95%)))[#align(center)[The illustration for this slide]]

]

#slide(title: "What about grids?", width: 70%)[
  The `grid` function works fine for more complex layouts, _but_ cannot be used together with the `reveal` and `pop` functions for slide transitions. The `illustrate` function works well for this usage.

  #reveal(on: 2)[#illustration[#align(horizon + center)[#rotate(-90deg)[#text(
    red,
    weight: "black",
    size: 40pt,
  )[Like so.]]]]]
]

#section[Transitions]

#slide(title: "Fundamentals", width: 60%)[
  There are two types of transitions

  Transitions that `reveal` will reserve their space, and transitions that `pop` do not.

  #illustration[

    #reveal(on: 5)[
      #block(
        fill: purple.lighten(90%),
        stroke: stroke(dash: "dashed", paint: purple.lighten(30%), thickness: 1pt),
        inset: 10pt,
        width: 100%,
      )[This purple element is revealed on stage 5]
    ]

    #pop(from: 3)[
      #block(
        fill: blue.lighten(90%),
        stroke: stroke(dash: "dashed", paint: blue.lighten(30%), thickness: 1pt),
        inset: 10pt,
        width: 100%,
      )[The blue element will pop in at stage 3]
    ]

    #reveal(from: 2, until: 4)[
      #block(
        fill: green.lighten(90%),
        stroke: stroke(dash: "dashed", paint: green.lighten(30%), thickness: 1pt),
        inset: 10pt,
        width: 100%,
      )[This element is revealed from stage 2, and will remain until stage 4]
    ]

  ]

  We are on stage
  #for stage in (1, 2, 3, 4, 5) {
    pop(on: stage)[#stage]
  }

  #stages(5)

  #v(5em)

  *Known bug*: when the animations are in another function, they sometimes fail to render their final stages. Add a `#stages(n)` at the end of the slide with an empty string and this will fix it

]

#slide(title: "Specifying the order of apparition", width: 80%)[

  #v(1fr)

  #show table.cell.where(y: 0): strong
  #set table(
    inset: 10pt,
    stroke: (x, y) => if y == 0 {
      (bottom: 0.7pt + black)
    } else {
      (bottom: 0.1pt + black)
    },
    align: (x, y) => if x == 3 { left } else { center },
  )

  #align(top)[
    #table(
      columns: (1fr, 1fr, 1fr, 5fr),
      table.header([on], [until], [from], [result]),
      [1], [], [], [#reveal(on: 1)[on slide 1 only]],
      [], [2], [], [#reveal(until: 2)[until slide 2]],
      [], [4], [2], [#reveal(until: 4, from: 2)[between slide 2 and 4]],
      [1], [], [3], [#reveal(on: 1, from: 3)[on slide 1 and then from 3]],
      [], [], [2], [#reveal(from: 2)[starting from slide 2]],
    )
  ]

  #v(1fr)
  _We are currently on stage #for stage in range(1, 5) { pop(on: stage)[#stage] }_


]

#slide(title: "Conditional formatting", width: 70%)[

  The `onstage(n)` function returns `true` when the slide is currently on stage `n`, and this can be used for conditional formatting.

  #illustration[
    #block(
      fill: luma(88%),
      stroke: red,
      inset: 10pt,
      width: 100%,
    )[
      This element is always present, but has a border in stage 2, and a background in stage 3.

      #context [On stage #nstage.get().first()]
      
      #if onstage(2) == false {
        [On stage 2]
      } else {
        [Not on stage 2 #onstage(2)]
      }

    ]
  ]

]


#section(color: rgb("#6b326aff"))[Section slides]


#slide(title: "What do sections do?")[
  Sections of the talk are marked with

  ```typst
  #section[Section title]
  ```

  They change the section header in the slides, and optionally change the accent color for the section.

  For example, the current section is started with

  ```typst
  #section(color: rgb("#6b326aff"))[Section slides]
  ```

]

#slide(title: "Display / hidden")[
  The `section` marker takes an optional argument `display`, which turns the slide display off _just for this section_.

  This is useful for short presentations when you want the _section header_ to change on the slides, but _do not want_ the slide to be displayed

  ```typst
  #section(display: false)[New section with no title slide]
  ```
]

#section[Fletcher and animations]

#slide(title: "Introduction")[
  This gets its own section because animations with `fletcher` are not particularly intuitive.

  This will require some finagling to get it done, but it is fully doable.
]


#section(color: red)[Kitchen sink]

#slide(title: "Title is longer than the content width", width: 10%)[
  This slide is here to test that when the slide content is _very narrow_, the text and the footer can actually overlap
]

#slide(title: "Stages debug")[
  This should be 1: #__get_max_from_reveal_element(on: 1) #reveal(on: 1)[and present on slide 1]

  This should be 3: #__get_max_from_reveal_element(until: 3) #reveal(from: 3)[and present after slide 3]

  This should be 2: #__get_max_from_reveal_element(from: 2) #reveal(until: 2)[and present on 1 and 2]

  This should be 5: #__get_max_from_reveal_element(on: 5, until: 3) #reveal(on: 1, from: 3)[and present on 1 and then from 3]

  #pop(on: 4)[This shows up on slide 4 only]
]
