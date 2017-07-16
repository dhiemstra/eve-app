module EveApp::TypeCardHelper
  def type_card(type, size=:medium, options={})
    # locals = { type: type, size: size, link_url: nil, clipboard: nil, description: nil }.merge(options)
    # render partial: 'shared/type_card', locals: locals
    content_tag(:div, class: "media type-card type-card-#{size}") do
      [
        image_tag(type.image, class: "d-flex mr-3"),
        content_tag(:div, class: "media-body") do
          [
            content_tag(:h6, type.name),
            content_tag(:div, 'description', class: 'text-sm text-muted')
          ].join("\n")
        end
      ].join("\n")
    end.html_safe
  end
end
