module EveApp::OutputHelper
  def isk(number, force_negative=false, round=true)
    if number
      number = BigDecimal.new(number) if number.is_a?(String)
      number = number / 100.0
      precision = round ? 0 : 2
      number = -number if force_negative
      negative = number < 0
      isk = number_to_currency(number, unit: 'ISK', separator: '.', delimiter: ',', format: "%n %u", precision: precision)
      content_tag(:span, isk, class: "isk #{negative ? 'text-danger' : ''}")
    else
      '-'
    end
  end

  def number(value)
    number_with_delimiter value
  end

  def percentage(value)
    return '-' unless value
    value = BigDecimal.new(value) if value.is_a?(String)
    value.round(1).to_s + "%"
  end
end
