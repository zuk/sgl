* sgl - simple generic library

����́ARuby����ȒP�Ƀ}���`���f�B�A��������悤�ɂ��郉�C�u�����ł��B
����ł́AMac OS X��Cocoa���ɑΉ����Ă܂��B

�|�p�n�̑�w�ɂ�����v���O���~���O����ɓ������Ă���A
�ł��邾���ȒP�Ƀv���O���~���O�̐��E��̌��ł���悤�ɂ��Ă��܂��B
�܂��A���ۂ̃��f�B�A�E�A�[�g��i�̐�����s����悤�Ȋg���������Ȃ��Ă��܂��B

* �K�v��

Mac OS X 10.2 (Jaguar), 10.3 (Panther)�̊��œ��삵�܂��B
OS X������ ruby 1.6.7, 1.6.8�œ���m�F���Ă��܂��B
RubyCocoa 0.4.0, 0.4.1 ���K�v�ł��B
ruby 1.8�ȍ~�ł̓���m�F�͂܂��s�Ȃ��Ă��܂��񂪁A
RubyCocoa�����삷����ł���Γ��삷��Ǝv���܂��B

* Mac OS X�ɂ�����install���@

~/sgl�ɉ𓀂������̂Ɖ��肵�܂��B

** 10.2�̏ꍇ
 % cd ~/sgl
 % sudo mkdir -p /usr/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/lib/ruby/site_ruby/1.6

** 10.3�̏ꍇ
 % cd ~/sgl
 % sudo mkdir -p /usr/local/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/local/lib/ruby/site_ruby/1.6

* ����m�F

test1.rb�Ƃ��āC���L�̃v���O��������͂���D

 require "sgl"
 def setup
   window 100, 100
 end
 def display
   line 0, 0, 100, 100
 end
 mainloop

�R�}���h���C�����牺�L�̂悤�ɓ��͂��Cwindow���\������邩�ǂ������m�F����D

 % ruby test1.rb

�����install�͊����ł��B
���ۂ̎g�����́Asamples�ȉ��ɂ���T���v���R�[�h������񂭂������B
�܂��Atests�ȉ��ɂ���e�X�g�R�[�h����Q�Ƃ��������B

* CVS�ɂ�����

 % cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik login
 % cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik co sgl

* ���C�Z���X

Ruby License�ł��B

* ���

Kouichirou Eto <2005 at eto.com>
