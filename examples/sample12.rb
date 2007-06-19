require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []             #���g����̔z���p�ӂ��܂��B
  for a in 0..10        #�z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��܂�
    $pos[a] = 0         #���g�ɑS��0�����Ă����܂��B
  end
  $index = 0            #���ݔz��̂ǂ��̕������w���Ă��邩�������ϐ��ł�
end

def display
  $pos[$index] = mouseX #�z���$index�̎����Ƃ���Ɍ��݂̃}�E�X��x���W�����܂��B

  for a in 0..10        #�z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��܂�
    x = $pos[a]
    color 0
    line x, -100, x, 100 #�c����`���܂��B
  end

  $index = $index + 1   #���݂�����$index���A���̒l�̂Ƃ���ɃZ�b�g���܂��B
  if 10 < $index  # $index���z��̑傫�����z���Ă��܂�����A0�ɃZ�b�g���Ȃ����܂�
    $index = 0
  end

  p $pos        #���̍s�ŁA$pos�Ƃ����z��̒��g���ǂ��Ȃ��Ă��邩��\�����Ă��܂�
end

mainloop
