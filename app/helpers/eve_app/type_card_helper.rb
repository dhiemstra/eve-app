module EveApp::TypeCardHelper
  def type_card(type, size=:medium, options={})
    # locals = { type: type, size: size, link_url: nil, clipboard: nil, description: nil }.merge(options)
    # render partial: 'shared/type_card', locals: locals

    body = [
      content_tag(:h6, type.name),
      content_tag(:div, type.description, class: 'text-sm text-muted')
    ].join("\n").html_safe
    wrapper = [
      image_tag(type.image),
      content_tag(:div, body, class: "media-body")
    ].join("\n").html_safe

    raw content_tag(:div, wrapper, class: "media type-card #{size}")
  end
end
