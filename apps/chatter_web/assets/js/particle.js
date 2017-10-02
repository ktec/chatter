import {joinChannel} from "./channel"

export default function (socket, root, id) {
  // add listener for channel messages

  // join the channel
  const channel = joinChannel(socket, id, "d3:particles", response => {
    console.log("Joined successfully", response)
    // response.map()
  })

  const width = Math.max(960, innerWidth),
       height = Math.max(500, innerHeight)

  const τ = 2 * Math.PI
  const radius = 200

  let x1 = width / 2,
      y1 = height / 2,
      x0 = x1,
      y0 = y1,
      i = 0,
      others = {}

  channel.on("position", (response) => {
    let {id} = response
    others[id] = response
  })

  function move() {
    const mouse = d3.mouse(this)
    x1 = mouse[0]
    y1 = mouse[1]
    channel.push("position", {id, x0, y0, x1, y1, i})
    d3.event.preventDefault()
  }

  const canvas = d3.select(root).append("canvas")
      .attr("width", width)
      .attr("height", height)
      .on("ontouchstart" in document ? "touchmove" : "mousemove", move)

  const context = canvas.node().getContext("2d")
  context.globalCompositeOperation = "lighter"
  context.lineWidth = 2

  const circleFactory = ({r,g,b}, {x, y}) => {
    return () => (time) => {
      context.strokeStyle = `rgba(${r},${g},${b},${1 - time})`
      context.beginPath()
      context.arc(x, y, radius * time, 0, τ)
      context.stroke()
    }
  }

  const getPosition = (x0, y0, x1, y1) => {
    const x = x0 + (x1 - x0) * .1
    const y = y0 + (y1 - y0) * .1
    return {x,y}
  }

  const render = () => {
    context.clearRect(0, 0, width, height)

    const colour = d3.hsl(++i % 360, 1, .5).rgb()
    const pos = getPosition(x0, y0, x1, y1)
    const circle = circleFactory(colour, pos)
    x0 = pos.x
    y0 = pos.y

    d3.select({}).transition()
        .duration(1500)
        .ease(Math.sqrt)
        .tween("circle", circle)

    Object.keys(others).map((key) => {
      if (key == id) { return }

      const {x0, y0, x1, y1, i} = others[key]
      const colour = d3.hsl(i % 360, 1, .5).rgb()
      const pos = getPosition(x0, y0, x1, y1)
      const circle = circleFactory(colour, pos)

      d3.select({}).transition()
          .duration(1500)
          .ease(Math.sqrt)
          .tween("circle", circle)
    })
  }

  d3.timer(render)
}
