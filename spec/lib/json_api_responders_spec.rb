require 'spec_helper'

describe JsonApiResponders do
  let(:controller) { FakeController.new }
  let(:resource)   { FakeModel.new }
  let(:responder)  { double(:responder) }

  describe '#respond_with' do
    it 'calls responder' do
      expect(JsonApiResponders::Responder).to(
        receive(:new).with(controller, resource, params: {}).and_return(responder)
      )
      expect(responder).to receive(:respond!)
      controller.respond_with(resource)
    end

    context 'when config has required params' do
      before do
        JsonApiResponders.configure do |config|
          config.required_options = { create: [:foo], index: [:blah] }
        end
      end

      it 'calls responder' do
        expect(JsonApiResponders::Responder).to(
          receive(:new).with(controller, resource, params: { action: 'create' }, foo: :bar).and_return(responder)
        )
        expect(responder).to receive(:respond!)
        controller.respond_with(resource, foo: :bar, params: { action: 'create' })
      end

      it 'calls responder and raises error' do
        expect{ controller.respond_with(resource, params: { action: 'create' }) }.to raise_error(JsonApiResponders::Errors::RequiredOptionMissingError)
      end
    end

    context 'when resource invalid and on_error is passed' do
      before do
        JsonApiResponders.configure do |config|
          config.required_options = []
        end
      end
      it 'calls responder' do
        expect(controller).to receive(:render).with(
          status: :unauthorized,
          content_type: 'application/vnd.api+json',
          json: { errors: [
            { detail: 'Unauthorized' },
            { title: 'json_api.errors.unprocessable_content.title',
              detail: "Name can't be blank",
              source: { parameter: :name, pointer: 'data/attributes/name' } }
          ] }
        )
        controller.respond_with(
          resource,
          on_error: { status: 401, detail: 'Unauthorized' },
          params: { action: 'create' }
        )
      end
    end
  end

  describe '#respond_with_error' do
    it 'calls responder with on_error' do
      expect(JsonApiResponders::Responder).to(
        receive(:new).with(
          controller, nil, on_error: { status: :forbidden, detail: 'help me' }
        ).and_return(responder)
      )
      expect(responder).to receive(:respond_error)
      controller.respond_with_error(:forbidden, 'help me')
    end
  end
end
