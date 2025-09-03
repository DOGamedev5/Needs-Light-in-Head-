return {
  detect = function(Ax, Ay, Awidth, Aheight, Bx, By, Bwidth, Bheight)
    return (Ax <= Bx + Bwidth and Bx <= Ax + Awidth) and (Ay <= By + Bheight and By <= Ay + Aheight)
  end,
}
