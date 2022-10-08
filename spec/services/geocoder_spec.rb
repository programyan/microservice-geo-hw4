RSpec.describe Geocoder, :aggregate_failures do
  subject { described_class.geocode(city) }

  context 'with valid city' do
    let(:city) { 'City 17' }

    it { is_expected.to eq({ lat: 45.05, lon: 90.05 }) }
  end

  context 'with missing city' do
    let(:city) { 'Missing' }

    it { is_expected.to be_nil }
  end
end
