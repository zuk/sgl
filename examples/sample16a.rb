require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# 中身が空の配列を用意する．
end

def display
  x = mouseX
  y = mouseY

  $pos << [x, y]	# 配列に現在のマウスの位置を追加する．

  $pos.each {|pos|	# 配列の各々の要素について{}の中身を実行する．
			# その各々の要素はposという変数に入る．
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

  if 10 < $pos.length	# もし配列がたまりすぎた場合は先頭から順に捨てる．
    $pos.shift
  end
end

mainloop
