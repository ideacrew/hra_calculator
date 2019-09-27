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

  def input_file_control(setting, form)
    id = setting[:key].to_s
    aria_describedby = id
    label = setting[:title] || id.titleize

    tag.div(tag.span('Upload', class: "input-group-text", id: id), class: "input-group-prepend") +
    tag.div(
      tag.input(nil, type: "file", id: id, class: "custom-file-input", aria: { describedby: aria_describedby }) +
      tag.label('Choose File', for: id, value: label, class: "custom-file-label"),
      class: "custom-file")
      # tag.label('Choose File', class: "input-group-text")
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

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end

  def input_text_control(setting, form)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "text", value: input_value, id: id, name: form.object_name + "[#{id}]",class: "form-control")
  end

  def input_color_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "color", value: input_value, id: id)
  end

  def input_swatch_control(setting, form)
    id = setting[:key].to_s
    color = setting[:value] || setting[:default]
    input_text_control(setting, form) +
    tag.div(tag.button(type: "button", id: id, class: "btn", value: "", style: "background-color: #{color}"), class: "input-group-append")
  end

  def input_currency_control(setting)
    id          = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_map    = { label: "Amount (to the nearest dollar)"}

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
    tag.input(nil, type: "text", value: input_value, id: id, class: "form-control", aria: aria_map) +
    tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append")
  end

  def input_radio_control(setting, input)
    input_value = setting[:value] || setting[:default]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
    tag.input(nil, type: "radio", "aria-label": aria_label) +
    tag.input(input_value, type: "text", class: "form-control", "aria-label": aria_label)
  end

  def build_attribute_field(form, attribute)
    setting = {
      key: attribute,
      default: form.object.send(attribute),
      type: :string
    }

    input_control = input_text_control(setting, form)
    form_group(setting, input_control)
  end

  def build_option_field(form, option)
    input_control = if option.type == :swatch
      input_swatch_control(option, form)
    elsif option.type == :base_64
      input_file_control(option, form)
    else
      input_text_control(option, form)
    end

    form_group(option, input_control)
  end

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, input_control)
    id          = setting[:key].to_s
    label       = setting[:title] || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting[:description]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) do
        label
      end +
      input_group { input_control } +
      tag.small(help_text, id: help_id, class: %w(form-text text-muted))
    end
  end

  def radio_form_group(setting, input_control)
    id          = setting[:key].to_s
    label       = setting[:title] || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting[:description]
    aria_label  = setting[:aria_label] || "Radio button for following text input"
    
    tag.div(
      tag.div(class: "input-group") do
        tag.label(for: id, value: label, aria: { label: aria_label }) +
        input_control + 
        tag.small(help_text, id: help_id, class: %w(form-text text-muted))
      end, class: 'form-group'
    )
  end
end

