# Copyright (C) 2004-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

# only for Ruby 1.6
if /\A1\.6/ =~ RUBY_VERSION
  class Array
    def fetch(n)
      a = self[n]
      if a.nil?
	a = yield
      end
      a
    end
  end

  module Enumerable
    def sort_by
      self.collect {|i| [yield(i), i]}.
	sort {|a,b| a[0] <=> b[0]}.
	collect! {|i| i[1]}
    end
  end

  alias org_exit exit
  def exit(n)
    n = 0 if n == true
    n = 1 if n == false
    org_exit(n)
  end
end
