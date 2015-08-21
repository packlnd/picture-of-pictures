require "open-uri"

class Pop
  def initialize(url)
    @img = Magick::ImageList.new
    @img.from_blob(open(url).read)
    @row = @img.rows
    @col = @img.columns
    @ilg = Magick::ImageList.new
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

  def increment_y
    @y += 1
  end

  def write_to_file
    @ilg.append(true).write("public/out.jpg")
  end

  def add_il(il)
    @ilg.push(il.append(false))
  end

end
