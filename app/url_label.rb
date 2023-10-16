class URLLabel
  attr_accessor :x, :y, :text, :size_enum, :alignment_enum, :vertical_alignment_enum, :blendmode_enum
  attr_accessor :r, :g, :b, :a
  attr_accessor :font, :size_px, :anchor_x, :anchor_y

  def initialize(position: {x: 0, y: 58}, url: "", text: "", title: "", underline: false, colors: {hover: {}, normal: {}, visited: {}}, font: "", size_enum: 0)
    @x = position.x
    @y = position.y
    @text = text
    @font = font
    @size_enum = size_enum

    if !title.empty?
      @title = title
    else
      @title = url
    end

    @url = url

    @bounds_size = {w: 0, h: 0}
    @bounds_size.w, @bounds_size.h = $gtk.calcstringbox(@text, @size_enum, @font)

    @vertical_alignment_enum = 2

    @last_hover_time = 0
    @show_title = false
    @last_mouse_position = {x: 0, y: 0}
  end

  def size_enum=(new_value)
    #dont do any calulations if the value is the same as what we have cached
    return if @size_enum == new_value
    @size_enum = new_value
    @bounds_size.w, @bounds_size.h = $gtk.calcstringbox(@text, @size_enum, @font)
  end

  def bounds
    #ideally @bounds_size gets recalculated anytime any of the following properties are modified:
    #size_enum, size_px
    #vertical_alignment_enum, alignment_enum
    #font, anchor_x, anchor_y
    {x: @x, y: @y - @bounds_size.h, **@bounds_size}
  end

  def tick(args)
    cursor = "arrow"
    if args.inputs.mouse.inside_rect?(bounds)
      cursor = "hand"
      @r = 255
      if (args.tick_count - @last_hover_time > 120) && !@title.empty?
        @last_hover_time = args.tick_count

        @show_title = true
        if @last_mouse_position.x != args.inputs.mouse.position.x ||  @last_mouse_position.y != args.inputs.mouse.position.y
          @last_mouse_position = args.inputs.mouse.position.copy
        end
      end

      #the thickness of the line here should be calculated based on the size_enum or size_px
      #currently just set to height of 3
      args.outputs.solids << bounds.merge(r: @r).merge(h: 3)

      if args.inputs.mouse.click
        args.gtk.openurl @url
      end
      args.gtk.set_system_cursor(cursor)
      
    else
      args.gtk.set_system_cursor(cursor)
      @r = 0
    end

    if @show_title
      if @last_mouse_position.x != args.inputs.mouse.position.x ||  @last_mouse_position.y != args.inputs.mouse.position.y
        @show_title = false
      end

      args.outputs.labels << {
        x: @x, y: @y + bounds.h, text: @title
      }
    end

  end

  def primitive_marker
    :label
  end

  def serialize
    {x: @x, y: @y, text: @text }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end