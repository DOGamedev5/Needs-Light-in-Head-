return {
  detect = function(Ax, Ay, Awidth, Aheight, Bx, By, Bwidth, Bheight)
    return (Ax <= Bx + Bwidth and Bx <= Ax + Awidth) and (Ay <= By + Bheight and By <= Ay + Aheight)
  end,
  detectPoint = function (Ax, Ay, Bx, By, Bwidth, Bheight)
    Ax = Ax or 0
    Ay = Ay or 0

    return (Ax <= Bx + Bwidth and Ax > Bx) and (Ay <= By + Bheight and Ay > By)
  end
}
