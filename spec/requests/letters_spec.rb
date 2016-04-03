require 'spec_helper'

RSpec.describe "Letters", :type => :request do
  describe "GET /letters" do
    it "works! (now write some real specs)" do
      get letters_path
      expect(response.status).to be(200)
    end
  end
end
