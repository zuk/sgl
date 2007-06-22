require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# 中身が空の配列を用意する．
  for a in 0..10	# 配列の要素それぞれについて繰り返す．
    $pos[a] = 0		# 中身に全部0を入れておく．
  end
  $index = 0		# 現在配列のどこの部分を指しているかを示す変数．
end

def display
  $pos[$index] = mouseX # 配列の$indexの示すところにマウスのx座標を入れる．

  for a in 0..10	# 配列の要素それぞれについて繰り返す．
    x = $pos[a]
    color 0
    line x, -100, x, 100 # 縦線を描く．
  end

  $index = $index + 1	# 現在を示す$indexを次の値のところにセットする．
  if 10 < $index	# $indexが配列の大きさを越えたら0にセットする．
    $index = 0
  end

  p $pos		# $posという配列の中身を表示する．
end

mainloop
