require 'rails_helper'

RSpec.describe EarthquakesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to redirect_to(california_earthquakes_path)
    end
  end

  describe "GET #california_earthquakes" do
    let(:ca_earthquakes) { double(:ca_earthquakes) }
    subject { get :california_earthquakes }

    before(:each) do
      allow(Earthquake).to receive(:in).with('CA').and_return ca_earthquakes
      allow(ca_earthquakes).to receive(:sorted).and_return ca_earthquakes
      subject
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "assigns title" do
      title = "List all earthquakes in California in the past month, sorted by decreasing magnitude"
      expect(assigns(:title)).to eql(title)
    end

    it "renders index template" do
      expect(response).to render_template(:index)
    end

    it "assigns earthquakes" do
      expect(assigns(:earthquakes)).to eql(ca_earthquakes)
    end
  end

  describe "GET #top_us_cities_earthquakes" do
    let(:top_us_cities) { double(:top_us_cities) }
    subject { get :top_us_cities_earthquakes }

    before(:each) do
      allow(Earthquake).to receive(:top_us_cities).and_return top_us_cities
      subject
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders index template" do
      expect(response).to render_template(:index)
    end

    it "assigns title" do
      title = "List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude"
      expect(assigns(:title)).to eql(title)
    end

    it "assigns earthquakes" do
      expect(assigns(:earthquakes)).to eql(top_us_cities)
    end
  end

end
