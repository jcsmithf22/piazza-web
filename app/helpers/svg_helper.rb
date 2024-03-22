module SvgHelper
  def svg(svg_name, **attributes)
    svg_markup =
      render file: "#{Rails.root}/app/views/application/svg/#{svg_name}.svg"

    xml = Nokogiri.XML(svg_markup)
    attributes&.each { |key, value| xml.root.set_attribute(key, value) }

    xml.root.to_xml.html_safe
  end
end
