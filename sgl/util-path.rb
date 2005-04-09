# Copyright (C) 2004-2005 Kouichirou Eto, All rights reserved.

require "pathname"

class String
  def path
    Pathname.new(self)
  end
end
