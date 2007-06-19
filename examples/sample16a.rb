require "sgl/opengl"

def setup
  window -200, -200, 200, 200
  background 100
  $pos = []		# ���g����̔z���p�ӂ��܂��B
end

def display
  x = mouseX
  y = mouseY

  $pos << [x, y]	# �z��ɁA���݂̃}�E�X�̈ʒu��ǉ����܂��B

  $pos.each {|pos|	# �z��̊e�X�̗v�f�ɂ��āA{}�̒��g�����s���܂��B
			# ���̊e�X�̗v�f�́Apos�Ƃ����ϐ��ɓ���܂��B
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

  if 10 < $pos.length	# �����z�񂪂��܂肷�����ꍇ�́A�擪���珇�Ɏ̂Ă�B
    $pos.shift
  end
end

mainloop
