require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  describe 'Validations' do
    it { should validate_numericality_of(:duration) }
    it { should validate_numericality_of(:duration).only_integer.is_greater_than(0).allow_nil }

    context 'is a draft' do
      before { allow(subject).to receive(:is_draft?).and_return(true) }
      %i[name description location duration start_at].each do |field|
        it { is_expected.not_to validate_presence_of(field) }
      end
    end

    context 'is published' do
      before { allow(subject).to receive(:is_draft?).and_return(false) }
      %i[name description location duration start_at].each do |field|
        it { is_expected.to validate_presence_of(field) }
      end
    end
  end

  describe 'scopes' do
    it '.draft returns all group events with true draft status' do
      group_events = create_list(:group_event, 5)
      expect(GroupEvent.draft).to eq(group_events)
    end

    it '.published returns all group events with false draft status' do
      published_group_events = create_list(:group_event, 5, :published)
      expect(GroupEvent.published).to eq(published_group_events)
    end

    it '.deleted returns all deleted group events' do
      deleted_group_events = create_list(:group_event, 5, :deleted)
      expect(GroupEvent.deleted).to eq(deleted_group_events)
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      subject { create(:group_event) }
      it { is_expected.to respond_to(:end_at) }
      it { is_expected.to respond_to(:mark_as_deleted) }
      it { is_expected.to respond_to(:mark_as_published) }
    end

    context 'executes methods correctly' do
      context '#end_at' do
        it 'return nil when start_at or duration are not defined' do
          group_event = create(:group_event, start_at: nil, duration: nil)
          expect(group_event.end_at).to eq(nil)
        end

        it 'return claculated end_at when start_at and duration are defined' do
          group_event = create(:group_event, start_at: '27-01-2021', duration: 5)
          expect(group_event.end_at).to eq(Date.parse('01-02-2021'))
        end
      end

      context '#mark_as_deleted' do
        it 'update is_deleted to true' do
          group_event = create(:group_event)
          group_event.mark_as_deleted
          expect(group_event.is_deleted).to eq(true)
        end
      end

      context '#mark_as_published' do
        it 'update is_draft to false' do
          group_event = create(:group_event)
          group_event.mark_as_published
          expect(group_event.is_draft).to eq(false)
        end
      end
    end
  end
end
