require 'presenters/v3/base_presenter'

module VCAP::CloudController::Presenters::V3
  class EventPresenter < BasePresenter
    def to_hash
      {
        guid: event.guid,
        created_at: event.timestamp,
        updated_at: event.timestamp,
        type: event.type,
        actor: actor,
        target: target,
        data: event.data || {},
        space: space,
        organization: org,
        links: build_links
      }
    end

    private

    def event
      @resource
    end

    def actor
      return nil unless event.actor

      {
        guid: event.actor,
        type: event.actor_type,
        name: event.actor_name
      }
    end

    def target
      return nil unless event.target

      {
        guid: event.target,
        type: event.target_type,
        name: event.target_name
      }
    end

    def space
      return nil unless event.space_guid.present?

      {
        guid: event.space_guid,
      }
    end

    def org
      return nil unless event.organization_guid.present?

      {
        guid: event.organization_guid,
      }
    end

    def build_links
      url_builder = VCAP::CloudController::Presenters::ApiUrlBuilder.new

      {
        self: {
          href: url_builder.build_url(path: "/v3/audit_events/#{event.guid}")
        },
      }
    end
  end
end