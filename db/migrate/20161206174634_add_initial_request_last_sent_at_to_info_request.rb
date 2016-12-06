# -*- encoding : utf-8 -*-
class AddInitialRequestLastSentAtToInfoRequest < ActiveRecord::Migration
  def change
    add_column :info_requests, :initial_request_last_sent_at, :datetime
  end
end
