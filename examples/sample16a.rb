require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# 中身が空の配列を用意します。
end

def display
  x = mouseX
  y = mouseY

  $pos << [x, y]	# 配列に、現在のマウスの位置を追加します。

  $pos.each {|pos|	# 配列の各々の要素について、{}の中身を実行します。
			# その各々の要素は、posという変数に入ります。
    x = pos[0]
    y = pos[1]

    push
    colorHSV 0, 100, 100, 10
    translate x, y, 0
    rotateX x
    rotateY y
    scale 20
    rect -5, -5, 5, 5
    pop
  }

  if 10 < $pos.length	# もし配列がたまりすぎた場合は、先頭から順に捨てる。
    $pos.shift
  end
end

mainloop
