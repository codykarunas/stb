require 'spec_helper'

describe Administrate::Field::Carrierwave do
  subject { Administrate::Field::Carrierwave.new(:field, data, :show) }
  let(:model) { double 'Model', persisted?: true }
  let(:file) { double 'File' }

  let(:cw_file) { double 'CW with file', model: model, file: file, version_exists?: true }
  let(:cw_no_file) { double 'CW without file', model: model, file: nil, version_exists?: true }

  let(:data) { cw_file }
  let(:options) { {} }

  before { allow(subject).to receive(:options).and_return(options) }

  describe '#to_partial_path' do
    it 'returns a partial based on the page being rendered' do
      path = subject.to_partial_path
      expect(path).to eq('/fields/carrierwave/show')
    end
  end

  describe '#image' do
    let(:output) { subject.image }

    context 'with nil' do
      before do
        allow(subject).to receive(:options).and_return(options)
      end

      it 'returns an empty string' do
        expect(output).to eq ''
      end
    end

    context 'with a valid option' do
      let(:options) { { image: :standard } }

      it 'returns the value' do
        expect(output).to eq :standard
      end
    end
  end

  describe '#image_on_index?' do
    let(:output) { subject.image_on_index? }

    context 'with nil' do
      it 'returns false' do
        expect(output).to be false
      end
    end

    context 'with a valid option' do
      let(:options) { { image_on_index: true } }

      it 'returns the value' do
        expect(output).to be true
      end
    end
  end

  describe '#multiple?' do
    let(:output) { subject.multiple? }

    context 'with nil' do
      it 'returns false' do
        expect(output).to be false
      end
    end

    context 'with a valid option' do
      let(:options) { { multiple: true } }

      it 'returns the value' do
        expect(output).to be true
      end
    end
  end

  describe '#remove?' do
    let(:output) { subject.remove? }

    context 'with nil' do
      it 'returns false' do
        expect(output).to be false
      end
    end

    context 'with a valid option' do
      let(:options) { { remove: true } }

      it 'returns the value' do
        expect(output).to be true
      end
    end
  end

  describe '#remote_url?' do
    let(:output) { subject.remote_url? }

    context 'with nil' do
      it 'returns false' do
        expect(output).to be false
      end
    end

    context 'with a valid option' do
      let(:options) { { remote_url: true } }

      it 'returns the value' do
        expect(output).to be true
      end
    end
  end

  describe '#files' do
    let(:output) { subject.files }

    it 'returns an array' do
      expect(output).to be_an(Array)
    end

    context 'when single file' do
      it 'returns an array with one element' do
        expect(output.length).to eq 1
      end
    end

    context 'when multiple files' do
      let(:data) { [cw_file, cw_file] }

      it 'returns a multi-element array' do
        expect(output.length).to eq 2
      end
    end
  end

  describe '#file' do
    let(:output) { subject.file }
    let(:data) { [cw_file, cw_file] }

    it 'returns the first file in the array' do
      expect(output).to eq cw_file
    end
  end

  describe '#show_preview?' do
    let(:output) { subject.show_preview? }

    context 'when there is an image to show' do
      it 'returns true' do
        expect(output).to be_truthy
      end
    end

    context 'when there is no image to show' do
      let(:model) { double 'Model', persisted?: false }

      it 'returns false' do
        expect(output).to be_falsey
      end
    end
  end

  describe '#show_file?' do
    let(:output) { subject.show_file? }

    context 'when there is a file to show' do
      it 'returns true' do
        expect(output).to be_truthy
      end
    end

    context 'when there is no file to show' do
      let(:data) { nil }

      it 'returns false' do
        expect(output).to be_falsey
      end
    end
  end
end
