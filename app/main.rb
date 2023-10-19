require "app/url_label.rb"

def tick args
  #this just shows the DragonRuby version.
  args.outputs.labels << {
    x: 5, y: 718, text: "DragonRuby Version: #{$gtk.version}", size_enum: -3
  }

  args.outputs.background_color = [128, 128, 128]
  args.state.url_label  ||= URLLabel.new(url: "https://www.gryphonclaw.net", text: "GryphonClaw Website", title: "This is a title", size_enum: 0)
  args.state.url_label2 ||= URLLabel.new(url: "https://www.dragonruby.org", text: "DragonRuby Website", title: "", size_enum: 5)
  args.state.url_label3 ||= URLLabel.new(url: "https://www.gryphonclaw.net", text: "This label shows the url because of blank title", title: "", size_enum: 8, alignment: {vertical: 2})

  #change some of the label settings
  my_label = args.state.url_label
  # my_label.size_enum = 0
  my_label.x = 20
  my_label.y = 100
  my_label.vertical_alignment_enum = 0

  my_label = args.state.url_label2
  my_label.size_enum = 5
  my_label.x = 20
  my_label.y = 200
  my_label.vertical_alignment_enum = 1

  my_label = args.state.url_label3
  my_label.size_enum = 0
  my_label.x = 20
  my_label.y = 300
  my_label.vertical_alignment_enum = 2

  #send processing to the labels
  # args.state.url_label.tick(args)
  # args.state.url_label2.tick(args)
  args.state.url_label3.tick(args)
  puts my_label.bounds
  #draw the labels
  # args.outputs.labels << args.state.url_label
  # args.outputs.labels << args.state.url_label2
  args.outputs.labels << args.state.url_label3

  if args.inputs.keyboard.key_down.r
    $gtk.reset_next_tick
  end
end
