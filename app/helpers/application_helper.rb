module ApplicationHelper  

  def select_dropdown(input_id, list)
    return unless list.is_a? Array
    content_tag(:select, class: "form-control", id: input_id, name: 'admin[' + input_id.to_s + ']') do
      concat(content_tag :option, "Select", value: "")
      list.each do |item|
        if item.is_a? Array
          concat(content_tag :option, item[0], value: item[1])
        elsif item.is_a? Hash
          concat(content_tag :option, item.first[1], value: item.first[0])
        else
          concat(content_tag :option, item.humanize, value: item)
        end
      end
    end
  end

  def build_select_group(setting)
    tag.select()
  # <div class="form-group">
  #   <label for="exampleFormControlSelect1">Example select</label>
  #   <select class="form-control" id="exampleFormControlSelect1">
  #     <option>1</option>
  #     <option>2</option>
  #     <option>3</option>
  #     <option>4</option>
  #     <option>5</option>
  #   </select>
  # </div>

  end

  def build_radio_input(setting)
    aria_label  = setting[:aria_label] || "Radio button for following text input"
    input_value = setting[:value] || setting[:default]

    input_group = tag.div(
      tag.div(
        tag.div((radio_button_tag setting.first[0].to_s, false),
          class: 'input-group-text'
        ),
        class: 'input-group-prepend'
      ) + tag.div(setting.first[1], class: 'form-control') ,
      class: 'input-group'
    )
    # build_form_group(setting, input_group)
  end

  def base64
  end


  def 

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end

  def input_text_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_describedby = id

    tag.input(nil, type: "text", value: input_value, id: id, class: "form-control", aria: { describedby: aria_describedby })
  end

  def input_file_control(setting)
    id = setting[:key].to_sz
    aria_describedby = id
    label = setting[:title] || id.titleize

    tag.div(tag.span('Upload', class: "input-group-text", id: id), class: "input-group-prepend") +
    tag.div(
      tag.input(nil, type: "file", value: input_value, id: id, class: "custom-file-input", aria: { describedby: aria_describedby }) +
      tag.label(for: id, value: label, class: "custom-file-label", aria: { label: aria_label }),
      class: "custom-file")
    tag.div(tag.span('Choose File', class: "input-group-text"), class: "input-group-append")
  end

  def input_color_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "color", value: input_value, id: id)
  end
 
  def input_swatch_control(setting)
    id = setting[:key].to_s
    color = setting[:value] || setting[:default]

    input_text_control(setting) +
    tag.div(tag.button(type: "button", id: id, class: "btn btn-outline-secondary", value: ""), class: "input-group-append")
  end

  def input_currency_control(setting)
    id          = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_map    = { label: "Amount (to the nearest dollar)"}

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
    tag.input(nil, type: "text", value: input_value, id: id, class: "form-control", aria: { map: aria_map }) +
    tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append")
  end

  def input_radio_control(setting, input)
    input_value = setting[:value] || setting[:default]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
    tag.input(nil, type: "radio") +
    tag.input(input_value, type: "text", class: "form-control", aria: {label: aria_label })
  end

  def build_form_group(controls)

  end

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, control)
    id          = setting[:key].to_s
    label       = setting[:title] || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting[:description]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) +
      control +
      tag.small(help_text, id: help_id, class: %w(form-text text-muted))
    end
  end


  def radio_form_group(setting, control)
    id          = setting[:key].to_s
    label       = setting[:title] || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting[:description]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) +
      control + 
      tag.small(help_text, id: help_id, class: %w(form-text text-muted))
    end
  end

end

