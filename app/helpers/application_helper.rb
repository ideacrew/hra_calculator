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

  def build_form_group(setting, input_group)
    id        = setting[:key].to_s
    label     = setting[:title] || id.titleize
    help_id   = id + 'HelpBlock'
    help_text = setting[:description]

    tag.div(class: "form-group") do
      tag.label(for: id, value: label) +
      input_group +
      tag.small(help_text, id: help_id, class: %w(form-text text-muted))
    end
  end

  def build_currency_input_group(setting)
    aria_label  = setting[:aria_label] || "Amount (to the nearest dollar)"
    input_value = setting[:value] || setting[:default]

    input_group = tag.div(
                    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
                    tag.input(nil, value: input_value, type: "text", class: "form-control", "aria-label": aria_label) +
                    tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append"),
                  class: "input-group"
                )
    build_form_group(setting, input_group)
  end

end

