# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  # http://www.ruby-forum.com/topic/123693
  def first_x_words(str, n=20, finish='&hellip;')
    str[0,n].sub(/ ?\S*$/,'') + finish    
  end
  
  # http://codesnippets.joyent.com/posts/show/1812
  # takes a number and options hash and outputs a string in any currency format
  def currencify(number, options={})
    # :currency_before => false puts the currency symbol after the number
    # default format: $12,345,678
    options = {:currency_symbol => "$", :delimiter => ",", :currency_before => true}.merge(options)
    
    int = number.to_s
    # insert the delimiters
    int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

    if options[:currency_before]
      options[:currency_symbol] + int
    else
      int + options[:decimal_symbol]
    end
  end
  
  # http://apidock.com/rails/ActionView/Helpers/FormHelper/fields_for
  def add_object_link(name, where, render_options) # to add a partial dynamically
    html = render(render_options)

    link_to_function name, %{
      Element.insert('#{where}', #{html.to_json}.replace(/index_to_replace_with_js/g, new Date().getTime()));
    }
  end
end
