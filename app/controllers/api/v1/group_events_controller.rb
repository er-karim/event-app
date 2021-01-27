module Api
  module V1
    class GroupEventsController < ApplicationController
      before_action :set_group_event, only: %i[show update destroy]

      # GET /group_events
      def index
        @group_events = GroupEvent.all
        json_response(@group_events)
      end

      # GET /group_events/1
      def show
        json_response(@group_event)
      end

      # POST /group_events
      def create
        @group_event = GroupEvent.create!(group_event_params)
        json_response(@group_event, :created)
      end

      # PATCH/PUT /group_events/1
      def update
        @group_event.update(group_event_params)
        json_response(@group_event)
      end

      # DELETE /group_events/1
      def destroy
        @group_event.mark_as_deleted
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_group_event
          @group_event = GroupEvent.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def group_event_params
          params.permit(:name, :description, :location, :duration, :start_at, :is_draft)
        end
    end
  end
end
