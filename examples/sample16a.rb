require "sgl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# ���g����̔z���p�ӂ���D
end

def display
  x = mouseX
  y = mouseY

  $pos << [x, y]	# �z��Ɍ��݂̃}�E�X�̈ʒu��ǉ�����D

  $pos.each {|pos|	# �z��̊e�X�̗v�f�ɂ���{}�̒��g�����s����D
			# ���̊e�X�̗v�f��pos�Ƃ����ϐ��ɓ���D
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

  if 10 < $pos.length	# �����z�񂪂��܂肷�����ꍇ�͐擪���珇�Ɏ̂Ă�D
    $pos.shift
  end
end

mainloop
