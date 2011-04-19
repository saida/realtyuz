module RealestateHelper
  def hidden_div_if(condition, attributes ={}, &block)      # &block helps to pass the block to content page
    if condition
      attributes["style"] = "display:none"
    end
    content_tag("div", attributes, &block)       
  end
  
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_remote title, :url => { :action => 'search_results', :params => params.merge({:c => column, :d => sort_dir})}
  end
end
