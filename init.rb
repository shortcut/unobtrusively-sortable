ActionView::Base.class_eval do
  include UnobtrusivelySortable::Helpers
end

ActionController::Base.class_eval do
  extend UnobtrusivelySortable::Controllers
end