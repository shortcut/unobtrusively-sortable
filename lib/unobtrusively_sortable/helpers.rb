# coding:utf-8 
module UnobtrusivelySortable
  module Helpers
    # Renders the <ul>-list that contains the sortable elements. 'Elements' is
    # an array of ActiveRecord instances.
    def unobtrusively_sortable_list(elements, options = {})
      options[:url] ||= __send__([:sort, elements.first.class.name.tableize, :path].join("_"))
      
      content_tag(:ul, elements.map {|e|
        content_tag(:li, sortable_handles(e, options) + yield(e))
      }.join, :class => "unobtrusively_sortable_list")
    end
    
    def sortable_handles(e, options)
      returning("") do |out|
        out << button_to("↑", options[:url] + "?direction=up&id=#{e.id}") unless e.first?
        out << " "
        out << button_to("↓", options[:url] + "?direction=down&id=#{e.id}") unless e.last?
        out << " "
      end
    end
  end
end