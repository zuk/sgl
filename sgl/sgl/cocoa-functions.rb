# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

module SGL
  # window functions
  def window(*a)	$__a__.window(*a);	end
  def close_window()	$__a__.close_window;	end
  def width()		$__a__.width;		end
  def height()		$__a__.height;		end

  # color functions
  def background(*a)	$__a__.background(*a);	end
  def backgroundHSV(*a)	$__a__.backgroundHSV(*a);	end
  def color(*a)		$__a__.color(*a);	end
  def colorHSV(*a)	$__a__.colorHSV(*a);	end

  # get status functions
  def mouseX()	$__a__.mouseX;	end
  def mouseY()	$__a__.mouseY;	end
  def mouseDown() $__a__.mouseDown;	end
  def keynum()	$__a__.keynum;	end

  # callback functions
  def setup()		end
  def onMouseDown(x,y)	end
  def onMouseUp(x,y)	end
  def onKeyDown(k)	end
  def onKeyUp(k)	end
  def display()		end

  # mainloop
  def mainloop
    $__a__.set_setup { setup }
    $__a__.set_mousedown {|x, y| onMouseDown(x, y) }
    $__a__.set_mouseup   {|x, y| onMouseUp(x, y) }
    $__a__.set_keydown   {|k| onKeyDown(k) }
    $__a__.set_keyup     {|k| onKeyUp(k) }
    $__a__.set_display { display }
    $__a__.mainloop
  end

  # create media object functions
  def movie(*a)	$__a__.movie(*a);	end
  def image(*a)	$__a__.image(*a);	end
  def font(*a)	$__a__.font(*a);	end
  def sound(*a)	$__a__.sound(*a);	end

  # draw functions
  def point(*a)	$__a__.point(*a);	end
  def lineWidth(*a)	$__a__.lineWidth(*a);	end
  def line(*a)	$__a__.line(*a);	end
  def rect(*a)	$__a__.rect(*a);	end
  def circle(*a)	$__a__.circle(*a);	end
  def rotateZ(*a)	$__a__.rotateZ(*a);	end
  def translate(*a)	$__a__.translate(*a);	end
  def scale(*a)	$__a__.scale(*a);	end
  def reset(*a)	$__a__.reset(*a);	end
end
