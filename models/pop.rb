require "open-uri"

O = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten

class Pop
  def initialize(url)
    @img = Magick::ImageList.new
    @img.from_blob(open(url).read)
    @row = @img.rows
    @col = @img.columns
    @ilg = Magick::ImageList.new
    @prefix = (0...10).map { O[rand(O.length)] }.join
    @y=0
  end

  def col
    @col
  end

  def img
    @img
  end

  def y
    @y
  end

  def increment
    @y += 1
  end

  def fname
    @current_fname
  end

  def write_to_file
    @current_fname = @prefix + @y.to_s + ".jpg"
    @ilg.append(true).write("public/" + @current_fname)
  end

  def add_il(il)
    @ilg.push(il.append(false))
  end

end
