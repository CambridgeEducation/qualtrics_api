require 'spec_helper'

describe QualtricsAPI::PanelImport do
  subject { described_class.new(id: 'PGRS_4GvIMg79RFEPW4d', panel_id: 'ML_0APx3C4rmHER6w5') }

  describe "integration" do
    describe "#update_status" do
      let(:result) do
        VCR.use_cassette('panel_import_update_success', record: :once) do
          subject.update_status
        end
      end

      it "updates status" do
        expect(result.status).to eq('100.0%')
      end
    
      it "updates percent completed" do
        expect(result.percent_completed).to eq(100.0)
      end
    
      it "updates completed" do
        expect(result.completed?).to be_truthy
      end
    end
  end

  describe 'equality' do
    context 'when same' do
      it 'returns true' do
        expect(subject).to eq(described_class.new(subject.attributes))
      end
    end
  
    context 'when different' do
      it 'returns false' do
        expect(subject).not_to eq(described_class.new)
      end
    end
  end
end
