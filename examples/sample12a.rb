require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $xpos = []		# ���g����̔z���x���W�Cy���W�ɂ��ėp�ӂ���D
  $ypos = []
  for a in 0..20	# �z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��D
    $xpos[a] = 0
    $ypos[a] = 0
  end
  $index = 0		# ���ݔz��̂ǂ��̕������w���Ă��邩�������D
end

def display
  $xpos[$index] = mouseX	# �Y��
  $ypos[$index] = mouseY

  for a in 0..20	# �z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��D
    x = $xpos[a]
    y = $ypos[a]
    colorHSV 0, 100, 100, 20
    circle x, y, 50, POLYGON
  end

  $index = $index + 1	# ���݂�����$index�����̒l�̂Ƃ���ɃZ�b�g����D
  if 20 < $index	# $index���z��̑傫�����z������0�ɃZ�b�g����
    $index = 0
  end

  p $xpos
  p $ypos
end

mainloop
