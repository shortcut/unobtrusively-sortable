dir = File.dirname(__FILE__)
rails_root = File.join(dir, '..', '..', '..', '..')
ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = rails_root
 
require File.join(rails_root, 'config', 'environment')
require 'test/unit'
require 'mocha'

class ParentModel
  def self.find(id)
    self.new
  end
end

class MockModel
  def self.find(id)
    self.new
  end
end

class MockedController
  extend UnobtrusivelySortable::Controllers
  sorts MockModel
  attr_accessor :params
end

class UnobtrusivelySortableTest < Test::Unit::TestCase
  def test_moving_up_with_parent
    MockModel.any_instance.expects(:move_higher)
    MockModel.expects(:read_inheritable_attribute).returns({:scope => :parent_model_id})
    MockedController.any_instance.expects(:redirect_to)
    
    finder_proxy = Object.new
    finder_proxy.expects(:find).returns(MockModel.new)
    ParentModel.any_instance.expects(:mock_models).returns(finder_proxy)
    
    c = MockedController.new
    c.params = {:direction => "up", :id => 1, :parent_model_id => 1}
    c.sort
  end
  
  def test_moving_up_without_parent
    MockModel.expects(:read_inheritable_attribute).returns({})
    MockModel.any_instance.expects(:move_higher)
    MockedController.any_instance.expects(:redirect_to)
    
    c = MockedController.new
    c.params = {:direction => "up", :id => 1}
    c.sort
  end
  
  def test_moving_down_without_parent
    MockModel.expects(:read_inheritable_attribute).returns({})
    MockModel.any_instance.expects(:move_lower)
    MockedController.any_instance.expects(:redirect_to)
    
    c = MockedController.new
    c.params = {:direction => "down", :id => 1}
    c.sort
  end
end
