require 'sgl'
useSound	# soundを使うことを宣言する．
sound = loadSound('sine.ogg')	# サンプル音をファイルから読みこむ．
		# ここではWindowsが標準で用意するサンプル音を使っている．
sound.play	# サンプル音を再生する．
sleep 1		# プログラムがすぐ終了するのをふせぐために待つ．
