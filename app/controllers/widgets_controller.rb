# -*- encoding : utf-8 -*-
# app/controllers/widget_controller.rb:
# Handle widgets, if enabled
#
# Copyright (c) 2014 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

require 'securerandom'

class WidgetsController < ApplicationController

    before_filter :check_widget_config, :find_info_request, :check_prominence
    skip_before_filter :set_x_frame_options_header, :only => [:show]

    def show
        medium_cache
        @track_thing = TrackThing.create_track_for_request(@info_request)
        @status = @info_request.calculate_status
        @count = @info_request.track_things.count + @info_request.widget_votes.count + 1

        @existing_track =
            if @user
                TrackThing.find_existing(@user, @track_thing)
            end

        @existing_vote =
            unless @existing_track
                @info_request.
                    widget_votes.
                        where(:cookie => cookies[:widget_vote]).
                            any?
            end

        render :action => 'show', :layout => false
    end

    def new
        long_cache
    end

    # Track interest in a request from a non-logged in user
    def update
        unless @user      
          cookie = cookies[:widget_vote]
        
          if cookie.nil?
              cookies.permanent[:widget_vote] = SecureRandom.hex(10)
              cookie = cookies[:widget_vote]
          end 
        
          @info_request.widget_votes.
              where(:cookie => cookie).
                  first_or_create
        end

        track_thing = TrackThing.create_track_for_request(@info_request)
        redirect_to do_track_path(track_thing), status => :temporary_redirect
    end

    private

    def find_info_request
        @info_request = InfoRequest.find(params[:request_id])
    end

    def check_widget_config
        unless AlaveteliConfiguration::enable_widgets
            raise ActiveRecord::RecordNotFound.new("Page not enabled")
        end
    end

    def check_prominence
        unless @info_request.prominence == 'normal'
            render :nothing => true, :status => :forbidden
        end
    end

end
