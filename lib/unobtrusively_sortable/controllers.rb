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
          if scope != "1 = 1" # the default scope. acts_as_list is silly.
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
          params[model_class.to_s.underscore].each_with_index do |id, position|
            position += 1
            model_class.update(id, {:position => position})
          end
          render :nothing => true
        end
      }
    end
  end
end