class URLLabel
  attr_accessor :x, :y, :text, :size_enum, :alignment_enum, :vertical_alignment_enum, :blendmode_enum
  attr_accessor :r, :g, :b, :a
  attr_accessor :font, :size_px, :anchor_x, :anchor_y

  @@white_color = {r: 255, g: 255, b: 255}
  @@black_color = {r: 0, g: 0, b: 0}
  @@tooltip_bg_color = {r: 255, g: 255, b: 202}

  def initialize(position: {x: 0, y: 58}, url: "", text: "", title: "", underline: false, colors: {hover: {}, normal: {}, visited: {}}, font: "", size_enum: 0, alignment: {vertical: 2, horizontal: 0})
    @x = position.x
    @y = position.y
    @text = text
    @font = font
    @size_enum = size_enum
    @size_px = size_enum_to_px()
    if !title.empty?
      @title = title
    else
      @title = url
    end

    @title_display_delay = 120

    @url = url

    @bounds_size = {w: 0, h: 0}
    @bounds_size.w, @bounds_size.h = $gtk.calcstringbox(@text, @size_enum, @font)

    @vertical_alignment_enum = alignment.vertical
    @alignment_enum = alignment.horizontal

    @last_hover_time = 0
    @show_title = false
    @last_mouse_position = {x: 0, y: 0}

    @bounds_offset = {x: 0, y: 0}
    calc_bounds()
    calc_vertical_offset()
  end

  def size_enum=(new_value)
    #dont do any calulations if the value is the same as what we have cached
    # return if @size_enum == new_value
    @size_enum = new_value
    #@bounds_size.w, @bounds_size.h = $gtk.calcstringbox(@text, @size_enum, @font)
    # puts "size enum changed, recalculate bounds and offset"

    calc_bounds()
    calc_vertical_offset()
  end

  def vertical_alignment_enum=(new_value)
    #dont do any calulations if the value is the same as what we have cached
    # return if @vertical_alignment_enum == new_value
    @vertical_alignment_enum = new_value

    # puts "vertical alignment changed, recalculate bounds and offset"
    calc_bounds()
    calc_vertical_offset()
  end

  def bounds
    #ideally @bounds_size gets recalculated anytime any of the following properties are modified:
    #size_enum, size_px
    #vertical_alignment_enum, alignment_enum
    #font, anchor_x, anchor_y
    {x: (@x + @bounds_offset.x), y: (@y + @bounds_offset.y), **@bounds_size}
  end

  def tick(args)
    cursor = "arrow"
    if args.inputs.mouse.inside_rect?(bounds)
      cursor = "hand"
      @r = 255
      if (args.tick_count - @last_hover_time > @title_display_delay) && !@title.empty?
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
      @show_title = false
    end

    if @show_title
      if @last_mouse_position.x != args.inputs.mouse.position.x ||  @last_mouse_position.y != args.inputs.mouse.position.y
        @show_title = false
      end

      #tooltip / title
      args.outputs.primitives << tooltip(args)

    end
    #for debugging show the bounds as a border
    args.outputs.borders << bounds
  end

  def size_enum_to_px
    (22 + (@size_enum * 2))
  end

  def size_px_to_enum
    size_px = size_enum_to_px()
    (size_px / 22)
  end

  def calc_bounds()
    # puts @size_enum
    @bounds_size.w, @bounds_size.h = $gtk.calcstringbox(@text, @size_enum, @font)
  end

  def calc_vertical_offset()
    ## 0 is bottom, 1 is middle, 2 is top
    case @vertical_alignment_enum
    when 0
      @bounds_offset.y = 0
    when 1
      @bounds_offset.y = -(@bounds_size.h / 2)
    else
      @bounds_offset.y = -@bounds_size.h #size_enum_to_px()
    end
  end

  def tooltip(args)
    x_pos = @x - 3
    y_pos = @y + 3
    tooltip_size = {w: 0, h: 0}
    tooltip_size.w, tooltip_size.h = args.gtk.calcstringbox(@title, -3, "")
    text_y_pos = (@y + bounds.h) - (tooltip_size.h / 2)
    [
      {x: x_pos, y: y_pos, w: tooltip_size.w + 6, h: tooltip_size.h + 6, primitive_marker: :solid}.merge(@@tooltip_bg_color),
      {x: x_pos, y: y_pos, w: tooltip_size.w + 6, h: tooltip_size.h + 6, primitive_marker: :border}.merge(@@black_color),
      #white lines to 
      {x: x_pos, y:  (y_pos + tooltip_size.h) + 3, x2: (@x + tooltip_size.w) + 1, y2: (y_pos + tooltip_size.h) + 3, primitive_marker: :line}.merge(@@white_color),
      {x: x_pos, y:  (y_pos - 2), x2: (@x - 3), y2: (y_pos + tooltip_size.h) + 3, primitive_marker: :line}.merge(@@white_color),
      {x: x_pos + 3, y: text_y_pos, text: @title, vertical_alignment_enum: 2,size_enum: -3, primitive_marker: :label}
    ]
  end
  def primitive_marker
    :label
  end

  def serialize
    {x: @x + @bounds_offset.x, y: @y + @bounds_offset.y, x_pos: @x, y_pos: @y, text: @text, vertical_alignment_enum: @vertical_alignment_enum, size_enum: @size_enum, size_px: @size_px, primitive_marker: primitive_marker, bounds_offset: @bounds_offset, url: @url, title: @title }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end