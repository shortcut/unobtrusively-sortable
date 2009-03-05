# coding:utf-8 
module UnobtrusivelySortable
  module Controllers
    # Call `sorts YourModelClass` in your controller to add sorting functionality to
    # it. Remember that you also need to set up the routes.
    def sorts(model_class)
      define_method(:sort) {
        
        if params[:id]
          # Increment or decrement a position by 1 step
          scope = model_class.read_inheritable_attribute("acts_as_list_configuration")[:scope] # post_id
          if scope
            parent = scope.to_s[/^(.+)_id$/, 1].classify.constantize.find(params[scope]) # Post.find(params[:category_id])
            instance = parent.send(model_class.to_s.tableize).find(params[:id]) # post.comments.find(params[:id])
          else
            instance = model_class.find(params[:id])
          end
          
          case params[:direction]
          when "up"
            instance.move_higher
          when "down"
            instance.move_lower
          end
          
          redirect_to :back
        else
          # Increment or decrement a position by 1 or more steps
        end
      }
    end
  end
end