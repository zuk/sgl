* sgl - simple generic library

これは、Rubyから簡単にマルチメディアを扱えるようにするライブラリです。
現状では、Mac OS XのCocoa環境に対応してます。

芸術系の大学におけるプログラミング教育に特化しており、
できるだけ簡単にプログラミングの世界を体験できるようにしています。
また、実際のメディア・アート作品の制作を行えるような拡張性をそなえています。

* 必要環境

Mac OS X 10.2 (Jaguar), 10.3 (Panther)の環境で動作します。
OS X附属の ruby 1.6.7, 1.6.8で動作確認しています。
RubyCocoa 0.4.0, 0.4.1 が必要です。
ruby 1.8以降での動作確認はまだ行なっていませんが、
RubyCocoaが動作する環境であれば動作すると思われます。

* Mac OS Xにおけるinstall方法

~/sglに解凍したものと仮定します。

** 10.2の場合
 % cd ~/sgl
 % sudo mkdir -p /usr/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/lib/ruby/site_ruby/1.6

** 10.3の場合
 % cd ~/sgl
 % sudo mkdir -p /usr/local/lib/ruby/site_ruby/1.6
 % sudo mv sgl sgl.rb /usr/local/lib/ruby/site_ruby/1.6

* 動作確認

test1.rbとして，下記のプログラムを入力する．

 require "sgl"
 def setup
   window 100, 100
 end
 def display
   line 0, 0, 100, 100
 end
 mainloop

コマンドラインから下記のように入力し，windowが表示されるかどうかを確認する．

 % ruby test1.rb

これでinstallは完了です。
実際の使い方は、samples以下にあるサンプルコードをごらんください。
また、tests以下にあるテストコードも御参照ください。

* CVSによる入手

 % cvs -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik login
 % cvs -z3 -d:pserver:anonymous@cvs.sourceforge.jp:/cvsroot/qwik co sgl

* ライセンス

Ruby Licenseです。

* 作者

Kouichirou Eto <2005 at eto.com>
