require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# ���g����̔z���p�ӂ���D
  for a in 0..10	# �z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��D
    $pos[a] = 0		# ���g�ɑS��0�����Ă����D
  end
  $index = 0		# ���ݔz��̂ǂ��̕������w���Ă��邩�������ϐ��D
end

def display
  $pos[$index] = mouseX # �z���$index�̎����Ƃ���Ƀ}�E�X��x���W������D

  for a in 0..10	# �z��̗v�f���ꂼ��ɂ��ČJ��Ԃ��D
    x = $pos[a]
    color 0
    line x, -100, x, 100 # �c����`���D
  end

  $index = $index + 1	# ���݂�����$index�����̒l�̂Ƃ���ɃZ�b�g����D
  if 10 < $index	# $index���z��̑傫�����z������0�ɃZ�b�g����D
    $index = 0
  end

  p $pos		# $pos�Ƃ����z��̒��g��\������D
end

mainloop
