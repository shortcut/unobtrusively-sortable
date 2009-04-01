module UnobtrusivelySortable
  module Helpers
    # Renders the <ul>-list that contains the sortable elements. 'Elements' is
    # an array of ActiveRecord instances.
    def unobtrusively_sortable_list(elements, options = {}, &block)
      options[:url] ||= !elements.empty? && __send__([:sort, elements.first.class.name.tableize, :path].join("_"))

      concat(%{<ul class="unobtrusively_sortable_list" sort_url="#{options[:url]}">})
      elements.each {|e| concat(content_tag(:li, sortable_handles(e, options) + capture(e, &block), :id => dom_id(e)))}
      concat("</ul>")
    end
    
    def sortable_handles(e, options)
      returning("") do |out|
        out << button_to("&uarr;", options[:url] + "?direction=up&id=#{e.id}") unless e.first?
        out << " "
        out << button_to("&darr;", options[:url] + "?direction=down&id=#{e.id}") unless e.last?
        out << " "
      end
    end
  end
end