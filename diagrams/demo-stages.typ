#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: pill
#import "../lib/slides.typ": hl, pop, reveal
#set text(size: 11pt)


#let diagram_config = (
  spacing: (10mm, 10mm),
  node-stroke: luma(30%) + 1.5pt,
  node-fill: luma(98%),
  edge-stroke: luma(30%) + 1pt,
  node-inset: 8pt,
  debug: 3,
)


#let step0 = (
  node(
    (0, 0),
    [
      This is the first node
    ],
    width: 45mm,
    height: 20mm,
  ),
  node(
    (2, 0),
    [
      We *accept some risk*
      \
      $0 <= alpha <= 1$
    ],
    width: 75mm,
    height: 20mm,
  ),
  // These are phantom nodes, I don't like it
  node((0, 2), [], width: 75mm, height: 20mm, fill: none, stroke: 0pt),
  node((1, 0), [], width: 75mm, height: 20mm, fill: none, stroke: 0pt),
  node((1, 1), [], width: 75mm, height: 20mm, fill: none, stroke: 0pt),
  node((2, 2), [], width: 75mm, height: 20mm, fill: none, stroke: 0pt),
)

#let step1 = (
  node(
    (2, 1),
    [
      We calculate *risk tolerance*
      \
      $c = ceil((n+1) times (1 - alpha)) times n^(-1)$
    ],
    width: 75mm,
    height: 20mm,
  ),
  edge((0, 0), (1, 0), (1, 1), (2, 1), "-|>"),
  edge((2, 0), (2, 1), "-|>"),
)


#let step2 = (
  node(
    (0, 1),
    [
      We measure *error*
      \
      $cal(S)_i = 1 - "Pr"("true class")$
    ],
    width: 75mm,
    height: 20mm,
  ),
  edge((0, 0), (0, 1), "-|>"),
)

#let step3 = (
  node(
    (1, 2),
    text(white)[
      *How wrong can we be?*
      \
      $q = "quantile"(scr(bold(S)),c)$
    ],
    stroke: white + 5pt,
    fill: luma(25%),
    width: 75mm,
    height: 20mm,
  ),
  edge((2, 1), (2, 2), (1, 2), "-|>"),
  edge((0, 1), (0, 2), (1, 2), "-|>", bend: -20deg),
)

#let steps = (step0, step1, step2, step3)

#for step in range(1, steps.len() + 1) {
  pop(on: step)[
    #diagram(
      ..diagram_config,
      ..steps.slice(0, step).flatten(),
    )
  ]
}


