module EveApp::EntityHelper
  def entity(record, size: :medium, description: nil, link_url: nil)
    title = link_url ? link_to(record.name, link_url) : record.name
    body = [
      content_tag(:h6, title.html_safe),
      content_tag(:div, description || record.try(:description), class: 'text-sm text-muted')
    ].join("\n").html_safe
    wrapper = [
      image_tag(record.image),
      content_tag(:div, body, class: "media-body")
    ].join("\n").html_safe

    raw content_tag(:div, wrapper, class: "media media-entity #{size}")
  end
end
