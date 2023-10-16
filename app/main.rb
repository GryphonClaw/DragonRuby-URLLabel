require "app/url_label.rb"

def tick args
  args.outputs.labels << {
    x: 5, y: 720, text: "DragonRuby Version: #{$gtk.version}", size_enum: -3
  }

  args.state.url_label  ||= URLLabel.new(url: "https://www.gryphonclaw.net", text: "This is a test", title: "This is a title", size_enum: 0)
  args.state.url_label2 ||= URLLabel.new(url: "https://www.gryphonclaw.net", text: "This is a test", title: "", size_enum: 5)
  args.state.url_label3 ||= URLLabel.new(url: "https://www.gryphonclaw.net", text: "This is a test", title: "", size_enum: 8)

  my_label = args.state.url_label
  my_label.size_enum = 8
  my_label.x = 20
  my_label.y = 120
  # my_label.vertical_alignment_enum = 0

  my_label = args.state.url_label2
  my_label.size_enum = 5
  my_label.x = 20
  my_label.y = 200

  my_label = args.state.url_label3
  my_label.size_enum = 0
  my_label.x = 20
  my_label.y = 300

  args.state.url_label.tick(args)
  args.state.url_label2.tick(args)
  args.state.url_label3.tick(args)
  args.outputs.labels << args.state.url_label
  args.outputs.labels << args.state.url_label2
  args.outputs.labels << args.state.url_label3

  if args.inputs.keyboard.key_down.r
    $gtk.reset_next_tick
  end
end
