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

  The slides support the `pinit` package natively -- the usual caveats about placement with `pinit` apply, see the package documentation

  \

  This text can be #pin(1)highlighted#pin(2) by `pinit`. The pins can also be #pin(3)animated#pin(4)

  #pinit-highlight(1, 2)

  #reveal(on: 2)[
    #pinit-highlight(3, 4)
    #pinit-point-from(4)[Like this]
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

  #pop(on: 2)[#illustration[#align(horizon + center)[#rotate(-90deg)[#text(
    red,
    weight: "black",
    size: 40pt,
  )[Like so.]]]]]
]

#section[Transitions]

#slide(title: "Fundamentals", width: 60%)[
  There are two types of transitions

]

#slide(title: "Specifying the order of apparition", width: 80%)[

  There are four ways to

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
