require 'spec_helper'

describe 'CirclesController' do
  describe 'routing' do
    it 'should respond to connection' do
      create_event('client_connected', nil).should be_routed_to 'circles#register_connection'
    end
    it 'should register circle' do
      create_event('register_circle', nil).should be_routed_to 'circles#register_circle'
    end
    it 'should retrieve id' do
      create_event('retrieve_id', nil).should be_routed_to 'circles#retrieve_id'
    end
    it 'should position circle' do
      create_event('update_circle', nil).should be_routed_to 'circles#position_circle'
    end
    it 'should get all circles' do
      create_event('get_circles', nil).should be_routed_to 'circles#all_circles'
    end
    it 'should respond to disconnection' do
      create_event('client_disconnected', nil).should be_routed_to 'circles#delete_circle'
    end
  end
  describe 'triggers' do
    it 'should register new circle trigger' do
      create_event('register_circle', {data: :test}).dispatch.should trigger_success_message :any
    end
  end
end