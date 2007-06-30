require File.dirname(__FILE__) + '/spec_helper.rb'
require 'sgl'

describe SGL do
  it "should return" do
    t = SGL::ColorTranslatorRGB.new(100, 100, 100, 100)
    t.norm(100, 100, 100).should == [1.0, 1.0, 1.0, 1.0]
    t.norm(100, 0, 0).should == [1.0, 0.0, 0.0, 1.0]

    t = SGL::ColorTranslatorHSV.new(100, 100, 100, 100)
    t.norm(100, 100, 100).should == [1.0, 0.0, 0.0, 1.0]
  end
end
