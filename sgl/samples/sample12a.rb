require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $xpos = []             #���g����̔z����Ax���W�Ay���W�ɂ��ėp�ӂ��܂��B
  $ypos = []
  for a in 0..20        #�z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��܂��B
    $xpos[a] = 0
    $ypos[a] = 0
  end
  $index = 0            #���ݔz��̂ǂ��̕������w���Ă��邩�������ϐ��ł��B
end

def display
  $xpos[$index] = mouseX  # �Y��
  $ypos[$index] = mouseY

  for a in 0..20        #�z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��܂��B
    x = $xpos[a]
    y = $ypos[a]
    colorHSV 0, 100, 100, 20
    circle x, y, 50, POLYGON
  end

  $index = $index + 1   #���݂�����$index���A���̒l�̂Ƃ���ɃZ�b�g���܂��B
  if 20 < $index        #$index���z��̑傫�����z���Ă��܂�����A0�ɃZ�b�g���Ȃ����܂��B
    $index = 0
  end

  p $xpos
  p $ypos
end

mainloop
