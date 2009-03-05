dir = File.dirname(__FILE__)
rails_root = File.join(dir, '..', '..', '..', '..')
ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = rails_root
 
require File.join(rails_root, 'config', 'environment')
require 'test/unit'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

class Post < ActiveRecord::Base
  has_many :comments, :order => "position"
end

class Comment < ActiveRecord::Base
  belongs_to :post
  acts_as_list
end

class UnobtrusivelySortableController < ActionController::Base
  sorts Comment
end

ActionController::Routing::Routes.draw do |map|
  map.resources :comments, :collection => {:sort => :post}
  map.connect ":controller/:action/:id"
end


class UnobtrusivelySortableControllerTest < ActionController::TestCase
  def setup
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :posts do |t|
          t.string :title
          t.text :excerpt, :body
        end

        create_table :comments do |t|
          t.text :comment
          t.integer :position, :post_id
        end
      end
    end
    
    @request.env["HTTP_REFERER"] = "http://google.com/"
    @post = Post.create!
    2.times { @post.comments.create! }
    @comment = @post.comments.create!
    
    @view = ActionView::Base.new
  end

  def teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
  
  def test_moving_up_with_parent
    Comment.acts_as_list :scope => :post_id
    assert_equal 3, @comment.position
    post :sort, :direction => "up", :id => @comment.id, :post_id => @post.id
    assert_equal 2, @comment.reload.position
  end
  
  def test_moving_up_without_parent
    Comment.acts_as_list
    
    assert_equal 3, @comment.position
    post :sort, :direction => "up", :id => @comment.id
    assert_equal 2, @comment.reload.position
  end
  
  def test_moving_down_without_parent
    Comment.acts_as_list
    
    comment = @post.comments.first
    assert_equal 1, comment.position
    post :sort, :direction => "down", :id => comment.id
    assert_equal 2, comment.reload.position
  end

  def test_sorting_via_jquery_ui
    new_order = [3, 1, 2]
    
    post :sort, :comment => new_order
    
    new_order.each_with_index do |id, index|
      assert_equal id, @post.comments[index].id
    end
  end
  
  def test_unobtrusively_sortable_list_with_empty_collection
    html = @view.unobtrusively_sortable_list([])
    assert_html(html, "ul.unobtrusively_sortable_list")
    assert_no_html(html, "ul li")
  end
  
  def test_unobtrusively_sortable_list
    @view.expects(:url_for).returns("/foo/bar/baz").at_least_once()
    @view.expects(:protect_against_forgery?).returns(true).at_least_once()
    @view.expects(:request_forgery_protection_token).returns("authenticity_token").at_least_once()
    @view.expects(:form_authenticity_token).returns("aoeui").at_least_once()
    
    html = @view.unobtrusively_sortable_list(@post.comments) {|c| "" }
    assert_html(html, "ul.unobtrusively_sortable_list li form input")
    # TODO: Improve this test.
  end
  
  def assert_html(html, selector)
    assert count_nodes(html, selector) > 0
  end
  
  def assert_no_html(html, selector)
    assert count_nodes(html, selector) == 0
  end
  
  def count_nodes(html, selector)
    HTML::Selector.new(selector).select(HTML::Document.new(html).root).size
  end
end