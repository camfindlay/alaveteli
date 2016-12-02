# -*- encoding : utf-8 -*-
require File.expand_path(File.join('..', '..', '..', 'spec_helper'), __FILE__)

describe 'request/_sidebar.html.erb' do
  let(:info_request) { FactoryGirl.create(:info_request) }
  let(:track_thing) do
    FactoryGirl.create(:track_thing, info_request: info_request)
  end
  let(:public_body) { info_request.public_body }
  let(:user) { info_request.user }
  let(:admin_user) { FactoryGirl.create("admin_user") }

  def render_page
    assign :info_request, info_request
    assign :track_thing, track_thing
    assign :status, info_request.calculate_status
    render
  end

  context "when the request has not been reported" do
    it "should show the offensive reporting header" do
      render_page
      expect(response).to have_css("h2", text: "Offensive? Unsuitable?")
    end
  end

  context "when the request has been reported" do
    before :each do
      info_request.report!("", "", nil)
    end

    it "should not show the offensive reporting header" do
      render_page
      expect(response).not_to have_css("h2", text: "Offensive? Unsuitable?")
    end

    it "should still allow the user to report it for personal info etc" do
      render_page
      expect(info_request.described_state).to eq "attention_requested"
      expect(response).to have_css("a", text: "Report this request")
    end

    context "and the request is hidden" do
      it "tell admins it's hidden"
    end

    context "and the request is requester only" do
      it "should tell the user that only they can see it"
    end

    context "and then deemed okay and left to complete" do
      it "should let the user know that the admins have not hidden it" do
        info_request.set_described_state("successful")
        render_page
        expect(response).to have_content("This request has been marked for " \
                                         "review by the site " \
                                         "administrators, who have not " \
                                         "hidden it at this time.")
      end
    end
  end
end