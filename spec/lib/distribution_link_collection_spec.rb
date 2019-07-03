require 'spec_helper'

describe QualtricsAPI::DistributionLinkCollection do
  describe "integration" do
    subject { described_class.new('SV_eVtvUQALTlL8Uzr', 'EMD_9A7FZioL5pgWZJb') }

    describe "#find" do
      # There's no API endpoint for retrieving a single distribution link that I can see.
      it 'is not implemented' do
        expect { subject.find('foo') }.to raise_exception(NotImplementedError)
      end
    end

    describe "#fetch" do
      describe "when success" do
        let!(:result) do
          VCR.use_cassette("distribution_link_collection_fetch_sucess", record: :once) do
            subject.each_page do |page|
              return page
            end
          end
        end

        it "populates the collection" do
          expect(result.size).to eq 100
          expect(result.first).to be_a QualtricsAPI::DistributionLink
        end
      end

      describe "when failed" do
        subject { described_class.new('SV_eVtvUQALTlL8Uzr', 'EMD_9A7FZioL5pgxxxx') }

        it "raises error" do
          VCR.use_cassette("distribution_link_collection_fetch_fail", record: :once) do
            expect { subject.each_page }.to raise_error(QualtricsAPI::NotFoundError)
          end
        end
      end
    end

    describe 'pagination' do
      it 'fetches pages from list endpoint' do
        page1 = page2 = nil
        VCR.use_cassette("distribution_link_collection_pagination") do
          page_no = 0
          max_pages = 2
          subject.each_page do |page|
            break if page_no == max_pages
            if page_no == 0
              page1 = page
            elsif page_no == 1
              page2 = page
            else
              raise 'should not iterate here'
            end
            page_no += 1
          end
          expect(page1).not_to be_nil
          expect(page2).not_to be_nil
        end
      end
    end
  end
end
