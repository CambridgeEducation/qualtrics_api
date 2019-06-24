require 'spec_helper'

describe QualtricsAPI::DistributionLinkCollection do
  describe "integration" do
    describe "#find" do
      let(:survey_id) { 'SV_eVtvUQALTlL8Uzr' }
      let(:distribution_id) { 'EMD_9A7FZioL5pgWZJb' }
      let(:distribution_link_attr_keys) do
        %i[
          status
          email
          first_name
          last_name
          link_expiration
          link
          exceeded_contact_frequency
          unsubscribed
          contact_id
          external_data_reference
        ]
      end
      let(:result) do
        VCR.use_cassette("distribution_links", record: :once) do
          subject.each(survey_id, distribution_id)
        end
      end

      it 'populates the result' do
        expect(result.first.attributes.keys).to match_array(distribution_link_attr_keys)
      end
    end
  end
end
