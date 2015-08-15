require 'rails_helper'

RSpec.describe LocationsController, type: :request do
  describe "GET #index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    context "search with valid params" do
      let(:search_params) do
        {
            location: { city: "Berlin", country: "Germany"},
            unit: { value: "metric" },
            commit: "Search"
        }
      end

      it "creates new record" do
        expect {
          post "/locations", search_params
        }.to change(Location, :count).by(1)
      end

      it "renders partial" do
        post "/locations", search_params
        expect(response).to render_template(partial: "_location")
      end
    end

    context "random with valid params" do

      it "creates new record" do
        expect {
          post "/locations", commit: "random", unit: { value: "metric" }
        }.to change(Location, :count).by(1)
      end

      it "renders partial" do
        post "/locations", commit: "random", unit: { value: "metric" }
        expect(response).to render_template(partial: "_location")
      end
    end

    context "search with invalid city" do
      let(:search_params) do
        {
          location: { city: "__", country: ""},
          commit: "Search",
          unit: { value: "metric" },
        }
      end
      it "doesn't create new record" do
        expect {
          post "/locations", search_params
        }.to change(Location, :count).by(0)
      end

      it "shows flash message" do
        post "/locations", search_params
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to be_present
      end
    end

    context "search with no city given" do
      let(:search_params) do
        {
            location: { city: "", country: ""},
            commit: "Search"
        }
      end
      it "doesn't create new record" do
        expect {
          post "/locations", search_params
        }.to change(Location, :count).by(0)
      end

      it "shows flash message" do
        post "/locations", search_params
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to be_present
      end
    end
  end
end
