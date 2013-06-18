module ApplicationHelper
  def render_field_value value=nil
    value = [value] unless value.is_a? Array
    value = value.collect { |x| x.respond_to?(:force_encoding) ? x.force_encoding("UTF-8") : x}
    return value.collect { |x|
      if x.to_s.strip == ''
        '&nbsp;'
      else
        html_escape x
      end
    }.join(field_value_separator).html_safe
  end
end
