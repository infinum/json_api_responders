module JsonApiResponders
  class Responder
    module Actions
      ACTIONS = %w(index show create update destroy).freeze

      def respond_to_index_action
        self.status ||= :ok
        render_resource
      end

      def respond_to_show_action
        self.status ||= :ok
        render_resource
      end

      def respond_to_create_action
        if has_errors?
          self.status ||= :unprocessable_content
          render_error
        else
          self.status ||= :created
          render_resource
        end
      end

      def respond_to_update_action
        if has_errors?
          self.status ||= :unprocessable_content
          render_error
        else
          self.status ||= :ok
          render_resource
        end
      end

      def respond_to_destroy_action
        self.status ||= :no_content
        controller.head(status, **render_options)
      end

      def render_resource
        controller.render(resource_render_options)
      end

      def resource_render_options
        render_options.merge(Hash[render_method, resource].merge(**options))
      end

      private

      def has_errors?
        resource.respond_to?(:errors) && resource.errors.any?
      end

      def render_method
        JsonApiResponders.config.render_method
      end

    end
  end
end
