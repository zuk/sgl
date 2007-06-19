require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $xpos = []             #中身が空の配列を、x座標、y座標について用意します。
  $ypos = []
  for a in 0..20        #配列の要素それぞれについて繰り返します。
    $xpos[a] = 0
    $ypos[a] = 0
  end
  $index = 0            #現在配列のどこの部分を指しているかを示す変数です。
end

def display
  $xpos[$index] = mouseX  # 添字
  $ypos[$index] = mouseY

  for a in 0..20        #配列の要素それぞれについて繰り返します。
    x = $xpos[a]
    y = $ypos[a]
    colorHSV 0, 100, 100, 20
    circle x, y, 50, POLYGON
  end

  $index = $index + 1   #現在を示す$indexを、次の値のところにセットします。
  if 20 < $index        #$indexが配列の大きさを越えてしまったら、0にセットしなおします。
    $index = 0
  end

  p $xpos
  p $ypos
end

mainloop
