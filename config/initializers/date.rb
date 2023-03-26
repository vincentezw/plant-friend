# frozen_string_literal: true

# require 'Date'

# This is a monkey patch to the Date class
class Date
  def season
    # TODO: not good for southern hemisphere
    day_hash = month * 100 + mday
    case day_hash
    when 101..401 then :winter
    when 402..630 then :spring
    when 701..930 then :summer
    when 1001..1231 then :fall
    end
  end
end
