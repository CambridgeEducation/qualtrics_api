require 'spec_helper'

describe QualtricsAPI::DistributionCollection do
  describe "integration" do
    subject { described_class.new(id: 'ABCD') }

    describe '#create' do
      let(:distribution) do
        QualtricsAPI::Distribution.new(
          action: "CreateDistribution",
          survey_id: "SV_eVtvUQALTlL8Uzr",
          mailing_list_id: "ML_3wO6vOd0yrRezyd",
          description: "Foobar",
          expiration_date: nil,
          link_type: 'Individual'
        )
      end
      let(:result) do
        VCR.use_cassette(cassette, record: :once) do
          QualtricsAPI::DistributionCollection.new.create(distribution)
        end
      end

      describe 'when success' do
        let(:cassette) { 'distribution_create_success' }

        it 'returns distribution' do
          expect(result).to be_a QualtricsAPI::Distribution
        end
      end
    end
  end
end
