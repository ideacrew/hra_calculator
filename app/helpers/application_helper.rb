module ApplicationHelper

  def render_flash
    rendered = []
    flash.each do |type, messages|
      if messages.respond_to?(:each)
        messages.each do |m|
          rendered << render(:partial => 'layouts/flash', :locals => {:type => type, :message => m}) unless m.blank?
        end
      else
        rendered << render(:partial => 'layouts/flash', :locals => {:type => type, :message => messages}) unless messages.blank?
      end
    end
    rendered.join('').html_safe
  end

  def menu_tab_class(a_tab, current_tab)
    (a_tab == current_tab) ? raw(" class=\"active\"") : ""
  end

  def select_control(setting)
    id = setting[:key].to_s
    selected_option = "Choose..."
    options = setting[:options]
    aria_describedby = id

    option_list = tag.option(selected_option, selected: true)
    options.each do |option|
      option_list += '\n ' + tag.option(option.values.first)
    end

    tag.select(option_list, id: id, class: "form-control")
  end

  def select_dropdown(input_id, list)
    return unless list.is_a? Array
    content_tag(:select, class: "form-control", id: input_id, name: 'admin[' + input_id.to_s + ']', required: true) do
      concat(content_tag :option, "Select", value: "")
      list.each do |item|
        if item.is_a? Array
          concat(content_tag :option, item[0], value: item[1])
        elsif item.is_a? Hash
          concat(content_tag :option, item.first[1], value: item.first[0])
        elsif input_id == 'state'
          concat(content_tag :option, item.to_s.titleize, value: item)
        else
          concat(content_tag :option, item.to_s.humanize, value: item)
        end
      end
    end
  end

  def input_import_control(setting, form)
    id = setting[:key].to_s
    aria_describedby = id
    label = setting[:title] || id.titleize

    tag.div(tag.span('Upload', class: "input-group-text", id: id), class: "input-group-prepend") +
    tag.div(
      tag.input(nil, type: "file", id: id, name: id + "[value]", class: "custom-file-input", aria: { describedby: aria_describedby }) +
      tag.label('Choose File', for: id, value: label, class: "custom-file-label"),
      class: "custom-file")
  end

  def input_file_control(setting, form)
    id = setting[:key].to_s
    aria_describedby = id
    label = setting[:title] || id.titleize

    preview = if setting.value.present?
      tag.img(class: 'w-100', src: "data:#{setting.content_type};base64,#{setting.value}")
    else
      tag.span('No logo')
    end

    input = tag.div(tag.span('Upload', class: "input-group-text", id: id) +
    tag.div(
      tag.input(nil, type: "file", id: id, name: form.object_name + "[value]", class: "custom-file-input", aria: { describedby: aria_describedby }) +
      tag.label('Choose File', for: id, value: label, class: "custom-file-label"),
      class: "custom-file"),class: "input-group-prepend")
      # tag.label('Choose File', class: "input-group-text")
    tag.div(tag.div(preview, class: 'col-2') + tag.div(input, class: 'col'), class: 'row')
  end

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end

  def input_text_control(setting, form)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_describedby = id

    if setting[:attribute]
      tag.input(nil, type: "text", value: input_value, id: id, name: form.object_name.to_s + "[#{id}]",class: "form-control", required: true)
    else
      tag.input(nil, type: "text", value: input_value, id: id, name: form.object_name.to_s + "[value]",class: "form-control", required: true)
    end
  end

  def input_number_control(setting, form)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_describedby = id

    if setting[:attribute]
      tag.input(nil, type: "number", step:"any", min: 0, max: 1, value: input_value, id: id, name: form.object_name.to_s + "[#{id}]",class: "form-control", required: true)
    else
      tag.input(nil, type: "number", step:"any", min: 0, max: 1, value: input_value, id: id, name: form.object_name.to_s + "[value]",class: "form-control", required: true)
    end
  end


  def input_color_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "color", value: input_value, id: id)
  end

  def input_swatch_control(setting, form)
    id = setting[:key].to_s
    color = setting[:value] || setting[:default]

    tag.input(nil, type: "text", value: color, id: id, name: form.object_name + "[value]",class: "js-color-swatch form-control") +
    tag.div(tag.button(type: "button", id: id, class: "btn", value: "", style: "background-color: #{color}"), class: "input-group-append")
  end

  def input_currency_control(setting)
    id          = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_map    = { label: "Amount (to the nearest dollar)"}

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
    tag.input(nil, type: "text", value: input_value, id: id, class: "form-control", aria: { map: aria_map }) +
    tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append")
  end

  def input_radio_control(setting, form)
    name        = setting[:key].to_s
    input_value = setting[:value] || setting[:default]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    setting.choices.collect do |choice|
      input_group do
        tag.div(tag.div(tag.input(nil, type: "radio", name: form.object_name + "[value]", value: choice.first[0], checked: input_value == choice.first[0].to_s, required: true), class: "input-group-text"), class: "input-group-prepend") +
        tag.input(nil, type: "text", placeholder: choice.first[1], class: "form-control", aria: {label: aria_label })
      end
    end.join('').html_safe
  end

  def build_attribute_field(form, attribute)
    setting = {
      key: attribute,
      default: form.object.send(attribute),
      type: :string,
      attribute: true
    }

    input_control = input_text_control(setting, form)
    form_group(setting, input_control)
  end

  def build_option_field(form, option)
    input_control = case option.type
    when :swatch
      input_swatch_control(option, form)
    when :base_64
      input_file_control(option, form)
    when :radio_select
      input_radio_control(option, form)
    else
      input_text_control(option, form)
    end

    if option.type == :radio_select
      radio_form_group(option, input_control)
    else
      form_group(option, input_control)
    end
  end

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, control)
    id          = setting[:key].to_s
    label       = setting[:title] || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting[:description]
    aria_label  = setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) do
        label
      end +
      input_group { control } +
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
      tag.label(for: id, value: label, aria: { label: aria_label }) do
        label
      end +
      control +
      tag.small(help_text, id: help_id, class: %w(form-text text-muted))
    end
  end

  def resource_name
    :account
  end

  def resource
    @resource ||= Account.new
  end

  def thead(headers, options={})
     tag.thead(class: options[:class_name]) do
      tag.tr do
        headers.collect {|item| concat(tag.th(item))}
      end
    end
  end

  def trow(row, options={})
    tag.tr do
      row.collect {|item| concat(tag.td(item))}
    end
  end

  def render_flash
    rendered = []
    flash.each do |type, messages|
      if messages.respond_to?(:each)
        messages.each do |m|
          rendered << render(:partial => 'layouts/flash', :locals => {:type => type, :message => m}) unless m.blank?
        end
      else
        rendered << render(:partial => 'layouts/flash', :locals => {:type => type, :message => messages}) unless messages.blank?
      end
    end
    rendered.join('').html_safe
  end
end

