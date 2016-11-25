# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe InfoRequest::States do

  describe :all do

    it 'should include "waiting_response"' do
      expect(InfoRequest::State.all.include?("waiting_response"))
        .to be true
    end

  end
end