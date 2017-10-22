require "spec_helper"

RSpec.describe Picture do
  context "scope" do
    let!(:published_records) { Array.new(3) { Picture.create(published_at: Time.current) } }
    let!(:unpublished_records) { Array.new(3) { Picture.create.tap(&:unpublish!) } }

    describe ".published" do
      subject { Picture.published.pluck(:id) }
      it { is_expected.to match_array published_records.map(&:id) }
    end

    describe ".unpublished" do
      subject { Picture.unpublished.pluck(:id) }
      it { is_expected.to match_array unpublished_records.map(&:id) }
    end
  end

  context "callback" do
    let(:instance) { Picture.new }
    subject { instance.published? }
    it { is_expected.to be true }
  end

  context "predicate" do
    let(:published) { Picture.new(published_at: Time.current) }
    let(:unpublished) { Picture.new.tap(&:unpublish) }
    let(:hidden) { Picture.new(hidden_at: Time.current) }
    let(:visible) { Picture.new(hidden_at: nil) }

    describe "#published?" do
      it { expect(published.published?).to be true }
      it { expect(unpublished.published?).to be false }
    end

    describe "#unpublished?" do
      it { expect(unpublished.unpublished?).to be true }
      it { expect(published.unpublished?).to be false }
    end

    describe "#hidden?" do
      it { expect(hidden.hidden?).to be true }
      it { expect(visible.hidden?).to be false }
    end

    describe "#visible?" do
      it { expect(visible.visible?).to be true }
      it { expect(hidden.visible?).to be false }
    end
  end

  context "bang" do
    let(:published) { Picture.new(published_at: Time.current) }
    let(:hidden) { Picture.new(hidden_at: Time.current) }
    let(:visible) { Picture.new(hidden_at: nil) }

    describe "#publish!" do
      let(:instance) { Picture.new(published_at: nil) }
      before { instance.publish! }
      it { expect(instance.published?).to be true }
      it { expect(instance.persisted?).to be true }
    end

    describe "#unpublish!" do
      let(:instance) { Picture.new(published_at: Time.current) }
      before { instance.unpublish! }
      it { expect(instance.unpublished?).to be true }
      it { expect(instance.persisted?).to be true }
    end

    describe "#hide!" do
      let(:instance) { Picture.new(hidden_at: nil) }
      before { instance.hide! }
      it { expect(instance.hidden?).to be true }
      it { expect(instance.persisted?).to be true }
    end

    describe "#show!" do
      let(:instance) { Picture.new(hidden_at: Time.current) }
      before { instance.show! }
      it { expect(instance.visible?).to be true }
      it { expect(instance.persisted?).to be true }
    end
  end
end
