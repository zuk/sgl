require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []             #中身が空の配列を用意します。
  for a in 0..10        #配列の要素それぞれについて繰り返します
    $pos[a] = 0         #中身に全部0を入れておきます。
  end
  $index = 0            #現在配列のどこの部分を指しているかを示す変数です
end

def display
  $pos[$index] = mouseX #配列の$indexの示すところに現在のマウスのx座標を入れます。

  for a in 0..10        #配列の要素それぞれについて繰り返します
    x = $pos[a]
    color 0
    line x, -100, x, 100 #縦線を描きます。
  end

  $index = $index + 1   #現在を示す$indexを、次の値のところにセットします。
  if 10 < $index  # $indexが配列の大きさを越えてしまったら、0にセットしなおします
    $index = 0
  end

  p $pos        #この行で、$posという配列の中身がどうなっているかを表示しています
end

mainloop
